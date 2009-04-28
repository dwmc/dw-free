#!/usr/bin/perl
#
# DW::Worker::ContentImporter::LiveJournal
#
# Importer worker for LiveJournal-based sites.
#
# Authors:
#      Andrea Nall <anall@andreanall.com>
#      Mark Smith <mark@dreamwidth.org>
#
# Copyright (c) 2009 by Dreamwidth Studios, LLC.
#
# This program is free software; you may redistribute it and/or modify it under
# the same terms as Perl itself.  For a copy of the license, please reference
# 'perldoc perlartistic' or 'perldoc perlgpl'.
#
# The entry and comment fetching code have been copied and modified from jbackup.pl

package DW::Worker::ContentImporter::LiveJournal;

use strict;
use base 'DW::Worker::ContentImporter';

use Carp qw/ croak confess /;
use Encode qw/ encode_utf8 /;
use Storable qw/ thaw /;
use LWP::UserAgent;
use XMLRPC::Lite;
use Digest::MD5 qw/ md5_hex /;

# storage for import related stuff
our %MAPS;

sub keep_exit_status_for { 0 }
sub grab_for { 600 }
sub max_retries { 5 }
sub retry_delay {
    my ( $class, $fails ) = @_;
    return ( 10, 30, 60, 300, 600 )[$fails];
}


sub remap_groupmask {
    my ( $class, $data, $allowmask ) = @_;

    my $newmask = 0;

    unless ( $MAPS{fg_map} ) {
        my $dbh = LJ::get_db_writer()
            or croak 'unable to get global database handle';
        my $row = $dbh->selectrow_array(
            'SELECT groupmap FROM import_data WHERE userid = ? AND import_data_id = ?',
            undef, $data->{userid}, $data->{import_data_id}
        );
        $MAPS{fg_map} = $row ? thaw( $row ) : {};
    }

    # trust/friends hasn't changed bits so just copy that over
    $newmask = 1
        if $allowmask & 1 == 1;

    foreach my $oid ( keys %{$MAPS{fg_map}} ) {
        my $nid = $MAPS{fg_map}->{$oid};
        my $old_bit = ( 2 ** $oid );

        if ( ( $allowmask & $old_bit ) == $old_bit ) {
            $newmask |= ( 2 ** $nid );
        }
    }

    return $newmask;
}

sub get_feed_account_from_url {
    my ( $class, $data, $url, $acct ) = @_;
    return undef unless $acct;

# FIXME: have to do something to pass the errors up
    my $errors = [];

    # canonicalize url
    $url =~ s!^feed://!http://!;  # eg, feed://www.example.com/
    $url =~ s/^feed://;           # eg, feed:http://www.example.com/
    return undef unless $url;

    # check for validity here
    if ( $acct ne '' ) {
        # canonicalize the username
        $acct = LJ::canonical_username( $acct );
        $acct = substr( $acct, 0, 20 );
        return undef unless $acct;

        # since we're creating, let's validate this against the deny list
        # FIXME: probably need to error nicely here, as we're not creating
        # the feed that the user is expecting...
        return undef
            if LJ::User->is_protected_username( $acct );

        # append _feed here, username should be valid by this point.
        $acct .= "_feed";
    }

    # see if it looks like a valid URL
    return undef
        unless $url =~ m!^http://([^:/]+)(?::(\d+))?!;

    # Try to figure out if this is a local user.
    my ( $hostname, $port ) = ( $1, $2 );
    if ( $hostname =~ /\Q$LJ::DOMAIN\E/i ) {
        # TODO: have to map this.. :(
        # FIXME: why submit a patch that has incomplete code? :|
    }

    # disallow ports (do we ever see this in the wild and care to support it?)
    return undef
        if defined $port;

    # see if we already know about this account
    my $dbh = LJ::get_db_writer();
    my $su = $dbh->selectrow_hashref(
        'SELECT userid FROM syndicated WHERE synurl = ?',
        undef, $url
    );
    return $su->{userid} if $su;

    # we assume that it's safe to create accounts that exist on other services.  if they
    # don't work, we won't care, the syndication system should handle that ok
    my $u = LJ::User->create_syndicated( user => $acct, feedurl => $url );
    return $u->id if $u;

    # failed somehow...
    return undef;
}

sub get_remapped_userids {
    my ( $class, $data, $user ) = @_;

    return @{ $MAPS{$data->{hostname}}->{$user} }
        if exists $MAPS{$data->{hostname}}->{$user};

    my $dbh = LJ::get_db_writer()
        or return;
    my ( $oid, $fid ) = $dbh->selectrow_array(
        'SELECT identity_userid, feed_userid FROM import_usermap WHERE hostname = ? AND username = ?',
        undef, $data->{hostname}, $user
    );

    unless ( defined $oid ) {
        warn "[$$] Remapping identity userid of $data->{hostname}:$user\n";
        $oid = $class->remap_username_friend( $data, $user );
        warn "     IDENTITY USERID IS STILL UNDEFINED\n"
            unless defined $oid;
    }

# FIXME: this is temporarily disabled while we hash out exactly how we want
# this functionality to work.
#    unless ( defined $fid ) {
#        warn "[$$] Remapping feed userid of $data->{hostname}:$user\n";
#        $fid = $class->remap_username_feed( $data, $user );
#        warn "     FEED USERID IS STILL UNDEFINED\n"
#            unless defined $fid;
#    }

    $dbh->do( 'REPLACE INTO import_usermap (hostname, username, identity_userid, feed_userid) VALUES (?, ?, ?, ?)',
              undef, $data->{hostname}, $user, $oid, $fid );
    $MAPS{$data->{hostname}}->{$user} = [ $oid, $fid ];

    return ( $oid, $fid );
}

sub remap_username_feed {
    my ( $class, $data, $username ) = @_;

    # canonicalize username and try to return
    $username =~ s/-/_/g;

    # don't allow identity accounts (they're not feeds by default)
    return undef
        if $username =~ m/^ext_/;

    # fall back to getting it from the ATOM data
    my $url = "http://www.$data->{hostname}/~$username/data/atom";
    my $acct = $class->get_feed_account_from_url( $data, $url, $username )
        or return undef;

    return $acct;
}

sub remap_username_friend {
    my ( $class, $data, $username ) = @_;

    # canonicalize username, in case they gave us a URL version, convert it to
    # the one we know sites use
    $username =~ s/-/_/g;

    if ( $username =~ m/^ext_/ ) {
        my $ua = LJ::get_useragent(
            role     => 'userpic',
            max_size => 524288, #half meg, this should be plenty
            timeout  => 20,
        );

        my $r = $ua->get( "http://$data->{hostname}/tools/opml.bml?user=$username" );
        my $data = $r->content;

        my $url = $1
            if $data =~ m!<ownerName>(.+?)</ownerName>!;
        $url = "http://$url/"
            unless $url =~ m/^https?:/;
        return undef unless $url;

        if ( $url =~ m!http://(.+)\.$LJ::DOMAIN\/$! ) {
            # this appears to be a local user!
            # Map this to the local userid in feed_map too, as this is a local user.
            return LJ::User->new_from_url( $url )->id;
        }

        my $iu = LJ::User::load_identity_user( 'O', $url, undef )
            or return undef;
        return $iu->id;

    } else {
        my $url_prefix = "http://$data->{hostname}/~" . $username;
        my ( $foaf_items ) = $class->get_foaf_from( $url_prefix );

        # if we get an empty hashref, we know that the foaf data failed
        # to load.  probably because the account is suspended or something.
        # in that case, we pretend.
        my $ident =
            exists $foaf_items->{identity} ? $foaf_items->{identity}->{url} : undef;
        $ident ||= "http://$username.$data->{hostname}/";

        # build the identity account (or return it if it exists)
        my $iu = LJ::User::load_identity_user( 'O', $ident, undef )
            or return undef;
        return $iu->id;
    }
}

sub remap_lj_user {
    my ( $class, $data, $event ) = @_;
    $event =~ s/(<lj[^>]+?(user|comm|syn)=["']?(.+?)["' ]?>)/<lj site="$data->{hostname}" $2="$3">/gi;
    return $event;
}

sub get_lj_session {
    my ( $class, $imp ) = @_;

    my $r = $class->call_xmlrpc( $imp, 'sessiongenerate', { expiration => 'short' } );
    return undef
        unless $r && ! $r->{fault};

    return $r->{ljsession};
}

sub xmlrpc_call_helper {
    # helper function that makes life easier on folks that call xmlrpc stuff.  this handles
    # running the actual request and checking for errors, as well as handling the cases where
    # we hit a problem and need to do something about it.  (abort or retry.)
    my ( $class, $opts, $xmlrpc, $method, $req, $mode, $hash, $depth ) = @_;

    # bail if depth is 4, obviously something is going terribly wrong
    if ( $depth >= 4 ) {
        return 
            {
                fault => 1,
                faultString => 'Exceeded XMLRPC recursion limit.',
            };
    }

    # call out
    my $res;
    eval { $res = $xmlrpc->call($method, $req); };
    if ( $res && $res->fault ) {
        return 
            {
                fault => 1,
                faultString => $res->fault->{faultString} || 'Unknown error.',
            };
    }

    # typically this is timeouts
    return $class->call_xmlrpc( $opts, $mode, $hash, $depth+1 )
        unless $res;

    return $res->result;
}

sub call_xmlrpc {
    # also a way to help people do xmlrpc stuff easily.  this method actually does the
    # challenge response stuff so we never send the user's password or md5 digest over
    # the internet.
    my ( $class, $opts, $mode, $hash, $depth ) = @_;

    my $xmlrpc = XMLRPC::Lite->new;
    $xmlrpc->proxy( "http://" . ( $opts->{server} || $opts->{hostname} ) . "/interface/xmlrpc" );

    my $chal;
    while ( ! $chal ) {
        my $get_chal = $class->xmlrpc_call_helper( $opts, $xmlrpc, 'LJ.XMLRPC.getchallenge' );
        $chal = $get_chal->{challenge};
    }

    my $response = md5_hex( $chal . ( $opts->{md5password} || $opts->{password_md5} || md5_hex( $opts->{password} ) ) );

    my $res = $class->xmlrpc_call_helper( $opts, $xmlrpc, "LJ.XMLRPC.$mode", {
        username       => $opts->{user} || $opts->{username},
        auth_method    => 'challenge',
        auth_challenge => $chal,
        auth_response  => $response,
        %{ $hash || {} },
    }, $mode, $hash, $depth );

    return $res;
}

sub get_foaf_from {
    my ( $class, $url ) = @_;

    my %items;
    my @interests;
    my $in_tag;
    my @schools;
    my %wanted_text_items = (
        'foaf:name' => 'name',
        'foaf:icqChatID' => 'icq',
        'foaf:aimChatID' => 'aolim',
        'foaf:jabberID' => 'jabber',
        'foaf:msnChatID' => 'msn',
        'foaf:yahooChatID' => 'yahoo',
        'ya:bio' => 'bio',
    );
    my %wanted_attrib_items = (
        'foaf:homepage' => { _tag => 'homepage', 'rdf:resource' => 'url', 'dc:title' => 'title'  },
        'foaf:openid' => { _tag => 'identity', 'rdf:resource' => 'url' },
    );
    my $foaf_handler = sub {
        my $tag = $_[1];
        shift; shift;
        my %temp = ( @_ );
        if ( $tag eq 'foaf:interest' ) {
            push @interests, encode_utf8( $temp{'dc:title'} || "" );
        } elsif ( $tag eq 'ya:school' ) {
            my ( $ctc, $sc, $cc, $sid ) = $temp{'rdf:resource'} =~ m/\?ctc=(.+?)&sc=(.+?)&cc=(.+?)&sid=([0-9]+)/;
            push @schools, {
                start => encode_utf8( $temp{'ya:dateStart'} || "" ),
                finish => encode_utf8( $temp{'ya:dateFinish'} || "" ),
                title => encode_utf8( $temp{'dc:title'} || "" ),
                ctc => encode_utf8( $ctc || "" ),
                sc => encode_utf8( $sc || "" ),
                cc => encode_utf8( $cc || "" ),
            };
        } elsif ( $wanted_attrib_items{$tag} ) {
            my $item = $wanted_attrib_items{$tag};
            my %hash;
            foreach my $key ( keys %$item ) {
                next if $key eq '_tag';
                $hash{$item->{$key}} = encode_utf8( $temp{$key} || "" );
            }
            $items{$item->{_tag}} = \%hash;
        } else {
            $in_tag = $tag;
        }
    };
    my $foaf_content = sub {
        my $text = $_[1];
        $text =~ s/\n//g;
        $text =~ s/^ +$//g;
        if ( $wanted_text_items{$in_tag} ) {
            $items{$wanted_text_items{$in_tag}} .= $text;
        }
    };
    my $foaf_closer = sub {
        my $tag = $_[1];
        if ( $wanted_text_items{$in_tag} ) {
            $items{$wanted_text_items{$in_tag}} = encode_utf8( $items{$wanted_text_items{$in_tag}} || "" );
        }
        $in_tag = undef;
    };

    my $ua = LJ::get_useragent(
                               role     => 'userpic',
                               max_size => 524288, #half meg, this should be plenty
                               timeout  => 10,
                               );

    my $r = $ua->get( "$url/data/foaf" );
    return undef unless ( $r && $r->is_success );

    my $parser = new XML::Parser( Handlers => { Start => $foaf_handler, Char => $foaf_content, End => $foaf_closer } );
    $parser->parse( $r->content );

    return ( \%items, \@interests, \@schools );
}

1;

package LJ::Event::CommunityJoinApprove;
use strict;
use Carp qw(croak);
use base 'LJ::Event';

sub new {
    my ($class, $u, $cu) = @_;
    foreach ($u, $cu) {
        croak 'Not an LJ::User' unless LJ::isu($_);
    }
    return $class->SUPER::new($u, $cu->{userid});
}

sub is_common { 1 } # As seen in LJ/Event.pm, event fired without subscription

# Override this with a false value make subscriptions to this event not show up in normal UI
sub is_visible { 0 }

# Whether Inbox is always subscribed to
sub always_checked { 1 }

my @_ml_strings_en = (
    'esn.comm_join_approve.email_subject',  # 'Your Request to Join [[community]] community',
    'esn.add_friend_community',             # '[[openlink]]Add community "[[community]]" to your friends page reading list[[closelink]]',
    'esn.comm_join_approve.email_text',     # 'Dear [[user]],
                                            #
                                            #Your request to join the "[[community]]" community has been approved.
                                            #If you wish to add this community to your friends page reading list,
                                            #click the link below.
                                            #
                                            #[[options]]
                                            #Please note that replies to this email are not sent to the community\'s maintainer(s). If you 
                                            #have any questions, you will need to contact them directly.
                                            #
                                            #Regards,
                                            #[[sitename]] Team
                                            #
                                            #',
);

sub as_email_subject {
    my ($self, $u) = @_;
    my $cu      = $self->community;
    my $lang    = $u->prop('browselang');
    return LJ::Lang::get_text($lang, 'esn.comm_join_approve.email_subject', undef, { 'community' => $cu->{user} });
}

sub _as_email {
    my ($self, $u, $cu, $is_html) = @_;

    # Precache text lines
    my $lang    = $u->prop('browselang');
    #LJ::Lang::get_text_multi($lang, undef, \@_ml_strings_en);

    my $vars = {
            'user'      => $u->{name},
            'username'  => $u->{name},
            'community' => $cu->{user},
            'sitename'  => $LJ::SITENAME,
            'siteroot'  => $LJ::SITEROOT,
    };

    $vars->{'options'} =
        $self->format_options($is_html, $lang, $vars,
            {
                'esn.add_friend_community'  => [ 1, "$LJ::SITEROOT/manage/circle/add.bml?user=" . $cu->{user} . "&action=subscribe" ],
            });

    return LJ::Lang::get_text($lang, 'esn.comm_join_approve.email_text', undef, $vars);
}

sub as_email_string {
    my ($self, $u) = @_;
    my $cu = $self->community;
    return '' unless $u && $cu;
    return _as_email($self, $u, $cu, 0);
}

sub as_email_html {
    my ($self, $u) = @_;
    my $cu = $self->community;
    return '' unless $u && $cu;
    return _as_email($self, $u, $cu, 1);
}

sub community {
    my $self = shift;
    return LJ::load_userid($self->arg1);
}

1;

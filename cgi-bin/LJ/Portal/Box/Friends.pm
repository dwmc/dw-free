package LJ::Portal::Box::Friends; # <--- Change this
use base 'LJ::Portal::Box';
use strict;

######################## override this stuff ######################

our $_box_description = 'Show your friends';
our $_box_name = "Friends";
our $_box_class = "Friends";
our $_prop_keys = {
    'showsyn' => 3,
    'maxshow' => 5,
    'showcomm' => 4,
};

our $_config_props = {
    'showsyn' => {
        'type'      => 'checkbox',
        'desc'      => 'Show syndicated accounts',
        'default'   => '1',
    },
    'showcomm' => {
        'type'      => 'checkbox',
        'desc'      => 'Show communities',
        'default'   => '1',
    },
    'maxshow' => {
        'type'    => 'integer',
        'desc'    => 'Maximum number of friends to show',
        'default' => 150,
        'min'     => 1,
        'max'     => 1000,
    },
};

sub generate_content {
    my $self = shift;
    my $pboxid = $self->{'pboxid'};
    my $u = $self->{'u'};

    my $usericonguy = "<img src=\"$LJ::SITEROOT/img/silk/identity/user.png\" />";

    my $content;

    my $showsyn= $self->get_prop('showsyn');
    my $showcomm= $self->get_prop('showcomm');
    my $maxshow= $self->get_prop('maxshow');

    # display current friends of u
    my $friends_u = $u->circle_users;
    my $friendcount = 0;
    my $foundfriends = 0;
    my $friendlist;
    my $displaying;

    if ($friends_u) {
        grep { $friendcount++ if $friends_u->{$_}->is_person; } keys %$friends_u;
        my @sortedfriends = sort { $friends_u->{$a}->{'user'} cmp $friends_u->{$b}->{'user'} } keys %$friends_u;

        foreach my $fid (@sortedfriends) {
            my $fu = $friends_u->{$fid};
            next unless $fu->is_person;

            unless ($foundfriends < $maxshow) {
                chop $friendlist;
                chop $friendlist;
                $friendlist .= "... (<a href=\"$LJ::SITEROOT/userinfo.bml?user=$u->{user}\">See all</a>)  ";
                last;
            }
            $foundfriends++;

            my $journallink = $fu->journal_base();

            $friendlist .= "<a href=\"$journallink\">$fu->{user}</a>, ";
        }
    } else {
        # haha they have no friends
        my $addfriendpic = "<img src=\"$LJ::SITEROOT/img/btn_addfriend.gif\" />";
        $friendlist .= "To add journals or communities to your Friends list, click the " .
            "$addfriendpic icon on their userinfo page.";
    }

    $content .= qq {
        <div class="FriendsCurrentTitle">
          Friends ($friendcount):
          <span class="FriendsEditButton">
            (<a href="$LJ::SITEROOT/manage/circle/edit.bml">Edit Friends</a>)
          </span>
        </div>
    };

    if ($foundfriends) {
        chop $friendlist;
        chop $friendlist;
    }

    if ($foundfriends < $friendcount) {
        $displaying = " Displaying $foundfriends";
    }

    $content .= qq {
        <div class="FriendsList">
            $usericonguy($friendcount)$displaying: <br />
            $friendlist
        </div>
    };

    # display communities
    my $commcount=0, my $commlist;

    if ($showcomm) {
        if ($friends_u) {
            grep { $commcount++ if $friends_u->{$_}->is_community; } keys %$friends_u;
            my @sortedfriends = sort { $friends_u->{$a}->{'user'} cmp $friends_u->{$b}->{'user'} } keys %$friends_u;

            foreach my $fid (@sortedfriends) {
                my $fu = $friends_u->{$fid};

                next unless $fu->is_community;

                my $journallink = $fu->journal_base();
                $commlist .= "<a href=\"$journallink\">$fu->{user}</a>, ";
            }
        }

        if (!$commcount) {
            $commlist .= "You have no communities listed as friends.";
        }

        if ($commcount) {
            chop $commlist;
            chop $commlist;
        }
        $content .= qq {
            <div class="FriendsList">
                <img src="$LJ::SITEROOT/img/silk/identity/community.png" /> ($commcount): <br />
                $commlist
            </div>
        };
    }

    # display syndicated buddies
    my $syncount=0, my $synlist;

    if ($showsyn) {
        if ($friends_u) {
            grep { $syncount++ if $friends_u->{$_}->is_syndicated; } keys %$friends_u;
            my @sortedfriends = sort { $friends_u->{$a}->{'user'} cmp $friends_u->{$b}->{'user'} } keys %$friends_u;

            foreach my $fid (@sortedfriends) {
                my $fu = $friends_u->{$fid};

                next unless $fu->is_syndicated;

                my $journallink = $fu->journal_base();
                $synlist .= "<a href=\"$journallink\">$fu->{user}</a>, ";
            }
        }

        if (!$syncount) {
            $synlist .= "You have no syndicated feeds.";
        }

        if ($syncount) {
            chop $synlist;
            chop $synlist;
        }
        $content .= qq {
            <div class="FriendsList">
                <img src="$LJ::SITEROOT/img/silk/identity/feed.png" /> ($syncount): <br />
                $synlist
            </div>
        };
    }

    return $content;
}


#######################################


sub box_description { $_box_description; }
sub box_name { $_box_name; }
sub box_class { $_box_class; }
sub config_props { $_config_props; }
sub prop_keys { $_prop_keys; }

1;

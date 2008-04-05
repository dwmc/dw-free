package LJ::Setting::Interests;
use base 'LJ::Setting';
use strict;
use warnings;

sub tags { qw(interests interest likes about) }

sub as_html {
    my ($class, $u, $errs, $args) = @_;
    my $key = $class->pkgkey;
    my $ret;

    # load interests
    my @interest_list;
    my $interests = $u->interests;
    foreach my $int (sort keys %$interests) {
        push @interest_list, $int if LJ::text_in($int);
    }

    $ret .= "<label for='interests_box'>" . $class->ml('.setting.interests.question') . "</label>";
    $ret .= "<p>" . $class->ml('.setting.interests.desc') . "</p>";
    $ret .= LJ::html_textarea({ 'name' => "${key}interests", 'id' => "interests_box", 'value' => join(", ", @interest_list),
                                'class' => 'text', 'rows' => '10', 'cols' => '50', 'wrap' => 'soft' });
    $ret .= "<p class='detail'>" . $class->ml('.setting.interests.note') . "</p>";
    $ret .= $class->errdiv($errs, "interests");

    return $ret;
}

sub error_check {
    my ($class, $u, $args) = @_;

    my $interest_list = $class->get_arg($args, "interests");
    my @ints = LJ::interest_string_to_list($interest_list);
    my $intcount = scalar @ints;
    my @interrors = ();

    # Don't bother validating the interests if there are already too many
    if ($intcount > 150) {
        $class->errors("interests" => LJ::Lang::ml('error.interest.excessive', { intcount => $intcount }));
        return 1;
    }

    # Clean interests and make sure they're valid
    my @valid_ints = LJ::validate_interest_list(\@interrors, @ints);
    if (@interrors > 0) {
        # FIXME: We might have a lot of errors. But we can't pass them all in or else
        # we have a hash collision. (The class looks for errors with a given key, so
        # we need to find a way to say "hey, look for errors with all these keys")
        $class->errors("interests" => LJ::Lang::ml($interrors[0]));
    }

    return 1;
}

sub save {
    my ($class, $u, $args) = @_;
    $class->error_check($u, $args);

    my $interest_list = $class->get_arg($args, "interests");
    my @new_interests = LJ::interest_string_to_list($interest_list);
    my $old_interests = $u->interests;

    $u->set_interests($old_interests, \@new_interests);
}

1;

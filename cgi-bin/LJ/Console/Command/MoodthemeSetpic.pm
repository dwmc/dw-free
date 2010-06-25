# This code was forked from the LiveJournal project owned and operated
# by Live Journal, Inc. The code has been modified and expanded by
# Dreamwidth Studios, LLC. These files were originally licensed under
# the terms of the license supplied by Live Journal, Inc, which can
# currently be found at:
#
# http://code.livejournal.org/trac/livejournal/browser/trunk/LICENSE-LiveJournal.txt
#
# In accordance with the original license, this code and all its
# modifications are provided under the GNU General Public License.
# A copy of that license can be found in the LICENSE file included as
# part of this distribution.

package LJ::Console::Command::MoodthemeSetpic;

use strict;
use base qw(LJ::Console::Command);
use Carp qw(croak);

sub cmd { "moodtheme_setpic" }

sub desc { "Change data for a mood theme. If picurl, width, or height is empty or zero, the data is deleted." }

sub args_desc { [
                 'themeid' => "Mood theme ID number.",
                 'moodid' => "Mood ID number.",
                 'picurl' => "URL of picture for this mood. Use /img/mood/themename/file.gif for public mood images",
                 'width' => "Width of picture",
                 'height' => "Height of picture",
                 ] }

sub usage { '<themeid> <moodid> <picurl> <width> <height>' }

sub can_execute { 1 }

sub execute {
    my ($self, $themeid, $moodid, $picurl, $width, $height, @args) = @_;

    return $self->error("This command takes five arguments. Consult the reference.")
        unless scalar(@args) == 0;

    my $remote = LJ::get_remote();
    return $self->error("Sorry, your account type doesn't let you create new mood themes")
        unless $remote->can_create_moodthemes;

    my $owner = DW::Mood->ownerid( $themeid );
    return $self->error("You do not own this mood theme.")
        unless $owner == $remote->id;

    my $dbh = LJ::get_db_writer() or
        return $self->error( "Database unavailable" );

    $width += 0;
    $height += 0;
    $moodid += 0;

    if (!$picurl || $width == 0 || $height == 0) {
        $dbh->do("DELETE FROM moodthemedata WHERE moodthemeid = ? AND moodid= ?", undef, $themeid, $moodid);
        $self->print("Data deleted for theme #$themeid, mood #$moodid.");
    } elsif ( length($picurl) > 200 ) {
        $self->error("Moodpic URLs cannot exceed 200 characters.");
    } else {
        $dbh->do("REPLACE INTO moodthemedata (moodthemeid, moodid, picurl, width, height) VALUES (?, ?, ?, ?, ?)",
                 undef, $themeid, $moodid, $picurl, $width, $height);
        $self->print("Data inserted for theme #$themeid, mood #$moodid.");
    }

    $self->error("Database error: " . $dbh->errstr)
        if $dbh->err;

    DW::Mood->clear_cache( $themeid );

    return 1;
}

1;

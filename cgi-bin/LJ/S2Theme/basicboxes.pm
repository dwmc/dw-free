package LJ::S2Theme::basicboxes;
use base qw( LJ::S2Theme );

sub layouts { ( "1" => "one-column", "2l" => "two-columns-left", "2r" => "two-columns-right", "3" => "three-columns-sides", "3r" => "three-columns-right", "3l" => "three-columns-left" ) }
sub layout_prop { "layout_type" }

sub designer { "branchandroot" }


package LJ::S2Theme::basicboxes::green;
use base qw( LJ::S2Theme::basicboxes );
sub cats { qw( featured ) }

1;
package LJ::S2Theme::boxesandborders;
use base qw( LJ::S2Theme );

sub layouts { ( "1" => "one-column", "2l" => "two-columns-left", "2r" => "two-columns-right", "3" => "three-columns-sides", "3r" => "three-columns-right", "3l" => "three-columns-left" ) }
sub layout_prop { "layout_type" }

sub designer { "branchandroot" }


package LJ::S2Theme::boxesandborders::gray;
use base qw( LJ::S2Theme::boxesandborders );
sub cats { qw( featured ) }

1;
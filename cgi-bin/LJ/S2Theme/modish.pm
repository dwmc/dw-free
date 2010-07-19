package LJ::S2Theme::modish;
use base qw( LJ::S2Theme );

sub layouts { ( "1" => "one-column", "2l" => "two-columns-left", "2r" => "two-columns-right", "3" => "three-columns-sides", "3r" => "three-columns-right", "3l" => "three-columns-left" ) }
sub layout_prop { "layout_type" }

sub designer { "branchandroot" }

package LJ::S2Theme::modish::cleansheets;
use base qw( LJ::S2Theme::modish );
sub cats { qw ( ) }
sub designer { "zvi" }

package LJ::S2Theme::modish::greyscale;
use base qw( LJ::S2Theme::modish );
sub cats { qw ( ) }
sub designer { "twtd" }

package LJ::S2Theme::modish::nnwm2009;
use base qw( LJ::S2Theme::modish );
sub cats { qw ( ) }
sub designer { "zvi" }

package LJ::S2Theme::modish::plasticgrass;
use base qw( LJ::S2Theme::modish );
sub cats { qw ( ) }
sub designer { "zvi" }

package LJ::S2Theme::modish::verdigris;
use base qw( LJ::S2Theme::modish );
sub cats { qw ( ) }
sub designer { "zvi" }

1;

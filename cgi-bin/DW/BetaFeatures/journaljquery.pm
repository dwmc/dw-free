#!/usr/bin/perl
#
# DW::BetaFeatures::journaljquery - Allow users to beta test the updated jquery-ified journals
#
# Authors:
#      Afuna <coder.dw@afunamatata.com>
#
# Copyright (c) 2011 by Dreamwidth Studios, LLC.
#
# This program is free software; you may redistribute it and/or modify it under
# the same terms as Perl itself. For a copy of the license, please reference
# 'perldoc perlartistic' or 'perldoc perlgpl'.

package DW::BetaFeatures::journaljquery;

use strict;
use base "LJ::BetaFeatures::default";

sub args_list {
    my @implemented = (
        "Logging in",
        "Screen/freeze/delete",
    );

    my @notimplemented = (
        "Contextual hover",
        "Quick reply",
        "Cut expand and collapse",
        "Media embed placeholder expansion",
        "Control strip injection for non-supporting journals",
        "Same-page poll submission",
        "Thread expander",
        "Icon browser",
    );

    return (
        implemented => "<ul>" . join( "\n", map { "<li>$_</li>" } @implemented ) . "</ul>",
        notimplemented => "<ul>" . join( "\n", map { "<li>$_</li>" } @notimplemented ) . "</ul>",
    );
}

1;

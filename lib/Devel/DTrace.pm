package Devel::DTrace;

require 5.006;

use strict;
use warnings;
use base 'DynaLoader';

=head1 NAME

Devel::DTrace - Enable dtrace probes for subroutine entry, exit

=head1 SYNOPSIS

  perl -MDevel::DTrace

=head1 DESCRIPTION

=cut

BEGIN {
    our $VERSION = '0.01';
    bootstrap Devel::DTrace $VERSION;
    _dtrace_hook_runops();
}

1;

__END__


=head1 AUTHOR

Andy Armstrong <andy@hexten.net>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Andy Armstrong C<< <andy@hexten.net> >>. All
rights reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.

=cut

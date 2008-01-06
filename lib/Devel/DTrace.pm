package Devel::DTrace;

require 5.006;

use strict;
use warnings;
use base 'DynaLoader';

=head1 NAME

Devel::DTrace - Enable dtrace probes for subroutine entry, exit

=head1 SYNOPSIS

  perl -MDevel::DTrace some_prog
  ps -af | grep perl
  dtrace -p <PID> -s examples/subs-tree.d

=head1 DESCRIPTION

Sun's dtrace tool is currently supplied with Solaris and Mac OS 10.5. It
allows probes to be attached to a running executable so that debug
information may be gathered.

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

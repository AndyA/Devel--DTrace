package Devel::DTrace;

require 5.006;

use strict;
use warnings;
use base 'DynaLoader';

=head1 NAME

Devel::DTrace - Enable dtrace probes for subroutine entry, exit

=head1 SYNOPSIS

    $ perl -MDevel::DTrace prog.pl
    $ ps -af | grep perl
    $ dtrace -p <PID> -s examples/subs-tree.d

    $ cat examples/subs-tree.d
    #pragma D option quiet

    perlxs$target:::sub-entry, perlxs$target:::sub-return {
    	printf("%s %s (%s:%d)\n", probename == "sub-entry" ? "->" : "<-",
                copyinstr(arg0), copyinstr(arg1), arg2);
    }

=head1 DESCRIPTION

This module is alpha. Use with care. Expect problems. Report bugs.

Sun's dtrace tool is currently supplied with Solaris and Mac OS 10.5. It
allows probes to be attached to a running executable so that debug information
may be gathered.

This module provides probes for subroutine entry and exit. See
F<examples/subs-tree.d> for an small example D script that uses them.

=head2 Limitations

Note that C<dtrace> can't find any probes in the Perl executable until
after C<Devel::DTrace> has loaded - because before then the probes don't
exist. That means that you can't use C<dtrace> to launch the perl
executable. Perl must already be running and have loaded
C<Devel::DTrace> before you can connect to it with C<dtrace>.

=cut

BEGIN {
    our $VERSION = '0.03';
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

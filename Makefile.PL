use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::Embed;
use Config;

require 5.008;

use constant IS_SOLARIS => ( $^O =~ /solaris/ );

my @dtrace = qw(
  /usr/sbin/dtrace
);

sub find_bin {
    for ( @_ ) {
        return $_ if -x $_;
    }
    return;
}

my $dtrace = find_bin( @dtrace );
unless ( $dtrace ) {
    warn "Can't find dtrace executable. "
      . "I looked in the following places:\n";
    warn "  $_\n" for @dtrace;
    warn "Can't continue.\n";
    exit 0;    # == NA test result
}

my @obj = qw( runops.o );
push @obj, 'plxsdtrace.o' if IS_SOLARIS;

my %args = (
    ( MM->can( 'signature_target' ) ? ( SIGN => 1 ) : () ),

    NAME          => 'Devel::DTrace',
    AUTHOR        => 'Andy Armstrong <andy@hexten.net>',
    LICENSE       => 'perl',
    VERSION_FROM  => 'lib/Devel/DTrace.pm',
    ABSTRACT_FROM => 'lib/Devel/DTrace.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More'        => 0,
        'Test::Differences' => 0
    },
    OBJECT    => join( ' ', @obj, 'DTrace.o' ),
    EXE_FILES => ['dtperl'],

    dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },

    clean => {
        FILES => [ 'Devel-DTrace-*', 'plxsdtrace.h', '*.o', 'dtperl' ]
    },

    depend => { 'runops.o' => 'plxsdtrace.h' },
);

WriteMakefile( %args );

sub MY::postamble {
    chomp( my ( $ccopts, $ldopts ) = ( ccopts(), ldopts() ) );

    my $obj = join ' ', @obj;

    my @mf = ( <<"EOT");
plxsdtrace.h: plxsdtrace.d
    $dtrace -h -s plxsdtrace.d -o plxsdtrace.h

dtperl: dtperl.o runops.o
    \$(LD) $ccopts -o dtperl $ldopts dtperl.o $obj
EOT

    if ( IS_SOLARIS ) {
        push @mf, <<"EOT";
plxsdtrace.o: plxsdtrace.d
    $dtrace -G -s plxsdtrace.d -o plxsdtrace.o
EOT
    }

    ( my $postamble = join "\n\n", @mf ) =~ s/^ +/\t/mg;

    return $postamble;
}

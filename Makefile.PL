use strict;
use warnings;
use ExtUtils::MakeMaker;
use Config;

require 5.006;

my @dtrace = qw(
  /usr/sbin/dtrace
);

sub find_bin {
    for ( @_ ) {
        return $_ if -x $_;
    }
    return;
}

my $dtrace = find_bin( @dtrace ) || die "Can't find dtrace executable";

my %args = (
    ( MM->can( 'signature_target' ) ? ( SIGN => 1 ) : () ),
    NAME          => 'Devel::DTrace',
    AUTHOR        => 'Andy Armstrong <andy@hexten.net>',
    LICENSE       => 'perl',
    VERSION_FROM  => 'lib/Devel/DTrace.pm',
    ABSTRACT_FROM => 'lib/Devel/DTrace.pm',
    PL_FILES      => {},
    PREREQ_PM     => { 'Test::More' => 0, },

    dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean  => { FILES      => 'Devel-DTrace-* pldtrace.h' },
    depend => { 'DTrace.o' => 'pldtrace.h' },
);

if ( $Config{'ccname'} =~ /gcc/ ) {
    $args{CCFLAGS} = '-Wall';
}

WriteMakefile( %args );

sub MY::postamble {
    return "pldtrace.h: pldtrace.d\n"
      . "\t$dtrace -h -s pldtrace.d -o pldtrace.h\n\n";
}

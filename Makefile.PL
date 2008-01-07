use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::Embed;
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
    OBJECT        => 'runops.o DTrace.o',
    EXE_FILES     => ['dtperl'],

    dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean  => { FILES      => 'Devel-DTrace-* pldtrace.h *.o dtperl' },
    depend => { 'runops.o' => 'pldtrace.h' },
);

if ( $Config{'ccname'} =~ /gcc/ ) {
    $args{CCFLAGS} = '-Wall';
}

WriteMakefile( %args );

sub MY::postamble {
    my $postamble = do { local $/; <DATA> };

    my %defn = (
        dtrace => $dtrace,
        ccopts => ccopts(),
        ldopts => ldopts()
    );

    chomp for values %defn;

    for ( $postamble ) {
        s/^ +/\t/mg;
        s/(%(\w+)%)/$defn{$2}||$1/ge;
    }

    return $postamble;
}

__DATA__
pldtrace.h: pldtrace.d
    %dtrace% -h -s pldtrace.d -o pldtrace.h

dtperl: dtperl.o runops.o
    $(CC) %ccopts% -o dtperl %ldopts% dtperl.o runops.o

use strict;
use warnings;
use ExtUtils::MakeMaker;
use Config;

my %args = (
    ( MM->can( 'signature_target' ) ? ( SIGN => 1 ) : () ),
    NAME          => 'Devel::DTrace',
    AUTHOR        => 'Andy Armstrong <andy@hexten.net>',
    LICENSE       => 'perl',
    VERSION_FROM  => 'lib/Devel/LeakTrace/Fast.pm',
    ABSTRACT_FROM => 'lib/Devel/LeakTrace/Fast.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Test::More' => 0,
    },
    LIBS   => [''],
    DEFINE => '',
    INC    => '-I. -Isupport',
    OBJECT => 'buffer.o hash.o list.o tools.o Fast.o',

    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Devel-DTrace-*' },
);

if ( $Config{'ccname'} =~ /gcc/ ) {
    $args{CCFLAGS} = '-Wall';
}

WriteMakefile( %args );

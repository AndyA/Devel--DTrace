#!/usr/bin/perl

use strict;
use warnings;

my $prog = 'bench.pl';

my @perl = (
    [ orig   => '~/Works/Perl/versions/blead/bin/perl' ],
    [ dtrace => '~/Works/Perl/versions/blead-dtrace/bin/perl' ],
);

my ( $hdr_fmt, $row_fmt )
  = map { join( ' | ', ($_) x ( @perl + 1 ) ) . "\n" } ( '%-10s', '%2.8f' );
my $rule
  = ( '=' x ( length( sprintf( $hdr_fmt, ('') x ( @perl + 1 ) ) ) - 1 ) )
  . "\n";

sub bench {
    my ( $perl, $prog ) = @_;
    chomp( my $time = `$perl $prog` );
    return $time;
}

sub try {
    my ( $ratio, @perl ) = @_;
    printf $hdr_fmt, ( map { $_->[0] } @perl ), 'ratio';
    print $rule;
    for ( 1 .. 5 ) {
        my @times = map { bench( $_->[1], $prog ) } @perl;
        printf $row_fmt, @times, $ratio->(@times);
    }
    print $rule;
}

try( sub { $_[1] / $_[0] }, @perl );
try( sub { $_[0] / $_[1] }, reverse @perl );

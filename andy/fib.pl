#!/usr/bin/perl

sub fib {
  my $n = shift;
  return 1 if $n < 2;
  return fib( $n - 1 ) + fib( $n - 2 );
}

while ( 1 ) {
  print fib( int( rand( 40 ) ) ), "\n";
}

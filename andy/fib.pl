#!/usr/bin/perl

sub fib {
    my $n = shift;
    return 1 if $n < 2;
    return fib( $n - 1 ) + fib( $n - 2 );
}

print "$$\n";

while ( <> ) {
    chomp;
    print fib( $_ ), "\n";
}

#!/usr/bin/perl

sub fib {
    my $n = shift;
    return 1 if $n < 2;
    return fib( $n - 1 ) + fib( $n - 2 );
}

sub frub {
    return 1;
}

sub frob {
    return fib( 5 );
    # return frub();
}

print frob(), "\n";

#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw( time );

$| = 1;

my $before = time();
dummy() for 1 .. 10_000_000;
my $after = time();

print $after - $before, "\n";

sub dummy { }

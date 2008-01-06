#!/bin/sh
sudo dtrace -s andy/subs-tree.d \
	-c 'perl -Iblib/arch -Iblib/lib -MDevel::DTrace andy/fib.pl'


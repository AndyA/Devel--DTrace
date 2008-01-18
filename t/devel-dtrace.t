use strict;
use warnings;
use Test::More;
use Test::Differences;

my @scripts = map { [ $_, reference( $_ ) ] } glob 't/scripts/*.pl';

my @methods = (
    [ 'module', $^X, ( map { "-I$_" } @INC ), '-MDevel::DTrace' ],
    [ 'dtperl', './dtperl' ],
);

plan tests => 1 * @scripts * @methods;

for my $method ( @methods ) {
    my ( $type, @cmd ) = @$method;
    for my $script ( @scripts ) {
        my ( $name, $todo, $want ) = @$script;
        my $got = dtrace_run( @cmd, $name );
        TODO: {
            local $TODO = $todo if $todo;
            eq_or_diff $got, $want, "$type, $name: ok";
        }
    }
}

sub reference {
    my $scp  = shift;
    my @out  = ();
    my $todo = undef;
    local $_;
    open my $sh, '<', $scp or die "Can't read $scp ($!)\n";
    while ( <$sh> ) {
        chomp;
        $todo = $1 if /# TODO\s+(.+)/;
        next if $. == 1 .. /^__DATA__$/;
        push @out, $_;
    }
    return ( $todo, \@out );
}

sub dtrace_run {
    my @cmd = @_;
    local $ENV{'DEVEL_DTRACE_RUNOPS_FAKE'} = 1;
    open my $proc, '-|', @cmd or die "Can't run @cmd ($!)\n";
    chomp( my @out = <$proc> );
    close $proc or die "@cmd failed ($!)\n";
    return \@out;
}

#!/usr/bin/perl -l

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my %network;
while (<$in>) {
    chomp;
    my ($a, $b) = split /-/;
    push @{ $network{$a} }, $b;
    push @{ $network{$b} }, $a;
}

sub get_largest_lan {
    my ($connections, $max, $largest_lan) = (shift, 0, undef);

    foreach my $computer (keys %$connections) {
        my $lan = get_most_connected($connections, {}, $computer);
        if (scalar(keys %$lan) > $max) { $max = scalar(keys %$lan); $largest_lan = $lan; }
    }
    return $largest_lan;
}

# This is somewhat the Bron–Kerbosch algorithm implementation. A little bit washed, but that's okay :)
sub get_most_connected {
    my ($connections, $nodes, $computer, $max) = (shift, shift, shift, 0);
    my $max_connected = $nodes;

    $nodes->{$computer} = 1;

    foreach my $node (@{$connections->{$computer}}) {
        next if (exists $max_connected->{$node});
        next unless is_connected($connections, $nodes, $node);
        my $lan = get_most_connected($connections, { %$nodes }, $node);
        next if not defined $lan;
        if ((not defined $max_connected) || scalar(keys %$lan) > $max) {
            $max = scalar(keys %$lan);
            $max_connected = $lan;
        }
    }
    return $max_connected;
}

sub is_connected {
    my ($connections, $nodes, $node) = (shift, shift, shift);
    foreach my $old (keys %$nodes) { return 0 if (not grep { $_ eq $old } @{$connections->{$node}}); }
    return 1;
}

my $password = get_largest_lan(\%network);
print "Part 02 : " . join(",", sort keys %$password);
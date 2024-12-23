#!/usr/bin/perl -l

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my (%network, %t);
while (<$in>) {
    chomp;
    my ($a, $b) = split /-/;
    push @{ $network{$a} }, $b;
    push @{ $network{$b} }, $a;
}

sub contains { my ($arr, $val) = @_; return grep { $_ eq $val } @$arr; }

foreach my $node (keys %network) {
    next unless $node =~ /^t/;
    my @neighbors = @{ $network{$node} };
    for my $i (0 .. $#neighbors) {
        for my $j ($i + 1 .. $#neighbors) {
            if (contains($network{$neighbors[$i]}, $neighbors[$j])) {
                my @inter_connected = sort ($node, $neighbors[$i], $neighbors[$j]);
                $t{join(',', @inter_connected)} = 1;
            }
        }
    }
}

print "Part 01 : ", scalar(keys %t);
#!/usr/bin/perl

use strict;
use warnings;
use Math::Cartesian::Product;

open(my $in, '<', 'input.txt') or die $!;

my $total = 0;

while (<$in>) {
    chomp;
    my ($target, $numbers_str) = /(\d+): (.+)/g;
    my @numbers = split " ", $numbers_str;

    my @combinations;
    cartesian {push @combinations, [@_]} (["+","*","||"]) x (@numbers - 1);

    foreach my $combination (@combinations) {
        my $result = $numbers[0];
        for my $i (0 .. $#{$combination}) {
            $result += $numbers[$i + 1] if ($combination->[$i] eq "+");
            $result *= $numbers[$i + 1] if ($combination->[$i] eq "*");
            $result = $result * (10 ** length($numbers[$i + 1])) + $numbers[$i + 1] if ($combination->[$i] eq "||");
        }
        $total += $target and last if ($target == $result);
    }
}

print "Part 02 : $total\n";
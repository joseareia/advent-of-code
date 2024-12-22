#!/usr/bin/perl -l

use strict;
use warnings;
use List::Util qw(sum);

open(my $in, '<', 'input.txt') or die $!;

my @secret_numbers;
while (<$in>) { chomp; push @secret_numbers, next_secret($_); }

sub next_secret {
    my ($i, $m) = ($_[0], 16777216);
    for (1 .. 2000) { $i = ($i ^ ($i * 64)) % $m, $i = ($i ^ ($i / 32)) % $m, $i = ($i ^ ($i * 2048)) % $m; }
    return $i;
}

print "Part 01 : ", sum @secret_numbers;
#!/usr/bin/perl

use strict;
use warnings;

my $input = "input.txt";

open(my $fh, '<', $input) or die "Cannot open file '$input': $!";

my $total = 0;
my @left_col = 0;
my @right_col = 0;

while(<$fh>) {
    chomp;
    my ($a, $b) = split /\s+/; # Greddy cause "/\s{3}/"" broke the syntax highlight.. what?
    push @left_col, $a;
    push @right_col, $b;
} 

close($fh);

my @sorted_left = sort {$a <=> $b} @left_col;
my @sorted_right = sort {$a <=> $b} @right_col;

for my $i (0 .. $#sorted_left) {
    $total += abs($sorted_left[$i] - abs $sorted_right[$i]);
}

print "Part 01 : $total\n";
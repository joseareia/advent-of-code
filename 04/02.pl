#!/usr/bin/perl

use strict;
use warnings;

my $input = "input.txt";

open(my $fh, '<', $input) or die "Cannot open file '$input': $!";

my @lines;
my $total = 0;

while (<$fh>) {
    chomp;
    push @lines, $_;
}

my $rows = scalar @lines; 
my $cols = length($lines[0]);

for my $i (1 .. $rows - 2) {
    for my $j (1 .. $cols - 2) {
        $total++ if (
            (
                substr($lines[$i], $j, 1) eq "A"            # [1,1] -> Center
            &&  substr($lines[$i - 1], $j - 1, 1) eq "M"    # [0,0] -> Top Left
            &&  substr($lines[$i - 1], $j + 1, 1) eq "M"    # [0,2] -> Top Right
            &&  substr($lines[$i + 1], $j - 1, 1) eq "S"    # [1,2] -> Bottom Left
            &&  substr($lines[$i + 1], $j + 1, 1) eq "S"    # [2,2] -> Bottom Right
            ) 
            ||
            (
                substr($lines[$i], $j, 1) eq "A"
            &&  substr($lines[$i - 1], $j - 1, 1) eq "S"
            &&  substr($lines[$i - 1], $j + 1, 1) eq "S"
            &&  substr($lines[$i + 1], $j - 1, 1) eq "M"
            &&  substr($lines[$i + 1], $j + 1, 1) eq "M"
            )
            ||
            (
                substr($lines[$i], $j, 1) eq "A"
            &&  substr($lines[$i - 1], $j - 1, 1) eq "M"
            &&  substr($lines[$i - 1], $j + 1, 1) eq "S"
            &&  substr($lines[$i + 1], $j - 1, 1) eq "M"
            &&  substr($lines[$i + 1], $j + 1, 1) eq "S"
            )
            ||
            (
                substr($lines[$i], $j, 1) eq "A"
            &&  substr($lines[$i - 1], $j - 1, 1) eq "S"
            &&  substr($lines[$i - 1], $j + 1, 1) eq "M"
            &&  substr($lines[$i + 1], $j - 1, 1) eq "S"
            &&  substr($lines[$i + 1], $j + 1, 1) eq "M"
            )
        );
    }
}

print "Part 02 : $total\n";
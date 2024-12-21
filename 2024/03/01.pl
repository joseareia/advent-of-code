#!/usr/bin/perl

use strict;
use warnings;

my $input = "input.txt";

open(my $fh, '<', $input) or die "Cannot open file '$input': $!";

my @line;
my $total = 0;

while (<$fh>) {
    chomp;
    while ($_ =~ /mul\((\d{1,3}),(\d{1,3})\)/gm) {
        $total += $1 * $2;
    }
} close($fh);

print "Part 01 : $total\n";
#!/usr/bin/perl

use strict;
use warnings;

my $input = "input.txt";

open(my $fh, '<', $input) or die "Cannot open file '$input': $!";

my @lines;
my $total = 0;
my $xmas = "XMAS";
my @directions = ([0,1], [0,-1], [1,0], [-1,0], [1,1], [-1,-1], [1,-1], [-1,1]);

while (<$fh>) {
    chomp;
    push @lines, $_;
}

my $rows = scalar @lines; 
my $cols = length($lines[0]);

for my $i (0 .. $rows - 1) {
    for my $j (0 .. $cols - 1) {
        foreach my $dir (@directions) {
            my ($di, $dj) = @$dir;
            my $found = 1;
            for my $k (0 .. length($xmas) - 1) {
                my $x = $i + $k * $di;
                my $y = $j + $k * $dj;
                if ($x < 0 || $x >= $rows || $y < 0 || $y >= $cols || substr($lines[$x], $y, 1) ne substr($xmas, $k, 1)) {
                    $found = 0;
                    last;
                }
            }
            $total ++ if ($found);
        }
    }
}

print "Part 01 : $total\n";
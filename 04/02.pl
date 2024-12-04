#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $grid = [map {chomp; [ split //, $_ ]} <$in>];

my $t = 0;
my $rows = scalar @$grid;
my $cols = scalar @{$grid->[0]};

for my $i (1 .. $rows - 2) {
    for my $j (1 .. $cols - 2) {
        my $pa = $grid->[$i-1]->[$j-1] . $grid->[$i]->[$j] . $grid->[$i+1]->[$j+1];
        my $pb = $grid->[$i+1]->[$j-1] . $grid->[$i]->[$j] . $grid->[$i-1]->[$j+1];
        $t++ if ($pa =~ /MAS|SAM/ && $pb =~ /MAS|SAM/);
    }
}

print "Part 02 : $t\n";
#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $grid = [map {chomp; [ split //, $_ ]} <$in>];
my $rows = scalar @$grid;
my $cols = scalar @{$grid->[0]};

my %visited;
my ($x, $y) = (0, 0); # Guard's first position.
my $total_visited = 1;

my $direction = 'N';
my %directions = (N => [-1, 0], S => [1, 0], W => [0, -1], E => [0, 1]);
my %turns = (N => 'E', E => 'S', S => 'W', W => 'N');

OUTER: for my $i (0 .. $rows - 1) {
    for my $j (0 .. $cols - 1) {
        ($x, $y) = ($i, $j) and last OUTER if ($grid->[$i]->[$j] eq "^");
    }
}

while ($x > 0 && $x < $rows - 1 && $y > 0 && $y < $cols - 1) {
    my $key = "$x,$y";
    $total_visited++ and $visited{$key} = 1 unless ($visited{$key}); # Check if the place was already visited.

    my $next_x = $x + $directions{$direction}->[0];
    my $next_y = $y + $directions{$direction}->[1];

    $direction = $turns{$direction} and next if ($grid->[$next_x]->[$next_y] eq '#');
    ($x, $y) = ($next_x, $next_y);
}

print "Part 01 : $total_visited\n";
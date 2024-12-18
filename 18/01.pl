#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(min);

open(my $in, '<', 'input.txt') or die $!;

my $grid_size = 70;
my @falling_bytes;

while (<$in>) { chomp; push @falling_bytes, [split /,/, $_]; }

my @grid;
for my $i (0 .. $grid_size) {
    for my $j (0 .. $grid_size) {
        $grid[$i][$j] = '.';
    }
}

for my $i (0 .. min(1023, $#falling_bytes)) {
    my ($x, $y) = @{$falling_bytes[$i]};
    $grid[$y][$x] = '#';
}

sub shortest_path {
    my @queue = ([0, 0, 0]);
    my %visited; $visited{"0,0"} = 1;

    while (@queue) {
        my ($x, $y, $steps) = @{shift @queue};

        if ($x == $grid_size && $y == $grid_size) {
            $grid[$y][$x] = 'O';
            return $steps;
        }

        for my $dir ([0, 1], [1, 0], [0, -1], [-1, 0]) {
            my ($nx, $ny) = ($x + $dir->[0], $y + $dir->[1]);
            my $boundary = ($nx >= 0 && $ny >= 0 && $nx <= $grid_size && $ny <= $grid_size);

            if ($boundary && $grid[$ny][$nx] eq '.' && !$visited{"$nx,$ny"}) {
                $visited{"$nx,$ny"} = 1;
                $grid[$ny][$nx] = 'O';
                push @queue, [$nx, $ny, $steps + 1];
            }
        }
    }
    return -1;
}

my $total = shortest_path();
print "Part 01 : $total\n";
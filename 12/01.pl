#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $grid = [map {chomp; [ split //, $_ ]} <$in>];
my $rows = scalar @$grid;
my $cols = scalar @{$grid->[0]};

my %visited;
my $total_price = 0;
my @directions = ([-1, 0], [1, 0], [0, -1], [0, 1]);

sub depth_first_search {
    my ($start_row, $start_col, $plant_type) = @_;
    my ($area, $perimeter, @stack) = (0, 0, [$start_row, $start_col]);

    while (@stack) {
        # Since I'm using a Depth First Search a LIFO strucutre should be used.
        # If we want to use something like BFS, we must use FIFO, i.e. use "shift" instead of "pop".
        my ($row, $col) = @{pop @stack};
        next if $visited{"$row,$col"}++; $area++;

        for my $dir (@directions) {
            my $new_row = $row + $dir->[0];
            my $new_col = $col + $dir->[1];
            my $boundary_condition = $new_row < 0 || $new_row >= $rows || $new_col < 0 || $new_col >= $cols;

            if ($boundary_condition || $grid->[$new_row]->[$new_col] ne $plant_type) {
                $perimeter++;
            } else {
                push @stack, [$new_row, $new_col] if !$visited{"$new_row,$new_col"};
            }
        }
    }
    return ($area, $perimeter);
}

for my $i (0 .. $rows - 1) {
    for my $j (0 .. $cols - 1) {
        next if $visited{"$i,$j"};
        my ($area, $perimeter) = depth_first_search($i, $j, $grid->[$i]->[$j]);
        $total_price += $area * $perimeter;
    }
}

print "Part 01 : $total_price\n";
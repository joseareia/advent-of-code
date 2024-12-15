#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my (@grid, @movements, $robot_x, $robot_y);
my %directions = ('^' => [-1, 0], 'v' => [1, 0], '<' => [0, -1], '>' => [0, 1]);

while (<$in>) {
    chomp;
    push @grid, [split('', $_)] if (/[#\.O@]+$/);
    push @movements, split('', $_) if (/[<^>v]/);
}

my @new_grid;
for my $row (@grid) {
    my @new_row;
    foreach my $tile (@$row) {
        push @new_row, 
            $tile eq '#' ? ('#', '#') :
            $tile eq 'O' ? ('[', ']') :
            $tile eq '.' ? ('.', '.') :
            $tile eq '@' ? ('@', '.') : ();
    }
    push @new_grid, \@new_row;
}

for my $row (0 .. $#new_grid) {
    for my $col (0 .. $#{$new_grid[$row]}) {
        ($robot_x, $robot_y) = ($row, $col) if ($new_grid[$row][$col] eq '@');
    }
}

foreach my $movement (@movements) {
    my ($dx, $dy) = @{$directions{$movement}};
    my ($next_x, $next_y) = ($robot_x + $dx, $robot_y + $dy);

    if ($new_grid[$next_x][$next_y] eq '.') {
        ($new_grid[$next_x][$next_y], $new_grid[$robot_x][$robot_y]) = ('@', '.');
        ($robot_x, $robot_y) = ($next_x, $next_y);
    }

    if ($new_grid[$next_x][$next_y] eq '[' || $new_grid[$next_x][$next_y] eq ']') {
        my @box_positions = ([$next_x, $next_y]);
        my ($box_x, $box_y) = ($next_x + $dx, $next_y + $dy);

        while ($new_grid[$box_x][$box_y] eq '[' || $new_grid[$box_x][$box_y] eq ']') {
            push @box_positions, [$box_x, $box_y];
            ($box_x, $box_y) = ($box_x + $dx, $box_y + $dy);
        }

        if ($new_grid[$box_x][$box_y] eq '.') {
            foreach my $pos (reverse @box_positions) {
                my ($bx, $by) = @$pos;
                $new_grid[$bx + $dx][$by + $dy] = $new_grid[$bx][$by];
                $new_grid[$bx][$by] = '.';
            }

            ($new_grid[$next_x][$next_y], $new_grid[$robot_x][$robot_y]) = ('@', '.');
            ($robot_x, $robot_y) = ($next_x, $next_y);
        }
    }
}

my $total = 0;
for my $row (0 .. $#new_grid) {
    for my $col (0 .. $#{$new_grid[$row]}) {
        ($total += 100 * $row + $col) if ($new_grid[$row][$col] eq ']');
    }
}

print "Part 02: $total\n";
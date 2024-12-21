#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my (@grid, @movements, $robot_x, $robot_y);
my %directions = ("^" => [-1, 0], "v" => [1, 0], "<" => [0, -1], ">" => [0, 1]);

while (<$in>) {
    chomp;
    if (/[#\.O@]+$/) {
        my @row = split('', $_);
        push @grid, \@row;
        for my $col (0 .. $#row) {
            ($robot_x, $robot_y) = ($#grid, $col) if ($row[$col] eq "@");
        }
    }
    push @movements, split('', $_) if (/[<^>v]/);
}

foreach my $movement (@movements) {
    my ($dx, $dy) = @{$directions{$movement}};
    my ($next_x, $next_y) = ($robot_x + $dx, $robot_y + $dy);
    
    if ($grid[$next_x][$next_y] eq ".") {
        ($grid[$next_x][$next_y], $grid[$robot_x][$robot_y]) = ("@", ".");
        ($robot_x, $robot_y) = ($next_x, $next_y);
    }

    if ($grid[$next_x][$next_y] eq "O") {
        my @box_positions = ([$next_x, $next_y]);
        my ($box_x, $box_y) = ($next_x + $dx, $next_y + $dy);
        
        while ($grid[$box_x][$box_y] eq "O") {
            push @box_positions, [$box_x, $box_y];
            ($box_x, $box_y) = ($box_x + $dx, $box_y + $dy);
        }

        if ($grid[$box_x][$box_y] eq ".") {
            ($grid[$robot_x][$robot_y], $grid[$next_x][$next_y], $grid[$box_x][$box_y]) = (".", "@", "O");
            ($robot_x, $robot_y) = ($next_x, $next_y);
        }
    }
}

my $total = 0;
for my $row (0 .. $#grid) {
    for my $col (0 .. $#{$grid[$row]}) {
        ($total += 100 * $row + $col) if ($grid[$row][$col] eq "O"); 
    }
}

print "Part 01 : $total\n";
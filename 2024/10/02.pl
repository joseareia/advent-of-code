#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $grid = [map {chomp; [ split //, $_ ]} <$in>];
my $rows = scalar @$grid;
my $cols = scalar @{$grid->[0]};

my $total_score = 0;
my @directions = ([0, 1], [1, 0], [0, -1], [-1, 0]);

sub traverse {
    my ($start_row, $start_col) = @_;
    my %visited;
    my @next = ([$start_row, $start_col]);
    my $score = 0;

    while (@next) {
        my ($x, $y) = @{shift @next};
        # next if $visited{"$x,$y"};
        # $visited{"$x,$y"} = 1;

        if ($grid->[$x]->[$y] == 9) {
            $score++; next;
        }

        for my $dir (@directions) {
            my ($dx, $dy) = @$dir;
            my ($new_x, $new_y) = ($x + $dx, $y + $dy);

            next if $new_x < 0 || $new_x >= $rows || $new_y < 0 || $new_y >= $cols;
            # next if $visited{"$new_x,$new_y"};
            next if $grid->[$new_x]->[$new_y] != $grid->[$x]->[$y] + 1;

            push @next, [$new_x, $new_y];
        }
    }
    return $score;
}

for my $i (0 .. $rows - 1) {
    for my $j (0 .. $cols - 1) {
        if ($grid->[$i]->[$j] == 0) {
            $total_score += traverse($i, $j);
        }
    }
}

print "Part 02 : $total_score\n";
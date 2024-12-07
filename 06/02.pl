#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $grid = [map {chomp; [ split //, $_ ]} <$in>];
my $rows = scalar @$grid;
my $cols = scalar @{$grid->[0]};

my %visited;
my ($guard_x, $guard_y) = (0, 0);

my $direction = 'N';
my %directions = (N => [-1, 0], S => [1, 0], W => [0, -1], E => [0, 1]);
my %turns = (N => 'E', E => 'S', S => 'W', W => 'N');

my %obstruction_positions;

OUTER: for my $i (0 .. $rows - 1) {
    for my $j (0 .. $cols - 1) {
        ($guard_x, $guard_y) = ($i, $j) and last OUTER if ($grid->[$i]->[$j] eq "^");
    }
}

for my $i (0 .. $rows - 1) {
    for my $j (0 .. $cols - 1) {
        next unless $grid->[$i]->[$j] eq '.';
        next if $i == $guard_x && $j == $guard_y;
        $obstruction_positions{"$i,$j"} = 1 if (check_loop($i, $j));
    }
}

sub check_loop {
    my ($obs_x, $obs_y) = @_;
    my %local_visited;
    my ($x, $y) = ($guard_x, $guard_y);
    my $direction = 'N';

    while (1) {
        my $key = "$x,$y,$direction";
        return 1 if $local_visited{$key};
        $local_visited{$key} = 1;

        my $next_x = $x + $directions{$direction}->[0];
        my $next_y = $y + $directions{$direction}->[1];

        if ($next_x == $obs_x && $next_y == $obs_y) {
            $direction = $turns{$direction};
            next;
        }

        if ($grid->[$next_x]->[$next_y] eq '#') {
            $direction = $turns{$direction};
        } else {
            ($x, $y) = ($next_x, $next_y);
        }

        return 0 if $x <= 0 || $x >= $rows - 1 || $y <= 0 || $y >= $cols - 1;
    }
}

print "Part 02 : ", scalar keys %obstruction_positions, "\n";
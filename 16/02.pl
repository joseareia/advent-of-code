#!/usr/bin/perl

use strict;
use warnings;

open my $in, '<', 'input.txt' or die $!;

my @data = <$in>; chomp @data;
my @directions = ([1, 0], [0, 1], [-1, 0], [0, -1]);
my (%grid, $start_position, $end_position, %visited, $best_score, %ideal);

for my $y (0 .. $#data) {
    for my $x (0 .. length($data[$y]) - 1) {
        $grid{"$x,$y"} = substr($data[$y], $x, 1);
        $start_position = [$x, $y] if substr($data[$y], $x, 1) eq 'S';
        $end_position = [$x, $y] if substr($data[$y], $x, 1) eq 'E';
    }
}

# I needed to make a new queue, different from the first part.
# This queue now stores the following: score, position, direction, and route.
my @queue = ( [0, $start_position, 0, {}] );

sub heuristic { my ($x, $y) = @_; return abs($x - $end_position->[0]) + abs($y - $end_position->[1]); }

while (@queue) {
    @queue = sort { ($a->[0] + heuristic(@{$a->[1]})) <=> ($b->[0] + heuristic(@{$b->[1]})) } @queue;

    my ($score, $current_pos, $direction, $route) = @{ shift @queue };
    my ($x, $y) = @$current_pos;
    
    $route->{"$x,$y"} = 1;
    
    last if (defined $best_score && $score > $best_score);
    next if (exists $visited{"$x,$y,$route"} && $visited{"$x,$y,$route"} < $score);

    $visited{"$x,$y,$route"} = $score;

    if ($grid{"$x,$y"} eq 'E') {
        $best_score = $score if (!defined $best_score);
        $ideal{$_} = 1 for keys %$route;
    }

    my $new_position = [$x + $directions[$direction]->[0], $y + $directions[$direction]->[1]];
    if ($grid{"$new_position->[0],$new_position->[1]"} ne '#') {
        push @queue, [$score + 1, $new_position, $direction, { %$route }];
    }

    for my $turn (-1, 1) {
        my $new_direction = ($direction + $turn) % 4;
        $new_direction += 4 if $new_direction < 0;
        $new_position = [$x + $directions[$new_direction]->[0], $y + $directions[$new_direction]->[1]];
        if ($grid{"$new_position->[0],$new_position->[1]"} ne '#') {
            push @queue, [$score + 1001, $new_position, $new_direction, { %$route }];
        }
    }
}

print "Part 02 : ", scalar keys %ideal, "\n";
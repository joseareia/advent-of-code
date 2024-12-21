#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my (@maze, %visited);
my ($start_x, $start_y, $end_x, $end_y);
my @directions = ([-1, 0], [0, 1], [1, 0], [0, -1]);

while (<$in>) { chomp; push @maze, [split //]; }

for my $i (0 .. $#maze) {
    for my $j (0 .. $#{$maze[$i]}) {
        ($start_x, $start_y) = ($i, $j) if ($maze[$i][$j] eq 'S');
        ($end_x, $end_y) = ($i, $j) if ($maze[$i][$j] eq 'E');
    }
}

# I'm going to apply the A* algoritm since we have a clear goal (S -> E).
# Also we've a heuristic (manhattan geometry), so A* is more suitable than Dijkstras.

# Direction is '1' because is the position index of 'E' in my @directions array.
my @queue = ({x => $start_x, y => $start_y, direction => 1, cost => 0});

# Heuristic calculation (manhattan geometry).
sub heuristic { my ($x, $y) = @_; return abs($x - $end_x) + abs($y - $end_y); }

while (@queue) {
    @queue = sort { ($a->{cost} + heuristic($a->{x}, $a->{y})) <=> ($b->{cost} + heuristic($b->{x}, $b->{y})) } @queue;

    my $current = shift @queue;
    my ($x, $y, $dir, $cost) = @$current{qw(x y direction cost)};

    print "Part 01 : $cost\n" and last if ($x == $end_x && $y == $end_y);

    $visited{"$x,$y,$dir"} = $cost;

    my ($nx, $ny) = ($x + $directions[$dir]->[0], $y + $directions[$dir]->[1]);
    if ($maze[$nx][$ny] ne '#' && (!exists $visited{"$nx,$ny,$dir"} || $visited{"$nx,$ny,$dir"} > $cost + 1)) {
        push @queue, { x => $nx, y => $ny, direction => $dir, cost => $cost + 1 };
    }

    # Attempt to rotate clockwise (1) of counterclockwise (-1).
    for my $turn (-1, 1) {
        # We need to make sure that the new direction is within the bounds of the directions array.
        # So, we must use the modulo operator of '4', i.e., the length of the directions array.
        my $new_dir = ($dir + $turn) % 4; 
        # We also need to make sure that the new direction is positive.
        $new_dir += 4 if $new_dir < 0;
        if (!exists $visited{"$x,$y,$new_dir"} || $visited{"$x,$y,$new_dir"} > $cost + 1000) {
            push @queue, { x => $x, y => $y, direction => $new_dir, cost => $cost + 1000 };
        }
    }
}
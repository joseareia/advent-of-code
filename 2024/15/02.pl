#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(all sum);

open(my $in, '<', 'input.txt') or die $!;

my ($map, $moves) = split /\n\n/, join '', <$in>;
my @move = $moves =~ /./g; # Parsing the moves into a new array. Easier to access.
my %directions = ("^" => [0, -1], "v" => [0, 1], "<" => [-1, 0], ">" => [1, 0]);

$map =~ s/./{ '#'=>'##', 'O'=>'[]', '.'=>'..', '@'=>'@.' }->{$&}/ge;

my ($x, $y, $w, $n, %grid) = (0, 0);
for ($map =~ /.+/g) {
    $grid{$x++, $y} = $_ for /./g;
    $w //= $x;
    $y++;
    $x = 0;
}

($x, $y) = $map =~ /@/ ? (length($`) % ($w + 1), int(length($`) / ($w + 1))) : die;

MOVE:
for my $move (@move) {
    my ($dx, $dy) = @{ $directions{$move} };
    my (@check, @gridmoves, %visited) = ([$x, $y]);

    # Once again I'm using a tree search algoritm.
    # In this case I'm using BFS, therefore I do need to shift the first position in the queue.
    while (@check) {
        my ($cx, $cy) = @{shift @check};
        my $cell = $grid{$cx, $cy};

        next MOVE if $cell eq '#';  # Skip if it hits the wall.
        next if $visited{$cx, $cy}++; # Skip if was already visited.
        next if index('@[]', $cell) == -1; # Skip invalid cells.

        push @gridmoves, [$cx, $cy];

        push @check, [$cx + 1, $cy] if $cell eq '[';
        push @check, [$cx - 1, $cy] if $cell eq ']';
        push @check, [$cx + $dx, $cy + $dy];
    }

    for (reverse @gridmoves) {
        my ($cx, $cy) = @$_;
        $grid{$cx + $dx, $cy + $dy} = substr($map, $cx + $dx + ($cy + $dy) * ($w + 1), 1) = $grid{$cx, $cy};
        $grid{$cx, $cy} = substr($map, $cx + $cy * ($w + 1), 1) = '.';
    }
    $x += $dx, $y += $dy if @gridmoves;
}

my $total = sum map { my ($x, $y) = /\d+/g; $x + $y * 100; } grep $grid{$_} =~ /\[/, keys %grid;
print "Part 02 : $total\n";
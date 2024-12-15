#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;
my @robots = map {/p=(-?\d+),(-?\d+)\s+v=(-?\d+),(-?\d+)/ ? {x=>$1, y=>$2, vx=>$3, vy=>$4} : ()} <$in>;
my ($width, $height, $time, $found) = (101, 103, 0, 0);

while (1) {
    my @grid = map { [(".") x $width] } 1 .. $height;

    foreach my $robot (@robots) {
        my $new_x = ($robot->{x} + $robot->{vx} * $time) % $width;
        my $new_y = ($robot->{y} + $robot->{vy} * $time) % $height;
        $new_x += $width if $new_x < 0;
        $new_y += $height if $new_y < 0;
        $grid[$new_y][$new_x] = '#';
    }

    $found = 1 if grep { join("", @$_) =~ /#{10,}/ } @grid;

    if ($found) {
        foreach my $row (@grid) {
            print join("", @$row), "\n";
        }
        print "Part 02 : $time\n"; last;
    }
    print "Current time step: $time\n" if $time %1000 == 0;
    $time++;
}
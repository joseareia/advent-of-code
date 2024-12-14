#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;
my @robots = map {/p=(-?\d+),(-?\d+)\s+v=(-?\d+),(-?\d+)/ ? {x=>$1, y=>$2, vx=>$3, vy=>$4} : ()} <$in>;

my ($time, $width, $height) = (100, 101, 103);
foreach my $robot (@robots) {
    # The modulos operand (%) can give the exactly 'x' or 'y' coordinate within the grid size specified.
    $robot->{x} = ($robot->{x} + $robot->{vx} * $time) % $width; 
    $robot->{y} = ($robot->{y} + $robot->{vy} * $time) % $height;

    # Perl can make the result of a modulo operand negative. Good job Perl!
    # We need to make sure that the value of 'x' and 'y' are both positive.
    $robot->{x} += $width if $robot->{x} < 0;
    $robot->{y} += $height if $robot->{y} < 0;
}

my ($q1, $q2, $q3, $q4) = (0, 0, 0, 0);
foreach my $robot (@robots) {
    my ($x, $y) = ($robot->{x}, $robot->{y});
    my ($width_calc, $height_calc) = (int($width / 2), int($height / 2));
    next unless ($x != $width_calc && $y != $height_calc);
    $q1++ if ($x > $width_calc && $y < $height_calc);
    $q2++ if ($x < $width_calc && $y < $height_calc);
    $q3++ if ($x < $width_calc && $y > $height_calc);
    $q4++ if ($x > $width_calc && $y > $height_calc);
}

my $total = $q1 * $q2 * $q3 * $q4;
print "Part 01 : $total\n";
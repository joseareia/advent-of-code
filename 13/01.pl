#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

# Today's problem is a set of equations.
# Px = a(Ax) + b(Bx) ... (1)
# Py = a(Ay) + b(By) ... (2)

# Then, we must simply isolate the 'a' and 'b'.
# a = (Px - b * Bx) / Ax
# b = ((Ax * Py) - (Ay * Px)) / ((Ay * Bx) - (By * Ax))

my $total = 0;
while (<$in>) {
    chomp;
    
    if (/Button A: X\+(\d+), Y\+(\d+)/) {
        my ($Ax, $Ay) = ($1, $2);
        my ($Bx, $By, $Px, $Py) = 0;

        $_ = <$in>; ($Bx, $By) = ($1, $2) if (/Button B: X\+(\d+), Y\+(\d+)/);
        $_ = <$in>; ($Px, $Py) = ($1, $2) if (/Prize: X=(\d+), Y=(\d+)/);

        my $b = int((($Ax * $Py) - ($Ay * $Px)) / (($By * $Ax) - ($Bx * $Ay)));
        my $a = int(($Px - ($b * $Bx)) / $Ax);

        my $check_x = ($a * $Ax + $b * $Bx);
        my $check_y = ($a * $Ay + $b * $By);

        $total += ($a * 3 + $b * 1) if ($check_x == $Px && $check_y == $Py);

        <$in>;
    }
}

print "Part 01 : $total\n";
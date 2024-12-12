#!/usr/bin/perl

use strict;
use warnings;

my %values;
open(my $in, '<', 'input.txt') or die $!;
$values{$_}++ for map { split(/\s+/) } <$in>;

for my $blink (1 .. 75) {
    my %new_values;
    foreach my $value (keys %values) {
        my $count = $values{$value};
        $new_values{1} += $count and next if ($value == 0);

        if (length($value) % 2 == 0) {
            my $l = substr($value, 0, length($value) / 2) + 0;
            my $r = substr($value, length($value) / 2) + 0;
            $new_values{$l} += $count;
            $new_values{$r} += $count;
            next;
        }

        $new_values{$value * 2024} += $count;
    }
    %values = %new_values;
}

my $total_count = 0;
$total_count += $values{$_} for keys %values;

print "Part 02 : $total_count\n";
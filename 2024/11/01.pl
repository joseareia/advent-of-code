#!/usr/bin/perl

use strict;
use warnings;

my @values;
open(my $in, '<', 'input.txt') or die $!;
push @values, split(/\s+/, $_) while (<$in>);

for my $blink (1 .. 25) {
    my @new_values;
    foreach my $value (@values) {
        push @new_values, 1 and next if ($value == 0);

        if (length($value) % 2 == 0) {
            my $l = substr($value, 0, length($value) / 2) + 0;
            my $r = substr($value, length($value) / 2) + 0;
            push @new_values, $l, $r; next;
        }

        push @new_values, $value * 2024;
    }
    @values = @new_values;
}

print "Part 01 : " . scalar(@values) . "\n";
#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;
my $line = <$in>; chomp $line;

my @disk;
my $file = 1;
my $index = 0;

foreach my $block (split //, $line) {
    if ($file) {
        for (my $i = 0; $i < $block; $i++) {
            push @disk, $index;
        } $index++;
    } else {
        for (my $i = 0; $i < $block; $i++) {
            push @disk, undef;
        }
    }
    $file = !$file;
}

for (my $i = 0; $i < @disk; $i++) {
    next unless (not defined $disk[$i]);
    for (my $j = @disk - 1; $j > $i; $j--) {
        next unless (defined $disk[$j]);
        $disk[$i] = $disk[$j];
        $disk[$j] = undef;
        last;
    }
}

my $checksum = 0;
for (my $i = 0; $i < @disk; $i++) {
    $checksum += $disk[$i] * $i if (defined $disk[$i]);
}

print "Part 01 : $checksum\n";
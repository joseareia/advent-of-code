#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;
my $line = <$in>; chomp $line;

my @disk;
my $file = 1;
my $index = 0;

foreach my $block_size (split //, $line) {
    if ($block_size > 0) {
        if ($file) {
            push @disk, { id => $index, size => $block_size };
            $index++;
        } else {
            if (not defined $disk[-1]->{id}) {
                $disk[-1]->{size} += $block_size;
            } else {
                push @disk, { size => $block_size };
            }
        }
    }
    $file = !$file;
}

my $result = [];
my $defrag_disk = \@disk;
my $disk_size = scalar(@{$defrag_disk});
for (my $i = 0; $i < $disk_size; $i++) {
    if (not defined $defrag_disk->[$i]->{id}) {
        my $remaining_size = $defrag_disk->[$i]->{size};
        for (my $j = $disk_size - 1; $j >= $i; $j--) {
            if (defined $defrag_disk->[$j]->{id} && $remaining_size >= $defrag_disk->[$j]->{size}) {
                push @$result, $defrag_disk->[$j];
                $remaining_size -= $defrag_disk->[$j]->{size};
                $defrag_disk->[$j] = { size => $defrag_disk->[$j]->{size} };
                last if $remaining_size == 0;
            }
        }
        push @$result, { size => $remaining_size } if $remaining_size > 0;
    } else {
        push @$result, $defrag_disk->[$i];
    }
}

my $checksum = 0;
my $result_index = 0;
my $result_size = int(@{$result});
for (my $i = 0; $i < $result_size; $i++) {
    if (defined $result->[$i]->{id}) {
        for (my $j = 0; $j < $result->[$i]->{size}; $j++) {
            $checksum += $result->[$i]->{id} * ($result_index + $j);
        }
    }
    $result_index = $result_index + $result->[$i]->{size};
}

print "Part 02 : $checksum\n";
#!/usr/bin/perl -l

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my (%keys, %locks);

while (my $line = <$in>) {
    chomp $line;
    next if $line =~ /^\s*$/;

    my ($data, $store);
    if ($line =~ /^#####$/) {
        $data = [0, 0, 0, 0, 0];
        $store = \%locks;
    } elsif ($line =~ /^\.\.\.\.\.$/) {
        $data = [0, 0, 0, 0, 0];
        $store = \%keys;
    } else {
        next;
    }

    for (1 .. 5) {
        $line = <$in>;
        chomp $line;
        for my $i (0 .. 4) {
            $data->[$i]++ if substr($line, $i, 1) eq '#';
        }
    }
    <$in>; # Just to "consume" the empty line.. it's a easy "hack" :)

    $store->{join(",", @$data)} = 0;
}

my $total = 0;
foreach my $key (keys %keys) {
    foreach my $lock (keys %locks) {
        my @k = split /,/, $key;
        my @l = split /,/, $lock;
        $total++ unless grep { $k[$_] + $l[$_] > 5 } 0 .. 4;
    }
}

print "Part 01 : $total";
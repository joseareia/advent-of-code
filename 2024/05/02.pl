#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $rules;
my @updates;
my $total = 0;

while (<$in>) {
    chomp;
    $rules->{$1,$2} = 1 if /(\d+)\|(\d+)/;
    push @updates, $_ if /,/;
}

for my $u (@updates) {
    my @pages = split /,/, $u;
    my @fixed = sort { exists $rules->{$a,$b} ? -1 : 1 } @pages;
    $total += $fixed[$#fixed/2] if ($u ne join(',', @fixed));
}

print "Part 02 : $total\n";

#!/usr/bin/perl

use strict;
use warnings;

my $input = "input.txt";

open(my $fh, '<', $input) or die "Cannot open file '$input': $!";

my %right_counts;
my @left_col = 0;
my $similarity = 0;

while(<$fh>) {
    chomp;
    my ($a, $b) = split /\s+/;
    push @left_col, $a;
    $right_counts{$b}++;
}

for my $i (0 .. $#left_col) {
    if (defined $right_counts{$left_col[$i]}) {
        $similarity += $left_col[$i] * $right_counts{$left_col[$i]};
    }
}

close($fh);

print "[ RESULT ] Distance: $similarity\n";
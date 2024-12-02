#!/usr/bin/perl

use strict;
use warnings;

my $input = "input.txt";

open(my $fh, '<', $input) or die "Cannot open file '$input': $!";

my @line;
my $safe = 0;

while (<$fh>) {
    chomp;
    my @line = split(/\s+/, $_);

    if (is_ordered('<', @line) || is_ordered('>', @line)) {
        my $aux = 1;
        for my $i (1 .. $#line) {
            my $diff = abs($line[$i] - $line[$i - 1]);
            if ($diff >= 4 || $diff == 0) {
                $aux = 0;
                last;
            }
        }

        $safe++ if $aux;
    }
}

sub is_ordered {
    my ($order, @array) = @_;
    for my $i (1 .. $#array) {
        return 0 unless eval "$array[$i - 1] $order $array[$i]";
    }
    return 1
}

close($fh);

print "Part 01 : $safe\n";
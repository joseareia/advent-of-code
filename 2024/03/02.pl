#!/usr/bin/perl

use strict;
use warnings;

my $input = "input.txt";

open(my $fh, '<', $input) or die "Cannot open file '$input': $!";

my $total = 0;
my $enable = 1;
my $input_string = join('', <$fh>);

while ($input_string =~ /mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don't\(\)/g) {
    my $match = $&;

    if ($match eq 'do()') {
        $enable = 1;
    } elsif ($match eq "don't()") {
        $enable = 0;
    } elsif ($enable) {
        $total += $1 * $2;
    }
}

print "Part 02 : $total\n";
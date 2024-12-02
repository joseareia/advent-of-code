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
    my $safe_aux = 0;

    foreach my $i (0 .. $#line) {
        if ($safe_aux == 1) {
            next;
        }

        my @index_list = 0 .. $#line;
        splice(@index_list, $i, 1);
        my @array_aux = @line[@index_list];

        if (is_ordered('<', @array_aux) || is_ordered('>', @array_aux)) {
            my $aux = 1;
            for my $j (1 .. $#array_aux) {
                my $diff = abs($array_aux[$j] - $array_aux[$j - 1]);
                if ($diff >= 4 || $diff == 0) {
                    $aux = 0;
                }
            }
            
            if ($aux) {
                $safe++;
                $safe_aux = 1;
            }
        }
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

print "Part 02 : $safe\n";
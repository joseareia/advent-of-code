#!/usr/bin/perl -l

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my @prices = (0, 0, 0, 0, 0);
my ($total, $line, $i) = (-1, 0, 0);
my (%secret_memory, %changes, %change_profits);

while (my $secret = <$in>) { 
    chomp $secret;

    for (1 .. 2000) {
        $secret = next_secret($secret);
        $prices[$i] = substr($secret, -1, 1);
        $i = ($i + 1) % 5;

        next if $#prices == 5;

        my $change_key = join(",", map { $prices[($_ + $i) % 5] - $prices[($_ + $i - 1) % 5] } 1 .. 4);
        my $price_str;
        $price_str = join(",", @prices) if ($change_key eq "-2,1,-1,3");

        unless ($changes{$line}{$change_key}) {
            $changes{$line}{$change_key} = 1;
            $change_profits{$change_key} += $prices[($i + 4) % 5];
        }
    }
    $line++;
}

sub next_secret {
    my ($s, $m) = (@_, 16777216);
    return $secret_memory{$s} if exists $secret_memory{$s};

    my $initial_secret = $s;
    $s = ($s ^ ($s * 64)) % $m, $s = ($s ^ ($s / 32)) % $m, $s = ($s ^ ($s * 2048)) % $m;
    $secret_memory{$initial_secret} = $s;

    return $s;
}

$total = (sort { $b <=> $a } values %change_profits)[0];
print "Part 02 : ", $total;
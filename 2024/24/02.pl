#!/usr/bin/perl -l

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my (%dependencies, %result);

while (<$in>) { chomp; last if (!$_); }
while (<$in>) {
    chomp;
    my ($a, $op, $b, $c) = $_ =~ /(\w+) (AND|OR|XOR) (\w+) -> (\w+)/;
    $dependencies{$c} = [$a, $b, $op];
}

for my $k (keys %dependencies) {
    my ($a, $b, $op) = @{$dependencies{$k}};

    if ($op eq 'AND' && $a ne 'x00' && $b ne 'x00') {
        for my $k2 (keys %dependencies) {
            my ($a2, $b2, $op2) = @{$dependencies{$k2}};
            $result{$k} = 1 if (($k eq $a2 || $k eq $b2) && $op2 ne 'OR');
        }
    }

    if ($op eq 'XOR') {
        $result{$k} = 1 if ($a !~ /^[xyz]/ && $b !~ /^[xyz]/ && $k !~ /^[xyz]/);
        for my $k2 (keys %dependencies) {
            my ($a2, $b2, $op2) = @{$dependencies{$k2}};
            $result{$k} = 1 if (($k eq $a2 || $k eq $b2) && $op2 eq 'OR');
        }
    }
    
    $result{$k} = 1 if ($k =~ /^z/ && $op ne 'XOR');
}

delete $result{'z45'};
print "Part 02 : ", join ',', sort keys %result;
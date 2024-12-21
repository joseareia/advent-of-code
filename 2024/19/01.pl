#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $reading_patterns = 1;
my (@towel_patterns, @desired_designs);

while (<$in>) {
    chomp;
    if ($_ eq "") { $reading_patterns = 0; next; }
    $reading_patterns ? @towel_patterns = split(/, /) : push @desired_designs, $_;
}

sub can_construct_design {
    my ($design, $patterns) = @_;

    my $helper;
    $helper = sub {
        my ($remaining) = @_;
        return 1 if $remaining eq "";
        foreach my $pattern (@$patterns) {
            if (index($remaining, $pattern) == 0) {
                my $new_remaining = substr($remaining, length($pattern));
                return 1 if $helper->($new_remaining);
            }
        }
        return 0;
    };
    return $helper->($design);
}

sub count_possible_designs {
    my ($patterns, $designs) = @_;
    my $possible_count = 0;
    foreach my $design (@$designs) {
        $possible_count++ if can_construct_design($design, $patterns);
    }
    return $possible_count;
}

my $total = count_possible_designs(\@towel_patterns, \@desired_designs);
print "Part 01 : $total\n";
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

sub count_arrangements {
    my ($design, $patterns) = @_;

    my (%memo, $helper);
    $helper = sub {
        my ($remaining) = @_;
        return 1 if $remaining eq "";
        return $memo{$remaining} if exists $memo{$remaining};
        
        my $count = 0;
        foreach my $pattern (@$patterns) {
            if (index($remaining, $pattern) == 0) {
                my $new_remaining = substr($remaining, length($pattern));
                $count += $helper->($new_remaining);
            }
        }
        $memo{$remaining} = $count;
        return $count;
    };

    return $helper->($design);
}

sub total_arrangements {
    my ($patterns, $designs) = @_;
    my $total_count = 0;
    foreach my $design (@$designs) {
        $total_count += count_arrangements($design, $patterns);
    }
    return $total_count;
}

my $total = total_arrangements(\@towel_patterns, \@desired_designs);
print "Part 02 : $total\n";
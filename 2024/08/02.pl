#!/usr/bin/perl

use strict;
use warnings;

open(my $input_file, '<', 'input.txt') or die $!;

my %antinodes;
my %antenna_positions;
my $line_number = 0;
my $line_length;

while (<$input_file>) {
    chomp;
    push @{$antenna_positions{$1}}, [ $-[0], $line_number ] while (/([A-Za-z0-9])/g);
    $line_length = length $_;
    ++$line_number;
}

foreach my $positions (values %antenna_positions) {
    foreach my $antenna (@$positions) {
        $antinodes{"$antenna->[0],$antenna->[1]"} = 1 if (scalar @$positions >= 2);
        foreach my $nxantenna (grep { !($_->[0] == $antenna->[0] && $_->[1] == $antenna->[1]) } @$positions) {
            my @distance = ($nxantenna->[0] - $antenna->[0], $nxantenna->[1] - $antenna->[1]);
            my @next_position = ($nxantenna->[0] + $distance[0], $nxantenna->[1] + $distance[1]);

            until ($next_position[0] < 0 || $next_position[0] >= $line_length || $next_position[1] < 0 || $next_position[1] >= $line_number) {
                $antinodes{"$next_position[0],$next_position[1]"} = 1;
                @next_position = ($next_position[0] + $distance[0], $next_position[1] + $distance[1]);
            }
        }
    }
}

my $total = scalar keys %antinodes;
print "Part 02 : $total\n";
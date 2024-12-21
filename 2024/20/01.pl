#!/usr/bin/perl

use strict;
use warnings;

# Today's problem is just another grid problem.
# I will try to do something different than other days.
# Today, I will organize the code into different subroutines and search for new ways to solve this problem.

open(my $in, '<', 'input.txt') or die $!;

my $min_saving = 100;
my $race = read_race_input();
my $total = count_cheats($race->{map}, $race->{start}, $race->{end}, $min_saving);

print "Part 01 : $total\n";

sub read_race_input {
    my ($map, $start, $end) = ([], undef, undef);

    while (<$in>) {
        chomp;
        my $y = @$map;
        $start = { x => index($_, 'S'), y => $y } if index($_, 'S') != -1;
        $end   = { x => index($_, 'E'), y => $y } if index($_, 'E') != -1;
        push @$map, [split //];
    }

    return { map => $map, start => $start, end => $end };
}

sub count_cheats {
    my ($map, $start, $end, $min_saving) = @_;
    my ($x, $y, $step, $cheats, $lengths) = ($start->{x}, $start->{y}, 0, 0, { $start->{x} => { $start->{y} => 0 } });

    while ($x != $end->{x} || $y != $end->{y}) {
        ($x, $y) = get_next_step($map, $x, $y, $lengths);
        $lengths->{$x}->{$y} = ++$step;
        $cheats += scalar keys %{get_shortcuts($map, $x, $y, $lengths, $min_saving)};
    }

    return $cheats;
}

sub is_valid {
    my ($map, $x, $y) = @_;
    return $y >= 0 && $y < @$map && $x >= 0 && $x < @{$map->[$y]} && $map->[$y]->[$x] ne '#';
}

sub get_next_step {
    my ($map, $x, $y, $lengths) = @_;

    for my $d ([0, 1], [0, -1], [1, 0], [-1, 0]) {
        my ($nx, $ny) = ($x + $d->[0], $y + $d->[1]);
        return ($nx, $ny) if is_valid($map, $nx, $ny) && !exists $lengths->{$nx}->{$ny};
    }
}

sub get_shortcuts {
    my ($map, $x, $y, $lengths, $min_saving) = @_;
    my %shortcuts;

    for my $d ([0, 2], [0, -2], [2, 0], [-2, 0]) {
        my ($nx, $ny) = ($x + $d->[0], $y + $d->[1]);
        next unless is_valid($map, $nx, $ny) && defined $lengths->{$nx}->{$ny};

        my $saving = $lengths->{$x}->{$y} - $lengths->{$nx}->{$ny} - 1;
        $shortcuts{"$x,$y->$nx,$ny"} = $saving if $saving >= $min_saving;
    }

    return \%shortcuts;
}
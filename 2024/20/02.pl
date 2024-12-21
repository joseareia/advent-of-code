#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $min_saving = 100;
my $race = read_race_input();

# Print like this works! Saves one line of code... cool :)
print "Part 02 : ", count_cheats($race->{map}, $race->{start}, $race->{end}, $min_saving), "\n";

sub read_race_input {
    my ($map, $start, $end) = ([], undef, undef);

    while (<$in>) {
        chomp; my $y = @$map;
        $start = { x => index($_, 'S'), y => $y } if index($_, 'S') != -1 && !$start;
        $end   = { x => index($_, 'E'), y => $y } if index($_, 'E') != -1 && !$end;
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

    for my $dy (-20 .. 20) {
        my $ny = $y + $dy;
        next if $ny < 0 || $ny >= @$map;

        for my $dx (-20 + abs($dy) .. 20 - abs($dy)) {
            next if $dx == 0 && $dy == 0;
            my $nx = $x + $dx;
            next unless is_valid($map, $nx, $ny);

            if (defined $lengths->{$nx}->{$ny}) {
                my $saving = $lengths->{$x}->{$y} - $lengths->{$nx}->{$ny} - abs($dx) - abs($dy) + 1;
                $shortcuts{"$x,$y->$nx,$ny"} = $saving if $saving >= $min_saving;
            }
        }
    }

    return \%shortcuts;
}
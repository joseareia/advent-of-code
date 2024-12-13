#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my $grid = [map {chomp; [ split //, $_ ]} <$in>];
my $rows = scalar @$grid;
my $cols = scalar @{$grid->[0]};
my @directions = ([-1, 0], [1, 0], [0, -1], [0, 1]);

sub fill {
    my ($row, $col, $plant, $region, $depth) = @_;
    $grid->[$row]->[$col] = $region;

    for my $dir (@directions) {
        my ($new_row, $new_col) = ($row + $dir->[0], $col + $dir->[1]);
        next if $new_row < 0 || $new_col < 0 || $new_row >= $rows || $new_col >= $cols;
        no warnings 'recursion'; # I really don't want any warnings about recursion in my terminal.
        fill($new_row, $new_col, $plant, $region, $depth + 1) if $grid->[$new_row]->[$new_col] eq $plant;
    }
}

my $region = 1;
for my $i (0 .. $rows - 1) {
    for my $j (0 .. $cols - 1) {
        fill($i, $j, $grid->[$i]->[$j], $region, 0); ++$region;
    }
}

# Add padding full of zeros to augment the boundaries. Thanks Anon.
for my $row (@$grid) { unshift @$row, 0; push @$row, 0; }
unshift @$grid, [(0) x @{$grid->[0]}];
push @$grid, [(0) x @{$grid->[0]}];
$rows += 2; $cols += 2;

my (%area, %sides);
my @corners = ([0, 1, -1, 0], [0, 1, 1, 0], [1, 0, 0, -1], [1, 0, 0, 1]);

for my $i (0 .. $rows - 1) {
    for my $j (0 .. $cols - 1) {
        next unless $grid->[$i]->[$j];
        ++$area{$grid->[$i]->[$j]};

        for my $corner (@corners) {
            my ($nx_a, $ny_a) = ($i + $corner->[0], $j + $corner->[1]);
            my ($nx_b, $ny_b) = ($i + $corner->[2], $j + $corner->[3]);
            my ($di_x, $di_y) = ($nx_a + $corner->[2], $ny_a + $corner->[3]); # Diagonal to check the corner.

            next if $nx_a < 0 || $ny_a < 0 || $nx_b < 0 || $ny_b < 0;
            next if $nx_a >= $rows || $ny_a >= $cols || $nx_b >= $rows || $ny_b >= $cols;

            my $a = $grid->[$nx_b]->[$ny_b] != $grid->[$i]->[$j];
            my $b = $grid->[$nx_a]->[$ny_a] != $grid->[$i]->[$j] || $grid->[$di_x]->[$di_y] == $grid->[$i]->[$j];

            $sides{$grid->[$i]->[$j]}++ if ($a && $b);
        }
    }
}

my $total_price = 0;
for my $region (keys %area) {
    $total_price += $area{$region} * $sides{$region};
}

print "Part 02 : $total_price\n";
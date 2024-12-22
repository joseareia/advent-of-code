#!/usr/bin/perl -l

use strict;
use warnings;

open(my $in, "<", "input.txt") or die $!;

my @codes;
while (my $line = <$in>) { 
    chomp $line;
    push @codes, [ split(//, $line) ];
}

my $total = get_complexity(\@codes);
print "Part 02 : $total";

sub get_complexity {
    my ($codes, $total) = (shift, 0);

    my $numeric_keypad = get_numeric_keypad();
    my $directional_keypad = get_directional_keypad();

    my @keypads;
    push @keypads, $numeric_keypad;
    push @keypads, $directional_keypad for (1..25);

    my $cache = {};
    foreach my $code (@$codes) {
        my $count = get_minimum_move_count($code, \@keypads, 0, $cache);
        $total += $count * code_to_number($code);
    }

    return $total;
}

sub code_to_number {
    my ($code, $number) = (shift, 0);
    for my $digit (@$code) { $number = $number * 10 + $digit if ($digit =~ /^[0-9]$/); }
    return $number;
}

sub get_minimum_move_count {
    my ($buttons, $keypads, $pad, $cache, $count) = (shift, shift, shift, shift, 0);
    
    my $str = join("", @$buttons);
    return $cache->{$pad}->{$str} if (exists $cache->{$pad}->{$str});

    my $current = $keypads->[$pad]->{'A'};

    my $not_valid = {};
    my ($x, $y) = ($keypads->[$pad]->{'X'}->{x}, $keypads->[$pad]->{'X'}->{y});
    $not_valid->{ $x }->{ $y } = 1;

    foreach my $button (@$buttons) {
        my $destination = $keypads->[$pad]->{$button};
        my $paths = get_paths($current, $destination, $not_valid);
        my $min;

        foreach my $path (@$paths) {
            push @$path, 'A';
            my $value;
            if (@$keypads > $pad + 1) {
                $value = get_minimum_move_count($path, $keypads, $pad + 1, $cache);
            } else {
                $value = scalar(@$path);
            }

            $min = $value if (!defined $min || $value < $min);
        }

        $count += $min;
        $current = $destination;
    }
    $cache->{$pad}->{$str} = $count;
    return $count;
}

sub get_numeric_keypad {
    my %hash;
    my $numpad = [['7', '8', '9'], ['4', '5', '6'], ['1', '2', '3'], ['X', '0', 'A']];

    for (my $y = 0; $y < scalar @$numpad; $y++) {
        for (my $x = 0; $x < scalar @{$numpad->[$y]}; $x++) {
            $hash{$numpad->[$y][$x]} = { x => $x, y => $y };
        }
    }
    return \%hash;
}

sub get_directional_keypad {
    my %hash;
    my $numpad = [['X', '^', 'A'], ['<', 'v', '>']];

    for (my $y = 0; $y < scalar @$numpad; $y++) {
        for (my $x = 0; $x < scalar @{$numpad->[$y]}; $x++) {
            $hash{$numpad->[$y][$x]} = { x => $x, y => $y };
        }
    }
    return \%hash;
}

sub get_paths {
    my @paths;
    my ($start, $end, $not_valid) = (shift, shift, shift);

    my ($dx, $dy) = ($end->{"x"} - $start->{"x"}, $end->{"y"} - $start->{"y"});

    if ($dx != 0 || $dy != 0) {
        my @directions;
        push @directions, { "x" => $dx / abs($dx), "y" =>  0 } if ($dx != 0);
        push @directions, { "y" => $dy / abs($dy), "x" =>  0 } if ($dy != 0);

        foreach my $direction (@directions) {
            my ($x, $y) = ($start->{"x"} + $direction->{"x"}, $start->{"y"} + $direction->{"y"});

            next if ($not_valid->{$x}->{$y});

            my $new_start = { "x" => $x, "y" => $y };
            my $new_paths = get_paths($new_start, $end, $not_valid);
            
            foreach my $path (@$new_paths) {
                unshift @$path, get_direction_character($direction);
                push @paths, $path;
            }
        }
    }
    elsif ($dx == 0 && $dy == 0) {
        push @paths, [];
    }
    return \@paths;
}

sub get_direction_character {
    my $direction = shift;
    return "v" if ($direction->{"x"} == 0 && $direction->{"y"} > 0);
    return "^" if ($direction->{"x"} == 0 && $direction->{"y"} < 0);
    return ">" if ($direction->{"x"} > 0 && $direction->{"y"} == 0);
    return "<" if ($direction->{"x"} < 0 && $direction->{"y"} == 0);
}
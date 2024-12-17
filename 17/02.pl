#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my @program;
while (<$in>) { chomp; if (/Program: (.*)/) { @program = split /,/, $1; } }

sub combo_value {
    my ($operand, $A, $B, $C) = @_;
    return $operand if $operand < 4;
    return $A if $operand == 4;
    return $B if $operand == 5;
    return $C if $operand == 6;
    die "Invalid combo operand: $operand\n";
}

sub run {
    my ($prog_ref, $initial_A) = @_;
    my ($A, $B, $C, $ip) = ($initial_A, 0, 0, 0);
    my @output;

    while ($ip < @$prog_ref) {
        my ($opcode, $operand) = ($prog_ref->[$ip], $prog_ref->[$ip + 1]);
        if ($opcode == 0) { $A = int($A / (2 ** combo_value($operand, $A, $B, $C))); } 
        elsif ($opcode == 1) { $B ^= $operand; } 
        elsif ($opcode == 2) { $B = combo_value($operand, $A, $B, $C) % 8; }
        elsif ($opcode == 3) { if ($A != 0) { $ip = $operand; next; } } 
        elsif ($opcode == 4) { $B ^= $C; } 
        elsif ($opcode == 5) { push @output, combo_value($operand, $A, $B, $C) % 8; }
        elsif ($opcode == 6) { $B = int($A / (2 ** combo_value($operand, $A, $B, $C))); } 
        elsif ($opcode == 7) { $C = int($A / (2 ** combo_value($operand, $A, $B, $C))); }        
        $ip += 2;
    }

    return @output;
}

sub find_a {
    my ($prog_ref, $target_ref, $A, $depth) = @_;
    $A //= 0; $depth //= 0;

    # Depth maximum value should be the total lenght of the target array.
    # Because depth means the iteration and try for each element in the array.
    return $A if $depth == @$target_ref;

    # The loop iterates over 8 possible values (0..7) for the register 'A' at each depth level.
    # This corresponds to trying all possible combinations of 3 bits (since 2^3 = 8). 
    # This is necessary because the program's operations work within a base-8 search space.
    for my $i (0 .. 7) {
        my $candidate_A = $A * 8 + $i;
        my @output = run($prog_ref, $candidate_A);
        if (@output && $output[0] == $target_ref->[$depth]) {
            my $result = find_a($prog_ref, $target_ref, $candidate_A, $depth + 1);
            return $result if $result; 
        }
    }
    return 0;
}

# We need to reserve the array because the program works by producing the output in reverse.
# Example: A program ouputs [4, 3, 5], but we want to find the 'A' that generates [5, 3, 4].
# To do so, we must reverse the target array ([4, 3, 5]) to compare it properly.
my @target = reverse @program;
my $result = find_a(\@program, \@target);

print "Part 02 : $result\n";
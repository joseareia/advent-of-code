#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my @program;
my ($A, $B, $C) = (0, 0, 0);

while (<$in>) {
    chomp;
    if (/Register A: (\d+)/) { $A = $1; } 
    if (/Register B: (\d+)/) { $B = $1; }
    if (/Register C: (\d+)/) { $C = $1; }
    if (/Program: (.*)/) { @program = split /,/, $1; }
}

my $ip = 0;
my @output = ();

sub combo_value {
    my ($operand) = @_;
    return $operand if $operand < 4;
    return $A if $operand == 4;
    return $B if $operand == 5;
    return $C if $operand == 6;
    die "Invalid combo operand: $operand\n"; # We must use this in case the operand is equal to '7'.
}

while ($ip < @program) {
    my ($opcode, $operand) = ($program[$ip], $program[$ip + 1]);

    if ($opcode == 0) { $A = int($A / (2 ** combo_value($operand))); } 
    elsif ($opcode == 1) { $B ^= $operand; } 
    elsif ($opcode == 2) { $B = combo_value($operand) % 8; }
    elsif ($opcode == 3) { if ($A != 0) { $ip = $operand; next; } } 
    elsif ($opcode == 4) { $B ^= $C; } 
    elsif ($opcode == 5) { push @output, combo_value($operand) % 8; }
    elsif ($opcode == 6) { $B = int($A / (2 ** combo_value($operand))); } 
    elsif ($opcode == 7) { $C = int($A / (2 ** combo_value($operand))); }
    
    $ip += 2; # It's a jump of two in order for us to move to next instruction.
}

print "Part 01 : ", join(",", @output), "\n";
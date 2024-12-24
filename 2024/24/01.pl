#!/usr/bin/perl -l

use strict;
use warnings;
use Math::BigInt;

open(my $in, '<', 'input.txt') or die $!;

my (%values, @commands);
my $reading_commands = 0;

while (my $l = <$in>) {
    next if $l eq "\n" and $reading_commands = 1; chomp($l);
    $reading_commands ? push(@commands, $l) : ($values{(split(": ", $l))[0]} = (split(": ", $l))[1] + 0);
}

while (@commands) {
    my $line = shift @commands;
    my ($command_line, $output) = split(" -> ", $line);
    my ($input1, $command, $input2) = split(" ", $command_line);

    if (exists $values{$input1} && exists $values{$input2}) {
        my ($value1, $value2, $result) = ($values{$input1} + 0, $values{$input2} + 0, undef);

        $result = $value1 && $value2 if ($command eq "AND");
        $result = $value1 || $value2 if ($command eq "OR");
        $result = $value1 ^ $value2 if ($command eq "XOR");
        $values{$output} = $result + 0;
    } else {
        push(@commands, $line);
    }
}

my $binary = "";
for my $i (0 .. 45) {
    my $key = sprintf("z%02d", $i);
    $binary = $values{$key} . $binary if (exists $values{$key});
}

print "Part 01 : ", Math::BigInt->new("0b$binary");
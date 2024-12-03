-- Pad numbers with leading zeros.
local function pad_number(num)
    return string.format("%02d", num)
end

-- Simulated progress bar
local function show_progress(verb, task)
    for i = 1, 100 do
        io.write(string.format("\r[\27[32m OK \27[0m] \27[90m%s\27[0m %s... %d%%", verb, task, i))
        io.flush()
        os.execute("sleep 0.0001") -- To make the output cool!
    end
    io.write(string.format("\r[\27[32m OK \27[0m] \27[90m%s\27[0m %s... Done\n", verb, task))
end

-- Create the necessary files inside the directory.
local function create_perl_files(number)
    local folder_name = pad_number(number)
    show_progress("Creating", "the project directory")
    os.execute("mkdir -p " .. folder_name)

    local input_file = io.open(folder_name .. "/input.txt", "w")
    if input_file then
        show_progress("Creating", "the input file")
        input_file:write("AoC!\n")
        input_file:close()
    else
        print("Could not create 'input.txt' in folder.")
        return
    end

    show_progress("Creating", "the script files")
    for i = 1, 2 do
        local pl_filename = folder_name .. "/" .. pad_number(i) .. ".pl"
        local pl_file = io.open(pl_filename, "w")
        if pl_file then
            local script_content = [[
#!/usr/bin/perl

use strict;
use warnings;

my $input = "input.txt";

open(my $fh, '<', $input) or die "Cannot open file '$input': $!";

my @line;
my $var = 0;

while (<$fh>) {
    chomp;
    my @line = split(/\s+/, $_);
}

close($fh);

print "Part ]] .. pad_number(i) .. [[ : $var\n";
]]
        pl_file:write(script_content)
        pl_file:close()
        else
            print("Could not create the files in folder.")
            return
        end
    end
end

io.write("Advent of Code - Please specify the day (1-25): ")
local number = tonumber(io.read())

if number then
    create_perl_files(number)
else
    print("Invalid number entered.")
end

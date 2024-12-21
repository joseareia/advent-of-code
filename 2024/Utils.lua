-- @module utils
local utils = {}

-- Ouput messages with colors
local ok = "[\27[32m OK \27[0m]"
local nok = "[\27[31m NOK \27[0m]"

function utils.pad_number(num)
    return string.format("%02d", num)
end

function utils.show_progress(message, command)
    local verb, task = message:match("^(%S+)%s*(.*)") -- Extract the first word and rest of the message.
    local start_time = os.clock() -- Timestamp before the command (or not).

    -- The user could not parse a command, so we need to check it.
    if (command ~= nil) then
        local process = io.popen(command)
        if not process then
            io.write(string.format("\r%s Failed to execute command: %s\n", nok, command))
            return
        end
        process:close()
    end

    local end_time = os.clock() -- Timestamp after the command (or not).
    local duration = end_time - start_time

    local elapsed = 0
    local update_interval = 0.05
    while elapsed < duration do
        local progress = math.min(100, (elapsed / duration) * 100)
        io.write(string.format("\r%s \27[90m%s\27[0m %s... %d%%", ok, verb, task, progress))
        io.flush()
        os.execute("sleep " .. update_interval)
        elapsed = elapsed + update_interval
    end

    io.write(string.format("\r%s \27[90m%s\27[0m %s... Done\n", ok, verb, task))
end

function utils.perl_script(i)
    local script_content = [[
#!/usr/bin/perl

use strict;
use warnings;

open(my $in, '<', 'input.txt') or die $!;

my @line;
my $total = 0;

while (<$in>) {
    chomp;
    my @line = split(/\s+/, $_);
}

print "Part ]] .. utils.pad_number(i) .. [[ : $total\n";
]]
    return script_content
end

return utils
-- Advent of Code Utility Script
-- Author: José Areia
-- Created: 2024-12-01
-- Description: Automates content generation for a specific Advent of Code day.
-- Note: Input files are not auto-downloaded intentionally, as I enjoy examining the input manually.

-- Utils
local utils = require("Utils")

-- Log message within a systemd boot style.. cause it's cool!
local ok = "[\27[32m OK \27[0m] "
local nok = "[\27[31m NOK \27[0m] "

-- Fetch the Advent of Code day by a user input.
io.write("Advent of Code - Please specify the day (1-25): ")
local day = tonumber(io.read())
if not (day >= 1 and day <= 25) then print(nok .. "Invalid day entered.") goto exit end

-- Creates a folder for the specified Advent of Code day.
local folder = utils.pad_number(day)
if io.open(folder, "r") then print(nok .. "The directory for that day already exists.") goto exit end
local command = "mkdir -p " .. folder
utils.show_progress("Creating the project directory", command)

-- Creates the input file and places it inside the previously created directory.
local input_file = io.open(folder .. "/input.txt", "w")
if not input_file then print(nok .. "Failed to create the input file.") goto exit end
utils.show_progress("Creating the input file")
input_file:write("Place your input file here.") -- Content that will be placed inside the input file.
input_file:close()

-- Creates the Perl script file and places it inside the previously created directory.
utils.show_progress("Creating the script files")
for i = 1, 2 do
    local pl_filename = folder .. "/" .. utils.pad_number(i) .. ".pl"
    local pl_file = io.open(pl_filename, "w")
    if not pl_file then print(nok .. "Failed to create the script files.") goto exit end
    script_content = utils.perl_script(i)
    pl_file:write(script_content) -- Content that will be placed inside the script files.
    pl_file:close()
end

::exit::
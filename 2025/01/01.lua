local file = io.open("input.txt", "r")
local dial, count = 50, 0

for line in file:lines() do
    local n = tonumber(line:sub(2)) % 100
    dial = (line:sub(1, 1) == "L" and dial - n or dial + n) % 100
    count = count + ((dial == 0) and 1 or 0)
end

print("Part 01 : " .. count)
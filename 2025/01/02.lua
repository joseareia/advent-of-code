local file = io.open("input.txt", "r")
local rotations, dial, count = {}, 50, 0

for line in file:lines() do
    table.insert(rotations, line:sub(1,1) == "L" and -tonumber(line:sub(2)) or tonumber(line:sub(2)))
end

for _, rot in ipairs(rotations) do
    local n_dial = dial + rot
    count = count 
        + (dial > 0 and n_dial <= 0 and 1 or 0)
        + (dial < 0 and n_dial >= 0 and 1 or 0)
        + math.abs(n_dial // 100)
    dial = n_dial % 100
end

print("Part 02 : " .. count)
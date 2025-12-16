local file = io.open("input.txt", "r")
local total = 0

for range in file:lines() do
    for r in range:gmatch("[^,%s]+") do
        local min, max = r:match("(%d+)-(%d+)")
        for id = tonumber(min), tonumber(max) do
            local s = tostring(id)
            if #s % 2 == 0 then 
                local f_half, l_half = s:sub(1, #s/2), s:sub(#s/2 + 1)
                if f_half == l_half then total = total + id end
            end
        end
    end
end

print("Part 01 : " .. total)
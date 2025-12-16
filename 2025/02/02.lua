local file = io.open("input.txt", "r")
local total = 0

for range in file:lines() do
    for r in range:gmatch("[^,%s]+") do
        local min, max = r:match("(%d+)-(%d+)")
        for id = tonumber(min), tonumber(max) do
            local s = tostring(id)
            local len, is_invalid = #s, false

            for pattern_len = 1, math.floor(len / 2) do
                if len % pattern_len == 0 then
                    local pattern, repetitions = s:sub(1, pattern_len), len/pattern_len
                    local matches = true

                    for i = 1, repetitions do
                        local start_pos = (i - 1) * pattern_len + 1
                        local segment = s:sub(start_pos, start_pos + pattern_len - 1)
                        if segment ~= pattern then matches = false break end
                    end

                    if matches and repetitions >= 2 then is_invalid = true break end
                end
            end
            if is_invalid then total = total + id end
        end
    end
end

print("Part 02 : " .. total)
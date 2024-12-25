with open("input.txt", "r") as file: lines = file.read().strip().splitlines()

total = sum(
    1 for s in lines
    if any(s[i:i+2] in s[i+2:] for i in range(len(s) - 1))
    and any(s[i] == s[i+2] for i in range(len(s) - 2))
)

print("Part 02:", total)

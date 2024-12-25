with open("input.txt", "r") as file: lines = file.read().strip().splitlines()

total = sum(
    1 for string in lines
    if sum(c in "aeiou" for c in string) >= 3
    and any(string[i] == string[i+1] for i in range(len(string) - 1))
    and all(f not in string for f in ["ab", "cd", "pq", "xy"])
)

print("Part 01: ", total)

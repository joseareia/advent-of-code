grid = [[0] * 1000 for _ in range(1000)]

def apply_instruction(instruction):
    parts = instruction.split()
    if parts[0] == "toggle":
        action = "toggle"
        start = list(map(int, parts[1].split(",")))
        end = list(map(int, parts[3].split(",")))
    else:
        action = parts[1]
        start = list(map(int, parts[2].split(",")))
        end = list(map(int, parts[4].split(",")))

    for x in range(start[0], end[0] + 1):
        for y in range(start[1], end[1] + 1):
            if action == "on":
                grid[x][y] += 1
            elif action == "off":
                grid[x][y] = max(0, grid[x][y] - 1)
            elif action == "toggle":
                grid[x][y] += 2

with open("input.txt", "r") as file:
    instructions = file.read().strip().splitlines()

for instruction in instructions:
    apply_instruction(instruction)

total = sum(sum(row) for row in grid)

print(f"Part 02 : {total}")
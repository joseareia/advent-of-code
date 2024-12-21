visited = set()
current_position = (0, 0)
visited.add(current_position)
directions = {'^': (-1, 0), 'v': (1, 0), '<': (0, -1), '>': (0, 1)}

with open("input.txt","r") as file:
    line = file.read().strip()
    for move in line:
        if move in directions:
            dx, dy = directions[move]
            current_position = (current_position[0] + dx, current_position[1] + dy)
            visited.add(current_position)

print("Part 01 :", len(visited))
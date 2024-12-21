visited = set()
santa_position = (0, 0)
robosanta_position = (0, 0)
visited.add(santa_position)
directions = {'^': (-1, 0), 'v': (1, 0), '<': (0, -1), '>': (0, 1)}

with open("input.txt","r") as file:
    line = file.read().strip()
    for i, move in enumerate(line):
        if move in directions:
            if i % 2 == 0:
                dx, dy = directions[move]
                santa_position = (santa_position[0] + dx, santa_position[1] + dy)
                visited.add(santa_position)
            else:
                dx, dy = directions[move]
                robosanta_position = (robosanta_position[0] + dx, robosanta_position[1] + dy)
                visited.add(robosanta_position)

print("Part 02 :", len(visited))
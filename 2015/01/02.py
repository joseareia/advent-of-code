with open("input.txt","r") as file: content = file.read()

total = 0
for i in range(len(content)):
    total += 1 if content[i] == "(" else -1
    if total == -1 : print("Part 02 :", i + 1) ; break
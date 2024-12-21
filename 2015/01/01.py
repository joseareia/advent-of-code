with open("input.txt","r") as file: content = file.read()
print("Part 01 :", sum(1 if char == '(' else -1 for char in content))
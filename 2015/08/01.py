import ast

with open("input.txt", "r") as file:
    lines = file.read().strip().splitlines()

total_code_chars = sum(len(line) for line in lines)
total_memory_chars = sum(len(ast.literal_eval(line)) for line in lines)
print(f"Part 01 : {total_code_chars - total_memory_chars}")
import ast

with open("input.txt", "r") as file:
    lines = file.read().strip().splitlines()

total_code_chars = sum(len(line) for line in lines)
total_memory_chars = sum(len(ast.literal_eval(line)) for line in lines)

def encode_string(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'

total_encoded_chars = sum(len(encode_string(line)) for line in lines)
print(f"Part 02 : {total_encoded_chars - total_code_chars}")
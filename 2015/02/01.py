with open("input.txt","r") as file: 
    total = 0
    while line := file.readline():
        l, w, h = map(int, line.rstrip().split('x'))
        total += (2*l*w + 2*w*h + 2*h*l) + min(l*w, l*h, w*h)

print("Part 01 :", total)
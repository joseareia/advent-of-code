with open("input.txt","r") as file: 
    total = 0
    while line := file.readline():
        l, w, h = map(int, line.rstrip().split('x'))
        total += (l*w*h) + min((2*w+2*l), (2*w+2*h), (2*l+2*h))

print("Part 02 :", total)
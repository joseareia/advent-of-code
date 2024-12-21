import hashlib

i = 0
input = "bgvyzdsv"

while hashlib.md5(input.encode()).hexdigest()[:5] != "00000":
    input = "bgvyzdsv" + str(i) ; i += 1

print("Part 01 :", i-1)
import hashlib

i = 0
input = "bgvyzdsv"

while hashlib.md5(input.encode()).hexdigest()[:6] != "000000":
    input = "bgvyzdsv" + str(i) ; i += 1

print("Part 02 :", i-1)
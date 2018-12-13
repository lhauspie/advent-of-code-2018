from puzzle_core import *
import datetime

nursery = None
notes = []

i = 0
with open("input.txt") as input:
    for line in input:
        line = line.rstrip()
        if i == 0:
            first_line = line.replace("initial state: ", "")
            nursery = Nursery(first_line, 10)
        elif i >= 2 :
            splittedLine = line.split(" => ")
            if splittedLine[1] == "#":
                notes.append(extractInt(splittedLine[0]))
        i += 1

# With the following code, I found there is 53 plants more between 2 generations after more than 1000 generations.
# previousCount = 0
# for i in range(0, 50_000_000_000):
#     if i % 1_000 == 0:
#         newCount = nursery.count()
#         print("iteration ", i, " gives ", newCount, " plants... That make a diff of ", newCount - previousCount, " plants")
#         previousCount = newCount
#     nursery.nextGen(notes)

a = datetime.datetime.now()
for i in range(0, 1_000):
    nursery.nextGen(notes)
b = datetime.datetime.now()

print( (50_000_000_000 - 1_000) * 53 + nursery.count(), " found in ", b-a, " µs")

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

for i in range(0, 20):
    nursery.nextGen(notes)
print(nursery.count())
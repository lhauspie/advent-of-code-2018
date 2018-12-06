# Day 6: Chronal Coordinates

The device on your wrist beeps several times, and once again you feel like you're falling.

"Situation critical," the device announces. "Destination indeterminate. Chronal interference detected. Please specify new target coordinates."

The device then produces a list of coordinates (your puzzle input). Are they places it thinks are safe or dangerous? It recommends you check manual page 729. The Elves did not give you a manual.

If they're dangerous, maybe you can minimize the danger by finding the coordinate that gives the largest distance from the other points.

Using only the Manhattan distance, determine the area around each coordinate by counting the number of integer X,Y locations that are closest to that coordinate (and aren't tied in distance to any other coordinate).

Your goal is to find the size of the largest area that isn't infinite. For example, consider the following list of coordinates:
```
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
```

If we name these coordinates `A` through `F`, we can draw them on a grid, putting `0,0` at the top left:
```
..........
.A........
..........
........C.
...D......
.....E....
.B........
..........
..........
........F.
```

This view is partial - the actual grid extends infinitely in all directions. Using the Manhattan distance, each location's closest coordinate can be determined, shown here in lowercase:
```
aaaaa.cccc
aAaaa.cccc
aaaddecccc
aadddeccCc
..dDdeeccc
bb.deEeecc
bBb.eeee..
bbb.eeefff
bbb.eeffff
bbb.ffffFf
```

Locations shown as `.` are equally far from two or more coordinates, and so they don't count as being closest to any.

In this example, the areas of coordinates A, B, C, and F are infinite - while not shown here, their areas extend forever outside the visible grid. However, the areas of coordinates D and E are finite: D is closest to 9 locations, and E is closest to 17 (both including the coordinate's location itself). Therefore, in this example, the size of the largest area is **17**.

**What is the size of the largest area** that isn't infinite?


## How to run
Lancer les tests:
```
$ julia test/run_tests.jl
```

Lancer les puzzles:
```
$ julia src/puzzle1.jl
$ julia src/puzzle2.jl
```

## Feedback

### C's
- 1h00 pour installer le compilateur Julia, ca va grandement réduire mon temps de résolution du Puzzle
    - Aucun support de apt ou yarn ou snap donc on fait l'installation à la main : https://julialang.org/downloads/index.html
- J'ai perdu un temps incommensurable (2 à 3 heures) sur les histoires de Multidimensionnal Array, pour comprendre que ceux ne sont pas des `Array[][]` mais des `Array[]` simple wrappé dans un object (`Array{Xxx}(2,2)`) qui se charge de gérer les "passage à la ligne" tout seul (Je vomis !!)
    - Cela dit, avec du recul, ca facilite la vie quand on doit parcourrir tous les éléments du tableau à N dimensions.
- Outre, les éccueils dûs à l'appréhension du langage, j'ai subit également une montée de version majeure qui a eut lieux le 9/08/2018... "subit" parce que quand on cherche de l'aide sur StackOverflow ou autre, on ne trouve que des conseils pour la `v0.7` de Julia.
- Les tests sont assez penibles à débuger, mais je m'y prends peut-être un peu mal, il doit y avoir moyen de redécouper en plusiseurs fichiers pour n'exécuter qu'une partie des tests.
- Petit piège : 
    - `a.jl` définie la fonction `get_max_area()`
    - `b.jl` redéfinie la fonction `get_max_area()`
    - `b.jl` utilise `include("a.jl")` donc c'est la définition de `b.jl` qui gagne

### B's
- Le truc génial c'est le typage et l'inférance de type, je n'est quasiment jamais écrit un type de structure dans mes méthodes, c'est quand même un sacré gain de temps même si je reste convaincu que c'est un frein à la maintenabilité
- Les index de table commence à 1, c'est un choix arbitraire qui reste peu répendu mais qui me convient bien, pas besoin d'être vigilent entre compteur et index.
- Le coté cool de Julia, c'est qu'il y a un Shell, un peu à la jshell, ce qui permet de tester rapidement des bouts de code.
- Et la cerise sur le gateau : Il existe des tonnes et des tonnes de fonctions utilitaires built-in pour faire des choses qu'on fait systématiquement en algorithmie, comme l'instantiation de tableau avec une valeur par défaut (ex: `zeros(3,5)` créera une matric de 3 par 5 avec que des `0` ou encore `trues(8)` créera un tableau de 8 booléens avec que des `true`)




LES TESTS, C'EST LA VIE !!!

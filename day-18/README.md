# Day 18 : Settlers of The North Pole ---

On the outskirts of the North Pole base construction project, many Elves are collecting lumber.

The lumber collection area is 50 acres by 50 acres; each acre can be either open ground (.), trees (|), or a lumberyard (#). You take a scan of the area (your puzzle input).

Strange magic is at work here: each minute, the landscape looks entirely different. In exactly one minute, an open acre can fill with trees, a wooded acre can be converted to a lumberyard, or a lumberyard can be cleared to open ground (the lumber having been sent to other projects).

The change to each acre is based entirely on the contents of that acre as well as the number of open, wooded, or lumberyard acres adjacent to it at the start of each minute. Here, "adjacent" means any of the eight acres surrounding that acre. (Acres on the edges of the lumber collection area might have fewer than eight adjacent acres; the missing acres aren't counted.)

In particular:

An open acre will become filled with trees if three or more adjacent acres contained trees. Otherwise, nothing happens.
An acre filled with trees will become a lumberyard if three or more adjacent acres were lumberyards. Otherwise, nothing happens.
An acre containing a lumberyard will remain a lumberyard if it was adjacent to at least one other lumberyard and at least one acre containing trees. Otherwise, it becomes open.
These changes happen across all acres simultaneously, each of them using the state of all acres at the beginning of the minute and changing to their new form by the end of that same minute. Changes that happen during the minute don't affect each other.

For example, suppose the lumber collection area is instead only 10 by 10 acres with this initial configuration:
```
Initial state:
.#.#...|#.
.....#|##|
.|..|...#.
..|#.....#
#.#|||#|#|
...#.||...
.|....|...
||...#|.#|
|.||||..|.
...#.|..|.

After 1 minute:
.......##.
......|###
.|..|...#.
..|#||...#
..##||.|#|
...#||||..
||...|||..
|||||.||.|
||||||||||
....||..|.

After 2 minutes:
.......#..
......|#..
.|.|||....
..##|||..#
..###|||#|
...#|||||.
|||||||||.
||||||||||
||||||||||
.|||||||||

After 3 minutes:
.......#..
....|||#..
.|.||||...
..###|||.#
...##|||#|
.||##|||||
||||||||||
||||||||||
||||||||||
||||||||||

After 4 minutes:
.....|.#..
...||||#..
.|.#||||..
..###||||#
...###||#|
|||##|||||
||||||||||
||||||||||
||||||||||
||||||||||

After 5 minutes:
....|||#..
...||||#..
.|.##||||.
..####|||#
.|.###||#|
|||###||||
||||||||||
||||||||||
||||||||||
||||||||||

After 6 minutes:
...||||#..
...||||#..
.|.###|||.
..#.##|||#
|||#.##|#|
|||###||||
||||#|||||
||||||||||
||||||||||
||||||||||

After 7 minutes:
...||||#..
..||#|##..
.|.####||.
||#..##||#
||##.##|#|
|||####|||
|||###||||
||||||||||
||||||||||
||||||||||

After 8 minutes:
..||||##..
..|#####..
|||#####|.
||#...##|#
||##..###|
||##.###||
|||####|||
||||#|||||
||||||||||
||||||||||

After 9 minutes:
..||###...
.||#####..
||##...##.
||#....###
|##....##|
||##..###|
||######||
|||###||||
||||||||||
||||||||||

After 10 minutes:
.||##.....
||###.....
||##......
|##.....##
|##.....##
|##....##|
||##.####|
||#####|||
||||#|||||
||||||||||
```

After 10 minutes, there are 37 wooded acres and 31 lumberyards. Multiplying the number of wooded acres by the number of lumberyards gives the total resource value after ten minutes: 37 * 31 = 1147.

**What will the total resource value of the lumber collection area be after 10 minutes?**  
and  
**What will the total resource value of the lumber collection area be after 1000000000 minutes?**



## How to run

Lancer les tests: Désolé, il n'y en a pas

Lancers les puzzles:
```
$ g++ -o puzzle puzzle.cpp
$ ./puzzle
```


## Feedback

Le langage a bien évolué depuis la dernière fois que je l'ai pratiqué (15+ ans) et ça rappèle de bons souvenirs de mes études.

Le fait que l'énnoncé indique que le landscape fait 50 par 50 aide énormément en C++ car les tableaux 2D sans taille fixe n'existe pas. J'aurai bien galéré si j'avais eut à faire des matrices dynamiques.


### B's

- Le `Hello, World!` se fait en 10 secondes top chrono. J'ai la chance de faire ca depuis un Linux où la commande `g++` est déjà installé grâce au GNU Compiler Collection (gcc).
- Très bon site sur le CPP : https://en.cppreference.com on y trouve le nécessaire pour coder.


### C's

- Framework de test non intégré, et ca a l'air d'être une vrai tannée à installer et configurer. N'ayant pas forcément le temps, je pense que pour une fois je vais faire l'impasse sur les tests unitaires (ce qui n'est vraiment pas bien du tout, soyons clairs). Mais j'ai quand même fais quelques programmes dans le dossier `tries` qui m'ont permis de valider certains points.
- J'ai tenté de compiler puis d'executer mon puzzle sur une autre machine et je me prends une belle `Erreur de segmentation (core dumped)`. Ce qui est selon moi l'illustration parfaite que C++ n'est pas super portable. 2 Machines, 2 Ubuntu 18.06, 2 x86_64, 2 gcc en version 7.3.0 et pourtant 2 résultats d'éxécution complètement différents. Et ça... c'est dommage !
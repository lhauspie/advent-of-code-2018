# Day 23 : Experimental Emergency Teleportation

Using your torch to search the darkness of the rocky cavern, you finally locate the man's friend: a small reindeer.

You're not sure how it got so far in this cave. It looks sick - too sick to walk - and too heavy for you to carry all the way back. Sleighs won't be invented for another 1500 years, of course.

The only option is experimental emergency teleportation.

You hit the "experimental emergency teleportation" button on the device and push I accept the risk on no fewer than 18 different warning messages. Immediately, the device deploys hundreds of tiny nanobots which fly around the cavern, apparently assembling themselves into a very specific formation. The device lists the X,Y,Z position (pos) for each nanobot as well as its signal radius (r) on its tiny screen (your puzzle input).

Each nanobot can transmit signals to any integer coordinate which is a distance away from it less than or equal to its signal radius (as measured by Manhattan distance). Coordinates a distance away of less than or equal to a nanobot's signal radius are said to be in range of that nanobot.

Before you start the teleportation process, you should determine which nanobot is the strongest (that is, which has the largest signal radius) and then, for that nanobot, the total number of nanobots that are in range of it, including itself.

For example, given the following nanobots:
```
pos=<0,0,0>, r=4
pos=<1,0,0>, r=1
pos=<4,0,0>, r=3
pos=<0,2,0>, r=1
pos=<0,5,0>, r=3
pos=<0,0,3>, r=1
pos=<1,1,1>, r=1
pos=<1,1,2>, r=1
pos=<1,3,1>, r=1
```

The strongest nanobot is the first one (position 0,0,0) because its signal radius, 4 is the largest. Using that nanobot's location and signal radius, the following nanobots are in or out of range:
- The nanobot at 0,0,0 is distance 0 away, and so it is in range.
- The nanobot at 1,0,0 is distance 1 away, and so it is in range.
- The nanobot at 4,0,0 is distance 4 away, and so it is in range.
- The nanobot at 0,2,0 is distance 2 away, and so it is in range.
- The nanobot at 0,5,0 is distance 5 away, and so it is not in range.
- The nanobot at 0,0,3 is distance 3 away, and so it is in range.
- The nanobot at 1,1,1 is distance 3 away, and so it is in range.
- The nanobot at 1,1,2 is distance 4 away, and so it is in range.
- The nanobot at 1,3,1 is distance 5 away, and so it is not in range.

In this example, in total, 7 nanobots are in range of the nanobot with the largest signal radius.

**Find the nanobot with the largest signal radius. How many nanobots are in range of its signals?**  
and  
**Find the coordinates that are in range of the largest number of nanobots. What is the shortest manhattan distance between any of those points and 0,0,0?**
 


## How to run

Lancer les tests:
```
$ cd puzzle
$ lein test
```

Lancer les puzzles:
```
$ cd puzzle
$ lein run
```


## Feedback


### B's

- On est dans la JVM et on bénéficie de maven pour la partie Dependency Manager. Même si je ne m'en suis pas servi, cela peut être utile.
- Et comme on est dans la JVM, il y a l'interopérabilité avec des composants Java (comme les list, les set, les Integers), ce qu je me suis interdit d'utiliser pour l'exercice.
- On est beaucoup aidé pour init le projet grâce à Leiningen: `lein new tries`
- La doc est super bien faites, avec des exemples de code pour chaque fonction. C'est très appréciable !
- Le currying est facile à mettre en place et plutot explicite via l'opérateur `partial`.

### C's

- J'ai été très décontenancé par le (non)typage des objets.. En fait, je n'ai pas trouvé comment définir de manière forte une structure de données. Il y a bien `deftype` et `defrecord` mais lors de la déclaration d'une fonction à l'aide de `defn`, les paramètres n'ont pas de type. On se croirait en JavaScript (mais je me trompe peut-être). D'ailleurs on instancie un objet comme ça `{:x 10 :y 1 :z 0}` vous avouerez que le ressemblance avec JS est frappante, non ?



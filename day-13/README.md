# Day 13 : Mine Cart Madness

A crop of this size requires significant logistics to transport produce, soil, fertilizer, and so on. The Elves are very busy pushing things around in **carts** on some kind of rudimentary system of tracks they've come up with.

Seeing as how cart-and-track systems don't appear in recorded history for another 1000 years, the Elves seem to be making this up as they go along. They haven't even figured out how to avoid collisions yet.

You map out the tracks (your puzzle input) and see where you can help.

Tracks consist of straight paths (`|` and `-`), curves (`/` and `\`), and intersections (`+`). Curves connect exactly two perpendicular pieces of track; for example, this is a closed loop:
```
/----\
|    |
|    |
\----/
```

Intersections occur when two perpendicular paths cross. At an intersection, a cart is capable of turning left, turning right, or continuing straight. Here are two loops connected by two intersections:
```
/-----\
|     |
|  /--+--\
|  |  |  |
\--+--/  |
   |     |
   \-----/
```

Several **carts** are also on the tracks. Carts always face either up (`^`), down (`v`), left (`<`), or right (`>`). (On your initial map, the track under each cart is a straight path matching the direction the cart is facing.)

Each time a cart has the option to turn (by arriving at any intersection), it turns **left** the first time, goes **straight** the second time, turns **right** the third time, and then repeats those directions starting again with **left** the fourth time, **straight** the fifth time, and so on. This process is independent of the particular intersection at which the cart has arrived - that is, the cart has no per-intersection memory.

Carts all move at the same speed; they take turns moving a single step at a time. They do this based on their **current location**: carts on the top row move first (acting from left to right), then carts on the second row move (again from left to right), then carts on the third row, and so on. Once each cart has moved one step, the process repeats; each of these loops is called a **tick**.

For example, suppose there are two carts on a straight track:
```
|  |  |  |  |
v  |  |  |  |
|  v  v  |  |
|  |  |  v  X
|  |  ^  ^  |
^  ^  |  |  |
|  |  |  |  |
```

First, the top cart moves. It is facing down (v), so it moves down one square. Second, the bottom cart moves. It is facing up (^), so it moves up one square. Because all carts have moved, the first tick ends. Then, the process repeats, starting with the first cart. The first cart moves down, then the second cart moves up - right into the first cart, colliding with it! (The location of the crash is marked with an X.) This ends the second and last tick.

Here is a longer example:
```
/->-\        
|   |  /----\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/   

/-->\        
|   |  /----\
| /-+--+-\  |
| | |  | |  |
\-+-/  \->--/
  \------/   

/---v        
|   |  /----\
| /-+--+-\  |
| | |  | |  |
\-+-/  \-+>-/
  \------/   

/---\        
|   v  /----\
| /-+--+-\  |
| | |  | |  |
\-+-/  \-+->/
  \------/   

/---\        
|   |  /----\
| /->--+-\  |
| | |  | |  |
\-+-/  \-+--^
  \------/   

/---\        
|   |  /----\
| /-+>-+-\  |
| | |  | |  ^
\-+-/  \-+--/
  \------/   

/---\        
|   |  /----\
| /-+->+-\  ^
| | |  | |  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /----<
| /-+-->-\  |
| | |  | |  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /---<\
| /-+--+>\  |
| | |  | |  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /--<-\
| /-+--+-v  |
| | |  | |  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /-<--\
| /-+--+-\  |
| | |  | v  |
\-+-/  \-+--/
  \------/   

/---\        
|   |  /<---\
| /-+--+-\  |
| | |  | |  |
\-+-/  \-<--/
  \------/   

/---\        
|   |  v----\
| /-+--+-\  |
| | |  | |  |
\-+-/  \<+--/
  \------/   

/---\        
|   |  /----\
| /-+--v-\  |
| | |  | |  |
\-+-/  ^-+--/
  \------/   

/---\        
|   |  /----\
| /-+--+-\  |
| | |  X |  |
\-+-/  \-+--/
  \------/   
```

After following their respective paths for a while, the carts eventually crash. To help prevent crashes, you'd like to know **the location of the first crash**. Locations are given in `X,Y` coordinates, where the furthest left column is `X=0` and the furthest top row is `Y=0`:
```
           111
 0123456789012
0/---\        
1|   |  /----\
2| /-+--+-\  |
3| | |  X |  |
4\-+-/  \-+--/
5  \------/   
```

In this example, the location of the first crash is **`7,3`**.

**What is the first crash location?**
and
**What is the location of the last cart after all other carts crashed and removed?**


## How to run

Lancer les tests:
```
$ ruby puzzle1/test/ts_all.rb
$ ruby puzzle2/test/ts_all.rb
```

Lancers les puzzles:
```
$ ruby puzzle1/src/puzzle.rb
$ ruby puzzle2/src/puzzle.rb
```


## Feedback

Ruby ressemble à s'y méprendre à du Python en terme de syntaxe, donc c'est un avantage de l'avoir pratiqué hier.

J'ai quand même perdu énoooooorménent de temps à cause d'une petite erreur de lecture de l'énoncé.

### B's

- La doc d'install est plutôt claire et simple : https://linuxize.com/post/how-to-install-ruby-on-ubuntu-18-04/
- Un wiki tout aussi clair et simple nous permet de s'initier au langage et aux tests unitaires : https://en.wikibooks.org/wiki/Ruby_Programming/Unit_testing
- Les rapports d'erreur sur les tests unitaires sont d'une rare qualité, avec de la couleur:
    - Le bloc de code est cité, avec un surlignage rouge pétant sur la ligne en erreur
    - Le resultat et l'attendu sont mis en perspective avec un jeu de couleur bien choisi (même pour un daltonien)


### C's

- Il ne semble pas être possible d'executer tous les testt cases (fichier `tc_*`) d'une seule commande
    - On est obligé de remplir un fichier test suite (fichier `ts_*`) qu'il faut remplir à la main. Donc forcément, quand on ajoute un nouveau test case, et bein on oublie, la moitier du temps, de l'ajouter au fichier test suite :(
- Je ne sais pas si je dois le mettre en B's ou en C's, mais tous les membres d'une classe sont protected.
    - Il n'y aucune notion de privée/publique.
    - Il faut passer par des getters/setters.
    - Ca fait du travail en plus, mais au moins... rien n'est public.
    - En fait, pas tout à fait, il est possible d'atteindre des variables d'instance grâce à `o.instance_variable_get(:@var)` et aussi de les mettre à jour avec `o.instance_variable_set(:@var, "foo")`... Donc je le range dans les C's
- Les enums n'existe pas en Ruby, il faut gruger avec la création d'un module
- A l'image de Python, le langage est ultra permissif et permet des énormités dans le code comme des typos qui font parfois perdre des heures comme avec ce bout de code (trouvez l'erreur):
    ```Ruby
    engine = Engine.new(strings)
    collision = nil
    while collision == nil
        colision = engine.step()
    end

    print(collision, "\n")
    ```

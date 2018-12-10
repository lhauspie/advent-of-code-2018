# Day 9: Marble Mania ---

You talk to the Elves while you wait for your navigation system to initialize. To pass the time, they introduce you to their favorite marble game.

The Elves play this game by taking turns arranging the marbles in a **circle** according to very particular rules. The marbles are numbered starting with `0` and increasing by `1` until every marble has a number.

First, the marble numbered `0` is placed in the **circle**. At this point, while it contains only a single marble, it is still a circle: the marble is both clockwise from itself and counter-clockwise from itself. This marble is designated the **current marble**.

Then, each Elf takes a turn placing the lowest-numbered remaining marble into the circle between the marbles that are `1` and `2` marbles **clockwise** of the current marble. (When the circle is large enough, this means that there is one marble between the marble that was just placed and the current marble.) The marble that was just placed then becomes the **current marble**.

However, if the marble that is about to be placed has a number which is a multiple of `23`, **something entirely different happens**. First, the current player keeps the marble they would have placed, adding it to their **score**. In addition, the marble `7` marbles **counter-clockwise** from the current marble is **removed** from the circle and **also** added to the current player's score. The marble located immediately **clockwise** of the marble that was removed becomes the new **current marble**.

For example, suppose there are 9 players. After the marble with value 0 is placed in the middle, each player (shown in square brackets) takes a turn. The result of each of those turns would produce circles of marbles like this, where clockwise is to the right and the resulting current marble is in parentheses:
```
[-] (0)
[1]  0 (1)
[2]  0 (2) 1 
[3]  0  2  1 (3)
[4]  0 (4) 2  1  3 
[5]  0  4  2 (5) 1  3 
[6]  0  4  2  5  1 (6) 3 
[7]  0  4  2  5  1  6  3 (7)
[8]  0 (8) 4  2  5  1  6  3  7 
[9]  0  8  4 (9) 2  5  1  6  3  7 
[1]  0  8  4  9  2(10) 5  1  6  3  7 
[2]  0  8  4  9  2 10  5(11) 1  6  3  7 
[3]  0  8  4  9  2 10  5 11  1(12) 6  3  7 
[4]  0  8  4  9  2 10  5 11  1 12  6(13) 3  7 
[5]  0  8  4  9  2 10  5 11  1 12  6 13  3(14) 7 
[6]  0  8  4  9  2 10  5 11  1 12  6 13  3 14  7(15)
[7]  0(16) 8  4  9  2 10  5 11  1 12  6 13  3 14  7 15 
[8]  0 16  8(17) 4  9  2 10  5 11  1 12  6 13  3 14  7 15 
[9]  0 16  8 17  4(18) 9  2 10  5 11  1 12  6 13  3 14  7 15 
[1]  0 16  8 17  4 18  9(19) 2 10  5 11  1 12  6 13  3 14  7 15 
[2]  0 16  8 17  4 18  9 19  2(20)10  5 11  1 12  6 13  3 14  7 15 
[3]  0 16  8 17  4 18  9 19  2 20 10(21) 5 11  1 12  6 13  3 14  7 15 
[4]  0 16  8 17  4 18  9 19  2 20 10 21  5(22)11  1 12  6 13  3 14  7 15 
[5]  0 16  8 17  4 18(19) 2 20 10 21  5 22 11  1 12  6 13  3 14  7 15 
[6]  0 16  8 17  4 18 19  2(24)20 10 21  5 22 11  1 12  6 13  3 14  7 15 
[7]  0 16  8 17  4 18 19  2 24 20(25)10 21  5 22 11  1 12  6 13  3 14  7 15
```

The goal is to be the **player with the highest score** after the last marble is used up. Assuming the example above ends after the marble numbered `25`, the winning score is `23+9=32` (because player 5 kept marble `23` and removed marble `9`, while no other player got any points in this very short example game).

Here are a few more examples:

    `10` players; last marble is worth `1618` points: high score is `8317`
    `13` players; last marble is worth `7999` points: high score is `146373`
    `17` players; last marble is worth `1104` points: high score is `2764`
    `21` players; last marble is worth `6111` points: high score is `54718`
    `30` players; last marble is worth `5807` points: high score is `37305`

**What is the winning Elf's score?**
  

## How to run

Lancer les tests:
```
$ lua puzzle_core_test.lua -v
```

Lancers les puzzles:
```
$ lua puzzle1.lua
$ lua puzzle2.lua
```


## Feedback

Je ne sais pas si je dois le mettre dans B's ou dans C's mais c'est un langage compilé qui est ensuite interprété dans une VM... Un peu comme java en fait.

Fort heureusement, je suis parti dans la bonne direction dès le début : utilisation d'une "LikedList" cyclique.  
Dans le cas contraire, j'aurai été dans l'obligation de tout recoder car la finalité de la partie 2 était simplement de faire exactement la même chose mais en multipliant par 100 le nombre de billes.

En fin de session, je me pose la question de construire un executable, je tombe sur [luastatic](https://github.com/ers35/luastatic) et en lisant le `README.md` je me dis que, quand même, les `Lua`istes adorent se faire des noeuds à la tête ! Ca transpile le code Lua en code C pour ensuite être compilé en executable standalone:
```
$ luarocks install --local luastatic
$ ~/.luarocks/bin/luastatic puzzle1.lua puzzle_core.lua /usr/lib/x86_64-linux-gnu/liblua5.1.a -I/usr/include/lua5.1
cc -Os puzzle1.lua.c  /usr/lib/x86_64-linux-gnu/liblua5.1.a -rdynamic -lm -ldl -o puzzle1 -I/usr/include/lua5.1
$ ~/.luarocks/bin/luastatic puzzle2.lua puzzle_core.lua /usr/lib/x86_64-linux-gnu/liblua5.1.a -I/usr/include/lua5.1
cc -Os puzzle2.lua.c  /usr/lib/x86_64-linux-gnu/liblua5.1.a -rdynamic -lm -ldl -o puzzle2 -I/usr/include/lua5.1
```

Avec un peu de recule, je me dis que j'aurai pu utiliser le `PonyLang` pour ce puzzle, car les `Elfes` auraient pu être des acteurs tout comme le `Plateau de jeu` pour gérer de la back pressure... j'espère avoir une autre occasion de m'essayer à ce langage.

En cherchant à savoir si d'autres l'avaient fait en Lua, je suis tombé sur [cette solution](https://www.reddit.com/r/adventofcode/comments/a4i97s/2018_day_9_solutions/ebephqt/) (très élégante cela dit en passant) qui est 15 fois plus concise que la mienne. Mais on comprend vite que ce code n'est pas testable de manière automatisée.


### B's

- Lua ne fait que 300ko, reste à voir combien fera l'executable final de mon programme. En comparaison, Julia faisait, au bas mot, 300Mo !
- Il s'installe en deux deux : `sudo apt install lua5.2` bien plus facile que Elixir
- Un petit site de démo nous aide à prendre en main le language... un peu comme _Go Playground_ mais en beaucoup moins bien : https://www.lua.org/cgi-bin/demo
- Langage très simple et facile d'accés une fois les écueils d'installation passés
    - Tellement simple que la structure de données `cycle` (présent en Python par exemple) n'existe pas, j'ai donc dû la recoder et la tester, ce qui m'a pris une bonne partie de mon temps.


### C's

- Pas d'outillage built-in pour executer ses tests, obligation d'utiliser un framework à part. Lua n'a jamais pris partie pour l'un ou l'autre de ces framework pour l'intégrer. Je pars donc sur LuaUnit
- LuaUnit s'installe en copiant/collant un fichier luaunit.lua du repo github : Whaaaaaaaaat ????
- Ah bein il existe un Package Manager spécifique à Lua : LuaRocks... c'est partie pour l'install : https://luarocks.org/
    - Bon finalement, c'est une grosse tanée à installer, il a besoin d'un fichier source pour pouvoir s'installer (o_O) (o_O) (o_O) : `lua.h`
    - Dépot du dit fichier à l'empacement souhaité (o_O) : `sudo cp -r /home/lhauspie/app/lua/5.2.4/src/* /usr/include/lua/5.2/`
    - Après une petite copie sauvage de quelques fichiers source de lua, le `./configure` fonctionne enfin !!!
    - Suivi du fameux `sudo make bootstrap` qui ne fonctionne pas du tout !! `Error: Failed finding Lua library. You may need to configure LUA_LIBDIR.`
    - Et en fait, la doc est complètement à chier parce qu'il suffit juste de faire un bon vieux `sudo apt install luarocks`
    - `sudo luarocks install luaunit` ne fonctionne pas du tout, car il ne trouve pas `lua.h` (copié/collé plus haut)
    - Ah bein non, en fait, il faut les copier là : `sudo cp -r /home/lhauspie/app/lua/5.2.4/src/* /usr/include/lua5.2/` nuance !!
    - Donc soit j'ai raté un énorme truc (ce qui fait que je galère) soit ceux sont des étapes nécessaires mais très males documentées.
- Ca fait maintenant 2h30 que je tente d'executer un pauvre test unitaire `Hello, World!`
    - Je me rends compte par hasard que `luarocks path` n'affiche pas les paths Lua en place, mais ce qu'il faut executer pour qu'ils le soient : `$(luarocks path)` !!!!
    - Ca fonctionne enfin !!!!! \o/ je vais enfin pouvoir commencer à resoudre le puzzle du jour :S
    - Les sites qui m'ont bien aidé : 
        - http://leafo.net/guides/customizing-the-luarocks-tree.html
        - https://luaunit.readthedocs.io/en/luaunit_v3_2_1/
- Bon passé outre ce démarrage très compliqué, il est vite pénible de devoir copier des `luaunit.` partout dans le code de test
- Pas de POO, donc on gruge et tout le monde le sait et s'en accorde ! [Comme on peut le voir ici](https://openclassrooms.com/forum/sujet/lua-creer-une-class-objet-50210#message-3962851)

- Pour splitter son code en plusieurs fichiers `.lua`, il faut aussi utiliser une gruge de sioux qui nous oblige à mettre des `M.` à toutes les sauces
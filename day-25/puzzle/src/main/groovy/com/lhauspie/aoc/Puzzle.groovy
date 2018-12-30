package com.lhauspie.aoc

class Puzzle {
    static void main(def args) {
        def puzzle = new Puzzle()

        def lines = []
        new File("input.txt").eachLine { line, lineNumber ->
            lines.add(line)
        }

        println "step 1: " + puzzle.step1(lines)
    }

    List<Star> parse(List<String> lines) {
        def stars = []
        for (line in lines) {
            stars.add(new Star(line))
        }
        return stars
    }

    Integer step1(List<String> lines) {
        def stars = parse(lines);
        def current_constellation = 0;
        def nb_constellations = 0;

        def i = 0;
        for (star_1 in stars) {
            for (star_2 in stars.subList(0, i)) {
                if (star_1.distanceFrom(star_2) <= 3) {
                    // same constellation
                    if (star_1.c == null) {
                        // star_1 is not part of constellation, so join
                        star_1.c = star_2.c
                    } else if (star_2.c != star_1.c) {
                        // merge constellations only if they are in different in both stars
                        def constellation = star_2.c
                        for (star in stars) {
                            if (star.c != null && star.c == constellation) {
                                star.c = star_1.c
                            }
                        }
                        nb_constellations -= 1
                    }
                }
            }
            if (star_1.c == null) {
                // no constellation found so create a new one
                star_1.c = current_constellation
                current_constellation += 1
                nb_constellations += 1
            }
            i++;
        }

        return nb_constellations
    }
}
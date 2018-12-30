package com.lhauspie.oac

import static groovy.test.GroovyAssert.*
import org.junit.*
import com.lhauspie.aoc.Puzzle

class PuzzleTest {
    def puzzle

    @Before
    void setUp() {
        println "Inside setup()"
        puzzle = Puzzle.newInstance()
    }

    @Test
    void test_parse() {
        def lines = ["0,1,2,3", "-1,-2,-3,-4", "0,0,0,0"]
        def stars = puzzle.parse(lines)
        assertEquals(3, stars.size())
        assertEquals(0, stars[0].x)
        assertEquals(-1, stars[1].x)
        assertEquals(0, stars[2].x)
    }


    @Test
    void test_step1_example1() {
        def lines = [
            "0,0,0,0",
            "3,0,0,0",
            "0,3,0,0",
            "0,0,3,0",
            "0,0,0,3",
            "0,0,0,6",
            "9,0,0,0",
            "12,0,0,0"
        ]
        assertEquals(2, puzzle.step1(lines))
    }

    @Test
    void test_step1_example2() {
        def lines = [
            "-1,2,2,0",
            "0,0,2,-2",
            "0,0,0,-2",
            "-1,2,0,0",
            "-2,-2,-2,2",
            "3,0,2,-1",
            "-1,3,2,2",
            "-1,0,-1,0",
            "0,2,1,-2",
            "3,0,0,0"
        ]
        assertEquals(4, puzzle.step1(lines))
    }

    @Test
    void test_step1_example3() {
        def lines = [
            "1,-1,0,1",
            "2,0,-1,0",
            "3,2,-1,0",
            "0,0,3,1",
            "0,0,-1,-1",
            "2,3,-2,0",
            "-2,2,0,0",
            "2,-2,0,-1",
            "1,-1,0,-1",
            "3,2,0,2"
        ]
        assertEquals(3, puzzle.step1(lines))
    }

    @Test
    void test_step1_example4() {
        def lines = [
            "1,-1,-1,-2",
            "-2,-2,0,1",
            "0,2,1,3",
            "-2,3,-2,1",
            "0,2,3,-2",
            "-1,-1,1,-2",
            "0,-2,-1,0",
            "-2,2,3,-1",
            "1,2,2,0",
            "-1,-2,0,-2"
        ]
        assertEquals(8, puzzle.step1(lines))
    }
}
package com.lhauspie.adventofcode

import kotlin.test.assertEquals
import kotlin.test.assertTrue
import org.junit.Test
import java.util.Arrays
import org.junit.Assert


class PuzzleTest {
    private val puzzle: Puzzle

    init {
        puzzle = Puzzle()
    }



    @Test fun addr() {
        check(puzzle.addr,
                intArrayOf(1, 2, 3, 4),
                intArrayOf(-1, 0, 1, 3),
                intArrayOf(1, 2, 3, 3))

        check(puzzle.addr,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 0, 1, 2),
                intArrayOf(6, 2, 8, 4))

        check(puzzle.addr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 0, 1, 0),
                intArrayOf(6, 2, 3, 4))

        check(puzzle.addr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 0, 10, 0),
                null)
    }


    @Test fun addi() {
        check(puzzle.addi,
                intArrayOf(1, 2, 3, 4),
                intArrayOf(-1, 0, 6, 3),
                intArrayOf(1, 2, 3, 7))

        check(puzzle.addi,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 0, 6, 2),
                intArrayOf(6, 2, 12, 4))

        check(puzzle.addi,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 0, 6, 0),
                intArrayOf(10, 2, 3, 4))

        check(puzzle.addi,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 0, 10, 0),
                intArrayOf(14, 2, 3, 4))
    }


    @Test fun mulr() {
        check(puzzle.mulr,
                intArrayOf(1, 2, 3, 4),
                intArrayOf(-1, 0, 2, 3),
                intArrayOf(1, 2, 3, 3))

        check(puzzle.mulr,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 0, 2, 2),
                intArrayOf(6, 2, 18, 4))

        check(puzzle.mulr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 1, 2, 0),
                intArrayOf(6, 2, 3, 4))

        check(puzzle.mulr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 10, 5, 0),
                null)
    }

    @Test fun muli() {
        check(puzzle.muli,
                intArrayOf(1, 2, 3, 4),
                intArrayOf(-1, 2, 4, 3),
                intArrayOf(1, 2, 3, 12))

        check(puzzle.muli,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 0, 4, 2),
                intArrayOf(6, 2, 24, 4))

        check(puzzle.muli,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 0, 4, 0),
                intArrayOf(16, 2, 3, 4))

        check(puzzle.muli,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 0, 11, 2),
                intArrayOf(4, 2, 44, 4))
    }

    @Test fun setr() {
        check(puzzle.setr,
                intArrayOf(5, 2, 3, 4),
                intArrayOf(-1, 0, -1, 3),
                intArrayOf(5, 2, 3, 5))

        check(puzzle.setr,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 3, -1, 2),
                intArrayOf(6, 2, 4, 4))

        check(puzzle.setr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 0, -1, 0),
                intArrayOf(4, 2, 3, 4))

        check(puzzle.setr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 10, -1, 2),
                null)
    }

    @Test fun seti() {
        check(puzzle.seti,
                intArrayOf(5, 2, 3, 4),
                intArrayOf(-1, 0, -1, 3),
                intArrayOf(5, 2, 3, 0))

        check(puzzle.seti,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 5, -1, 2),
                intArrayOf(6, 2, 5, 4))

        check(puzzle.seti,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 0, -1, 0),
                intArrayOf(0, 2, 3, 4))

        check(puzzle.seti,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 10, -1, 2),
                intArrayOf(4, 2, 10, 4))
    }

    @Test fun gtrr() {
        check(puzzle.gtrr,
                intArrayOf(5, 2, 3, 4),
                intArrayOf(-1, 0, 2, 3),
                intArrayOf(5, 2, 3, 1))

        check(puzzle.gtrr,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 1, 0, 2),
                intArrayOf(6, 2, 0, 4))

        check(puzzle.gtrr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 3, 0, 0),
                intArrayOf(0, 2, 3, 4))

        check(puzzle.gtrr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 10, 1, 2),
                null)

        check(puzzle.gtrr,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 1, 10, 2),
                null)
    }

    @Test fun gtri() {
        check(puzzle.gtri,
                intArrayOf(5, 2, 3, 4),
                intArrayOf(-1, 0, 2, 3),
                intArrayOf(5, 2, 3, 1))

        check(puzzle.gtri,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 1, 0, 2),
                intArrayOf(6, 2, 1, 4))

        check(puzzle.gtri,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 3, 0, 0),
                intArrayOf(1, 2, 3, 4))

        check(puzzle.gtri,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 10, 1, 2),
                null)

        check(puzzle.gtri,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 1, 10, 2),
                intArrayOf(4, 2, 0, 4))
    }

    @Test fun gtir() {
        check(puzzle.gtir,
                intArrayOf(5, 2, 3, 4),
                intArrayOf(-1, 0, 2, 3),
                intArrayOf(5, 2, 3, 0))

        check(puzzle.gtir,
                intArrayOf(6, 2, 3, 4),
                intArrayOf(-1, 1, 0, 2),
                intArrayOf(6, 2, 0, 4))

        check(puzzle.gtir,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 3, 1, 0),
                intArrayOf(1, 2, 3, 4))

        check(puzzle.gtir,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 10, 1, 2),
                intArrayOf(4, 2, 1, 4))

        check(puzzle.gtir,
                intArrayOf(4, 2, 3, 4),
                intArrayOf(-1, 1, 10, 2),
                null)
    }

    @Test
    fun eqrr() {
        check(puzzle.eqrr,
                intArrayOf(1, 2, 2, 0),
                intArrayOf(2, 1, 2, 1),
                intArrayOf(1, 1, 2, 0))
    }

    @Test fun extract() {
        Assert.assertArrayEquals(puzzle.extractBefore("Before: [3, 2, 1, 1]"), intArrayOf(3, 2, 1, 1))
        Assert.assertArrayEquals(puzzle.extractInstruction("3 2 1 1"), intArrayOf(3, 2, 1, 1))
        Assert.assertArrayEquals(puzzle.extractAfter("After:  [3, 2, 1, 1]"), intArrayOf(3, 2, 1, 1))
    }


    @Test fun behaveLikeThreeOrMoreOpCodes() {
        /*
            Before: [3, 2, 1, 1]
            9 2 1 2
            After:  [3, 2, 2, 1]
        */
        val before = intArrayOf(3, 2, 1, 1)
        val instruction = intArrayOf(9, 2, 1, 2)
        val after = intArrayOf(3, 2, 2, 1)

        assertEquals(puzzle.numberOfMatchingOpCodes(before, instruction, after), 3)
    }

    fun check(operation : (IntArray, IntArray)->IntArray?, registers : IntArray, instruction : IntArray, expected : IntArray?) {
        Assert.assertArrayEquals(expected, operation(registers, instruction))
    }
}

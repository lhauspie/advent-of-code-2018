package com.lhauspie.aoc;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for simple Puzzle.
 */
public class PuzzleTest extends TestCase {
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public PuzzleTest(String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( PuzzleTest.class );
    }

    /**
     * Rigourous Test :-)
     */
    public void testApp() {
        assertEquals(18346, Puzzle.step1());
        assertEquals(8698, Puzzle.step2());
    }
}

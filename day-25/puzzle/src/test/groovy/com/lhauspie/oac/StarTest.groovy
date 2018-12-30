package com.lhauspie.oac

import com.lhauspie.aoc.Star

class StarTest extends GroovyTestCase {

    void test_parse() {
        def star_1 = new Star("0,1,2,3")
        assertEquals(0, star_1.x)
        assertEquals(1, star_1.y)
        assertEquals(2, star_1.z)
        assertEquals(3, star_1.a)

        def star_2 = new Star("-1,-2,-3,-4")
        assertEquals(-1, star_2.x)
        assertEquals(-2, star_2.y)
        assertEquals(-3, star_2.z)
        assertEquals(-4, star_2.a)
    }

    void test_distance() {
        println "Running test_sayHello_World"
        def star_1 = new Star("0,0,0,0")
        def star_2 = new Star("3,3,3,3")

        assertEquals(12, star_1.distanceFrom(star_2))
        assertEquals(12, star_2.distanceFrom(star_1))
    }

    void tearDown() {
        println "Inside tearDown()"
    }
}
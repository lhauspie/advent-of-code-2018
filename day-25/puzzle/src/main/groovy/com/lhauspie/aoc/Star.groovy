package com.lhauspie.aoc;

class Star {
    Integer x
    Integer y
    Integer z
    Integer a

    Integer c

    Star(String s) {
        def split = s.split(",")
        this.x = split[0] as Integer
        this.y = split[1] as Integer
        this.z = split[2] as Integer
        this.a = split[3] as Integer
    }

    def distanceFrom(Star s) {
        Math.abs(this.x - s.x) + Math.abs(this.y - s.y) + Math.abs(this.z - s.z) + Math.abs(this.a - s.a)
    }
}

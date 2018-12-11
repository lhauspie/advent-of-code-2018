<?php
declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class CoordTest extends TestCase {
    public function testAdd_1_1_toCoord() {
        $coord = new Coord(3, 4);
        $coord->add(new Coord(1, 1));
        $this->assertEquals(
            $coord,
            new Coord(4, 5)
        );
    }

    public function testAdd_1_5_toCoord() {
        $coord = new Coord(3, 4);
        $coord->add(new Coord(1, 5));
        $this->assertEquals(
            $coord,
            new Coord(4, 9)
        );
    }
}

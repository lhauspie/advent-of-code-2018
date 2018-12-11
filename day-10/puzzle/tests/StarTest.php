<?php
declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class StarTest extends TestCase {
    public function testMove55UpdatesCoord(): void {
        $star = new Star(new Coord(1, 1), new Coord(5, 5));
        $star->move();
        $this->assertEquals($star->position, new Coord(6, 6));
    }

    public function testMove28UpdatesCoord(): void {
        $star = new Star(new Coord(1, 1), new Coord(2, 8));
        $star->move();
        $this->assertEquals($star->position, new Coord(3, 9));
    }

    public function testGetNormalizedPositionCoord(): void {
        $star = new Star(new Coord(-4998, -3003), new Coord(2, 8));
        $this->assertEquals($star->position, new Coord(-4998, -3003));
        $normalizedPosition = $star->getNormalizedPosition(new Coord(-5000, -2000));
        $this->assertEquals($normalizedPosition, new Coord(2, -1003));
        $this->assertEquals($star->position, new Coord(-4998, -3003));
    }
}
<?php
declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class SkyTest extends TestCase {
    public function testAddStarToSky() {
        $sky = new Sky();
        $sky->push(new Star(new Coord(1, 1), new Coord(1,2)));
        $this->assertEquals($sky->nbStars, 1);
        $sky->push(new Star(new Coord(1, 1), new Coord(1,2)));
        $this->assertEquals($sky->nbStars, 2);
    }

    public function testGetBounds() {
        $sky = new Sky();
        $sky->push(new Star(new Coord(8, 10), new Coord(1,2)));
        $sky->push(new Star(new Coord(10, 8), new Coord(1,2)));
        $this->assertEquals($sky->getTopLeftCoord(), new Coord(8, 8));
        $this->assertEquals($sky->getBottomRightCoord(), new Coord(10, 10));
    }

    public function testGetBoundsBis() {
        $sky = new Sky();
        $sky->push(new Star(new Coord(-10, 8), new Coord(1,2)));
        $sky->push(new Star(new Coord(-20, 40), new Coord(1,2)));
        $this->assertEquals($sky->getTopLeftCoord(), new Coord(-20, 8));
        $this->assertEquals($sky->getBottomRightCoord(), new Coord(-10, 40));
    }

    public function testCompute() {
        $sky = new Sky();
        $sky->push(new Star(new Coord(8, 10), new Coord(5, -2)));
        $sky->push(new Star(new Coord(10, 8), new Coord(-10, 2)));
        $sky->compute();
        $this->assertEquals($sky->stars[0]->position, new Coord(13, 8));
        $this->assertEquals($sky->stars[1]->position, new Coord(0, 10));
    }

    public function testGetNormalizedCoordAfterCompute() {
        $sky = new Sky();
        $sky->push(new Star(new Coord(8, 10), new Coord(5, -2)));
        $sky->push(new Star(new Coord(10, 8), new Coord(-10, 2)));
        $sky->compute();

        $this->assertEquals($sky->stars[0]->position, new Coord(13, 8));
        $this->assertEquals($sky->stars[1]->position, new Coord(0, 10));

        $topLeftCoord = $sky->getTopLeftCoord();
        $this->assertEquals($topLeftCoord, new Coord(0, 8));
        $this->assertEquals($sky->getBottomRightCoord(), new Coord(13, 10));

        $normalizedPosition = $sky->stars[0]->getNormalizedPosition($topLeftCoord);
        $this->assertEquals($normalizedPosition, new Coord(13, 0));
        $normalizedPosition = $sky->stars[1]->getNormalizedPosition($topLeftCoord);
        $this->assertEquals($normalizedPosition, new Coord(0, 2));
    }

    public function testGetHeightAfterCompute() {
        $sky = new Sky();
        $sky->push(new Star(new Coord(8, 10), new Coord(5, -20)));
        $sky->push(new Star(new Coord(10, 8), new Coord(-10, 25)));
        $this->assertEquals($sky->getHeight(), 2);
        $sky->compute();
        $this->assertEquals($sky->getHeight(), 43);
    }
}

<?php
declare(strict_types=1);

class Sky {
    public $nbStars = 0;
    public $stars = [];

    function __construct() {
        $this->nbStars = 0;
    }

    function push(Star $star) {
        $this->stars[$this->nbStars] = $star;
        $this->nbStars++;
    }

    function add($other) {
        $this->x += $other->x;
        $this->y += $other->y;
    }

    public function getTopLeftCoord() {
        $minx = 2147483647; // Integer.MAX_VALUE
        $miny = 2147483647; // Integer.MAX_VALUE
        for ($i = 0; $i < $this->nbStars; $i++) {
            if ($this->stars[$i]->position->x < $minx) {
                $minx = $this->stars[$i]->position->x;
            }
            if ($this->stars[$i]->position->y < $miny) {
                $miny = $this->stars[$i]->position->y;
            }
        }
        return new Coord($minx, $miny);
    }

    public function getBottomRightCoord() {
        $maxx = -2147483647; // Integer.MAX_VALUE
        $maxy = -2147483647; // Integer.MAX_VALUE
        for ($i = 0; $i < $this->nbStars; $i++) {
            if ($this->stars[$i]->position->x > $maxx) {
                $maxx = $this->stars[$i]->position->x;
            }
            if ($this->stars[$i]->position->y > $maxy) {
                $maxy = $this->stars[$i]->position->y;
            }
        }
        return new Coord($maxx, $maxy);
    }

    function compute() {
        for ($i = 0; $i < $this->nbStars; $i++) {
            $this->stars[$i]->move();
        }
    }

    function getHeight() {
        return $this->getBottomRightCoord()->y - $this->getTopLeftCoord()->y + 1;
    }

    function getWidth() {
        return $this->getBottomRightCoord()->x - $this->getTopLeftCoord()->x + 1;
    }

    function display() {
        $height = $this->getHeight();
        $width = $this->getWidth();
        $origin = $this->getTopLeftCoord();

        print_r("Height : " . $height . "\n");
        print_r("Width : " . $width . "\n");

        $message = [];
        for ($i = 0; $i < $height; $i++) {
            for ($j = 0; $j < $width; $j++) {
                $message[$i][$j] = ".";
            }
        }

        for ($i = 0; $i < $this->nbStars; $i++) {
            $position = $this->stars[$i]->getNormalizedPosition($origin);
            $x = $position->x;
            $y = $position->y;
            $message[$y][$x] = "#";
        }

        for ($i = 0; $i < $height; $i++) {
            for ($j = 0; $j < $width; $j++) {
                print_r($message[$i][$j]);
            }
            print_r("\n");
        }
    }
}


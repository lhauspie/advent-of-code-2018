<?php
declare(strict_types=1);

class Coord {
    public $x;
    public $y;

    function __construct(int $x, int $y) {
        $this->x = $x;
        $this->y = $y;
    }

    function add($other) {
        $this->x += $other->x;
        $this->y += $other->y;
    }
}


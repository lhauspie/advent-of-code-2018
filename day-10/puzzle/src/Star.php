<?php
declare(strict_types=1);

class Star {
    public $position;
    public $velocity;

    function __construct($position, $velocity) {
        $this->position = $position;
        $this->velocity = $velocity;
    }

    public function move(): void {
        $this->position->add($this->velocity);
    }

    public function getNormalizedPosition($origin): Coord {
        return new Coord($this->position->x - $origin->x, $this->position->y - $origin->y);
    }
}
<?php
declare(strict_types=1);

require_once 'src/Sky.php';
require_once 'src/Coord.php';
require_once 'src/Star.php';

$handle = fopen("input.txt", "r");
if ($handle) {
    $sky = new Sky();

    while (($line = fgets($handle)) !== false) {
        preg_match_all('/-?\d+/', $line, $matches);
        $x = intval($matches[0][0]);
        $y = intval($matches[0][1]);
        $vx = intval($matches[0][2]);
        $vy = intval($matches[0][3]);
        $sky->push(new Star(new Coord($x, $y), new Coord($vx, $vy)));
    }

    $height = $sky->getHeight();
    $count = 0;
    while ($height != 10) { // 10 is the size of the message
        $sky->compute();
        $count++;
        $height = $sky->getHeight();
    }
    print_r("Message released after " . $count . " secondes\n");

    $sky->display();

    fclose($handle);
} else {
    print_r("file does not exists !");
} 


?>
<?php
declare(strict_types=1);

final class Hello {
    function sayHello($name) {
        return "Hello, " . $name . "!";
    }
}

echo Hello::sayHello("World");
?>
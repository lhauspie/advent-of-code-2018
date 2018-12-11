<?php
declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class HelloTest extends TestCase {
    public function testSayHello() : void {
        $this->assertEquals(
            'Hello, World!',
            Hello::sayHello('World')
        );
    }
}

?>
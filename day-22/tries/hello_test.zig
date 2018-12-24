const assert = @import("std").debug.assert;
const hello = @import("hello.zig");


test "Saying hello to world" {
    const helloWorld = comptime(hello.sayHello("world"));
    const expected = "Hello, world!";

    var i: u8 = 0;
    // For loops iterate over slices and arrays.
    for (helloWorld) |char| {
        assert(char == expected[i]);
        i = i+1;
    }
}

test "Saying hello to Budy" {
    const helloWorld = comptime(hello.sayHello("Budy"));
    const expected = "Hello, Budy!";

    var i: u8 = 0;
    // For loops iterate over slices and arrays.
    for (helloWorld) |char| {
        assert(char == expected[i]);
        i = i+1;
    }
}


test "Saying hello to Logan" {
    const helloWorld = comptime(hello.sayHello("Logan"));
    const expected = "Hello, Logan!";

    var i: u8 = 0;
    // For loops iterate over slices and arrays.
    for (helloWorld) |char| {
        assert(char == expected[i]);
        i = i+1;
    }
}
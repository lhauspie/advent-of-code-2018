const assert = @import("std").debug.assert;
const warn = @import("std").debug.warn;
const model = @import("model.zig");
const Point = @import("model.zig").Point;
const Direction = @import("model.zig").Direction;


test "init and update x and y of Point" {
    var p = Point{
        .x = 0,
        .y = 0,
    };
    assert(p.x == 0);
    assert(p.y == 0);

    p.x = 10;
    assert(p.x == 10);
    assert(p.y == 0);

    p.y = 10;
    assert(p.x == 10);
    assert(p.y == 10);
}

test "move to North, South, West, East" {
    var p = Point{
        .x = 10,
        .y = 10,
    };
    assert(p.x == 10);
    assert(p.y == 10);

    p = p.goTo(Direction.North);
    assert(p.x == 10);
    assert(p.y == 9);

    p = p.goTo(Direction.East);
    assert(p.x == 11);
    assert(p.y == 9);

    p = p.goTo(Direction.South);
    assert(p.x == 11);
    assert(p.y == 10);

    p = p.goTo(Direction.West);
    assert(p.x == 10);
    assert(p.y == 10);
}

test "is_negative" {
    var p: Point = Point{.x=0, .y=0};

    p = Point{.x=-1, .y=-1};
    assert(p.is_negative());

    p = Point{.x=-1, .y=0};
    assert(p.is_negative());

    p = Point{.x=0, .y=-1};
    assert(p.is_negative());

    p = Point{.x=0, .y=0};
    assert(!p.is_negative());
}

test "a - b is negative" {
    var a: i32 = 10;
    var b: i32 = 15;
    var c: i32 = a-b;

    assert(b - a == 5);
    assert(c == -5);

    assert(comparePoints(Point{.x=0, .y=0}, Point{.x=5, .y=5}) == -5);
}

pub fn comparePoints(a: ?Point, b: ?Point) i32 {
    // warn("comparing a:{} to b:{}\n", a, b);
    var result: i32 = 0;
    if (a == null and b == null) {
        result = 0;
    } else if (a == null) {
        result = -1;
    } else if (b == null) {
        result = 1;
    } else {
        result = a.?.x - b.?.x;
    }
    return result;
}

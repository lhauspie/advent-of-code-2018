const warn = @import("std").debug.warn;

pub const Direction = struct {
    x: i8,
    y: i8,

    pub const North = Direction{.x=0,.y=-1};
    pub const South = Direction{.x=0,.y=1};
    pub const West = Direction{.x=-1,.y=0};
    pub const East = Direction{.x=1,.y=0};
};

pub const Point = struct {
    x: i32,
    y: i32,

    pub fn goTo(self: Point, direction: Direction) Point {
        return Point {
            .x = self.x + direction.x,
            .y = self.y + direction.y,
        };
    }

    pub fn is_negative(self: Point) bool {
        return self.x < 0 or self.y < 0;
    }

    pub fn out_of_bound(self: *Point, x: usize, y: usize) bool {
        return self.x >= @intCast(i32, x) or self.y >= @intCast(i32, y);
    }
};

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



pub const Tool = enum {
    Neither,
    ClimbingGear,
    Torch,

    pub fn is_valid(self: Tool, risk: u8) bool {
        return (risk == 0 and (self == Tool.Torch   or self == Tool.ClimbingGear))
            or (risk == 1 and (self == Tool.Neither or self == Tool.ClimbingGear))
            or (risk == 2 and (self == Tool.Torch   or self == Tool.Neither));
    }
};


pub const State = struct {
    point: Point,
    times: i16,
    tool: Tool,
};

pub fn compareStates(a: ?State, b: ?State) i32 {
    // warn("comparing a:{} to b:{}\n", a, b);
    var result: i32 = 0;
    if (a == null and b == null) {
        // warn("a and b are null\n");
        result = 0;
    } else if (a == null) {
        // warn("a is null\n");
        result = -1;
    } else if (b == null) {
        // warn("b is null\n");
        result = 1;
    } else {
        // warn("a and b are not null => {} - {}\n", a.?.times, b.?.times);
        result = a.?.times - b.?.times;
    }
    // warn(" ==> {}\n", result);
    return -result;
}

const assert = @import("std").debug.assert;
const warn = @import("std").debug.warn;


// Declare a struct.
// Zig gives no guarantees about the order of fields and whether or
// not there will be padding.
const Point = struct {
    x: u32,
    y: u32,
};

const Stack = struct {
    pub const Node = struct {
        prev: ?*Node,
        data: ?Point,
    };

    last: ?*Node,
    len: usize,

    pub fn init() Stack {
        return Stack {
            .last = null,
            .len = 0,
        };
    }

    pub fn push(self: *Stack, node: *Node) *Node {
        // var node = Node {
        //     .prev = self.last,
        //     .data = data,
        // };
        node.prev = self.last;
        self.last = node;
        self.len += 1;

        warn("pushed data: {}\n", self.last.?.data);
        return self.last.?;
    }

    pub fn pop(self: *Stack) ?Point {
        var data: ?Point = null;
        if (self.len > 0) {
            data = self.last.?.data;
            self.last = self.last.?.prev;
            self.len -= 1;
            // data = self.last.?.data;
        }
        warn("poped data: {}\n", data);
        return data;
    }
};

test "update x and y of Point" {
    var point = Point{
        .x = 0,
        .y = 0,
    };
    point.x = 10;
    assert(point.x == 10);
    assert(point.y == 0);

    var stack = Stack.init();
    assert(stack.last == null);
    assert(stack.len == 0);

    var point_1_1 = Point{
        .x = 1,
        .y = 1,
    };
    var node_1_1 = Stack.Node {
        .prev = null,
        .data = point_1_1,
    };
    _ = stack.push(&node_1_1);
    assert(stack.last.?.data.?.x == 1);
    assert(stack.last.?.data.?.y == 1);
    assert(stack.len == 1);
    warn("{}\n", stack);

    var point_2_2 = Point{
        .x = 2,
        .y = 2,
    };
    var node_2_2 = Stack.Node {
        .prev = null,
        .data = point_2_2,
    };
    _ = stack.push(&node_2_2);
    assert(stack.last.?.data.?.x == 2);
    assert(stack.last.?.data.?.y == 2);
    assert(stack.len == 2);
    warn("{}", stack);

    var poped_point = stack.pop();
    warn("{}\n", poped_point);
    warn("{}\n", stack);
    assert(poped_point.?.x == 2);
    assert(poped_point.?.y == 2);
    assert(stack.len == 1);

    poped_point = stack.pop();
    warn("{}\n", poped_point);
    warn("{}\n", stack);
    assert(poped_point.?.x == 1);
    assert(poped_point.?.y == 1);
    assert(stack.len == 0);

    warn("{}\n", stack);


}
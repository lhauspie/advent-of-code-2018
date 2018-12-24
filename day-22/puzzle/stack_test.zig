const assert = @import("std").debug.assert;
const warn = @import("std").debug.warn;
const stack = @import("stack.zig");
const SortedStack = @import("stack.zig").SortedStack;
const model = @import("model.zig");
const Point = @import("model.zig").Point;


pub fn hi() [3]u8 {
    return "hi!";
}

test "Play with stack" {
    const StackOfPoints = SortedStack(Point);

    var queue = StackOfPoints.init(model.comparePoints);
    assert(queue.last == null);
    assert(queue.len == 0);

    var node_1_1 = StackOfPoints.Node.init(Point{
            .x = 1,
            .y = 1,
        });
    _ = queue.push(node_1_1);
    assert(queue.last.?.data.?.x == 1);
    assert(queue.last.?.data.?.y == 1);
    assert(queue.len == 1);
    // warn("pushed {}\n", node_1_1.data);
    // queue.display();

    {
        var node_10_10 = StackOfPoints.Node.init(Point{
                .x = 10,
                .y = 10,
            });
        _ = queue.push(node_10_10);
        assert(queue.last.?.data.?.x == 10);
        assert(queue.last.?.data.?.y == 10);
        assert(queue.len == 2);
        // warn("pushed {}\n", node_10_10.data);
        // queue.display();
    }

    {
        var node_5_5 = StackOfPoints.Node.init(Point{
                .x = 5,
                .y = 5,
            });
        warn("&node_5_5: {}\n", @ptrToInt(&node_5_5));
        _ = queue.push(node_5_5);
        assert(queue.last.?.data.?.x == 10);
        assert(queue.last.?.data.?.y == 10);
        assert(queue.len == 3);
        // warn("pushed {}\n", node_5_5.data);
        // queue.display();
    }
    // warn("{}\n", node_5_5.data);

    var node_5_5_bis = StackOfPoints.Node.init(Point{
            .x = 5,
            .y = 5,
        });
    warn("&node_5_5_bis: {}\n", @ptrToInt(&node_5_5_bis));
    _ = queue.push(node_5_5_bis);
    assert(queue.last.?.data.?.x == 10);
    assert(queue.last.?.data.?.y == 10);
    assert(queue.len == 4);
    // warn("pushed {}\n", node_5_5.data);
    // queue.display();

    var poped_point: ?Point = null;
    
    poped_point = queue.pop();
    // warn("poped {}\n", poped_point);
    // queue.display();
    assert(poped_point.?.x == 10);
    assert(poped_point.?.y == 10);
    assert(queue.len == 3);

    poped_point = queue.pop();
    // warn("poped {}\n", poped_point);
    // queue.display();
    assert(poped_point.?.x == 5);
    assert(poped_point.?.y == 5);
    assert(queue.len == 2);

    poped_point = queue.pop();
    // warn("poped {}\n", poped_point);
    // queue.display();
    assert(poped_point.?.x == 5);
    assert(poped_point.?.y == 5);
    assert(queue.len == 1);

    poped_point = queue.pop();
    // warn("poped {}\n", poped_point);
    // queue.display();
    assert(poped_point.?.x == 1);
    assert(poped_point.?.y == 1);
    assert(queue.len == 0);

    poped_point = queue.pop();
    // warn("poped {}\n", poped_point);
    // queue.display();
    assert(poped_point == null);
    assert(queue.len == 0);

    // warn("{}\n", queue);
}


test "allocate" {
    var data = Point{.x=1,.y=1};

    warn("\n");
    var first_node = stack.allocate(SortedStack(Point).Node);
    first_node.data = data;
    // warn("first_node: {} => {}\n", first_node, @ptrToInt(first_node));

    var second_node = stack.allocate(SortedStack(Point).Node);
    data = Point{.x=5,.y=5};
    second_node.data = data;
    // warn("second_node: {} => {}\n", second_node, @ptrToInt(second_node));
    // warn("first_node: {} => {}\n", first_node, @ptrToInt(first_node));
    assert(first_node.data.?.x == 1);
    assert(first_node.data.?.y == 1);
}

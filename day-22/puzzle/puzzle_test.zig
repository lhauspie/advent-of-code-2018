const assert = @import("std").debug.assert;
const warn = @import("std").debug.warn;
const puzzle = @import("puzzle.zig");
const model = @import("model.zig");
const State = @import("model.zig").State;
const Tool = @import("model.zig").Tool;
const Point = @import("model.zig").Point;

test "Memory contains null" {
    // var 0_0: *?u64 = puzzle.get_memory_erosion_level(0, 0);
    // assert(value == null);

    // if (0_0.*) |value| {
    //     assert(value == null);
    // }
    assert(puzzle.get_memory_erosion_level(0, 0).* == null);
    assert(puzzle.get_memory_erosion_level(0, 1).* == null);
    assert(puzzle.get_memory_erosion_level(1, 0).* == null);
    assert(puzzle.get_memory_erosion_level(1, 1).* == null);
}


test "The region at (0,0) and depth 510 has the type 0" {
    assert(puzzle.get_type(0, 0, 510, 5, 5) == 0);
    puzzle.get_memory_erosion_level(0, 0).* = null;
}
test "The region at target and depth 510 has the type 0" {
    assert(puzzle.get_type(5, 5, 510, 5, 5) == 0);
    puzzle.get_memory_erosion_level(5, 5).* = null;
}

test "The region at (0,0) and depth 511 has the type 1" {
    assert(puzzle.get_type(0, 0, 511, 5, 5) == 1);
    puzzle.get_memory_erosion_level(0, 0).* = null;
}

test "The region at (1,0) and depth 510 has the type 1" {
    assert(puzzle.get_type(1, 0, 510, 5, 5) == 1);
}

test "The region at (0,1) and depth 510 has the type 0" {
    assert(puzzle.get_type(0, 1, 510, 5, 5) == 0);
}

test "The region at (1,1) and depth 510 has the type 2" {
    assert(puzzle.get_type(1, 1, 510, 5, 5) == 2);
}

test "Tool is Valid with Risk" {
    assert(Tool.Torch.is_valid(0));
    assert(!Tool.Torch.is_valid(1));
    assert(Tool.Torch.is_valid(2));

    assert(!Tool.Neither.is_valid(0));
    assert(Tool.Neither.is_valid(1));
    assert(Tool.Neither.is_valid(2));

    assert(Tool.ClimbingGear.is_valid(0));
    assert(Tool.ClimbingGear.is_valid(1));
    assert(!Tool.ClimbingGear.is_valid(2));
}

test "get_memory_erosion_level get the right erosion_level" {
    var erosion_level = puzzle.get_memory_erosion_level(0, 0);

    assert(erosion_level.* == null);
    erosion_level.* = 1;

    erosion_level = puzzle.get_memory_erosion_level(0, 0);
    assert(erosion_level.*.? == 1);
}

test "get_count get the right count" {
    var count = puzzle.get_count(Point{.x=0,.y=0}, Tool.Torch);

    assert(count.* == 0);
    count.* = 1;
    assert(puzzle.get_count(Point{.x=0,.y=0}, Tool.Torch).* == 1);

    count = puzzle.get_count(Point{.x=0,.y=0}, Tool.ClimbingGear);
    assert(count.* == 0);
}

test "comparing Two States" {
    var state_a = State{
        .point = Point{.x=1, .y=0},
        .times = 8,
        .tool = Tool.ClimbingGear,
    };
    var state_b = State{
        .point = Point{.x=2, .y=0},
        .times = 9,
        .tool = Tool.ClimbingGear,
    };

    assert(model.compareStates(state_a, state_b) == 1);
}

test "advent of code examples" {
    var total_risk_level: u64 = puzzle.get_total_risk_level(510, 10, 10);
    warn("total_risk_level = {}", total_risk_level);
    assert(total_risk_level == 115);

    var fewest_number_of_minutes = puzzle.compute_path(510, 10, 10);
    warn("fewest_number_of_minutes = {}", fewest_number_of_minutes);
    assert(fewest_number_of_minutes == 45);
}
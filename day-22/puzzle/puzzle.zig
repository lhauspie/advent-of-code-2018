const warn = @import("std").debug.warn;
const time = @import("std").os.time;
const SortedStack = @import("stack.zig").SortedStack;
const model = @import("model.zig");
const Point = @import("model.zig").Point;
const State = @import("model.zig").State;
const Direction = @import("model.zig").Direction;
const Tool = @import("model.zig").Tool;


const input_depth: u32 = 11991;
const input_target_x: usize = 6;
const input_target_y: usize = 797;
// const input_depth: u32 = 510;
// const input_target_x: usize = 10;
// const input_target_y: usize = 10;

const cave_width: usize = input_target_x + 100;
const cave_height: usize = input_target_y + 600;



var erosion_levels = init: {
    var row: [cave_width]?u64 = []?u64{null} ** cave_width;
    var initial_value: [cave_height][cave_width]?u64 = [][cave_width]?u64{row} ** cave_height;
    break :init initial_value;
};
pub fn get_memory_erosion_level(x: u32, y: u32) *?u64 {
    var row_y: *[cave_width]?u64 = &erosion_levels[y];
    var region_x_y: *?u64 = &row_y[x];

    return region_x_y;
}

var torch_count = init: {
    var row: [cave_width]i64 = []i64{0} ** cave_width;
    var initial_value: [cave_height][cave_width]i64 = [][cave_width]i64{row} ** cave_height;
    break :init initial_value;
};
var neither_count = init: {
    var row: [cave_width]i64 = []i64{0} ** cave_width;
    var initial_value: [cave_height][cave_width]i64 = [][cave_width]i64{row} ** cave_height;
    break :init initial_value;
};
var climbing_gear_count = init: {
    var row: [cave_width]i64 = []i64{0} ** cave_width;
    var initial_value: [cave_height][cave_width]i64 = [][cave_width]i64{row} ** cave_height;
    break :init initial_value;
};
pub fn get_count(point: Point, tool: Tool) *i64 {
    var count = &torch_count;
    if (tool == Tool.Neither) {
        count = &neither_count;
    }
    if (tool == Tool.ClimbingGear) {
        count = &climbing_gear_count;
    }

    var row_y: *[cave_width]i64 = &count[@intCast(usize, point.y)];
    var count_x_y: *i64 = &row_y[@intCast(usize, point.x)];
    return count_x_y;
}

// var region_types = init: {
//     var row: [cave_width]?u64 = []?u64{null} ** cave_width;
//     var initial_value: [cave_height][cave_width]?u64 = [][cave_width]?u64{row} ** cave_height;
//     break :init initial_value;
// };


pub fn get_erosion_level(x: u32, y: u32, depth: u32, target_x: usize, target_y: usize) u64 {
    var memory_erosion_level: *?u64 = get_memory_erosion_level(x, y);
    if (memory_erosion_level.* == null) { // no erosion_level calculated before
        // warn("no erosion_level calculated before for x:{} y:{}\n", x, y);
        var geologic_index: u64 = 0;
        if (x == 0 and y == 0) {
            geologic_index = 0;
        } else if (x == target_x and y == target_y) {
            geologic_index = 0;
        } else if (x == 0) {
            geologic_index = y * 48271;
        } else if (y == 0) {
            geologic_index = x * 16807;
        } else {
            geologic_index = get_erosion_level(x-1, y, depth, target_x, target_x) * get_erosion_level(x, y-1, depth, target_x, target_x);
        }

        memory_erosion_level.* = @mod((geologic_index + depth), 20183);
    }

    var erosion_level: u64 = 0;
    if (memory_erosion_level.*) |value| {
        erosion_level = value;
    }
    return erosion_level;
}

pub fn get_type(x: u32, y: u32, depth: u32, target_x: usize, target_y: usize) u8 {
    var erosion_level: u64 = get_erosion_level(x, y, depth, target_x, target_y);
    var region_type: u64 = @mod(erosion_level, 3);
    return @intCast(u8, region_type);
}


pub fn get_total_risk_level(depth: u32, target_x: usize, target_y: usize) u64 {
    var total_risk_level: u64 = 0;
    var y: u32 = 0;
    while (y <= target_y) {
        var x: u32 = 0;
        while (x <= target_x) {
            var region_type: u8 = get_type(x, y, depth, target_x, target_y);
            total_risk_level += region_type;
            x += 1;
        }
        y += 1;
    }

    return total_risk_level;
}

pub fn compute_path(depth: u32, target_x: usize, target_y: usize) i32 {
    const directions = []Direction {Direction.North, Direction.East, Direction.West, Direction.South};
    const tools = []Tool {Tool.Neither, Tool.ClimbingGear, Tool.Torch};
    var targ_x = @intCast(i32, target_x);
    var targ_y = @intCast(i32, target_y);

    const StackOfStates = SortedStack(State);
    var queue: StackOfStates = StackOfStates.init(model.compareStates);
    var node_to_push: *StackOfStates.Node = StackOfStates.Node.init(State{
            .point = Point{.x=0, .y=0},
            .times = 0,
            .tool = Tool.Torch,
        });
    _ = queue.push(node_to_push);
    // queue.display();

    while (queue.len > 0) {
        var current_state: State = queue.pop().?;
        var current_point: Point = current_state.point;
        if (current_point.x == targ_x and current_point.y == targ_y) {
            if (current_state.tool == Tool.Torch) {
                return current_state.times;
            } else {
                return current_state.times + 7;
            }
        }

        for (directions) |dir| {
            var next_point = current_point.goTo(dir);
            // warn("dir is: {}\n", dir);
            // warn("current_point {} goto {} is next_point: {}\n", current_point, dir, next_point);

            if (next_point.is_negative() or next_point.out_of_bound(cave_width, cave_height)) {
                continue;
            }
            var current_risk = get_type(@intCast(u32, current_point.x), @intCast(u32, current_point.y), depth, target_x, target_y);
            var next_risk = get_type(@intCast(u32, next_point.x), @intCast(u32, next_point.y), depth, target_x, target_y);

            for (tools) |next_tool| {
                // warn("next_tool is: {}\n", next_tool);
                var inc: i8 = 1;
                if (next_tool != current_state.tool) {
                    inc = 8;
                }
                var next_times = current_state.times + inc;

                var count: *i64 = get_count(next_point, next_tool);
                // warn("count of {}/{} is: {} | next_times is: {}\n", next_point, next_tool, count.*, next_times);
                if ((count.* == 0 or count.* > next_times) and next_tool.is_valid(next_risk) and next_tool.is_valid(current_risk)) {
                    node_to_push = StackOfStates.Node.init(State{
                            .point = next_point,
                            .times = next_times,
                            .tool = next_tool,
                        });
                    _ = queue.push(node_to_push);
                    // queue.display();
                    count.* = next_times;
                    // warn("new value of count is: {}\n", get_count(next_point, next_tool).*);
                }
            }
        }
        // time.sleep(1, 0);
        // warn("\n\n");
    }
    return 0;
}

pub fn main() void {
    var total_risk_level: u64 = get_total_risk_level(input_depth, input_target_x, input_target_y);
    warn("total_risk_level is: {}\n", total_risk_level);

    var fewest_number_of_minutes = compute_path(input_depth, input_target_x, input_target_y);
    warn("fewest number of minutes is: {}\n", fewest_number_of_minutes);
}


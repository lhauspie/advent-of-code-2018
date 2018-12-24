const warn = @import("std").debug.warn;

const a_number: i32 = 1234;
const a_string = "foobar";

pub fn main() void {
    warn("here is a string: '{}' here is a number: {}\n", a_string, a_number);
}
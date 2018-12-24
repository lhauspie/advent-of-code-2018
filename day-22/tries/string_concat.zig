const std = @import("std");
const debug = std.debug;

test "slice bounds ignored in comptime concatenation"
{
    const bs = comptime blk:
    {
        const b = c"111";
        break :blk b[0..1];
    };
    
    const str = "" ++ bs ++ "2345";
    debug.assert(str.len == 5);
}

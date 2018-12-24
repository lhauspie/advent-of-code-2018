const assert = @import("std").debug.assert;
const warn = @import("std").debug.warn;

fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,
        };

        first: ?*Node,
        last:  ?*Node,
        len:   usize,

        pub fn init() LinkedList(T) {
            var length: usize = 0;
            return LinkedList(T) {
                .first = null,
                .last = null,
                .len = 0,
            };
        }

        pub fn push(self: *LinkedList(T), data: T) Node {
            var node: LinkedList(T).Node = Node {
                .prev = self.last,
                .next = null,
                .data = 1234,
            };
            if (self.last != null) {
                self.last.?.next = &node;
            }
            self.last = &node;
            self.len += 1;
            return node;
        }
    };
}

test "linked list" {
    // Functions called at compile-time are memoized. This means you can
    // do this:
    assert(LinkedList(i32) == LinkedList(i32));

    var list = LinkedList(i32).init();
    assert(list.len == 0);


    // var node = list.push(1234);
    warn("\n{}\n", list.push(1234));
    warn("\n{}\n", list.push(6789));
    warn("\n{}\n", list);


    // Since types are first class values you can instantiate the type
    // by assigning it to a variable:
    const ListOfInts = LinkedList(i32);
    assert(ListOfInts == LinkedList(i32));

    var node = ListOfInts.Node {
        .prev = null,
        .next = null,
        .data = 1234,
    };
    var list2 = LinkedList(i32) {
        .first = &node,
        .last = &node,
        .len = 1,
    };
    _ = list2.push(234354);
    assert(list.first.?.data == 1234);
}
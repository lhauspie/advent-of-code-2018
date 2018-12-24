const warn = @import("std").debug.warn;

pub fn SortedStack(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: ?T,

            pub fn init(data: ?T) *Node {
                var node = allocate(Node);
                node.data = data;
                // warn("node created with addr: {}\n", @ptrToInt(node));
                return node;
            }
        };

        compare: fn(?T, ?T) i32,
        first: ?*Node,
        last: ?*Node,
        len: usize,

        pub fn init(compare: fn(?T, ?T) i32) SortedStack(T) {
            return SortedStack(T) {
                .compare = compare,
                .first = null,
                .last = null,
                .len = 0,
            };
        }

        pub fn push(self: *SortedStack(T), node: *Node) void {
            // warn("pushing data {}\n", node.data);
            var lesserNode: ?*Node = null;
            var greaterNode: ?*Node = null;
            var found: bool = false;

            // loop over the linked list to find the first elment greater than the node to insert
            var currentNode: ?*Node = self.first;
            // warn("searching");
            while (currentNode != null and !found) {
                found = self.compare(currentNode.?.data, node.data) >= 0;
                lesserNode = currentNode.?.prev;
                greaterNode = currentNode;
                currentNode = currentNode.?.next;
                // warn(".");
            }
            // warn("\n");

            if (found) {
                node.prev = lesserNode;
                node.next = greaterNode;
                if (lesserNode != null and greaterNode != null) {
                    lesserNode.?.next = node;
                    greaterNode.?.prev = node;
                    // warn("place to insert found between {} and {} !\n", lesserNode.?.data, greaterNode.?.data);
                } else if (lesserNode != null) {
                    lesserNode.?.next = node;
                    // warn("place to insert found after {} !\n", lesserNode.?.data);
                } else if (greaterNode != null) {
                    self.first = node;
                    greaterNode.?.prev = node;
                    // warn("place to insert found before {} !\n", greaterNode.?.data);
                }
            } else {
                // warn("place to insert not found pushing at the end of stack !\n");
                if (self.first == null) {
                    self.first = node;
                }
                if (self.last != null) {
                    self.last.?.next = node;
                }
                node.prev = self.last;
                self.last = node;
            }

            self.len += 1;
        }

        pub fn pop(self: *SortedStack(T)) ?T {
            var data: ?T = null;
            if (self.len > 0) {
                data = self.last.?.data;
                self.last = self.last.?.prev;
                if (self.last != null) {
                    self.last.?.next = null;
                } else {
                    self.first = null;
                }
                self.len -= 1;
            }
            // warn("poping data {}\n", data);
            return data;
        }

        pub fn display(self: *SortedStack(T)) void {
            var currentNode: ?*Node = self.first;
            warn("Stack of {} elements : ", self.len);
            while (currentNode != null) {
                warn("{} -> ", currentNode.?.data);
                currentNode = currentNode.?.next;
            }
            warn("null \n");
        }
    };
}

// x=100 / y=2000 / state_size=32 / nb_tools=4 / nb_directions=4
var memory: [100*2000*32*4]u8 = undefined;
var memory_index: usize = 0;
pub fn allocate(comptime T: type) *T {
    // return @ptrCast([*]T, &some_mem[0])[0..n];
 
    // const size = @sizeOf(T);
    var value: []T = @ptrCast([*]T, &memory[0])[memory_index..memory_index+1];
    memory_index += 1;

    return &value[0];
}

const std = @import("std");
const terminal = @import("terminal.zig");
const menu = @import("../menu.zig");

pub fn renderMenu(term: *terminal.Terminal, node: *const menu.MenuNode, selected: usize) !void {
    try term.clear();
    const writer = term.stdout.writer();

    try writer.print("{s}\n", .{node.title});
    try writer.print("{s}\n\n", .{node.description});

    for (node.children, 0..) |child, idx| {
        if (idx == selected) {
            try writer.print("> {s}\n", .{child.title});
        } else {
            try writer.print("  {s}\n", .{child.title});
        }
    }

    try writer.writeAll("\nenter: select  b/backspace: back  q: quit\n");
}

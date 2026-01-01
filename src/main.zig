const std = @import("std");
const app = @import("app.zig");
const terminal = @import("ui/terminal.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var term = try terminal.Terminal.init();
    defer term.deinit();

    var application = app.App.init(gpa.allocator(), &term);
    try application.run();
}

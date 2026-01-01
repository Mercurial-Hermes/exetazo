const std = @import("std");
const terminal = @import("../ui/terminal.zig");
const registry = @import("registry.zig");
const context = @import("context.zig");

pub fn runExperiment(
    term: *terminal.Terminal,
    allocator: std.mem.Allocator,
    experiment: *const registry.Experiment,
) !void {
    try term.clear();
    const writer = term.stdout.writer();
    try writer.print("{s}\n", .{experiment.title});
    try writer.print("{s}\n\n", .{experiment.description});

    var exec_ctx = context.ExecutionContext{
        .allocator = allocator,
        .writer = writer,
    };

    try experiment.run(&exec_ctx);

    try writer.writeAll("\nPress any key to return.\n");
    try term.waitForKey();
}

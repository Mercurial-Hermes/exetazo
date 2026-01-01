const std = @import("std");

pub const ExecutionContext = struct {
    allocator: std.mem.Allocator,
    writer: std.fs.File.Writer,

    pub fn writeAll(self: *ExecutionContext, bytes: []const u8) !void {
        try self.writer.writeAll(bytes);
    }

    pub fn print(self: *ExecutionContext, comptime fmt: []const u8, args: anytype) !void {
        try self.writer.print(fmt, args);
    }
};

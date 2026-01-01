const std = @import("std");
const context = @import("context.zig");
const c = @cImport({
    @cInclude("unistd.h");
});

pub const Experiment = struct {
    id: []const u8,
    title: []const u8,
    description: []const u8,
    run: *const fn (ctx: *context.ExecutionContext) anyerror!void,
};

pub const process_id = Experiment{
    .id = "process_id",
    .title = "Process ID",
    .description = "Read the PID via getpid().",
    .run = runProcessId,
};

pub const user_identity = Experiment{
    .id = "user_identity",
    .title = "User Identity",
    .description = "Read UID and GID from the kernel.",
    .run = runUserIdentity,
};

pub const monotonic_clock = Experiment{
    .id = "monotonic_clock",
    .title = "Monotonic Clock",
    .description = "Read CLOCK_MONOTONIC via clock_gettime().",
    .run = runMonotonicClock,
};

fn runProcessId(ctx: *context.ExecutionContext) !void {
    const pid = c.getpid();
    try ctx.print("pid: {d}\n", .{pid});
}

fn runUserIdentity(ctx: *context.ExecutionContext) !void {
    const uid = c.getuid();
    const gid = c.getgid();
    try ctx.print("uid: {d}\n", .{uid});
    try ctx.print("gid: {d}\n", .{gid});
}

fn runMonotonicClock(ctx: *context.ExecutionContext) !void {
    const ts = try std.posix.clock_gettime(.MONOTONIC);
    try ctx.print("clock_monotonic: {d}.{d:0>9}\n", .{ ts.sec, ts.nsec });
}

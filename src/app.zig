const std = @import("std");
const menu = @import("menu.zig");
const terminal = @import("ui/terminal.zig");
const render = @import("ui/render.zig");
const runner = @import("experiments/runner.zig");

const MenuFrame = struct {
    node: *const menu.MenuNode,
    selected: usize,
};

pub const App = struct {
    allocator: std.mem.Allocator,
    term: *terminal.Terminal,

    pub fn init(allocator: std.mem.Allocator, term: *terminal.Terminal) App {
        return .{
            .allocator = allocator,
            .term = term,
        };
    }

    pub fn run(self: *App) !void {
        var stack = std.ArrayList(MenuFrame).init(self.allocator);
        defer stack.deinit();

        var current: *const menu.MenuNode = &menu.root;
        var selected: usize = 0;

        while (true) {
            try render.renderMenu(self.term, current, selected);

            if (try self.term.readKey()) |key| {
                switch (key) {
                    .up => {
                        if (current.children.len > 0) {
                            if (selected == 0) {
                                selected = current.children.len - 1;
                            } else {
                                selected -= 1;
                            }
                        }
                    },
                    .down => {
                        if (current.children.len > 0) {
                            selected = (selected + 1) % current.children.len;
                        }
                    },
                    .enter => {
                        if (current.children.len == 0) continue;

                        const next = &current.children[selected];
                        if (next.hasChildren()) {
                            try stack.append(.{ .node = current, .selected = selected });
                            current = next;
                            selected = 0;
                        } else if (next.experiment) |experiment| {
                            try runner.runExperiment(self.term, self.allocator, experiment);
                        }
                    },
                    .back => {
                        if (stack.pop()) |frame| {
                            current = frame.node;
                            selected = frame.selected;
                        }
                    },
                    .quit => return,
                    .left, .right, .escape => {},
                }
            }

            std.time.sleep(16 * std.time.ns_per_ms);
        }
    }
};

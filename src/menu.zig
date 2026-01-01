const experiments = @import("experiments/registry.zig");

pub const MenuNode = struct {
    title: []const u8,
    description: []const u8,
    children: []const MenuNode,
    experiment: ?*const experiments.Experiment,

    pub fn hasChildren(self: *const MenuNode) bool {
        return self.children.len > 0;
    }
};

pub const root = MenuNode{
    .title = "Exetazo",
    .description = "Empirical probes for macOS API behavior.",
    .children = &[_]MenuNode{
        MenuNode{
            .title = "Process and Identity",
            .description = "Process state, identity, and permissions.",
            .children = &[_]MenuNode{
                MenuNode{
                    .title = "Process ID",
                    .description = "Read the current PID using libc.",
                    .children = &[_]MenuNode{},
                    .experiment = &experiments.process_id,
                },
                MenuNode{
                    .title = "User Identity",
                    .description = "Report UID and GID from the kernel.",
                    .children = &[_]MenuNode{},
                    .experiment = &experiments.user_identity,
                },
            },
            .experiment = null,
        },
        MenuNode{
            .title = "Timing",
            .description = "Clocks and scheduling behavior.",
            .children = &[_]MenuNode{
                MenuNode{
                    .title = "Monotonic Clock",
                    .description = "Read monotonic time via mach time.",
                    .children = &[_]MenuNode{},
                    .experiment = &experiments.monotonic_clock,
                },
            },
            .experiment = null,
        },
    },
    .experiment = null,
};

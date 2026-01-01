const std = @import("std");
const posix = std.posix;

const vmin_index: usize = 16;
const vtime_index: usize = 17;

pub const Key = enum {
    up,
    down,
    left,
    right,
    enter,
    back,
    quit,
    escape,
};

pub const Terminal = struct {
    stdin_fd: posix.fd_t,
    stdout: std.fs.File,
    original_termios: posix.termios,

    pub fn init() !Terminal {
        const stdin_file = std.io.getStdIn();
        const stdout_file = std.io.getStdOut();
        const fd = stdin_file.handle;

        const original = try posix.tcgetattr(fd);
        var raw = original;
        raw.iflag.IXON = false;
        raw.iflag.ICRNL = false;
        raw.iflag.BRKINT = false;
        raw.iflag.INPCK = false;
        raw.iflag.ISTRIP = false;
        raw.oflag.OPOST = true;
        raw.oflag.ONLCR = true;
        raw.cflag.CSIZE = .CS8;
        raw.cflag.CREAD = true;
        raw.lflag.ECHO = false;
        raw.lflag.ICANON = false;
        raw.lflag.IEXTEN = false;
        raw.lflag.ISIG = false;
        raw.cc[vmin_index] = 0;
        raw.cc[vtime_index] = 1;

        try posix.tcsetattr(fd, .FLUSH, raw);

        var term = Terminal{
            .stdin_fd = fd,
            .stdout = stdout_file,
            .original_termios = original,
        };

        try term.hideCursor();
        return term;
    }

    pub fn deinit(self: *Terminal) void {
        posix.tcsetattr(self.stdin_fd, .FLUSH, self.original_termios) catch {};
        self.showCursor() catch {};
    }

    pub fn clear(self: *Terminal) !void {
        try self.stdout.writer().writeAll("\x1b[2J\x1b[H");
    }

    pub fn hideCursor(self: *Terminal) !void {
        try self.stdout.writer().writeAll("\x1b[?25l");
    }

    pub fn showCursor(self: *Terminal) !void {
        try self.stdout.writer().writeAll("\x1b[?25h");
    }

    pub fn readKey(self: *Terminal) !?Key {
        var buf: [3]u8 = undefined;
        const n = try posix.read(self.stdin_fd, buf[0..1]);
        if (n == 0) return null;

        const byte = buf[0];
        if (byte == 0x1b) {
            const n2 = try posix.read(self.stdin_fd, buf[1..3]);
            if (n2 == 2 and buf[1] == '[') {
                return switch (buf[2]) {
                    'A' => .up,
                    'B' => .down,
                    'C' => .right,
                    'D' => .left,
                    else => .escape,
                };
            }
            return .escape;
        }

        return switch (byte) {
            'q', 'Q' => .quit,
            'b', 'B' => .back,
            127, 8 => .back,
            '\n', '\r' => .enter,
            else => null,
        };
    }

    pub fn waitForKey(self: *Terminal) !void {
        while (true) {
            if (try self.readKey()) |_| return;
            std.time.sleep(10 * std.time.ns_per_ms);
        }
    }
};

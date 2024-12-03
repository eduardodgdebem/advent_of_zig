const std = @import("std");
const part1 = @import("part1.zig");

pub fn main() !void {
    const ans_1 = try part1.resolve();
    std.debug.print("part 1: {}\n", .{ans_1});
}

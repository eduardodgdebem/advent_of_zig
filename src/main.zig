const std = @import("std");
const day1_part1 = @import("day1/part1.zig");

pub fn main() !void {
    const ans_1 = try day1_part1.resolve();
    std.debug.print("part 1: {}\n", .{ans_1});
}

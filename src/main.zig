const std = @import("std");
const day1_part1 = @import("day1/part1.zig");
const day1_part2 = @import("day1/part2.zig");
const day2_part1 = @import("day2/part1.zig");

pub fn main() !void {
    const ans_1 = try day1_part1.resolve();
    std.debug.print("part 1: {}\n", .{ans_1});
    const ans_2 = try day1_part2.resolve();
    std.debug.print("part 2: {}\n", .{ans_2});
    const ans_3 = try day2_part1.resolve();
    std.debug.print("part 3: {}\n", .{ans_3});
}

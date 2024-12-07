const std = @import("std");
const day1_part1 = @import("day1/part1.zig");
const day1_part2 = @import("day1/part2.zig");
const day2_part1 = @import("day2/part1.zig");
const day3_part1 = @import("day3/part1.zig");
const day4_part1 = @import("day4/part1.zig");

pub fn main() !void {
    const ans_1 = try day1_part1.resolve();
    std.debug.print("part 1: {}\n", .{ans_1});
    const ans_2 = try day1_part2.resolve();
    std.debug.print("part 2: {}\n", .{ans_2});
    const ans_3 = try day2_part1.resolve();
    std.debug.print("part 3: {}\n", .{ans_3});
    const ans_4 = try day3_part1.resolve();
    std.debug.print("part 4: {}\n", .{ans_4});
    const ans_5 = try day4_part1.resolve();
    std.debug.print("part 5: {}\n", .{ans_5});
}

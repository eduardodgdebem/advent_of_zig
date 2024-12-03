const std = @import("std");
const helper = @import("../helper.zig");

pub fn resolve() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();
    var lines = try helper.readFile(allocator, "day_2.txt");

    defer {
        for (lines.items) |line| {
            allocator.free(line);
        }
        lines.deinit();
    }

    return calcSafeQnt(&lines);
}

fn calcSafeQnt(lines: *std.ArrayList([]const u8)) !u32 {
    var qnt: u32 = 0;
    for (lines.items) |line| {
        if (try isSafe(line)) {
            qnt += 1;
        }
    }
    return qnt;
}

fn isSafe(line: []const u8) !bool {
    var iter = std.mem.tokenize(u8, line, " ");
    if (iter.peek() == null) return false;

    const first = try std.fmt.parseInt(i32, iter.next().?, 10);
    if (iter.peek() == null) return true;

    var sign: ?i8 = null;
    var prev = first;

    while (iter.peek() != null) {
        const curr = try std.fmt.parseInt(i32, iter.next().?, 10);
        const diff: u32 = @abs(prev - curr);

        if (!(diff >= 1 and diff <= 3)) {
            return false;
        }

        const curr_sign: i8 = if (prev - curr > 0) 1 else -1;

        if (sign == null) {
            sign = curr_sign;
        } else if (sign.? != curr_sign) {
            return false;
        }

        prev = curr;
    }

    return true;
}

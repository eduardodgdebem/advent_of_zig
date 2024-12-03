const std = @import("std");
const helper = @import("../helper.zig");

pub fn resolve() !u64 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();
    var lines = try helper.readFile(allocator, "day_1.txt");

    defer {
        for (lines.items) |line| {
            allocator.free(line);
        }
        lines.deinit();
    }

    var left = std.ArrayList(u64).init(allocator);
    defer left.deinit();
    var right = std.ArrayList(u64).init(allocator);
    defer right.deinit();
    _ = try splitLines(&lines, &left, &right);
    _ = try helper.bubbleSort(u64, &left);
    _ = try helper.bubbleSort(u64, &right);
    return calcSimilarity(&left, &right);
}

fn splitLines(lines: *std.ArrayList([]const u8), left: *std.ArrayList(u64), right: *std.ArrayList(u64)) !void {
    for (lines.items) |line| {
        var iter = std.mem.tokenize(u8, line, "   ");
        const left_val = try std.fmt.parseInt(u64, iter.peek().?, 10);
        try left.append(left_val);
        _ = iter.next();
        const right_val = try std.fmt.parseInt(u64, iter.peek().?, 10);
        try right.append(right_val);
    }
}

fn calcSimilarity(left: *std.ArrayList(u64), right: *std.ArrayList(u64)) u64 {
    if (left.items.len != right.items.len) return 0;

    var total: u64 = 0;
    var appers_qnt: u64 = 0;

    for (left.items) |left_value| {
        for (right.items) |right_value| {
            if (left_value == right_value) {
                appers_qnt += 1;
            }
        }

        total += left_value * appers_qnt;
        appers_qnt = 0;
    }

    return total;
}

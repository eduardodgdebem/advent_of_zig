const std = @import("std");
const helper = @import("helper.zig");
const fs = std.fs;
const io = std.io;

pub fn resolve() !u32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();
    var lines = try readFile(allocator, "input_1.txt");

    defer {
        for (lines.items) |line| {
            allocator.free(line);
        }
        lines.deinit();
    }

    var left = std.ArrayList(i32).init(allocator);
    defer left.deinit();
    var right = std.ArrayList(i32).init(allocator);
    defer right.deinit();
    _ = try splitLines(&lines, &left, &right);
    _ = try helper.bubbleSort(i32, &left);
    _ = try helper.bubbleSort(i32, &right);
    return calcDistance(&left, &right);
}

fn readFile(allocator: std.mem.Allocator, file_name: []const u8) !std.ArrayList([]const u8) {
    var f = try fs.cwd().openFile(file_name, .{});
    defer f.close();

    var buffered_reader = io.bufferedReader(f.reader());
    var reader = buffered_reader.reader();
    var lines = std.ArrayList([]const u8).init(allocator);
    errdefer lines.deinit();

    var buf: [std.mem.page_size]u8 = undefined;

    while (try reader.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const trimmed_line = std.mem.trim(u8, line, &std.ascii.whitespace);

        try lines.append(try allocator.dupe(u8, trimmed_line));
    }

    return lines;
}

fn splitLines(lines: *std.ArrayList([]const u8), left: *std.ArrayList(i32), right: *std.ArrayList(i32)) !void {
    for (lines.items) |line| {
        var iter = std.mem.tokenize(u8, line, "   ");
        const left_val = try std.fmt.parseInt(i32, iter.peek().?, 10);
        try left.append(left_val);

        _ = iter.next();

        const right_val = try std.fmt.parseInt(i32, iter.peek().?, 10);
        try right.append(right_val);
    }
}

fn calcDistance(left: *std.ArrayList(i32), right: *std.ArrayList(i32)) u32 {
    if (left.items.len != right.items.len) return 0;

    var i: usize = 0;
    var total: u32 = 0;

    while (i < left.items.len) : (i += 1) {
        const left_val = left.items[i];
        const right_val = right.items[i];
        total += @abs(left_val - right_val);
    }

    return total;
}

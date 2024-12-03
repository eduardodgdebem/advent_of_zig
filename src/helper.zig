const std = @import("std");
const fs = std.fs;
const io = std.io;

pub fn bubbleSort(comptime T: type, arr: *std.ArrayList(T)) !void {
    var i: usize = 0;
    var j: usize = 0;

    while (i <= arr.items.len - 1) : (i += 1) {
        while (j < arr.items.len - 1) : (j += 1) {
            if (arr.items[j] > arr.items[j + 1]) {
                const temp = arr.items[j];
                arr.items[j] = arr.items[j + 1];
                arr.items[j + 1] = temp;
            }
        }
        j = 0;
    }
}

pub fn readFile(allocator: std.mem.Allocator, file_name: []const u8) !std.ArrayList([]const u8) {
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

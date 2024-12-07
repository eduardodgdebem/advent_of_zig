const std = @import("std");
const helper = @import("../helper.zig");

pub fn resolve() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // const file = helper.read_file_2(allocator, "day_4.txt");
    // defer allocator.free(file);
    const file = "MMMSXXMASM\nMSAMXMSMSA\nAMXSXMAAMM\nMSAMASMSMX\nXMASAMXAMM\nXXAMMXXAMA\nSMSMSASXSS\nSAXAMASAAA\nMAMMMXMMMM\nMXMXAXMASX";
    const file_2d = try helper.split_lines(allocator, file);
    defer {
        for (file_2d) |line| {
            allocator.free(line);
        }
        allocator.free(file_2d);
    }

    const ans = search_word("XMAS", file_2d);
    std.debug.print("total: {}\n", .{ans});
}

fn search_word(word_to_search: []const u8, buf: [][]const u8) u8 {
    var i: u8 = 0;
    var j: u8 = 0;
    var total: u8 = 0;

    while (buf.len > i) : (i += 1) {
        while (buf[i].len > j) : (j += 1) {
            if (word_to_search[0] == buf[i][j]) {
                const found = recursive_walk(word_to_search, buf, [2]u8{ j, i }, 0);
                std.debug.print("{}\n", .{found});
                if (found) {
                    total += 1;
                }
            }
        }

        j = 0;
    }

    return total;
}

const Movements = struct {
    pub fn up(x: u8, y: u8) [2]u8 {
        return [2]u8{ x, y - 1 };
    }
    pub fn down(x: u8, y: u8) [2]u8 {
        return [2]u8{ x, y + 1 };
    }
    pub fn left(x: u8, y: u8) [2]u8 {
        return [2]u8{ x - 1, y };
    }
    pub fn right(x: u8, y: u8) [2]u8 {
        return [2]u8{ x + 1, y };
    }
    pub fn up_left(x: u8, y: u8) [2]u8 {
        return [2]u8{ x - 1, y - 1 };
    }
    pub fn up_right(x: u8, y: u8) [2]u8 {
        return [2]u8{ x + 1, y - 1 };
    }
    pub fn down_left(x: u8, y: u8) [2]u8 {
        return [2]u8{ x - 1, y + 1 };
    }
    pub fn down_right(x: u8, y: u8) [2]u8 {
        return [2]u8{ x + 1, y + 1 };
    }
};

fn recursive_walk(word_to_search: []const u8, buf: [][]const u8, curr_idx: [2]u8, curr_word_idx: u8) bool {
    const x = curr_idx[0];
    const y = curr_idx[1];
    const curr_char = buf[y][x];
    var results = [_]bool{false} ** 8;

    if (word_to_search[curr_word_idx] == curr_char) {
        if (word_to_search.len - 1 == curr_word_idx) {
            return true;
        }
        if (y > 0) {
            results[0] = recursive_walk(word_to_search, buf, Movements.up(x, y), curr_word_idx + 1);
            if (x > 0) {
                results[4] = recursive_walk(word_to_search, buf, Movements.up_left(x, y), curr_word_idx + 1);
            }
            if (x < buf[y].len - 1) {
                results[5] = recursive_walk(word_to_search, buf, Movements.up_right(x, y), curr_word_idx + 1);
            }
        }
        if (y < buf.len - 1) {
            results[1] = recursive_walk(word_to_search, buf, Movements.down(x, y), curr_word_idx + 1);
            if (x > 0) {
                results[6] = recursive_walk(word_to_search, buf, Movements.down_left(x, y), curr_word_idx + 1);
            }
            if (x < buf[y].len - 1) {
                results[7] = recursive_walk(word_to_search, buf, Movements.down_right(x, y), curr_word_idx + 1);
            }
        }
        if (x > 0) {
            results[2] = recursive_walk(word_to_search, buf, Movements.left(x, y), curr_word_idx + 1);
        }
        if (x < buf[y].len - 1) {
            results[3] = recursive_walk(word_to_search, buf, Movements.right(x, y), curr_word_idx + 1);
        }
    }

    for (results, 0..) |result, i| {
        if (result) {
            std.debug.print("idx: {}\n", .{i});
            return true;
        }
    }

    return false;
}

const std = @import("std");
const helper = @import("../helper.zig");

pub fn resolve() !i32 {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();
    var lines = try helper.readFile(allocator, "day_3.txt");

    defer {
        for (lines.items) |line| {
            allocator.free(line);
        }
        lines.deinit();
    }

    var total: i32 = 0;
    for (lines.items) |line| {
        const to_sum = dfa_sub(line);
        total += to_sum;
    }

    return total;
}

fn dfa_sub(slice: []const u8) i32 {
    const head = "mul(";
    var state: i32 = -1;
    var pos: usize = undefined;
    var cur: [2]i32 = undefined;
    var idx: usize = undefined;
    var flags: usize = undefined;
    var total: i32 = 0;
    for (slice) |ch| {
        if (state == -1) {
            state = 0;
            pos = 0;
            cur = [2]i32{ 0, 0 };
            idx = 0;
            flags = 0;
        }
        switch (state) {
            // numbers
            1 => {
                if (ch == ',') {
                    idx += 1;
                    if (idx > 1) state = -1;
                } else if (ch >= '0' and ch <= '9') {
                    cur[idx] = cur[idx] * 10 + @as(i32, @intCast(ch - '0'));
                    flags |= idx + 1;
                } else if (ch == ')' and idx == 1 and cur[0] >= 0 and cur[1] >= 0 and flags == 3) {
                    // std.debug.print("{d}*{d}\n", .{ cur[0], cur[1] });
                    total += cur[0] * cur[1];
                    state = -1;
                } else state = -1;
            },
            // prefix
            0 => {
                if (ch == head[pos]) {
                    pos += 1;
                } else {
                    pos = 0;
                }
                if (pos == head.len) {
                    state = 1;
                    cur = [2]i32{ 0, 0 };
                    idx = 0;
                }
            },
            else => {},
        }
    }

    return total;
}

// fn processLine(allocator: std.mem.Allocator, line: []const u8) !i64 {
//     const first_part_to_match = "mul(";
//     var last_match_idx: u8 = 0;
//     var last_match_idx_second: u8 = 0;
//     var buff = std.ArrayList(u8).init(allocator);
//     defer buff.deinit();
//     var total: i64 = 0;
//
//     for (line) |char| {
//         if (first_part_to_match[last_match_idx] == char and last_match_idx <= first_part_to_match.len - 1) {
//             last_match_idx += 1;
//         }
//
//         if (last_match_idx > first_part_to_match.len - 1) {
//             if (first_part_to_match[last_match_idx_second] == char and last_match_idx_second <= first_part_to_match.len - 1) {
//                 last_match_idx_second += 1;
//             }
//             if (last_match_idx_second > first_part_to_match.len - 1) {
//                 buff.clearAndFree();
//                 last_match_idx_second = 0;
//             }
//
//             if (char == ')') {
//                 last_match_idx = 0;
//                 const to_sum = multiply(buff.items[2..]) catch 0;
//                 total += to_sum;
//                 std.debug.print("line: {s}\n =>", .{buff.items});
//                 std.debug.print("to sun: {}\n", .{to_sum});
//                 buff.clearAndFree();
//             }
//
//             try buff.append(char);
//         }
//     }
//
//     return total;
// }
//
// const MultiplyError = error{ Null, TooMany };
//
// fn multiply(string: []u8) !i64 {
//     var iter = std.mem.tokenize(u8, string, ",");
//     if (iter.peek() == null) {
//         return MultiplyError.Null;
//     }
//
//     const first_num = try std.fmt.parseInt(i64, iter.next().?, 10);
//     if (iter.peek() == null) {
//         return MultiplyError.Null;
//     }
//
//     const second_num = try std.fmt.parseInt(i64, iter.next().?, 10);
//     const sla = @as(i64, @intCast())
//
//     if (iter.peek() != null) {
//         return MultiplyError.TooMany;
//     }
//
//     return first_num * second_num;
// }

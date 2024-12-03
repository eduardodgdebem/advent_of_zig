const std = @import("std");

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

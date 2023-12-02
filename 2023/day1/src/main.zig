const std = @import("std");
const part1 = @embedFile("data/part1");

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    // var sum: i32 = 0;
    //
    // var lines = std.mem.tokenize(u8, part1, "\n");
    // while (lines.next()) |line| {
    //     const result = try removeNonNumeric(&allocator, line);
    //     var tens: i32 = result[0];
    //     const ones: i32 = result[result.len - 1];
    //     tens *= 10;
    //     sum += tens + ones;
    // }
    // std.debug.print("Part 1: {d}\n", .{sum});

    var p2sum: i32 = 0;

    var p2lines = std.mem.tokenize(u8, part1, "\n");
    while (p2lines.next()) |line| {
        const newline = try replaceStringNumberWithInts(&allocator, line);
        const result = try removeNonNumeric(&allocator, newline);
        var tens: i32 = result[0];
        const ones: i32 = result[result.len - 1];
        tens *= 10;
        p2sum += tens + ones;
    }
    std.debug.print("Part 2: {d}\n", .{p2sum});
}

fn removeNonNumeric(allocator: *std.mem.Allocator, input: []const u8) ![]i32 {
    const output = try allocator.alloc(i32, 256);
    var index: usize = 0;

    for (input) |char| {
        if (char >= '0' and char <= '9') {
            const i: i32 = char - '0';
            output[index] = i;
            index += 1;
        }
    }

    return output[0..index];
}

fn replaceStringNumberWithInts(allocator: *std.mem.Allocator, line: []const u8) ![]const u8 {
    var result = try allocator.alloc(u8, line.len);
    var index: usize = 0;
    var count: usize = 0;

    while (index < line.len) {
        var num_to_send = @min(5, line.len - index);
        var num: u8 = 0;
        while (num_to_send >= 3) {
            num = stringToNumber(line[index .. index + num_to_send]) catch {
                num_to_send -= 1;
                continue;
            };
            break;
        }
        if (num > 0) {
            result[count] = num;
            index += 1;
            count += 1;
        } else {
            result[count] = line[index];
            index += 1;
            count += 1;
        }
    }
    const out: []const u8 = result[0..count];
    return out;
}

fn stringToNumber(str: []const u8) !u8 {
    if (std.mem.eql(u8, str, "zero")) return '0' + 0;
    if (std.mem.eql(u8, str, "one")) return '0' + 1;
    if (std.mem.eql(u8, str, "two")) return '0' + 2;
    if (std.mem.eql(u8, str, "three")) return '0' + 3;
    if (std.mem.eql(u8, str, "four")) return '0' + 4;
    if (std.mem.eql(u8, str, "five")) return '0' + 5;
    if (std.mem.eql(u8, str, "six")) return '0' + 6;
    if (std.mem.eql(u8, str, "seven")) return '0' + 7;
    if (std.mem.eql(u8, str, "eight")) return '0' + 8;
    if (std.mem.eql(u8, str, "nine")) return '0' + 9;

    return error.InvalidNumber;
}

test "String to Number" {
    var result: u8 = stringToNumber("one") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    if (result != '1') {
        std.debug.print("result {d}", .{result});
        try std.testing.expect(std.mem.eql(u8, "false", "Result did not eq '1'"));
    }
    result = stringToNumber("error") catch |err| {
        if (err != error.InvalidNumber) {
            try std.testing.expect(std.mem.eql(u8, "false", "This should have throw error.InvalidNumber"));
        }
        return;
    };
}

test "Replace String Numbers with u8" {
    var allocator = std.heap.page_allocator;
    var result = replaceStringNumberWithInts(&allocator, "two1nine") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    try testu8Arrays(result, &[_]u8{ '2', 'w', 'o', '1', '9', 'i', 'n', 'e' });

    result = replaceStringNumberWithInts(&allocator, "eightwothree") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    try testu8Arrays(result, &[_]u8{ '8', 'i', 'g', 'h', '2', 'w', 'o', '3', 'h', 'r', 'e', 'e' });

    result = replaceStringNumberWithInts(&allocator, "abcone2threexyz") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    try testu8Arrays(result, &[_]u8{ 'a', 'b', 'c', '1', 'n', 'e', '2', '3', 'h', 'r', 'e', 'e', 'x', 'y', 'z' });

    result = replaceStringNumberWithInts(&allocator, "4nineeightseven2") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    try testu8Arrays(result, &[_]u8{ '4', '9', 'i', 'n', 'e', '8', 'i', 'g', 'h', 't', '7', 'e', 'v', 'e', 'n', '2' });

    result = replaceStringNumberWithInts(&allocator, "zoneight234") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    try testu8Arrays(result, &[_]u8{ 'z', '1', 'n', '8', 'i', 'g', 'h', 't', '2', '3', '4' });

    result = replaceStringNumberWithInts(&allocator, "7pqrstsixteen") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    try testu8Arrays(result, &[_]u8{ '7', 'p', 'q', 'r', 's', 't', '6', 'i', 'x', 't', 'e', 'e', 'n' });

    result = replaceStringNumberWithInts(&allocator, "one1two2threeight") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    try testu8Arrays(result, &[_]u8{ '1', 'n', 'e', '1', '2', 'w', 'o', '2', '3', 'h', 'r', 'e', '8', 'i', 'g', 'h', 't' });
    allocator.free(result);
}

test "Remove Non Numerics" {
    var allocator = std.heap.page_allocator;

    const result = removeNonNumeric(&allocator, "one1two2three3not") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    defer allocator.free(result);
    try testi32Arrays(result, &[_]i32{ 1, 2, 3 });
}

test "Together" {
    var allocator = std.heap.page_allocator;
    var newline = replaceStringNumberWithInts(&allocator, "7pqrstsixteen") catch |err| {
        std.debug.print("Caught Error: {}", .{err});
        return;
    };
    const result = try removeNonNumeric(&allocator, newline);
    try testi32Arrays(result, &[_]i32{ 7, 6 });
}

fn testu8Arrays(result: []const u8, expected: []const u8) !void {
    var count: usize = 0;
    for (result) |i| {
        try std.testing.expect(i == expected[count]);
        count += 1;
    }
}

fn testi32Arrays(result: []i32, expected: []const i32) !void {
    var count: usize = 0;
    for (result) |i| {
        try std.testing.expect(i == expected[count]);
        count += 1;
    }
}

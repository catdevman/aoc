const std = @import("std");

const part1 = @embedFile("data/part1");

const MAX_BLUE: i32 = 14;
const MAX_RED: i32 = 12;
const MAX_GREEN: i32 = 13;

pub fn main() !void {
    // var allocator = std.heap.page_allocator;

    var p1sum: i32 = 0;
    var p2sum: i32 = 0;

    var p1lines = std.mem.tokenize(u8, part1, "\n");
    while (p1lines.next()) |line| {
        var max_blue: i32 = -1;
        var max_red: i32 = -1;
        var max_green: i32 = -1;
        var colon_split = std.mem.split(u8, line, ":");
        var game_id_str = colon_split.next().?;
        var game_sets_str = colon_split.next().?;
        var game_id_split = std.mem.split(u8, game_id_str, " ");
        _ = game_id_split.next().?;
        game_id_str = game_id_split.next().?;
        const game_id = try std.fmt.parseInt(i32, game_id_str, 10);
        var add_game_id = true;
        var game_sets_split = std.mem.split(u8, game_sets_str, ";");
        while (game_sets_split.next()) |game_set_str| {
            var game_set_split = std.mem.split(u8, game_set_str, ",");
            while (game_set_split.next()) |dice_str| {
                var dice_split = std.mem.split(u8, dice_str, " ");
                _ = dice_split.next().?; // Get rid of prefix " "
                var roll_value = dice_split.next().?;
                var val = try std.fmt.parseInt(i32, roll_value, 10);
                var roll_color = dice_split.next().?;
                if (std.mem.eql(u8, roll_color, "red")) {
                    if (val > max_red) {
                        max_red = val;
                    }
                    if (val > MAX_RED) {
                        add_game_id = false;
                    }
                } else if (std.mem.eql(u8, roll_color, "blue")) {
                    if (val > max_blue) {
                        max_blue = val;
                    }
                    if (val > MAX_BLUE) {
                        add_game_id = false;
                    }
                } else if (std.mem.eql(u8, roll_color, "green")) {
                    if (val > max_green) {
                        max_green = val;
                    }
                    if (val > MAX_GREEN) {
                        add_game_id = false;
                    }
                }
            }
        }
        var temp: i32 = 1;
        temp = if (max_red > 0) temp * max_red else temp;
        temp = if (max_blue > 0) temp * max_blue else temp;
        temp = if (max_green > 0) temp * max_green else temp;
        p2sum += temp;
        std.debug.print("game: {d}\nsets: {s}\nadd_game_id: {any}\n", .{ game_id, game_sets_str, add_game_id });
        std.debug.print("==========\n", .{});
        if (add_game_id) {
            p1sum += game_id;
        }
    }
    std.debug.print("Part1: {d}\n", .{p1sum});
    std.debug.print("Part2: {d}\n", .{p2sum});
}

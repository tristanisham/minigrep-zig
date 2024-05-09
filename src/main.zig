// minigrep
// Copyright 2023 Tristan Isham
// https://twitter.com/atalocke

const std = @import("std");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Collecting Command line arguments
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // How to do a for loop
    //    for (args) |arg| {
    //     std.debug.print("{s}\n", .{arg});
    //    }

    if (args.len < 3) {
        std.log.err("minigrep requires a string and target file path.\n\t`$ minigrep <query> <file>`", .{});
        std.process.exit(1);
    }

    const query = args[1];
    const file_path = args[2];

    std.debug.print("Searching for \"{s}\" in file: {s}\n", .{ query, file_path });

    // Accessing a file
    const file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    const contents = try file.readToEndAlloc(allocator, (try file.stat()).size);
    // std.debug.print("With text:{s}\n", .{contents});

    if (try search(allocator, &contents, &query)) |results| {
        std.log.info("\x1b[1;32mFound:\x1b[1;0m\n", .{});
        for (results.items) |item| {
            std.debug.print("{s}\n", .{item});
        }
        results.deinit();
    } else {
        std.debug.print("😵", .{});
    }
}


/// Search returns any lines containing the provided `query` paramater. If no lines are found search returns `null`.
///
/// The **caller must free** the returned lines:
/// ```
/// if (try search(alloc, &content, &query)) |lines| {
///     // do something with lines
///     lines.deinit();
/// }
/// ```
fn search(alloc: std.mem.Allocator, source: *const []u8, query: *const []u8) !?ArrayList([]const u8) {
    var list = ArrayList([]const u8).init(alloc);

    var iter = std.mem.split(u8, source.*, "\n");
    while (iter.next()) |line| {
        if (std.mem.containsAtLeast(u8, line, 1, query.*)) {
            try list.append(line);
        }
    }

    if (list.items.len > 0) {
        return list;
    }

    return null;
}

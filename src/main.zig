// Test file generated from `zig init-exe` and modified with my notes on Zig.

// Importing is not as convenient as in Rust.
// Can't find any way to unpack the returned struct (i.e. {ArrayList, testing, ..} = ...)
// Need to do new consts for each function if you don't want to do `std.` all the time.
// OTOH, it is pretty cool that imports are just normal structs.
const std = @import("std");

// `!` indicates the function can return an error
pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual non-debug output, and needs explicit init & flush
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // Zig has anonymous structs using the syntax `.{fields...}` :D
    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    // ALWAYS need to specify what allocator you want to use.
    // Having the option to specify different allocators is a cool feature of Zig,
    // but I wish it was just an option and not a requirement. Having to do it
    // all the time is inconvenient and makes the code unnecessarily verbose.
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // also need to explicitly deallocate

    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

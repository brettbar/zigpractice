const rl = @import("raylib");
const std = @import("std");
const el = @import("./elements.zig");
const irongui = @import("./forge.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();
    var f: irongui.Forge = irongui.Forge.init(allocator);
    defer {
        f.deinit();
        _ = gpa.deinit();
    }

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        // const first: []const u8 = "Example:";
        // const num_as_str = std.fmt.comptimePrint("{s} {d}", .{ first, elem.id });
        // const final = @as([*:0]const u8, @ptrCast(num_as_str));

        const width = @as(f32, @floatFromInt(rl.getScreenWidth()));
        const height = @as(f32, @floatFromInt(rl.getScreenHeight()));
        const root_r: rl.Rectangle = .{ .x = 0, .y = 0, .width = width, .height = height };

        const grid_e = try f.grid(root_r, 3, 3);
        const grid = try grid_e.grid();
        const col1 = grid.slot(grid_e, 4);

        try f.text_label(col1, "ABC");

        defer f.clear();
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.gray);

        f.draw();

        //rl.drawFPS(0, 0);
        //----------------------------------------------------------------------------------
    }
}

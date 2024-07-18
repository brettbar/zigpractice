const rl = @import("raylib");
const std = @import("std");
const irongui = @import("./irongui.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    const elem = irongui.Element{
        .id = 0,
        .background = rl.Color.purple,
        // .t = irongui.Union{
        //     .grid = irongui.Grid{
        //         .w = 0,
        //         .h = 0,
        //     },
        // },
        .t = irongui.Union{
            .text = irongui.Text{
                .text = "Press",
            },
        },
    };

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        const first: []const u8 = "Example:";
        const num_as_str = std.fmt.comptimePrint("{s} {d}", .{ first, elem.id });

        const final = @as([*:0]const u8, @ptrCast(num_as_str));

        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        rl.drawText(final, 190, 200, 20, rl.Color.light_gray);

        elem.draw();
        //----------------------------------------------------------------------------------
    }
}

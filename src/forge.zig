const el = @import("./elements.zig");
const rl = @import("raylib");
const std = @import("std");

pub const Forge = struct {
    stack: std.ArrayList(el.Element),

    pub fn init(alloc: std.mem.Allocator) Forge {
        return Forge{ .stack = std.ArrayList(el.Element).init(alloc) };
    }

    pub fn deinit(self: Forge) void {
        self.stack.deinit();
    }

    pub fn clear(self: *Forge) void {
        self.stack.clearAndFree();
    }

    pub fn grid(self: *Forge, t: rl.Rectangle, cols: u32, rows: u32) !el.Element {
        const element = el.Element{
            .id = 0,
            .transform = t,
            .background = rl.colorAlpha(rl.Color.black, 0.0),
            .t = el.Union{
                .grid = el.Grid{
                    .cols = cols,
                    .rows = rows,
                },
            },
        };

        try self.stack.append(element);

        return element;
    }

    pub fn text_label(self: *Forge, t: rl.Rectangle, txt: []const u8) !void {
        const element = el.Element{
            .id = 0,
            .transform = t,
            .background = rl.Color.black,
            .t = el.Union{
                .text = el.Text{
                    .text = txt,
                },
            },
        };

        try self.stack.append(element);
    }

    pub fn draw(self: *Forge) void {
        for (self.stack.items) |elem| {
            elem.draw();
        }
    }
};

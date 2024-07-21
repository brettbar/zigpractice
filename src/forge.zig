const el = @import("./elements.zig");
const rl = @import("raylib");
const std = @import("std");

pub const Forge = struct {
    stack: std.ArrayList(el.Element),
    // bool TextButton( rect t, str txt, Color c = { 0, 0, 0, 0 }, f32 s = 1.0f ) {
    //   auto e = TextLabel( t, txt, c, s );
    //   e->interactable = true;
    //   return CheckInteract( *e );
    // }
    // Element *Grid(
    //   rect t,
    //   u32 c,
    //   u32 r,
    //   Color color = { 0, 0, 0, 0 },
    //   f32 s = 1.0f
    // ) {
    //   auto e = new Element();
    //   e->type = Type::Grid;
    //   e->id = queue.size();
    //   e->background = BLUE;
    //   e->transform = t;
    //   e->scale = s;
    //   e->background = color;
    //   e->t.grid = new IGrid( c, r );
    //   queue.push_back( e );
    //   return e;
    // }
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
            .background = rl.Color.white,
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
            .background = rl.Color.purple,
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

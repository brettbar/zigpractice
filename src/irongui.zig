const rl = @import("raylib");
const std = @import("std");

pub const Element_t = enum { grid, text, text_input, texture, tabs };

pub const Element = struct {
    id: u32,
    //transform: rl.Rectangle,
    // scale: f32,
    background: rl.Color,
    // stateful: bool,
    // interactable: bool,

    t: Union,

    pub fn draw(self: Element) void {
        switch (self.t) {
            Element_t.grid => self.t.grid.draw(),
            Element_t.text => self.t.text.draw(self),
            Element_t.text_input => std.debug.print("text_input", .{}),
            Element_t.texture => std.debug.print("texture", .{}),
            Element_t.tabs => std.debug.print("tabs", .{}),
        }
    }
};

pub const Grid = struct {
    w: u32,
    h: u32,

    pub fn draw(self: Grid) void {
        std.debug.print("grid {d}\n", .{self.w});
    }
};

pub const Text = struct {
    text: []const u8,

    pub fn draw(self: Text, element: Element) void {
        const final = @as([*:0]const u8, @ptrCast(self.text));
        rl.drawRectangle(190, 200, 200, 40, rl.Color.black);
        rl.drawRectangleLines(190, 200, 200, 40, element.background);
        rl.drawText(final, 190, 200, 32, rl.Color.white);
    }
};

pub const Union = union(Element_t) {
    grid: Grid,
    text: Text,
    text_input: u32,
    texture: u32,
    tabs: u32,
};

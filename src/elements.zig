const rl = @import("raylib");
const std = @import("std");

pub fn coords_from_index(index: u32, width: u32) rl.Vector2 {
    const index_i = @as(i32, @intCast(index));
    const width_i = @as(i32, @intCast(width));

    const x: i32 = @mod(index_i, width_i);
    const y: i32 = @divFloor(index_i, width_i);

    return .{
        .x = @as(f32, @floatFromInt(x)),
        .y = @as(f32, @floatFromInt(y)),
    };
}

pub const Element_t = enum { grid, text, text_input, texture, tabs };

pub const Element = struct {
    id: u32,
    transform: rl.Rectangle,
    // scale: f32,
    background: rl.Color,
    // stateful: bool,
    // interactable: bool,

    t: Union,

    pub fn draw(self: Element) void {
        switch (self.t) {
            Element_t.grid => self.t.grid.draw(self),
            Element_t.text => self.t.text.draw(self),
            Element_t.text_input => std.debug.print("text_input", .{}),
            Element_t.texture => std.debug.print("texture", .{}),
            Element_t.tabs => std.debug.print("tabs", .{}),
        }
    }

    pub fn grid(self: Element) !Grid {
        if (self.t != Element_t.grid) {
            return error.invalidtype;
        }

        return self.t.grid;
    }
};

pub const Grid = struct {
    cols: u32,
    rows: u32,

    pub fn draw(_: Grid, element: Element) void {
        if (element.background.a > 0) {
            rl.drawRectangleRec(element.transform, element.background);
        }
    }

    pub fn col(self: Grid, el: Element, column: u32) rl.Rectangle {
        // @volatile
        const slot_width: f32 = el.transform.width / @as(f32, @floatFromInt(self.cols));
        const slot_height: f32 = el.transform.height / @as(f32, @floatFromInt(self.rows));

        return rl.Rectangle{
            .x = el.transform.x + @as(f32, @floatFromInt(column)) * slot_width,
            .y = el.transform.y,
            .width = slot_width,
            .height = slot_height * @as(f32, @floatFromInt(self.rows)),
        };
    }

    pub fn slot(self: Grid, el: Element, i: u32) rl.Rectangle {
        const coords = coords_from_index(i, self.cols);
        // @volatile
        const slot_width: f32 = el.transform.width / @as(f32, @floatFromInt(self.cols));
        const slot_height: f32 = el.transform.height / @as(f32, @floatFromInt(self.rows));

        return rl.Rectangle{
            .x = el.transform.x + (coords.x * slot_width),
            .y = el.transform.y + (coords.y * slot_height),
            .width = slot_width,
            .height = slot_height,
        };
    }
};

pub const Text = struct {
    text: []const u8,

    pub fn draw(self: Text, element: Element) void {
        const final = @as([*:0]const u8, @ptrCast(self.text));
        rl.drawRectangleRec(element.transform, element.background);
        rl.drawRectangleLinesEx(element.transform, 2.0, rl.Color.white);

        const font_size = 32.0;
        const text_width: f32 = @as(f32, @floatFromInt(rl.measureText(final, font_size)));

        const text_pos_x: f32 = (element.transform.x + element.transform.width / 2.0) - (text_width / 2.0);
        const text_pos_y: f32 = (element.transform.y + element.transform.height / 2.0) - (font_size / 2.0);

        rl.drawText(
            final,
            @as(i32, @intFromFloat(text_pos_x)),
            @as(i32, @intFromFloat(text_pos_y)),
            font_size,
            rl.Color.white,
        );
    }
};

pub const Union = union(Element_t) {
    grid: Grid,
    text: Text,
    text_input: u32,
    texture: u32,
    tabs: u32,
};

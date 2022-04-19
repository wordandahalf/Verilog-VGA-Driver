module VgaImageDriver(
    input   i_DRAW_ENABLE,
    input   [$clog2(p_H_VISIBLE_AREA) - 1: 0]  i_SCANLINE_X,
    input   [$clog2(p_V_VISIBLE_AREA) - 1: 0]  i_SCANLINE_Y,

    output  [7:0]   o_VGA_RED,
    output  [7:0]   o_VGA_GREEN,
    output  [7:0]   o_VGA_BLUE
);
    parameter   p_H_VISIBLE_AREA    = 640;
    parameter   p_V_VISIBLE_AREA    = 480;

    wire    [7:0]   w_IMAGE_DATA [p_H_VISIBLE_AREA * p_V_VISIBLE_AREA * 3 - 1:0];

    ImageMultiplexer multiplexer(0, w_IMAGE_DATA);

    assign o_VGA_RED    = i_DRAW_ENABLE ? w_IMAGE_DATA[(i_SCANLINE_Y * p_H_VISIBLE_AREA) + (i_SCANLINE_X * 3) + 0] : 8'b0;
    assign o_VGA_GREEN  = i_DRAW_ENABLE ? w_IMAGE_DATA[(i_SCANLINE_Y * p_H_VISIBLE_AREA) + (i_SCANLINE_X * 3) + 1] : 8'b0;
    assign o_VGA_BLUE   = i_DRAW_ENABLE ? w_IMAGE_DATA[(i_SCANLINE_Y * p_H_VISIBLE_AREA) + (i_SCANLINE_X * 3) + 2] : 8'b0;
endmodule
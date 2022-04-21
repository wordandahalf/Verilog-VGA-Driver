module Top(
    // 50 MHz core clock
    input           i_CLK,

    // Tactile button input to cycle
    // through the three images
    // input           i_CYCLE_IMAGE,

    // Tactile button input to blank
    // the display
    // input           i_BLANK_DISPLAY,

    // VGA color signals
    output  [7:0]   o_VGA_RED,
    output  [7:0]   o_VGA_GREEN,
    output  [7:0]   o_VGA_BLUE,

    // VGA synchronization signals
    output          o_VGA_CLK,
    output          o_VGA_HSYNC,
    output          o_VGA_VSYNC,

    // Debugging signals
    output          o_DRAW_ENABLE
);
    ClockDivider #(2) divider(i_CLK, o_VGA_CLK);

    wire    [$clog2(640) - 1: 0]    w_SCANLINE_X /*verilator public*/;
    wire    [$clog2(480) - 1: 0]    w_SCANLINE_Y /*verilator public*/;

    VgaScanlineDriver scanline_driver(
        o_VGA_CLK,
        o_VGA_HSYNC, o_VGA_VSYNC,
        o_DRAW_ENABLE,
        w_SCANLINE_X, w_SCANLINE_Y
    );

    VgaImageDriver image_driver(
        o_DRAW_ENABLE,
        w_SCANLINE_X, w_SCANLINE_Y,
        o_VGA_RED, o_VGA_GREEN, o_VGA_BLUE
    );
endmodule
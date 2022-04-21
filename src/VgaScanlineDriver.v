module VgaScanlineDriver(
    input   i_VGA_CLOCK,

    output  o_VGA_SYNC_H,
    output  o_VGA_SYNC_V,

    output  o_DRAW_ENABLE,

    output [$clog2(p_H_VISIBLE_AREA) - 1: 0]    o_SCANLINE_X,
    output [$clog2(p_V_VISIBLE_AREA) - 1: 0]    o_SCANLINE_Y
);

    // Horizontal timings
    parameter   p_H_VISIBLE_AREA    = 640;
    parameter   p_H_FRONT_PORCH     = 16;
    parameter   p_H_SYNC_PULSE      = 96;
    parameter   p_H_BACK_PORCH      = 48;
    parameter   p_H_WHOLE_LINE      = 800;

    // Vertical timings
    parameter   p_V_VISIBLE_AREA    = 480;
    parameter   p_V_FRONT_PORCH     = 10;
    parameter   p_V_SYNC_PULSE      = 2;
    parameter   p_V_BACK_PORCH      = 33;
    parameter   p_V_WHOLE_FRAME     = 525;

    reg [$clog2(p_H_WHOLE_LINE) - 1:0]   r_COUNTER_X = 0;
    reg [$clog2(p_V_WHOLE_FRAME) - 1:0]  r_COUNTER_Y = 0;

    // 
    always @(posedge i_VGA_CLOCK)
    begin
        r_COUNTER_X <= (r_COUNTER_X + 1'b1) % p_H_WHOLE_LINE;

        if (r_COUNTER_X == p_H_WHOLE_LINE - 1)
            r_COUNTER_Y <= (r_COUNTER_Y + 1'b1) % p_V_WHOLE_FRAME;
    end

    // Assign synchronization signals
    assign o_VGA_SYNC_H =
        (r_COUNTER_X > p_H_FRONT_PORCH + p_H_VISIBLE_AREA + p_H_BACK_PORCH - 1)
            && (r_COUNTER_X < p_H_WHOLE_LINE);

    assign o_VGA_SYNC_V =
        (r_COUNTER_Y > p_V_VISIBLE_AREA + p_V_FRONT_PORCH + p_V_BACK_PORCH - 1)
            && (r_COUNTER_Y < p_V_WHOLE_FRAME);

    // Assign enable signal
    assign o_DRAW_ENABLE =
        ((r_COUNTER_X >= p_H_FRONT_PORCH) && (r_COUNTER_X < p_H_FRONT_PORCH + p_H_VISIBLE_AREA))
            && ((r_COUNTER_Y >= p_V_FRONT_PORCH) && (r_COUNTER_Y < p_V_FRONT_PORCH + p_V_VISIBLE_AREA));

    assign o_SCANLINE_X = r_COUNTER_X[$clog2(p_H_VISIBLE_AREA) - 1:0] - p_H_FRONT_PORCH;
    assign o_SCANLINE_Y = r_COUNTER_Y[$clog2(p_V_VISIBLE_AREA) - 1:0] - p_V_FRONT_PORCH;
endmodule
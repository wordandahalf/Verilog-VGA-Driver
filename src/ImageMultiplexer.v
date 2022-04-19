module ImageMultiplexer(
    input   [1:0]   i_IMAGE_SELECT,

    output  [7:0] o_IMAGE_DATA [p_RESOLUTION * 3 - 1:0]
);

    parameter p_RESOLUTION = 640 * 480;

    reg [7:0]    r_IMAGE_0_DATA [p_RESOLUTION * 3 - 1:0];
    reg [7:0]    r_IMAGE_1_DATA [p_RESOLUTION * 3 - 1:0];
    reg [7:0]    r_IMAGE_2_DATA [p_RESOLUTION * 3 - 1:0];

    initial
    begin
        $readmemh("images/photo0.png.hex", r_IMAGE_0_DATA);
        $readmemh("images/photo1.png.hex", r_IMAGE_1_DATA);
        $readmemh("images/photo2.png.hex", r_IMAGE_2_DATA);
    end

    assign o_IMAGE_DATA =
        (i_IMAGE_SELECT == 0) ? r_IMAGE_0_DATA :
        (i_IMAGE_SELECT == 1) ? r_IMAGE_1_DATA :
        (i_IMAGE_SELECT == 2) ? r_IMAGE_2_DATA : 0;
endmodule
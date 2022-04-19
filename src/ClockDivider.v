//
// Divides i_CLK by p_DIVISION.
//
module ClockDivider(
	input	i_CLK,
	output  o_CLK
);

	parameter p_DIVISION = 1;
	
	reg [$clog2(p_DIVISION) - 1:0] r_COUNTER = 0;
	
	always @(posedge i_CLK)
		r_COUNTER <= r_COUNTER + 1'b1;
		
	assign o_CLK = &r_COUNTER;
endmodule
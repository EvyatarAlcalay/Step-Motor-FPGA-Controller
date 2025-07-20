module clk_divider(clk, rst, count_to, clk_out);

// IO declaration 
input wire clk;
input wire rst;
input wire [20:0] count_to;
output reg clk_out;

// inner reg 
reg [20:0] count;

// clock divider logic - create clock with half period of count_to
always @(posedge clk or negedge rst)
	begin
		if (~rst) begin 
				count <= 21'd0;
				clk_out = 0;
		end else if (count >= count_to - 21'd1) begin 
			count <= 21'd0;
			clk_out = (~clk_out); // change the clock
		end else begin 
			count <= count + 21'd1;
		end 
	end
	
endmodule

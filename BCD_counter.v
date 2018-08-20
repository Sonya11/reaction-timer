//1-digit BCD counter with carry out
module one_digit_BCD_counter(input clk, input rst, input enable, 
										output reg[3:0] count, output reg carry_out); //ripple carry out = RCO, D = load value, Q = current count 
	
	always@(posedge clk, posedge rst)
	begin
			if(rst)
			begin
				count <= 0; 
				carry_out = 0;
			end
			else if(count < 4'b1001) // if less than 9
			begin
				if(enable)  //value only changes when counter is enabled 
				begin
					count <= count + 1;
					carry_out = 0;
				end
			end
			else
			begin
				count <= 0; 
				carry_out = 1; //carryout is a 1 only when count = 9
			end
	end
endmodule


//n-digit bcd counter with deflaut size of 4 digits (16 bits)
module n_digit_BCD_counter(input clk, input rst, input enable, output[(n*4)-1:0] count);

	parameter n = 4; //# of decimal digits
	
	wire[n:0] carry;
	assign carry[0] = clk;
	
	genvar i;
	generate //instantiate 4 1-bit BCD counters with carry out of previous counter fed in to enable of new counter
		for(i = 0; i < n; i = i + 1) 
		begin:BCD
			one_digit_BCD_counter BCD_counter(carry[i], rst, enable, count[(i+1)*n-1:i*n], carry[i+1]); 
		end
	endgenerate
	
endmodule

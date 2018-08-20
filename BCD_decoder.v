//7 segment diaplay decoder for one BCD digit
module BCD_to_7seg(input[3:0] BCD_val, input dec_pt, output reg[7:0] display_val);

	always@(BCD_val)
	begin
		if(dec_pt)
		begin
			case(BCD_val)               //.gfedcba
				4'b0000: display_val = ~8'b10111111;//0.
				4'b0001: display_val = ~8'b10000110;
				4'b0010: display_val = ~8'b11011011;
				4'b0011: display_val = ~8'b11001111;
				4'b0100: display_val = ~8'b11100110;
				4'b0101: display_val = ~8'b11101101;//5.
				4'b0110: display_val = ~8'b11111101;
				4'b0111: display_val = ~8'b10000111;
				4'b1000: display_val = ~8'b11111111;
				4'b1001: display_val = ~8'b11100111;//9.
				default: display_val = ~8'b11110001;//F.
			endcase
		end
		else
		begin
			case(BCD_val)
				4'b0000: display_val = ~8'b00111111;//0
				4'b0001: display_val = ~8'b00000110;
				4'b0010: display_val = ~8'b01011011;
				4'b0011: display_val = ~8'b01001111;
				4'b0100: display_val = ~8'b01100110;
				4'b0101: display_val = ~8'b01101101;//5
				4'b0110: display_val = ~8'b01111101;
				4'b0111: display_val = ~8'b00000111;
				4'b1000: display_val = ~8'b01111111;
				4'b1001: display_val = ~8'b01100111;//9
				default: display_val = ~8'b01110001;//F
			endcase
		end
	end

endmodule

module mux2to1(input[n*4-1:0] display1, input[n*4-1:0] display2, input select, output reg[n*4-1:0] display_out);
	
	parameter n = 4; //number of decimal digits 
	
	always@(select)
	begin
		if(select)
			display_out = display1;
		else
			display_out = display2;
	end
	
endmodule

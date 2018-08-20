//n-bit comparator (default size is 64 bits)
module comparator(input[n-1:0] value, input[n-1:0] compare_value, output reg en); //if value is reached, enable pulse goes high for one clock cycle

	parameter n = 64;
	
	always@(value)
	begin //set en to 1 if equal - if not, set to 0
		if(compare_value == value)
			en = 1'b1;
		else
			en = 1'b0;
	end
	
endmodule


//neg edge triggered d flip flop
module d_flip_flop(input D, input clk, input rst, 
							input en, output reg Q);
	
	//always blocks are really useful for flip flops since they are edge-triggerd <3
	always@(negedge(clk), posedge(rst))
	begin
		if(rst) 						//reset (asynchronous since it is in the sensitivity list)
		begin
			Q = 1'b0; 
		end
		else if(en) 		      //from characteristic table for d flip flop
		begin
			Q <= D; 					//non-blocking assignment to store value of D precisely at clock edge
		end
	end
	
endmodule

//positive edge triggered n-bit binary counter (default size is 64 bits)
module n_bit_counter (input clk, input enable, input[n-1:0] max_count, input rst, output reg[n-1:0] count);

	parameter n = 64; 
	
	always@(posedge clk, posedge rst)
	begin
		if(rst)                //asyncrhonous reset
		begin
			count <= 0;    
		end
		else if(count < max_count)
		begin
			if(enable)          //count will only be updated if module is enabled
				count <= count + 1; 
		end
		else
		begin
			count <= 0;        //if count is greater than or equal to max_count, reset to 0
		end	
	end
endmodule

//n-bit clock divider (default size is 64 bits)
module clock_divider(input in_clock, input[n-1:0] divide_by, input reset, output out_clock);

	parameter n = 64;

	wire[n-1:0] current_count;
	wire ff_enable;
	
	//counter module to count input clock pulses 
	n_bit_counter #(n) COUNT32_DIV(in_clock, 1, divide_by, reset, current_count);
	
	//comparator to check for flip value
	comparator #(n) COMPARE32_DIV(current_count, divide_by, ff_enable);
	
	//d flip flop with inverted feedback from output to toggle the previous state
	d_flip_flop DFF(~out_clock, in_clock, reset, ff_enable, out_clock);
	
endmodule



//n-bit timer (default size is 64 bits)
module up_timer(input clock, input enable, input[n-1:0] stop_val, input reset, output trigger); //(clock = 1k divided clock <3)
	
	parameter n = 64;
	wire[n-1:0] current_count; 
	
	//counter to count to stop value
	n_bit_counter #(n) COUNT32_TIMER(clock, enable, stop_val, reset, current_count);
	
	//to send signal when stope value is reached
	comparator #(n) COMPARE32_TIMER(current_count, stop_val, trigger); //trigger will stay high for one cycle of clock(on and off), and is pos triggered since counter is pos triggered 
	
endmodule

//LFSR
module lfsr(input clkin, input enable, output reg [6:0]numba);

	always@(posedge clkin)
		begin
			if (enable)
			begin
			if (numba == 7'b0)
				numba <=  7'b01100110;   //eliminates posibility that output will be 0
			else 
			
			begin                       //shift bits one to left and put XOR of MSB into LSB location
				numba[6] <= numba[5];
				numba[5] <= numba[4];
				numba[4] <= numba[3];
				numba[3] <= numba[2];
				numba[2] <= numba[1];
				numba[1] <= numba[0];
				numba[0] <= numba[6]^numba[5];
				 
			  end
			  end
		end	  
endmodule

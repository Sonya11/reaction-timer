//Moore state machine!
module state_machine(input clock, input reset, input start_button, input stop_button, 
							input timer_trigger, input display_select, output reg[6:0] module_controls, output[2:0] state); //currently not outputtingthe correct module controls 
	
	//define state vars <3
	reg[2:0] current_state, next_state;
	parameter[2:0] A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b100, E = 3'b101, F = 3'b011, G = 3'b110, H = 3'b111; //state variables 
	parameter[6:0] A_out = 7'b0001101, B_out = 7'b0010000, C_out = 7'b0, D_out = 7'b1000000, E_out = 7'b0, F_out = 7'b0100010; //state outputs
	
	//define state transitions <3
	always@(current_state, start_button, stop_button, timer_trigger, display_select)
	begin
		case(current_state)
		
			A: begin
				module_controls = A_out;
				if(~start_button & ~display_select) //if start = 0, display = 0, others = d
					next_state = A;
				else if(~start_button & display_select) //if start = 0, display = 1, others = d
					next_state = E;
				else if(start_button) //if start = 1, others = d
					next_state = B;
				end
				
			B: begin
				module_controls = B_out;
				if(~stop_button & ~timer_trigger) //if stop = 0, trigger = 0, others = d
					next_state = B;
				else if(timer_trigger) //if trigger = 1, others = d
					next_state = F;
				else if(stop_button & ~timer_trigger) //if stop = 1, trigger = 0, others = d
					next_state = C;
				end
					
			C: begin
				module_controls = C_out;
				if(~stop_button) //if stop = 0, others = d
					next_state = B;
				else if(stop_button) //if stop = 1, others = d
					next_state = C;
				end
					
			D: begin
				module_controls = D_out;
				if(~start_button) //if start = 0, others = d
					next_state = D;
				else if(start_button) //if stop = 1, others = d
					next_state = A;
				end
					
			E: begin
				module_controls = E_out;
				if(display_select) //if display = 1, others = d
					next_state = E;
				else if(~display_select) //if display = 0, others = d
					next_state = A;
				end
					
			F: begin
				module_controls = F_out;
				if(~stop_button) //if stop = 0, others = d
					next_state = F;
				else if(stop_button) //if stop = 1, others = d
					next_state = D;
				end
				
			default: begin //for any other value, return to state A
						module_controls = 7'b0;
						next_state = A;
						end
		endcase

	end
	
	//latch the state <3
	always@(posedge clock, posedge reset)
	begin
		if(reset) //asynchronous reset
			current_state <= A;
		else
			current_state <= next_state; //set current state to next state at clk posedge
	end
	
	assign state = current_state;

endmodule

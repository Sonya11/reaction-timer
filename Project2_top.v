module Project2_top(input MAX10_CLK1_50,output [7:0] HEX0, output [7:0] HEX1, 
							output [7:0] HEX2, output [7:0] HEX3, output [7:0] HEX4, 
							output [7:0] HEX5,input [1:0] KEY, output [9:0] LEDR,
							input [9:0] SW);

	//declaring wires				
	wire clock_1kHz, clock_10Hz;	
	wire trigger;		
	wire[6:0] module_controls;
	wire[15:0] BCD_count;
	wire[2:0] current_state;
	wire[15:0] high_score;
	wire[15:0] display;
	wire[6:0] stop_val;

	//turning off unused HEX displays
	assign HEX3 = ~8'b00000000;
	assign HEX4 = ~8'b00000000;

	//instantiate 1kHz and 10Hz clock divider modules with a 32-bit counter size
	clock_divider #(32) DIV_50M_1kHz(MAX10_CLK1_50, 24999, 0, clock_1kHz);//50MHz/(2*1kHz)-1 = 24,999
	clock_divider #(32) DIV_50M_10Hz(MAX10_CLK1_50, 2499999, 0, clock_10Hz);//50MHz/(2*10Hz)-1 = 2,499,999

	//instantiate state machine module with button and switch inputs -- (clk, rst, start, stop, trigger, display, controls, state)
	state_machine FSM(clock_1kHz, SW[0], ~KEY[0], ~KEY[1], trigger, SW[1], module_controls, current_state);
	//              {min enable, BCD enable, timer enable, BCD reset, timer reset, LED, LFSR en}	
	//module_controls[   6            5            4            3          2        1      0    ]

	//display state to 7-segment display
	BCD_to_7seg DISP(current_state, 0, HEX5);		

	//instantiate LFSR module with enable bit as module_controls[0]
	lfsr LFSR(clock_1kHz, module_controls[0], stop_val);

	//instatiate up timer module with 32 bit size --  (clk, enable, count to, rst, trigger)
	up_timer #(32) UP_TIMER_0(clock_10Hz, module_controls[4], stop_val, module_controls[2], trigger);

	//instantiat BCD counter module with 4 digit size(clock, rst, enable, count)
	n_digit_BCD_counter #(4) BCD_0(clock_1kHz, module_controls[3], module_controls[5], BCD_count);							

	//assigning LED timer indicator to LED control output from state machine
	assign LEDR[4] = module_controls[1]; 

	//instantiate high score module
	high_score #(4) HS(module_controls[6], BCD_count, high_score, high_score);

	//insatniate display multiplexer
	mux2to1 #(4) MUX(high_score, BCD_count, SW[1], display);

	//insantiate decoders for hex display
	BCD_to_7seg DECODER_2(display[7:4], 0, HEX0); //(value, DP, output)
	BCD_to_7seg DECODER_3(display[11:8], 0, HEX1); 
	BCD_to_7seg DECODER_4(display[15:12], 1, HEX2); 	

endmodule

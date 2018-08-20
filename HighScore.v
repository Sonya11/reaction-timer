//high score module
module high_score(input enable, input[(4*n)-1:0] new_score, input[(4*n)-1:0] high_score_in, output reg[(4*n)-1:0] high_score_out);
//use feedback so that no register is necessary ^

	parameter n = 4; //number of decimal digits

	always@(new_score, high_score_in)
	begin
		if(enable) //only checks high socre when enabled (enabled in state D)
		begin
			if((new_score > high_score_in)) 
			begin
				high_score_out = high_score_in; //high score is the same if new score is larger
			end
			else
			begin
				high_score_out = new_score; //high score is now the most recent score
			end
		end
		else
		begin
			high_score_out = high_score_in; //high score stays the same if not enabled
		end
	end

endmodule

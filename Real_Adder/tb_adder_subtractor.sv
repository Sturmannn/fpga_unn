module tb_adder_subtractor;

	logic [3:0] sw_1;
	logic [3:0] sw_2;
	logic subtract_mode;
	logic [4:0] led_1;
	
	adder_subtractor UUT(
		.operand_A(sw_1),
		.operand_B(sw_2),
		.subtract_mode(subtract_mode),
		.result(led_1)
	);
	
	initial begin
		$display("-----------------------------------------");
		
		// 3 + 3 = 4
		sw_1 = 4'b0011;
		sw_2 = 4'b0011;
		subtract_mode = 1'b0;
		
		#100;
		
		// 7 - 2 = 5
		sw_1 = 4'b0111;
		sw_2 = 4'b0010;
		subtract_mode = 1'b1;
		
		#100;
		
		// 10 + 10 = 20
		sw_1 = 4'b1010;
		sw_2 = 4'b1010;
		subtract_mode = 1'b0;
		
		#100;
		
		// 5 - 10 = -5
		sw_1 = 4'b0101;
		sw_2 = 4'b1010;
		subtract_mode = 1'b1;
		
		#100;
		
		$display("-----------------------------------------");
				
	end
endmodule

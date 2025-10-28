module adder_subtractor(
	input logic [3:0] operand_A,
	input logic [3:0] operand_B,
	input logic subtract_mode, // 0 сложение, 1 - вычитание
	output logic [4:0] result
);
	
	 // Для вычитания B инвертируется
    logic [3:0] b_modified;
	 
	 logic [4:0] carries;
	 
	 assign b_modified = operand_B ^ {4{subtract_mode}};
	 

    full_adder fa0 (
        .a(operand_A[0]),
        .b(b_modified[0]),
        .carry_in(subtract_mode),
        .sum(result[0]),
        .carry_out(carries[0])
    );

    full_adder fa1 (
        .a(operand_A[1]),
        .b(b_modified[1]),
        .carry_in(carries[0]),
        .sum(result[1]),
        .carry_out(carries[1])
    );

    full_adder fa2 (
        .a(operand_A[2]),
        .b(b_modified[2]),
        .carry_in(carries[1]),
        .sum(result[2]),
        .carry_out(carries[2])
    );

    full_adder fa3 (
        .a(operand_A[3]),
        .b(b_modified[3]),
        .carry_in(carries[2]),
        .sum(result[3]),
        .carry_out(carries[3])
    );

    full_adder fa4 (
        .a(1'b0),
        .b(subtract_mode),
        .carry_in(carries[3]),
        .sum(result[4]),
        .carry_out(carries[4])
    );
	 
    /*always_comb begin
        if (subtract_mode == 1'b1) begin
            result = {1'b0, operand_A} - {1'b0, operand_B};
        end
        else begin
            result = {1'b0, operand_A} + {1'b0, operand_B};
        end
    end*/

endmodule
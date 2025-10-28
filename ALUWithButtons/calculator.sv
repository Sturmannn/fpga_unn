module calculator (
    input  logic        CLOCK_50_B5B,
    input  logic [9:0]  SW,
    input  logic [3:0]  KEY,

    output logic [6:0]  HEX0,
    output logic [6:0]  HEX1,
    output logic [9:0]  LEDR
);

    logic [3:0] reg_A;
    logic [3:0] reg_B;
    logic       reg_IsSub;
    logic [4:0] reg_Result;
    
    logic [3:0] key_prev;
    logic [3:0] key_pressed_tick;

    always_ff @(posedge CLOCK_50_B5B or negedge KEY[3]) begin
        
        if (~KEY[3]) begin
            reg_A      <= 4'b0;
            reg_B      <= 4'b0;
            reg_IsSub  <= 1'b0;
            reg_Result <= 5'b0;
            key_prev   <= 4'b1111;
        end
        else begin
            key_prev <= KEY;

            if (key_pressed_tick[0]) begin
                reg_A <= SW[3:0];
            end
            
            if (key_pressed_tick[1]) begin
                reg_B <= SW[3:0];
            end
            
            if (key_pressed_tick[2]) begin
                reg_IsSub <= ~reg_IsSub;
                
                if (~reg_IsSub) begin
                    reg_Result <= {1'b0, reg_A} + {1'b0, reg_B};
                end else begin
                    reg_Result <= {1'b0, reg_A} - {1'b0, reg_B};
                end
            end
        end
    end
    
    assign key_pressed_tick = key_prev & ~KEY;

    logic [3:0] display_value_low;
    logic [3:0] display_value_high;

    always_comb begin
        display_value_high = 4'b0; 
        if (SW[9]) begin
            if (SW[8]) display_value_low = reg_B;
            else       display_value_low = reg_A;
        end 
        else begin
            display_value_low  = reg_Result[3:0];
            display_value_high = {3'b0, reg_Result[4]};
        end
    end

    always_comb begin
        case (display_value_low)
            4'h0: HEX0 = 7'b1000000;
            4'h1: HEX0 = 7'b1111001;
            4'h2: HEX0 = 7'b0100100;
            4'h3: HEX0 = 7'b0110000;
            4'h4: HEX0 = 7'b0011001;
            4'h5: HEX0 = 7'b0010010;
            4'h6: HEX0 = 7'b0000010;
            4'h7: HEX0 = 7'b1111000;
            4'h8: HEX0 = 7'b0000000;
            4'h9: HEX0 = 7'b0010000;
            4'ha: HEX0 = 7'b0001000;
            4'hb: HEX0 = 7'b0000011;
            4'hc: HEX0 = 7'b1000110;
            4'hd: HEX0 = 7'b0100001;
            4'he: HEX0 = 7'b0000110;
            4'hf: HEX0 = 7'b0001110;
            default: HEX0 = 7'b1111111;
        endcase
    end
    
    always_comb begin
        case (display_value_high)
            4'h1:    HEX1 = 7'b1111001;
            default: HEX1 = 7'b1111111;
        endcase
    end
    
    assign LEDR[3:0]  = reg_A;
    assign LEDR[7:4]  = reg_B;
    assign LEDR[8]    = reg_IsSub;
    assign LEDR[9]    = reg_Result[4];
    
endmodule
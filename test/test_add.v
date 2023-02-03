
module top_unsigned(input [6:0] op0, input [6:0] op1, output [14:0] sum0);
    assign sum0     = op0 + op1;
endmodule

module top_signed(input signed [6:0] op0, input signed [6:0] op1, output signed [14:0] sum0);
    assign sum0     = op0 + op1;
endmodule

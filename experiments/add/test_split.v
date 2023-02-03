`default_nettype none

// Addition: 4 bits maximum

module top_unsigned(input [6:0] op0, input [6:0] op1, output [12:0] sum0);

    wire c_2;
    assign {c_2, sum0[2:0]}     = {1'b0, op0[2:0]} + {1'b0, op1[2:0]};

    wire [3:0]  op1_5_3_c2      = {1'b0, op1[5:3]} + c_2;

    wire c_5;
    assign {c_5,  sum0[5:3]}     = {1'b0, op0[5:3]} + op1_5_3_c2;

    wire [3:0]  op1_6_6_c5      = {3'b0, op1[6:6]} + c_5;
    assign sum0[7:6]            = op0[6:6] + op1_6_6_c5;
    assign sum0[12:8]           = 0;

endmodule

module top_signed(input signed [6:0] op0, input signed [6:0] op1, output signed [12:0] sum0);

    wire [12:0] s_op0     = op0;     // This does sign extension even if target is unsigned.
    wire [12:0] s_op1     = op1;

    // Step 1 
    // No op1_2_0_c-1...

    wire c_2;
    assign {c_2,  sum0[2:0]}     = {1'b0, s_op0[2:0]} + {1'b0, s_op1[2:0]};             // 1

    // Step 2
    wire [3:0]  op1_5_3_c2       = {1'b0, s_op1[5:3]} + c_2;                            // 2

    wire c_5;
    assign {c_5,  sum0[5:3]}     = {1'b0, s_op0[5:3]} + op1_5_3_c2;                     // 3

    // Step 3
    wire [3:0]  op1_8_6_c5       = {1'b0, s_op1[8:6]} + c_5;                            // 4

    wire c_8;
    assign {c_8,  sum0[8:6]}     = {1'b0, s_op0[8:6]} + op1_8_6_c5;                     // 5

    // Step 4
    wire [3:0]  op1_11_9_c8      = {1'b0, s_op1[11:9]} + c_8;                           // 6

    wire c_11;
    assign {c_11, sum0[11:9]}    = {1'b0, s_op0[11:9]} + op1_11_9_c8;                   // 7

    // Step 5
    wire [3:0]  op1_14_12_c11    = {3'b0, s_op1[12]} + c_11;                            // 8

    assign sum0[12]              = s_op0[12] + op1_14_12_c11;                           // 9


endmodule

`ifdef BLAH
module top_signed2(input signed [6:0] op0, input signed [6:0] op1, output signed [12:0] sum0);

    wire [12:0] s_op0     = op0;     // This does sign extension even if target is unsigned.
    wire [12:0] s_op1     = op1;

    wire [3:0] c_2_sum0_2_0;
    assign c_2_sum0_2_0         = {1'b0, s_op0[2:0]} + {1'b0, s_op1[2:0]};              // 1
    assign sum0[2:0]            = c_2_sum0_2_0[2:0];

    wire [3:0]  op1_5_3_c2      = {1'b0, s_op1[5:3]} + c_2_sum0_2_0[3];                 // 2

    wire c_5;
    assign {c_5,  sum0[5:3]}     = {1'b0, s_op0[5:3]} + op1_5_3_c2;                     // 3

    wire [3:0]  op1_7_6_c5      = {1'b0, s_op1[8:6]} + c_5;                             // 4
    assign sum0[8:6]            = { 1'b0, s_op0[8:6]} + op1_7_6_c5;                     // 5

endmodule

module top_signed3(input signed [6:0] op0, input signed [6:0] op1, output signed [12:0] sum0);

    wire [12:0] s_op0     = op0;
    wire [12:0] s_op1     = op1;

    assign sum0[3:0]            = s_op0[3:0] + s_op1[3:0];                          // 1
    wire c_3                    = $unsigned(sum0[3:0]) < $unsigned(s_op0[3:0]);     // 2

    wire [3:0]  op1_7_4_c3      = s_op1[7:4] + c_3;                                 // 3
    //wire c_7a                   = (op1_7_4_c3==0) && c_3;                           
    wire c_7a                   = $unsigned(op1_7_4_c3) < c_3;                      // 4

    assign sum0[7:4]            = s_op0[7:4] + op1_7_4_c3;                          // 5
    wire c_7b                   = $unsigned(sum0[7:4]) < $unsigned(s_op0[7:4]);     // 6

    wire op1_8_8_7a             = s_op1[8] + c_7a;                                  // 7
    wire op1_8_8_7b             = op1_8_8_7a + c_7b;                                // 8
    assign sum0[8]              = s_op0[8] + op1_8_8_7b;                            // 9

endmodule

module tb(output signed [12:0] sum0);
    top_signed3 u_dut(.op0(2), .op1(5), .sum0(sum0));
endmodule
`endif




`ifndef ADD_MAXWIDTH
$fatal(1, "Macro ADD_MAXWIDTH must be defined");
`endif

`define MAX(a,b) (a > b ? a : b)
`define MIN(a,b) (a < b ? a : b)

(* techmap_celltype = "$add"*)
module add_split (A, B, Y);
    parameter A_SIGNED = 0;
    parameter B_SIGNED = 0;
    parameter A_WIDTH = 1;
    parameter B_WIDTH = 1;
    parameter Y_WIDTH = 1;

    (* force_downto *)
    input [A_WIDTH-1:0] A;
    (* force_downto *)
    input [B_WIDTH-1:0] B;
    (* force_downto *)
    output [Y_WIDTH-1:0] Y;

    parameter _TECHMAP_CELLTYPE_ = "";

    localparam IS_SIGNED        = A_SIGNED && B_SIGNED;

    generate
    if (Y_WIDTH <= `ADD_MAXWIDTH) begin
        // Adder is already the right size.
        wire _TECHMAP_FAIL_ = 1;
    end
    else if (A_WIDTH < B_WIDTH) begin
        \$add #(
            .A_SIGNED(B_SIGNED),
            .B_SIGNED(A_SIGNED),
            .A_WIDTH(B_WIDTH),
            .B_WIDTH(A_WIDTH),
            .Y_WIDTH(Y_WIDTH)
        ) $add (
            .A(B),
            .B(A),
            .Y(Y)
        );
    end
    else begin
		// FIXME: optimize for cases where A_WIDTH != B_WIDTH.
        localparam max_width = ((Y_WIDTH+(`ADD_MAXWIDTH-1)-1)/(`ADD_MAXWIDTH-1))*(`ADD_MAXWIDTH-1);
    
        wire [max_width-1:0]	s_op0; 
        wire [max_width-1:0]    s_op1;
        wire [max_width-1:0]    sum;
        
        generate if (IS_SIGNED) begin
           assign s_op0     = $signed(A);
           assign s_op1     = $signed(B);
        end
        else begin
           assign s_op0     = A;
           assign s_op1     = B;
        end
        endgenerate
    
        reg c;
        reg [`ADD_MAXWIDTH-1:0]	s_op1_plus_c;
    
        always begin : blk
            integer lsb;
            for(lsb=0; lsb < Y_WIDTH; lsb = lsb + `ADD_MAXWIDTH -1) begin
            if (lsb==0) begin
                s_op1_plus_c     = {1'b0, s_op1[`ADD_MAXWIDTH-2+lsb:lsb] };
            end
            else begin
                s_op1_plus_c     = {1'b0, s_op1[`ADD_MAXWIDTH-2+lsb:lsb] } + c;
            end
    
            {c, sum[`ADD_MAXWIDTH-2+lsb:lsb] } = { 1'b0, s_op0[`ADD_MAXWIDTH-2+lsb:lsb] } + s_op1_plus_c;
            end
    
            Y = sum[Y_WIDTH-1:0];
        end
    end
    endgenerate

endmodule



module relayer_unit(
    input wire [15:0] instr1,
    input wire [15:0]instr2,
    output wire [15:0]instr1_out,
    output wire [15:0]instr2_out,
    output wire issingleinstr
);
    // reg [15:0] instructions1 [0:10];
    // reg [15:0] instructions2 [0:10];
    // reg [15:0] instr1_reg;
    // reg [15:0] instr2_reg;
    // integer i=0;
    // integer j=0;
    // always(@*) begin
    //     if ((instr1[10:8] != instr2[10:8])&&(instr1[10:8]!=instr2[7:5])&&(instr2[11]==0&&instr1[10:8]!=instr2[4:2])) begin
    //         if((instr2[10:8]!=instr1[7:5])&&(instr1[11]==0&&instr2[10:8]!=instr1[4:2])) begin
    //             instructions1[i] = instr1;
    //             instructions2[j] = instr2;
    //             i = i+1;
    //             j = j+1;
    //         end     
    //         else begin
                
    //         end
    //     end
    //     else begin
    //         instr1_out <= instr1_reg;
    //         instr2_out <= instr2_reg;
    //     end
    //     instr1_reg <= instr1;
    //     instr2_reg <= instr2;
    // end
    reg [15:0] buffer1 [0:2];    
    reg [15:0] buffer2 [0:2];
    reg [15:0] instr1_reg;
    reg [15:0] instr2_reg;
    

endmodule 
`include "fetch/fetch_unit.v"
`include "decode/decode_unit.v"
`include "execute/execute_unit.v"
`include "memory/memory_unit.v"
`include "writeback/writeback_unit.v"
`include "fetch/relayer.v"
`include "execute/alu.v"
`include "decode/control_unit.v"

module top_module();
    // pipeline 1
    wire clk;
    wire reset;
    wire stall;
    wire is_branch_taken;
    wire [15:0] branch_target;
    wire issingleinstr;
    wire [15:0] instr1fetchrelayer;
    wire [15:0] instr2fetchrelayer;
    //fetch unit
    fetch_unit fetch_unit_1(
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .branch_target(branch_target),
        .issingleinstr(issingleinstr),
        .instr1(instr1fetchrelayer),
        .instr2(instr2fetchrelayer)
    );
    wire [15:0] instr1final;
    wire [15:0] instr2final;
    //relayer
    relayer relayer_1(
        .instr1_in(instr1fetchrelayer),
        .instr2_in(instr2fetchrelayer),
        .instr1_o(instr1final),
        .instr2_o(),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .branch_target(branch_target),
        .issingleinstr(issingleinstr)
    );


    // pipeline 2
    
endmodule
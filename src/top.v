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
    wire [15:0] instr1;
    wire [15:0] instr2;
    //fetch unit
    fetch_unit fetch_unit_1(
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .branch_target(branch_target),
        .issingleinstr(issingleinstr),
        .instr1(instr1),
        .instr2(instr2)
    );


    // pipeline 2
    
endmodule
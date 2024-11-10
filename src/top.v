// `include "fetch/fetch_unit.v"
// `include "decode/decode_unit.v"
// `include "execute/execute_unit.v"
// `include "memory/memory_unit.v"
// `include "writeback/writeback_unit.v"
// `include "fetch/relayer.v"
// `include "execute/alu.v"
// `include "decode/control_unit.v"

module top_module();
    reg clk_reg;
    initial begin
        clk_reg = 0;
        forever begin
            #5 clk_reg = ~clk_reg;
        end
    end
    wire clk;
    assign clk=clk_reg;
    wire reset;
    wire is_branch_taken;
    wire issingleinstr;
    wire stall;
    wire [15:0] instr1fetchrelayer;
    wire [15:0] instr2fetchrelayer;
    assign is_branch_taken = (is_branch_taken1 | is_branch_taken2);
    //fetch unit
    reg [15:0] branchpc_reg;
    reg [15:0] branchtarget1_reg;
    reg [15:0] branchtarget2_reg;
    always@(*) begin
        branchtarget1_reg = branch_target1;
        branchtarget2_reg = branch_target2;
        if(branchtarget1_reg) begin
            branchpc_reg = branchpc1;
        end
        else if (branchtarget2_reg) begin
            branchpc_reg = branchpc2;
        end
        else begin
            branchpc_reg = 16'h0;
        end
    end
    wire [15:0] branchpc;
    wire [15:0] branchpc2;
    assign branchpc = branchpc_reg;
    fetch_unit fetch_unit(
        .clk(clk),
        .reset(reset),
        .stall(isstall),
        .is_branch_taken(is_branch_taken),
        .branch_target(branchpc),
        .issingleinstr(issingleinstr),
        .instr1(instr1fetchrelayer),
        .instr2(instr2fetchrelayer)
    );
    wire [15:0] instr1relayerdecode;
    wire [15:0] instr2relayerdecode;
    wire isstall;
    //relayer
    relayer_unit relayer_unit(
        .instr1_in(instr1fetchrelayer),
        .instr2_in(instr2fetchrelayer),
        .instr1_o(instr1relayerdecode),
        .instr2_o(instr2relayerdecode),
        .isstall(isstall),
        .issingleinstr(issingleinstr)
    );
    
    // pipeline 1
    wire [15:0] instr1decodeexecute1;
    wire [15:0] instr2decodeexecute1;
    wire [19:0] rdvalmem1;
    wire [19:0] rdvalmem2;
    wire [4:0] imm1;
    wire [3:0] opcode1;
    wire [15:0] branch_target1;
    wire [15:0] op11;
    wire [15:0] op21;
    wire [15:0] instrdecodeexecute1;
    wire immflag1;
    wire [15:0] instrdecodealu1;
// module decode_unit (
//     input wire clk,
//     input wire reset,
//     input wire stall,                               // Stall signal
//     input wire is_branch_taken,                     // Branch taken signal
//     input wire [15:0] instr,                        // 16-bit instruction
//     input wire [19:0] rdvalmem1,
//     input wire [19:0] rdvalmem2,
//     output wire [4:0] imm,                          // 5-bit immediate value
//     output wire [3:0] opcode,                       // 4-bit Opcode
//     output wire [15:0] branch_target,               // Calculated branch target
//     output wire [15:0] op1, op2,                    // Operand values
//     // output wire[15:0 ] instrout,
//     output wire imm_flag                            // Immediate flag
// );
    //decode unit
    decode_unit decode_unit1(
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .instr(instr1relayerdecode),
        .rdvalmem1(rdvalmem1),
        .rdvalmem2(rdvalmem2),
        .imm(imm1),
        .opcode(opcode1),
        .branch_target(branch_target1),
        .op1(op11),
        .op2(op21),
        .instrout(instrdecodealu1),
        .imm_flag(immflag1)
    );
    // control unit

    // input wire clk,
    // input wire reset,
    // input wire stall,
    // input wire [3:0] opcode,  // 4-bit opcode from decode unit
    // output wire isadd,
    // output wire issub,
    // output wire ismul,
    // output wire isld,
    // output wire isst,
    // output wire iscmp,
    // output wire ismov,
    // output wire isor,
    // output wire isand,
    // output wire isnot,
    // output wire islsl,
    // output wire islsr,
    // output wire isbeq,
    // output wire isbgt,
    // output wire iswb,
    // output wire isubranch
    wire isadd1;
    wire issub1;
    wire ismul1;
    wire isld1;
    wire isst1;
    wire iscmp1;
    wire ismov1;
    wire isor1;
    wire isand1;
    wire isnot1;
    wire islsl1;
    wire islsr1;
    wire isbeq1;
    wire isbgt1;
    wire iswb1;
    wire isubranch1;

    control_unit control_unit1(
        .clk(clk),
        .reset(reset),
        .is_branch_taken(is_branch_taken),
        .stall(stall),
        .opcode(opcode1),
        .isadd(isadd1),
        .issub(issub1),
        .ismul(ismul1),
        .isld(isld1),
        .isst(isst1),
        .iscmp(iscmp1),
        .ismov(ismov1),
        .isor(isor1),
        .isand(isand1),
        .isnot(isnot1),
        .islsl(islsl1),
        .islsr(islsr1),
        .isbeq(isbeq1),
        .isbgt(isbgt1),
        .iswb(iswb1),
        .isubranch(isubranch1)
    );

    //exec

    // input wire [15:0] brachtarget,
    // input wire isunconditionalbranch,
    // input wire isBeq,
    // input wire isBgt,
    // input wire [127:0] regval,
    // output wire [15:0] branchpc,
    // output wire isbranchtaken
    wire [15:0] branchpc1;
    reg [127:0] regval;
    always@(posedge clk) begin
        if(reset) begin
            regval <= 128'h0;
        end
        else begin
            $readmemh("registers.hex", regval);
        end
    end
    execute_unit execute_unit1(
        .clk(clk),
        .brachtarget(branch_target1),
        .reset(reset),
        .isunconditionalbranch(isubranch1),
        .isBeq(isbeq1),
        .isBgt(isbgt1),
        .regval(regval),
        .branchpc(branchpc1),
        .isbranchtaken(is_branch_taken1)
    );
    //alu

    // input wire clk,
    // input wire [11:0] alusignals,
    // input wire [15:0] instrin,
    // /*
    //     isadd
    //     isld
    //     isst
    //     issub
    //     ismul
    //     iscmp
    //     ismov
    //     isor
    //     isand
    //     isnot
    //     islsl
    //     islsr
    // */  
    // input wire [15:0] op1,
    // input wire [15:0] op2,
    // input wire [4:0] immx,
    // input wire isimmediate,
    // output wire [15:0] aluresult,
    // output wire [15:0] instrout
    wire [15:0] instralumem1;
    alu alu1(
        .clk(clk),
        .reset(reset),
        .is_branch_takenin(1'b0),  // if is_branch_takenin is 1 then flush the pipeline
        .alusignals({isadd1, isld1, isst1, issub1, ismul1, iscmp1, ismov1, isor1, isand1, isnot1, islsl1, islsr1}),
        .instrin(instrdecodealu1),
        .op1(op11),
        .op2(op21),
        .immx(imm1),
        .isimmediate(imm_flag1),
        .aluresult(aluresult1),
        .instrout(instralumem1)
    );
    //memory 

    // input wire clk,
    // input wire isld,
    // input wire isst,
    // input wire [15:0] instr,
    // input wire [15:0] op2,
    // input wire [15:0] aluresult,
    // output wire [15:0] ldresult,
    // output wire [19:0] rdvalmem
    wire [15:0] ldresult1;
    wire [15:0] aluresult1;
    memory_unit memory_unit1(
        .clk(clk),
        .reset(reset),
        .isld(isld1),
        .isst(isst1),
        .instr(instralumem1),
        .op2(op21),
        .aluresult(aluresult1),
        .ldresult(ldresult1),
        .rdvalmem(rdvalmem1)
    );
    //writeback
    writeback_unit writeback_unit1(
        .clk(clk),
        .iswb(iswb1),
        .isld(isld1),
        .rd(rdvalmem1[2:0]),
        .ldresult(ldresult1),
        .aluresult(aluresult1)
    );

    // pipeline 2
    // decode 2
    wire [4:0] imm2;
    wire [3:0] opcode2;
    wire [15:0] branch_target2;
    wire [15:0] op12;
    wire [15:0] op22;
    wire [15:0] instrdecodealu2;
    wire imm_flag2;
    decode_unit decode_unit2(
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .instr(instr2relayerdecode),
        .rdvalmem1(rdvalmem1),
        .rdvalmem2(rdvalmem2),
        .imm(imm2),
        .opcode(opcode2),
        .branch_target(branch_target2),
        .op1(op12),
        .op2(op22),
        .instrout(instrdecodealu2),
        .imm_flag(imm_flag2)
    );
    //control unit 
    control_unit control_unit2(
        .clk(clk),
        .reset(reset),
        .is_branch_taken(is_branch_taken),
        .stall(stall),
        .opcode(opcode2),
        .isadd(isadd2),
        .issub(issub2),
        .ismul(ismul2),
        .isld(isld2),
        .isst(isst2),
        .iscmp(iscmp2),
        .ismov(ismov2),
        .isor(isor2),
        .isand(isand2),
        .isnot(isnot2),
        .islsl(islsl2),
        .islsr(islsr2),
        .isbeq(isbeq2),
        .isbgt(isbgt2),
        .iswb(iswb2),
        .isubranch(isubranch2)
    );
    //execute
    execute_unit execute2(
        .clk(clk),
        .brachtarget(branch_target2),
        .reset(reset),
        .isunconditionalbranch(isubranch2),
        .isBeq(isbeq2),
        .isBgt(isbgt2),
        .regval(regval),
        .branchpc(branchpc2),
        .isbranchtaken(is_branch_taken2)
    )  ;  
    //alu
    wire [15:0] aluresult2;
    wire [15:0] ldresult2;
    wire [15:0] instralumem2;
    alu alu2(
        .clk(clk),
        .reset(reset),
        .is_branch_takenin(is_branch_taken1),  // if is_branch_takenin is 1 then flush the pipeline
        .alusignals({isadd2, isld2, isst2, issub2, ismul2, iscmp2, ismov2, isor2, isand2, isnot2, islsl2, islsr2}),
        .instrin(instrdecodealu2),
        .op1(op12),
        .op2(op22),
        .immx(imm2),
        .isimmediate(imm_flag2),
        .aluresult(aluresult2),
        .instrout(instralumem2)
    );
    //memory
    memory_unit memory_unit2(
        .clk(clk),
        .reset(reset),
        .isld(isld2),
        .isst(isst2),
        .instr(instralumem2),
        .op2(op22),
        .aluresult(aluresult2),
        .ldresult(ldresult2),
        .rdvalmem(rdvalmem2)
    );
    //writeback
    writeback_unit writeback_unit2(
        .clk(clk),
        .iswb(iswb2),
        .isld(isld2),
        .rd(rdvalmem2[2:0]),
        .ldresult(ldresult2),
        .aluresult(aluresult2)
    );
endmodule
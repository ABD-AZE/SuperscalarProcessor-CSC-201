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
    reg reset_reg;
    initial begin
        clk_reg = 0;
        reset_reg = 1;
        #10  reset_reg = 0;
        forever begin
            #5 clk_reg = ~clk_reg;
        end
    end
    wire clk;
    assign clk=clk_reg;
    wire reset;
    assign reset=reset_reg;
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
        .instr(instr1relayerdecode),
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

    
    wire [15:0] branchpc1;
    reg [15:0] regmem[0:7];
    reg [127:0] regval;
    integer i;
    always@(posedge clk) begin
        if(reset) begin
            regval <= 128'h0;
        end
        else begin
            $readmemh("registers.hex", regmem);
        end
        regval = {regmem[7], regmem[6], regmem[5], regmem[4], regmem[3], regmem[2], regmem[1], regmem[0]};
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
    wire isldalu1,isstalu1,iswbalu1;
    wire [15:0] op21alu1; 
    wire [15:0] instralumem1;
    alu alu1(
        .clk(clk),
        .reset(reset),
        .is_branch_takenin(1'b0),  
        .alusignals({islsr1, islsl1, isnot1, isand1, isor1, ismov1, iscmp1, ismul1, issub1, isst1, isld1, isadd1}),
        .instrin(instrdecodealu1),
        .op1(op11),
        .op2(op21),
        .immx(imm1),
        .isimmediate(immflag1),
        .iswb(iswb1),
        .aluresult(aluresult1),
        .isld1(isldalu1),
        .isst1(isstalu1),
        .op2_out(op21alu1),
        .iswb_out(iswbalu1),
        .instrout(instralumem1)
    );
    //memory 

    wire [15:0] ldresult1;
    wire [15:0] aluresult1;
    wire [15:0] aluresultmem1,instrmemwb1;
    wire isldmem1,iswbmem1;
    memory_unit memory_unit1(
        .clk(clk),
        .reset(reset),
        .isld(isldalu1),
        .isst(isstalu1),
        .iswb(iswbalu1),
        .instr(instralumem1),
        .op2(op21alu1),
        .aluresult(aluresult1),
        .ldresult(ldresult1),
        .rdvalmem(rdvalmem1),
        .aluresult_out(aluresultmem1),
        .isld_out(isldmem1),
        .iswb_out(iswbmem1),
        .instr_out(instrmemwb1)
    );
    //writeback
    wire [15:0] aluresultwb,instrwb,ldresultwb;
    wire isldwb,iswbwb;
    writeback_unit1 writeback_unit1(
        .clk(clk),
        .iswb(iswbmem1),
        .isld(isldmem1),
        .instr(instrmemwb1),
        .ldresult(ldresult1),
        .aluresult(aluresultmem1),
        .iswbin2(iswbmem2),
        .isldmem2(isldmem2),
        .instrmemwb2(instrmemwb2),
        .ldresult2(ldresult2),
        .aluresultmem2(aluresultmem2),
        .iswbwb(iswbwb),
        .isldwb(isldwb),
        .instrwb(instrwb),
        .ldresultwb(ldresultwb),
        .aluresultwb(aluresultwb),
        .regvalwb(regvalwb)
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
        .instr(instr2relayerdecode),
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
    wire isldalu2,isstalu2,iswbalu2;
    wire [15:0] op22alu2; 
    alu alu2(
        .clk(clk),
        .reset(reset),
        .is_branch_takenin(1'b0),  
        .alusignals({islsr2, islsl2, isnot2, isand2, isor2, ismov2, iscmp2, ismul2, issub2, isst2, isld2, isadd2}),
        .instrin(instrdecodealu2),
        .op1(op12),
        .op2(op22),
        .immx(imm2),
        .isimmediate(imm_flag2),
        .iswb(iswb2),
        .aluresult(aluresult2),
        .isld1(isldalu2),
        .isst1(isstalu2),
        .op2_out(op22alu2),
        .iswb_out(iswbalu2),
        .instrout(instralumem2)
    );
    //memory
    wire [15:0] aluresultmem2,instrmemwb2;
    wire isldmem2,iswbmem2;
    memory_unit memory_unit2(
        .clk(clk),
        .reset(reset),
        .isld(isldalu2),
        .isst(isstalu2),
        .iswb(iswbalu2),
        .instr(instralumem2),
        .op2(op22alu2),
        .aluresult(aluresult2),
        .ldresult(ldresult2),
        .rdvalmem(rdvalmem2),
        .aluresult_out(aluresultmem2),
        .isld_out(isldmem2),
        .iswb_out(iswbmem2),
        .instr_out(instrmemwb2)
    );
    //writeback
    wire [127:0] regvalwb;
    writeback_unit2 writeback_unit2(
        .clk(clk),
        .iswb(iswbwb),
        .isld(isldwb),
        .instr(instrwb),
        .ldresult(ldresultwb),
        .aluresult(aluresultwb),
        .regvalwb(regvalwb)
    );
endmodule

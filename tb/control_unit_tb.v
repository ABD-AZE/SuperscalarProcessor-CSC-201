module control_unit_tb;
    // Inputs to the control unit
    reg clk;
    reg reset;
    reg stall;
    reg [15:0] instr;
    reg is_branch_taken;

    // Outputs from the control unit
    wire isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, iswb, isubranch;

    // Instantiate the control unit
    control_unit uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .instr(instr),
        .is_branch_taken(is_branch_taken),
        .isadd(isadd),
        .issub(issub),
        .ismul(ismul),
        .isld(isld),
        .isst(isst),
        .iscmp(iscmp),
        .ismov(ismov),
        .isor(isor),
        .isand(isand),
        .isnot(isnot),
        .islsl(islsl),
        .islsr(islsr),
        .isbeq(isbeq),
        .isbgt(isbgt),
        .iswb(iswb),
        .isubranch(isubranch)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        $dumpfile("control_unit.vcd");
        $dumpvars(0, control_unit_tb);
        reset = 1;
        stall = 0;
        instr = 16'b0;
        is_branch_taken = 0;

        // Apply reset
        #10;
        reset = 0;
        #5;
        // Test ADD instruction
        instr = 16'b0001_0000_0000_0000; // ADD opcode
        #10;
        $display("ADD: isadd=%b, iswb=%b", isadd, iswb);

        // Test SUB instruction
        instr = 16'b0010_0000_0000_0000; // SUB opcode
        #10;
        $display("SUB: issub=%b, iswb=%b", issub, iswb);

        // Test LD instruction
        instr = 16'b0100_0000_0000_0000; // LD opcode
        #10;
        $display("LD: isld=%b, iswb=%b", isld, iswb);

        // Test BEQ instruction
        instr = 16'b1110_0000_0000_0000; // BEQ opcode
        #10;
        $display("BEQ: isbeq=%b, iswb=%b", isbeq, iswb);

        // Test unconditional branch with branch taken
        instr = 16'b1100_0000_0000_0000; // UBRANCH opcode
        is_branch_taken = 1;
        #10;
        $display("UBRANCH (branch taken): isubranch=%b", isubranch);
        is_branch_taken = 0;

        // Test stall condition
        // stall = 1;
        // instr = 16'b1110_0000_0000_0000; // UBRANCH opcode

        // #10;
        // $display("STALL: Outputs should be zero: isadd=%b, issub=%b, iswb=%b", isadd, issub, iswb);
        // stall = 0;

        // Test NOT instruction after stall
        instr = 16'b1010_0000_0000_0000; // NOT opcode
        #10;
        $display("NOT: isnot=%b, iswb=%b", isnot, iswb);

        // Test reset again
        reset = 1;
        #10;
        reset = 0;
        $display("After Reset: Outputs should be zero: isadd=%b, issub=%b, iswb=%b", isadd, issub, iswb);

        // Finish simulation
        #20;
        $stop;
    end
endmodule

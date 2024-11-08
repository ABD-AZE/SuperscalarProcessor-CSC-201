module tb_control_unit;
    // Testbench signals
    reg clk;
    reg reset;
    reg stall;
    reg [3:0] opcode;   // 4-bit opcode input
    wire isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, iswb, isubranch;

    // Instantiate the control unit
    control_unit uut (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .opcode(opcode),
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
        .isxor(isxor),
        .isbeq(isbeq),
        .isbgt(isbgt),
        .iswb(iswb),
        .isubranch(isubranch)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10 time unit clock period

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        stall = 0;
        opcode = 4'b0000;  // Default opcode (ADD)

        // Apply reset
        reset = 1; #10;
        reset = 0; #10;

        // Test ADD opcode
        opcode = 4'b0000;  // ADD
        #10;
        $display("---- ADD TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test SUB opcode
        opcode = 4'b0001;  // SUB
        #10;
        $display("---- SUB TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test MUL opcode
        opcode = 4'b0010;  // MUL
        #10;
        $display("---- MUL TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test AND opcode
        opcode = 4'b1000;  // AND
        #10;
        $display("---- AND TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test OR opcode
        opcode = 4'b0111;  // OR
        #10;
        $display("---- OR TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test NOT opcode
        opcode = 4'b1001;  // NOT
        #10;
        $display("---- NOT TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test MOV opcode
        opcode = 4'b0110;  // MOV
        #10;
        $display("---- MOV TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test LD opcode
        opcode = 4'b0011;  // LD
        #10;
        $display("---- LD TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test LSL opcode
        opcode = 4'b1010;  // LSL
        #10;
        $display("---- LSL TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test LSR opcode
        opcode = 4'b1011;  // LSR
        #10;
        $display("---- LSR TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test ST opcode
        opcode = 4'b0100;  // ST (no writeback)
        #10;
        $display("---- ST TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test CMP opcode
        opcode = 4'b0101;  // CMP (no writeback)
        #10;
        $display("---- CMP TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test BEQ opcode
        opcode = 4'b1101;  // BEQ (no writeback)
        #10;
        $display("---- BEQ TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test BGT opcode
        opcode = 4'b1110;  // BGT (no writeback)
        #10;
        $display("---- BGT TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // Test UBRANCH opcode
        opcode = 4'b1100;  // UBRANCH (no writeback)
        #10;
        $display("---- UBRANCH TEST ----");
        $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isxor: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                  iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isxor, isbeq, isbgt, isubranch);

        // End the simulation
        $finish;
    end
endmodule

module tb_control_unit;
    // Testbench signals
    reg clk;
    reg reset;
    reg stall;
    reg [3:0] opcode;   // 4-bit opcode input
    wire isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, iswb, isubranch;

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
        .isbeq(isbeq),
        .isbgt(isbgt),
        .iswb(iswb),
        .isubranch(isubranch)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;  // 10 ns clock period
    end

    // Test sequence
    initial begin
        $dumpfile("control_unit.vcd");
        $dumpvars(0, tb_control_unit);  // Initialize signals
        clk = 0;
        reset = 0;
        stall = 0;
        opcode = 4'b0000;  // Default opcode (ADD)

        // Apply reset
        #5 reset = 1;
        #10 reset = 0;

        // Run test tasks
        test_add;
        #10 test_sub;
        #10 test_mul;
        #10 test_ld;
        #10 test_st;
        #10 test_cmp;
        #10 test_mov;
        #10 test_or;
        #10 test_and;
        #10 test_not;
        #10 test_lsl;
        #10 test_lsr;
        #10 test_stall;
        #10 test_beq;
        #10 test_bgt;
        #10 test_ubranch;
        #160 $finish;
    end

    // Test Case 1: ADD opcode
    task test_add;
        begin
            opcode = 4'b0001;  // ADD
            @(posedge clk); // Wait for a clock edge to capture output
            $display("---- ADD TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 2: SUB opcode
    task test_sub;
        begin
            opcode = 4'b0010;  // SUB
            @(posedge clk);
            $display("---- SUB TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 3: MUL opcode
    task test_mul;
        begin
            opcode = 4'b0011;  // MUL
            @(posedge clk);
            $display("---- MUL TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 4: LD opcode
    task test_ld;
        begin
            opcode = 4'b0100;  // LD
            @(posedge clk);
            $display("---- LD TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 5: ST opcode
    task test_st;
        begin
            opcode = 4'b0101;  // ST
            @(posedge clk);
            $display("---- ST TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 6: CMP opcode
    task test_cmp;
        begin
            opcode = 4'b0110;  // CMP
            @(posedge clk);
            $display("---- CMP TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 7: MOV opcode
    task test_mov;
        begin
            opcode = 4'b0111;  // MOV
            @(posedge clk);
            $display("---- MOV TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 8: OR opcode
    task test_or;
        begin
            opcode = 4'b1000;  // OR
            @(posedge clk);
            $display("---- OR TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 9: AND opcode
    task test_and;
        begin
            opcode = 4'b1001;  // AND
            @(posedge clk);
            $display("---- AND TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 10: NOT opcode
    task test_not;
        begin
            opcode = 4'b1010;  // NOT
            @(posedge clk);
            $display("---- NOT TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 11: LSL opcode
    task test_lsl;
        begin
            opcode = 4'b1011;  // LSL
            @(posedge clk);
            $display("---- LSL TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 12: LSR opcode
    task test_lsr;
        begin
            opcode = 4'b1101;  // LSR
            @(posedge clk);
            $display("---- LSR TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 13: BEQ opcode
    task test_beq;
        begin
            opcode = 4'b1110;  // BEQ
            @(posedge clk);
            $display("---- BEQ TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 14: BGT opcode
    task test_bgt;
        begin
            opcode = 4'b1111;  // BGT
            @(posedge clk);
            $display("---- BGT TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    // Test Case 16: UBranch opcode
    task test_ubranch;
        begin
            opcode = 4'b1100;  // UBranch (could share the opcode with WB if needed)
            @(posedge clk);
            $display("---- UBranch TEST ----");
            $display("iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
        end
    endtask

    task test_stall;
        begin
            // Test with stall signal active
            // opcode = 4'b0001;  // ADD (or any opcode for testing)
            stall = 1;         // Set the stall signal
            @(posedge clk);    // Wait for a clock edge
            $display("---- STALL TEST ----");
            $display("stall: %b, iswb: %b, isadd: %b, issub: %b, ismul: %b, isld: %b, isst: %b, iscmp: %b, ismov: %b, isor: %b, isand: %b, isnot: %b, islsl: %b, islsr: %b, isbeq: %b, isbgt: %b, isubranch: %b", 
                     stall, iswb, isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr, isbeq, isbgt, isubranch);
            stall = 0;
        end
    endtask

endmodule

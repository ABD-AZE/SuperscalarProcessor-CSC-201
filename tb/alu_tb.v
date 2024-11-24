`timescale 1ns / 1ps

module alu_tb;

    // Inputs
    reg reset;
    reg clk;
    reg [11:0] alusignals;
    reg [15:0] instrin;
    reg [15:0] op1;
    reg [15:0] op2;
    reg [4:0] immx;
    reg iswb;
    reg isimmediate;
    reg is_branch_takenin;

    // Outputs
    wire [15:0] aluresult;
    wire [15:0] instrout;
    wire isld1;
    wire isst1;
    wire [15:0] op2_out;
    wire iswb_out;

    // Instantiate the ALU module
    alu uut (
        .reset(reset),
        .clk(clk),
        .alusignals(alusignals),
        .instrin(instrin),
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .iswb(iswb),
        .isimmediate(isimmediate),
        .is_branch_takenin(is_branch_takenin),
        .aluresult(aluresult),
        .instrout(instrout),
        .isld1(isld1),
        .isst1(isst1),
        .op2_out(op2_out),
        .iswb_out(iswb_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Testbench
    initial begin
        // Initialize inputs
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);
        reset = 1;
        alusignals = 0;
        instrin = 0;
        op1 = 0;
        op2 = 0;
        immx = 0;
        iswb = 0;
        isimmediate = 0;
        is_branch_takenin = 0;

        // Apply reset
        #10;
        reset = 0;
        #5;

        // Test ADD operation
        alusignals = 12'b000000000001; // ADD signal
        instrin=16'h1;
        op1 = 16'd10;
        op2 = 16'd20;
        #10;
        $display("ADD: Result = %d (Expected: 30)", aluresult);

        // Test SUB operation
        instrin=16'h2;
        alusignals = 12'b000000000010; // load signal
        op1 = 16'd8;
        op2 = 16'd7;
        #10;
        $display("SUB: Result = %d (Expected: 10)", aluresult);

        // Test AND operation
        alusignals = 12'b000000010000; // MUL signal
        op1 = 16'b10101010;
        op2 = 16'b11110000;
        #10;
        $display("AND: Result = %b (Expected: 10100000)", aluresult);

        // Test OR operation
        alusignals = 12'b000000100000; // COMP signal
        op1 = 16'b10101010;
        op2 = 16'b01010101;
        #10;
        $display("OR: Result = %b (Expected: 11111111)", aluresult);

        // Test MUL operation
        alusignals = 12'b000001000000; // MOV signal
        op1 = 16'd5;
        op2 = 16'd3;
        #10;
        $display("MUL: Result = %d (Expected: 15)", aluresult);

        // Test Immediate addition
        alusignals = 12'b000000000001; // ADD signal
        op1 = 16'd10;
        immx = 5'd5;
        isimmediate = 1;
        #10;
        $display("ADD Immediate: Result = %d (Expected: 15)", aluresult);

        // Test NOT operation
        alusignals = 12'b001000000000; // NOT signal
        op1 = 16'b1111000011110000;
        #10;
        $display("NOT: Result = %b (Expected: 0000111100001111)", aluresult);

        // Test LSL (Shift Left) operation
        alusignals = 12'b010000000000; // LSL signal
        op1 = 16'b0000000000001111;
        op2 = 16'd4; // Shift by 4
        #10;
        $display("LSL: Result = %b (Expected: 11110000)", aluresult);

        // Test LSR (Shift Right) operation
        alusignals = 12'b100000000000; // LSR signal
        op1 = 16'b1111000000000000;
        op2 = 16'd4; // Shift by 4
        #10;
        $display("LSR: Result = %b (Expected: 0000111100000000)", aluresult);

        // Test branch taken reset
        is_branch_takenin = 1;
        #10;
        is_branch_takenin = 0;
        $display("Branch Taken Reset: Result = %d (Expected: 0)", aluresult);

        // End simulation
        #20;
        $finish;
    end

endmodule

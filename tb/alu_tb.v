`timescale 1ns / 1ps

module alu_tb();
    // Inputs
    reg clk;
    reg [11:0] alusignals;
    reg [15:0] op1;
    reg [15:0] op2;
    reg [4:0] immx;
    reg isimmediate;

    // Output
    wire [15:0] aluresult;

    // Instantiate the ALU module
    alu uut (
        .clk(clk),
        .alusignals(alusignals),
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .isimmediate(isimmediate),
        .aluresult(aluresult)
    );

    // Clock generation
    initial begin
        clk = 1;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test procedure
    initial begin
        $dumpfile("alu_unit.vcd");
        $dumpvars(0,alu_tb);
        // Initialize inputs
        op1 = 16'h0005;    // Operand 1
        op2 = 16'h0003;    // Operand 2
        immx = 5'b00011;   // Immediate value
        isimmediate = 0;
        alusignals = 12'b000000000000; // Clear ALU signals
        #10;

        // Test ADD operation
        alusignals = 12'b000000000001; // isadd
        #10;
        $display("ADD: Result = %h", aluresult);

        // Test LOAD operation
        alusignals = 12'b000000000010; // isld
        #10;
        $display("LOAD: Result = %h", aluresult);

        // Test STORE operation
        alusignals = 12'b0000000000100; // isst
        #10;
        $display("STORE: Result = %h", aluresult);
        
        // Test SUB operation
        alusignals = 12'b000000001000; // issub
        #10;
        $display("SUB: Result = %h", aluresult);

        // Test MUL operation
        alusignals = 12'b000000010000; // ismul
        #10;
        $display("MUL: Result = %h", aluresult);

        // Test CMP operation
        alusignals = 12'b000000100000; // iscmp
        #10;
        $display("CMP: Result = %h", aluresult);
        
        // Test MOV operation
        alusignals = 12'b000001000000; // ismov
        #10;
        $display("MOV (immediate): Result = %h", aluresult);

        // Test OR operation
        alusignals = 12'b000010000000; // isor
        #10;
        $display("OR: Result = %h", aluresult);

        // Test AND operation
        alusignals = 12'b000100000000; // isand
        #10;
        $display("AND: Result = %h", aluresult);

        // Test NOT operation
        alusignals = 12'b001000000000; // isnot
        #10;
        $display("NOT: Result = %h", aluresult);

        // Test LSL operation
        alusignals = 12'b010000000000; // islsl
        #10;
        $display("LSL: Result = %h", aluresult);

        // Test LSR operation
        alusignals = 12'b100000000000; // islsr
        #10;
        $display("LSR: Result = %h", aluresult);
        


        // End of test
        $finish;
    end
endmodule

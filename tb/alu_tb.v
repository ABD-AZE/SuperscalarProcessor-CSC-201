
module alu_tb;

    reg clk;
    reg [11:0] alusignals;
    reg [15:0] op1;
    reg [15:0] op2;
    reg [4:0] immx;
    reg [15:0] instr;
    reg isimmediate;
    wire [15:0] aluresult;
    wire [18:0] rdval;

    // Instantiate the ALU module
    alu uut (
        .clk(clk),
        .alusignals(alusignals),
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .instr(instr),
        .isimmediate(isimmediate),
        .aluresult(aluresult),
        .rdval(rdval)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns clock period
    end

    // Test initialization
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
        $monitor("Time = %0d, op1 = %h, op2 = %h, immx = %h, aluresult = %h, rdval = %h", 
                  $time, op1, op2, immx, aluresult, rdval);
        #5
        // Reset inputs
        alusignals = 12'b0;
        op1 = 16'b0;
        op2 = 16'b0;
        immx = 5'b0;
        instr = 16'b0;
        isimmediate = 0;

        // Wait for reset to settle
        #10;
        // Test ADD operation
        op1 = 16'h0010;
        op2 = 16'h0005;
        alusignals = 12'b000000000001; // Setting `isadd` high
        #10;
        
        // Test SUB operation
        alusignals = 12'b000000000010; // Setting `issub` high
        #10;

        // Test MUL operation
        alusignals = 12'b000000001000; // Setting `ismul` high
        #10;

        // Test OR operation
        alusignals = 12'b000000010000; // Setting `isor` high
        #10;

        // Test AND operation
        alusignals = 12'b000000100000; // Setting `isand` high
        #10;

        // Test NOT operation
        alusignals = 12'b000001000000; // Setting `isnot` high
        op1 = 16'hFFFF; // Test with all 1s to check NOT
        #10;

        // Test immediate mode for MOV
        alusignals = 12'b000010000000; // Setting `ismov` high
        isimmediate = 1;  // Immediate mode
        immx = 5'b00101;  // Set immediate value
        #10;

        // Test LSL (Logical Shift Left)
        alusignals = 12'b000100000000; // Setting `islsl` high
        op1 = 16'h0001;
        op2 = 16'h0003; // Shift left by 3
        #10;

        // Test LSR (Logical Shift Right)
        alusignals = 12'b001000000000; // Setting `islsr` high
        op1 = 16'h0008;
        op2 = 16'h0002; // Shift right by 2
        #10;

        // Test CMP (Compare)
        alusignals = 12'b000000100000; // Setting `iscmp` high
        op1 = 16'h000A;
        op2 = 16'h000A; // Compare equal case
        #10;

        // Test invalid operation
        alusignals = 12'b000000000000; // No operation selected
        #10;

        $finish;  // End of simulation
    end

endmodule

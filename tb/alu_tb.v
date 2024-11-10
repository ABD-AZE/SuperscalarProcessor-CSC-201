module alu_tb();
    // Testbench signals
    reg reset;
    reg clk;
    reg [11:0] alusignals;
    reg [15:0] instrin;
    reg [15:0] op1;
    reg [15:0] op2;
    reg [4:0] immx;
    reg isimmediate;
    reg is_branch_takenin;
    wire [15:0] aluresult;
    wire [15:0] instrout;
    
    // Instantiate the ALU module
    alu uut (
        .reset(reset),
        .clk(clk),
        .alusignals(alusignals),
        .instrin(instrin),
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .isimmediate(isimmediate),
        .aluresult(aluresult),
        .instrout(instrout),
        .is_branch_takenin(is_branch_takenin)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize inputs
        $dumpfile("a.vcd");
        $dumpvars(0, alu_tb);
        reset = 0;
        clk = 0;
        alusignals = 12'b0;
        instrin = 16'h0000;
        op1 = 16'h0000;
        op2 = 16'h0000;
        immx = 5'h00;
        isimmediate = 0;
        is_branch_takenin = 0;

        // Reset
        #5 reset = 1;
        #10 reset = 0;
        // Test ADD operation
        op1 = 16'h0003;
        op2 = 16'h0004;
        alusignals[0] = 1'b1; // Set isadd
        $display("ADD result: %h, Expected: 0007", aluresult);
        
        // Test SUB operation
        #10;
        alusignals = 12'b0;
        alusignals[3] = 1'b1; // Set issub
        $display("SUB result: %h, Expected: FFFF", aluresult);
        
        // Test AND operation
        #10;
        alusignals = 12'b0;
        alusignals[8] = 1'b1; // Set isand
        op1 = 16'hF0F0;
        op2 = 16'h0FF0;
        $display("AND result: %h, Expected: 00F0", aluresult);
        
        // Test OR operation
        #10;
        alusignals = 12'b0;
        alusignals[7] = 1'b1; // Set isor
        $display("OR result: %h, Expected: FFF0", aluresult);
        
        // Test IMMEDIATE operation (ADD with immediate value)
        #10;
        alusignals = 12'b0;
        alusignals[0] = 1'b1; // Set isadd
        isimmediate = 1;
        immx = 5'h1;
        op1 = 16'h0002;
        $display("ADD Immediate result: %h, Expected: 0003", aluresult);
        
        // Test Branch Taken
        #10;
        is_branch_takenin = 1;
        $display("Branch Taken result: %h, Expected: 0000", aluresult);
        
        $finish;
    end
endmodule

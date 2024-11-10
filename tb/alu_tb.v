module alu_tb;
    reg clk;
    reg [11:0] alusignals;
    reg [15:0] instrin;
    reg [15:0] op1;
    reg [15:0] op2;
    reg [4:0] immx;
    reg [15:0] instr;
    reg isimmediate;
    wire [15:0] aluresult;
    wire [15:0] instrout;

    // Instantiate the ALU module
    alu dut (
        .clk(clk),
        .alusignals(alusignals),
        .instrin(instrin),
        .op1(op1),
        .op2(op2),
        .immx(immx),
        .instr(instr),
        .isimmediate(isimmediate),
        .aluresult(aluresult),
        .instrout(instrout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test cases
    initial begin
        // Initialize inputs
        $dumpfile("alu_unit.vcd");
        $dumpvars(0, alu_tb);
        instrin = 16'h1234;
        op1 = 16'h0005;
        op2 = 16'h0003;
        immx = 5'b00110;
        instr = 16'h5678;
        isimmediate = 0;

        // Reset all ALU signals
        alusignals = 12'b0;

        // Test addition (isadd signal)
        #10 alusignals[0] = 1; // isadd
        #10 alusignals = 12'b0; // Reset signals

        // Test subtraction (issub signal)
        #10 alusignals[3] = 1; // issub
        #10 alusignals = 12'b0; // Reset signals

        // Test multiplication (ismul signal)
        #10 alusignals[4] = 1; // ismul
        #10 alusignals = 12'b0; // Reset signals

        // Test compare (iscmp signal)
        #10 alusignals[5] = 1; // iscmp
        #10 alusignals = 12'b0; // Reset signals

        // Test logical OR (isor signal)
        #10 alusignals[7] = 1; // isor
        #10 alusignals = 12'b0; // Reset signals

        // Test logical AND (isand signal)
        #10 alusignals[8] = 1; // isand
        #10 alusignals = 12'b0; // Reset signals

        // Test left shift (islsl signal)
        #10 alusignals[10] = 1; // islsl
        #10 alusignals = 12'b0; // Reset signals

        // Test right shift (islsr signal)
        #10 alusignals[11] = 1; // islsr
        #10 alusignals = 12'b0; // Reset signals

        // Test immediate mode (isimmediate = 1)
        #10 isimmediate = 1;
        op1 = 16'h0004;
        immx = 5'b00010; // immediate value
        alusignals[0] = 1; // isadd
        #10 alusignals = 12'b0;
        isimmediate = 0;

        // End simulation
        #20 $finish;
    end

    // Display output
    initial begin
        $monitor("Time = %0t | alusignals = %b | op1 = %h | op2 = %h | immx = %b | isimmediate = %b | aluresult = %h | instrout = %h", 
                 $time, alusignals, op1, op2, immx, isimmediate, aluresult, instrout);
    end
endmodule

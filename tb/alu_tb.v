module alu_tb;

  // Inputs
  reg clk;
  reg [11:0] alusignals;
  reg [15:0] instrin;
  reg [15:0] op1;
  reg [15:0] op2;
  reg [4:0] immx;
  reg isimmediate;

  // Outputs
  wire [15:0] aluresult;
  wire [15:0] instrout;

  // Instantiate the Unit Under Test (UUT)
  alu uut (
    .clk(clk), 
    .alusignals(alusignals), 
    .instrin(instrin), 
    .op1(op1), 
    .op2(op2), 
    .immx(immx), 
    .isimmediate(isimmediate), 
    .aluresult(aluresult), 
    .instrout(instrout)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test scenarios
  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb);
    // Initialize Inputs
    clk = 0;
    alusignals = 12'b0;
    instrin = 16'b0;
    op1 = 16'b0;
    op2 = 16'b0;
    immx = 5'b0;
    isimmediate = 0;
    #5;
    
    // Monitor changes
    $monitor("Time: %0d, op1: %h, op2: %h, immx: %h, isadd: %b, issub: %b, ismul: %b, aluresult: %h", 
             $time, op1, op2, immx, alusignals[0], alusignals[3], alusignals[4], aluresult);

    // Test ADD operation
    #10 alusignals = 12'b000000000001;  // isadd signal
    op1 = 16'h0001;
    op2 = 16'h0005;

    // Test LD operation (load)
    #10 alusignals = 12'b000000000010;  // isld signal
    op1 = 16'h0010;
    op2 = 16'h0005;

    // Test ST operation (store)
    #10 alusignals = 12'b000000000100;  // isst signal
    op1 = 16'h0010;
    op2 = 16'h0005;

    // Test SUB operation
    #10 alusignals = 12'b000000001000;  // issub signal
    op1 = 16'h000A;
    op2 = 16'h0003;

    // Test MUL operation
    #10 alusignals = 12'b000000010000;  // ismul signal
    op1 = 16'h0003;
    op2 = 16'h0002;

    // Test CMP operation (Comparison)
    #10 alusignals = 12'b000000100000;  // iscmp signal
    op1 = 16'h000F;
    op2 = 16'h000F;

    // Test MOV operation
    #10 alusignals = 12'b000001000000;  // ismov signal
    op1 = 16'h0F0F;
    op2 = 16'h00FF;

    // Test OR operation
    #10 alusignals = 12'b000010000000;  // isor signal
    op1 = 16'h0F0F;
    op2 = 16'h00FF;

    // Test AND operation
    #10 alusignals = 12'b000100000000;  // isand signal
    op1 = 16'h00FF;
    op2 = 16'h0F0F;

    // Test NOT operation
    #10 alusignals = 12'b001000000000;  // isnot signal
    op1 = 16'h00FF;

    // Test LSL operation (Logical Shift Left)
    #10 alusignals = 12'b010000000000;  // islsl signal
    op1 = 16'h000F;
    op2 = 16'h0002;

    // Test LSR operation (Logical Shift Right)
    #10 alusignals = 12'b100000000000;  // islsr signal
    op1 = 16'h000F;
    op2 = 16'h0002;

    // End simulation
    #100 $finish;
  end

endmodule

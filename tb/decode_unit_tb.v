module decode_unit_tb;
    // Inputs
    reg clk;
    reg reset;
    reg stall;
    reg is_branch_taken;
    reg [15:0] instr;
    reg [19:0] rdvalmem1;
    reg [19:0] rdvalmem2;
    
    // Outputs
    wire [4:0] imm;
    wire [3:0] opcode;
    wire [15:0] branch_target;
    wire [15:0] op1, op2;
    wire imm_flag;
    wire [15:0] instrout;
    
    // Instantiate the decode unit
    decode_unit DUT (
        .clk(clk),
        .reset(reset),
        .stall(stall),
        .is_branch_taken(is_branch_taken),
        .instr(instr),
        .rdvalmem1(rdvalmem1),
        .rdvalmem2(rdvalmem2),
        .imm(imm),
        .opcode(opcode),
        .branch_target(branch_target),
        .op1(op1),
        .op2(op2),
        .imm_flag(imm_flag),
        .instrout(instrout)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock with a period of 10 time units
    end

    // Testbench logic
    initial begin
        // Initialize inputs
         $dumpfile("decode_unit.vcd");
        $dumpvars(0, decode_unit_tb);
        reset = 1;
        stall = 0;
        is_branch_taken = 0;
        instr = 16'h0000;
        rdvalmem1 = 20'b0;
        rdvalmem2 = 20'b0;

        // Wait for a few clock cycles
        #15 reset = 0;

        // Test case 1: Basic instruction decode
        instr = 16'b110100101100000; // Example instruction with opcode 1101 and registers
        rdvalmem1 = 20'hF1234;          // rdvalmem1 is irrelevant for now
        rdvalmem2 = 20'hF5678;
        
        // Check the output
        $display("Test 1 - Instr: %h, Opcode: %h, Op1: %h, Op2: %h, Imm: %h, Branch Target: %h", instr, opcode, op1, op2, imm, branch_target);
        
        // Test case 2: Stall and Branch
        // stall = 1;                      // Introduce a stall signal
        // $display("Test 2 (Stall) - Opcode: %h, Op1: %h, Op2: %h", opcode, op1, op2);
        // #10;                            // Wait one clock cycle
        
        stall = 0;                      // Remove the stall
        is_branch_taken = 1;            // Simulate a branch taken condition
        $display("Test 3 (Branch Taken) - Opcode: %h, Op1: %h, Op2: %h, Instrout: %h", opcode, op1, op2, instrout);
        
        // Test case 3: Another instruction decode with immediate
        is_branch_taken = 0;
        #10;                            // Wait one clock cycle
        instr = 16'b101000101100011; // Another example instruction
        rdvalmem1 = 20'hF9876;
        rdvalmem2 = 20'hF5432;
        $display("Test 4 - Instr: %h, Opcode: %h, Op1: %h, Op2: %h, Imm: %h, Branch Target: %h", instr, opcode, op1, op2, imm, branch_target);
        #20;
        $finish;                          // Stop the simulation
    end
endmodule

module relayer_unit_tb;
    
    reg [15:0] instr1_in;
    reg [15:0] instr2_in;
    wire [15:0] instr1_o;
    wire [15:0] instr2_o;
    wire issingleinstr;
    wire isstall;

    relayer_unit uut (
        .instr1_in(instr1_in), 
        .instr2_in(instr2_in), 
        .instr1_o(instr1_o), 
        .instr2_o(instr2_o), 
        .issingleinstr(issingleinstr), 
        .isstall(isstall)
    );

    initial begin
	      $dumpfile("relayer_unit.vcd");
        $dumpvars(0, relayer_unit_tb);
        // Initialize inputs
        instr1_in = 16'h0000;
        instr2_in = 16'h0000;

        // Add stimulus here
        #10 instr1_in = 16'h1234; instr2_in = 16'h5678; // Basic input with two instructions
        #10 instr1_in = 16'h0000; instr2_in = 16'h0000; // Test with NOPs
        #10 instr1_in = 16'h1234; instr2_in = 16'h1234; // Same instruction for both inputs
        #10 instr1_in = 16'h1234; instr2_in = 16'h0000; // Single instruction with NOP in second slot
        #10 instr1_in = 16'h0000; instr2_in = 16'h5678; // Single instruction with NOP in first slot
        
        // Test cases that might trigger stalling
        #10 instr1_in = 16'h8F34; instr2_in = 16'h8F78; // Test for potential stalls based on specific conditions
        
        #10 instr1_in = 16'hAAAA; instr2_in = 16'hBBBB; // Test unrelated instructions
        
        #10 instr1_in = 16'h1234; instr2_in = 16'h5678; // Another pass-through test case
        
        #10 $finish;
    end

    initial begin
        // Monitor the outputs
        $monitor("At time %0t: instr1_in = %h, instr2_in = %h | instr1_o = %h, instr2_o = %h, issingleinstr = %b, isstall = %b", 
                 $time, instr1_in, instr2_in, instr1_o, instr2_o, issingleinstr, isstall);
    end

endmodule

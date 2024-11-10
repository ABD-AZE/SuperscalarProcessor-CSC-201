module memory_unit_tb;
    // Inputs
    reg clk;
    reg isld;
    reg isst;
    reg [15:0] instr;
    reg [15:0] op2;
    reg [15:0] aluresult;

    // Outputs
    wire [15:0] ldresult;
    wire [19:0] rdvalmem;

    // Instantiate the memory unit
    memory_unit uut (
        .clk(clk),
        .isld(isld),
        .isst(isst),
        .instr(instr),
        .op2(op2),
        .aluresult(aluresult),
        .ldresult(ldresult),
        .rdvalmem(rdvalmem)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10 ns clock period
    end

    initial begin
        // Initialize inputs
        $dumpfile("u1.vcd");
        $dumpvars(0, memory_unit_tb);
        clk = 0;
        isld = 0;
        isst = 0;
        instr = 16'h0000;
        op2 = 16'h0000;
        aluresult = 16'h0000;
        #5;
        // Load operation test
        #10; // wait for some time
        isld = 1;
        aluresult = 16'h0002; // Load from address 5
        instr = 16'h0701; // Example instruction with rd = instr[7:5] = 3
        $display("Load Test - ldresult: %h, rdvalmem: %h", ldresult, rdvalmem);
        #10;
        isld = 0;

        // Check the result of ldresult and rdvalmem

        // Store operation test
        isst = 1;
        aluresult = 16'h000A; // Store to address 10
        op2 = 16'hAAAA; // Value to store
        instr = 16'h1000; // Example instruction with rd = instr[7:5] = 4
        #10;
        isst = 0;
        isld = 0;
        aluresult = 16'h0010;  // Example address
        instr = 16'hA5A5;      // Example instruction (use bits [7:5] for rdvalmem)

        // Check the result of store operation
        $display("Store Test - ldresult: %h, rdvalmem: %h", ldresult, rdvalmem);

        // End the simulation
        #150;
        $stop;
    end
endmodule

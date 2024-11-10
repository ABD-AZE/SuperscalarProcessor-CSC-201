
module memory_unit_tb;
    reg clk;
    reg isld;
    reg isst;
    reg [15:0] instr;
    reg [15:0] op2;
    reg [15:0] aluresult;
    wire [15:0] ldresult;
    wire [18:0] rdvalmem;

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
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Toggle clock every 5 ns
    end

    // Initialize memory file and set up initial conditions
    initial begin
        $dumpfile("memory_unit.vcd");
        $dumpvars(0, memory_unit_tb);
        // Initialize control signals
        #5; 
        isld = 0;
        isst = 0;
        instr = 16'b0;
        op2 = 16'b0;
        aluresult = 16'b0;

        // Initial reset state to read memory
        $display("Starting memory unit test...");

        // Test load operation
        #10;
        aluresult = 16'h0002;  // Address to load from
        isld = 1;
        isst = 0;
        #10;
        isld = 0;
        $display("Loaded data at address 0x0002: ldresult = %h, rdvalmem = %h", ldresult, rdvalmem);

        // Test store operation
        #10;
        aluresult = 16'h0003;  // Address to store to
        op2 = 16'hABCD;       // Data to store
        isst = 1;
        isld = 0;
        #10;
        isst = 0;
        $display("Stored data 0xABCD at address 0x0003");

        // Verify if the data was stored correctly by loading it back
        #10;
        aluresult = 16'h0003;
        isld = 1;
        isst = 0;
        #10;
        isld = 0;
        $display("Loaded data at address 0x0003 after store: ldresult = %h, rdvalmem = %h", ldresult, rdvalmem);

        // Add more test cases as needed
        $finish;    
    end
endmodule

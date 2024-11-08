module memory_unit (
    input wire isld,
    input wire isst,
    input wire [15:0] op2,
    input wire [15:0] aluresult
    output reg [15:0] ldresult
);
    reg [15:0] memory[0:31]; // Memory array to hold values from hex file , 32 addressess and 16 bit data
    initial begin
        $readmemh("data_memory.hex", memory);
    end
    
endmodule

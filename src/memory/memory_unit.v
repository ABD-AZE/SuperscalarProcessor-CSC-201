module memory_unit (
    input wire clk,
    input wire isld,
    input wire isst,
    input wire [15:0] instr,
    input wire [15:0] op2,
    input wire [15:0] aluresult,
    output wire [15:0] ldresult,
    output wire [18:0] rdvalmem
);
    integer i;
    reg [15:0] memory[0:31]; // Memory array to hold values from hex file , 32 addressess and 16 bit data
    initial begin
        $readmemh("data_memory.hex", memory);
        ld_reg = 16'h0000;
        ld = 16'h0000;
    end
    integer file;
    reg [15:0] ld_reg,ld;
    always @(posedge clk) begin
        if (isld) begin
            $readmemh("data_memory.hex", memory);
            ld_reg = memory[aluresult];
            $display("ldresult_reg = %h", ld_reg);
        end
        else if (isst) begin
            $readmemh("data_memory.hex", memory);
            file = $fopen("data_memory.hex", "w");
            memory[aluresult] = op2;
            for (i = 0; i < 32; i = i + 1) begin
                $fwrite(file, "%h\n", memory[i]); 
            end
            ld_reg = 16'h0000;
            $fclose(file);
        end
        $display("ldresult = %h", ld);
        #10 ld = ld_reg;
    end
    assign ldresult = ld;
    assign rdvalmem = {ld,instr[10:8]};
endmodule

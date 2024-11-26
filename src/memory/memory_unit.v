module memory_unit (
    input wire clk,
    input wire isld,
    input wire isst,
    input wire reset,
    input wire iswb,
    input wire [15:0] instr,
    input wire [15:0] op2,
    input wire [15:0] aluresult,
    output wire [15:0] aluresult_out,
    output wire isld_out,
    output wire iswb_out,
    output wire [15:0] instr_out,
    output wire [15:0] ldresult,
    output wire [19:0] rdvalmem
);
    integer i;
    reg [15:0] aluresult_reg;
    reg [15:0] instr_rd;
    reg [15:0] instr_1;
    reg iswb_1;
    reg iswb_reg;
    reg isld_reg;
    reg isld_1;
    reg [15:0] memory[0:31];
    initial begin
        $readmemh("data_memory.hex", memory);
        ld_reg = 16'h0000;
        ld = 16'h0000;
        aluresult_reg = 16'h0000;
        result = 19'h00000;
        rdval = 19'h00000;
        iswb_reg = 0;
        isld_reg = 0;
        instr_rd = 16'h0;   
    end
    integer file;
    reg [15:0] ld_reg,ld;
    reg [19:0] result;
    reg [19:0] rdval;
    always @(posedge clk) begin
        if(reset) begin
            ld_reg <= 16'h0;
            result <= 19'h0;
            aluresult_reg <= 16'h0;
        end
        else if (isld) begin
            $readmemh("data_memory.hex", memory);
            ld_reg <= memory[aluresult];
            $readmemh("data_memory.hex", memory);
            result <= {1'h0,memory[aluresult],instr[10:8]};
            // $display("rdval = %h", result);
        end
        else if (isst) begin
            $readmemh("data_memory.hex", memory);
            file = $fopen("data_memory.hex", "w");
            memory[aluresult] = op2;
            for (i = 0; i < 32; i = i + 1) begin
                $fwrite(file, "%h\n", memory[i]); 
            end
            ld_reg <= 16'h0000;
            $fclose(file);
            result <= {19'h0,1'h1};
            // $display("rdval = %h", result);
        end
        else begin 
            ld_reg <= 16'h0000;
            // result_1 = {aluresult, instr[7:5]};
            result <={instr[10:8],aluresult,1'h0};
            // $display("rdval = %h", result);x
        end
        // $display("ldresult = %h", ld);
        aluresult_reg<=aluresult;
        $display("aluresult: ", aluresult);
        $display("aluresult_reg: ", aluresult_reg);
        ld<=ld_reg;
        rdval<=result;
        isld_1<=isld;
        isld_reg<=isld_1;
        iswb_reg<=iswb;
        iswb_1<=iswb_reg;
        instr_rd<=instr;
        instr_1<=instr_rd;
    end
    assign ldresult = ld;
    assign rdvalmem = result;
    assign aluresult_out = aluresult_reg;
    assign iswb_out = iswb_reg;
    assign instr_out = instr_rd;
    assign isld_out = isld_reg;
endmodule

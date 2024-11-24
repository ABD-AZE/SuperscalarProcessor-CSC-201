module writeback_unit(
    input wire clk,
    input wire iswb,
    input wire isld,
    input wire [15:0] instr,
    input wire [15:0] ldresult,
    input wire [15:0] aluresult
);
    integer file;
    integer i;
    reg [15:0] result;
    reg [15:0] reg_file [0:7];
    initial begin
        $readmemh("registers.hex", reg_file);
    end
    always @(posedge clk) begin
        if (iswb) begin
            if (isld) begin
                result = ldresult;
            end else begin
                result = aluresult;
            end
            reg_file[instr[10:8]] = result;
        end
    end
    always @(*) begin
        file = $fopen("registers.hex", "w");
        for (i = 0; i < 8; i = i + 1) begin
            $fwrite(file, "%h\n", reg_file[i]); 
        end
        $fclose(file);
    end


endmodule

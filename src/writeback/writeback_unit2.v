module writeback_unit2(
    input wire clk,
    input wire iswb,
    input wire isld,
    input wire [15:0] instr,
    input wire [15:0] ldresult,
    input wire [15:0] aluresult,
    input wire [127:0] regvalwb
);
    integer file;
    integer i;
    reg [15:0] result;
    reg [15:0] reg_file [0:7];
    always @(*) begin
        reg_file[0] = regvalwb[15:0];
        reg_file[1] = regvalwb[31:16];
        reg_file[2] = regvalwb[47:32];
        reg_file[3] = regvalwb[63:48];
        reg_file[4] = regvalwb[79:64];
        reg_file[5] = regvalwb[95:80];
        reg_file[6] = regvalwb[111:96];
        reg_file[7] = regvalwb[127:112];
        if (iswb) begin
            if (isld) begin
                result = ldresult;
            end else begin
                result = aluresult;
            end
            reg_file[instr[10:8]] = aluresult;
            file = $fopen("registers.hex", "w");
            for (i = 0; i < 8; i = i + 1) begin
                $fwrite(file, "%h\n", reg_file[i]); 
            end
            $fclose(file);
        end
    end


endmodule

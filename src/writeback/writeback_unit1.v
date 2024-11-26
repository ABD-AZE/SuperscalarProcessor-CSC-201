module writeback_unit1(
    input wire clk,
    input wire iswb,
    input wire isld,
    input wire [15:0] instr,
    input wire [15:0] ldresult,
    input wire [15:0] aluresult,
    input wire iswbin2,
    input wire isldmem2,
    input wire [15:0] instrmemwb2,
    input wire [15:0] ldresult2,
    input wire [15:0] aluresultmem2,
    output wire iswbwb,
    output wire isldwb,
    output wire [15:0] instrwb,
    output wire [15:0] ldresultwb,
    output wire [15:0] aluresultwb,
    output wire [127:0] regvalwb
);
//         .iswbin2(iswbmem2),
//         .isldin2(isldmem2),
//         .instrin2(instrmemwb2),
//         .ldresultin2(ldresult2),
//         .aluresultin2(aluresultmem2)
//         .iswbout2(iswbwb),
//         .isldout2(isldwb),
//         .instrout2(instrwb),
//         .ldresultout2(ldresultwb),
//         .aluresultout2(aluresultwb)
    integer file;
    integer i;
    reg [127:0] regval_reg;

    reg [15:0] result;
    reg [15:0] reg_file [0:7];
    reg iswbwb_reg, isldwb_reg;
    reg [15:0] instrwb_reg, ldresultwb_reg, aluresultwb_reg;
    initial begin
        $readmemh("registers.hex", reg_file);
        result  = 16'b0;
        iswbwb_reg = 0;
        isldwb_reg = 0;
        instrwb_reg = 16'b0;
        ldresultwb_reg = 16'b0;
        aluresultwb_reg = 16'b0;
    end
    always @(posedge clk) begin
        $readmemh("registers.hex", reg_file);
        if (iswb) begin
            if (isld) begin
                reg_file[instr[10:8]] = ldresult;
            end else begin
                reg_file[instr[10:8]] = aluresult;
            end
            file = $fopen("registers.hex", "w");
            for (i = 0; i < 8; i = i + 1) begin
                $fwrite(file, "%h\n", reg_file[i]); 
            end
            $fclose(file);
        end
        regval_reg = {reg_file[7], reg_file[6], reg_file[5], reg_file[4], reg_file[3], reg_file[2], reg_file[1], reg_file[0]};
        iswbwb_reg <= iswbin2;
        isldwb_reg <= isldmem2;
        instrwb_reg <= instrmemwb2;
        ldresultwb_reg <= ldresult2;
        aluresultwb_reg <= aluresultmem2;
    end
    assign iswbwb = iswbwb_reg;
    assign isldwb = isldwb_reg;
    assign instrwb = instrwb_reg;
    assign ldresultwb = ldresultwb_reg;
    assign aluresultwb = aluresultwb_reg;
    assign regvalwb = regval_reg;

endmodule

// update the flags register and do the required calculations
module alu(
    input wire clk,
    input wire [11:0] alusignals,
    input wire [15:0] instrin,
    /*
        isadd
        isld
        isst
        issub
        ismul
        iscmp
        ismov
        isor
        isand
        isnot
        islsl
        islsr
    */  
    input wire [15:0] op1,
    input wire [15:0] op2,
    input wire [4:0] immx,
    input wire [15:0] instr,
    input wire isimmediate,
    output wire [15:0] aluresult,
    output wire [15:0] instrout
);
    integer file;
    integer i;
    reg [15:0] reg_file [7:0];
    reg [15:0] A;
    reg [15:0] B;
    wire isadd;
    wire isld;
    wire isst;
    wire issub;
    wire ismul;
    wire iscmp;
    wire ismov;
    wire isor;
    wire isand;
    wire isnot;
    wire islsl;
    wire islsr;
    assign isadd = alusignals[0];
    assign isld = alusignals[1];
    assign isst = alusignals[2];
    assign issub = alusignals[3];
    assign ismul = alusignals[4];
    assign iscmp = alusignals[5];
    assign ismov = alusignals[6];
    assign isor = alusignals[7];
    assign isand = alusignals[8];
    assign isnot = alusignals[9];
    assign islsl = alusignals[10];
    assign islsr = alusignals[11];
    reg isadd_reg;
    reg isld_reg;
    reg isst_reg;
    reg issub_reg;
    reg ismul_reg;
    reg iscmp_reg;
    reg ismov_reg;
    reg isor_reg;
    reg isand_reg;
    reg isnot_reg;
    reg islsl_reg;
    reg islsr_reg;
    reg isimmediate_reg;
    reg [15:0]op1_reg;
    reg [15:0]op2_reg;
    reg [4:0]immx_reg;
    reg [15:0] result;
    reg instrout_reg;
    reg instrout_reg1;
    initial begin
        $readmemh("registers.hex", reg_file);
        isadd_reg = 1'b0;
        isld_reg = 1'b0;
        isst_reg = 1'b0;
        issub_reg = 1'b0;
        ismul_reg = 1'b0;
        iscmp_reg = 1'b0;
        ismov_reg = 1'b0;
        isor_reg = 1'b0;
        isand_reg = 1'b0;
        isnot_reg = 1'b0;
        islsl_reg = 1'b0;
        islsr_reg = 1'b0;
        isimmediate_reg = 1'b0;
        op1_reg = 16'b0;
        op2_reg = 16'b0;
        immx_reg = 5'b0;
        instrout_reg = 16'b0;
        instrout_reg1 = 16'b0;
    end
    reg [15:0] instrw;
    always @(posedge clk) begin
        if (isimmediate_reg) begin
            A = op1;
            B = immx;
        end else begin
            A = op1;
            B = op2;
        end
        if (isadd_reg) begin
            result <= A + B;
        end else if (isld_reg) begin
            result <= A + B;
        end else if (isst_reg) begin
            result <= A + B;
        end else if (issub_reg) begin
            result <= A - B;
        end else if (ismul_reg) begin
            result <= A * B;
        end else if (iscmp_reg) begin // 1 for equal, 2 for greater than  , 0 for less than 
            if (A == B) begin
                result <= 16'b1;
                reg_file[7] = 16'b1;
            end else if (A>B) begin
                result <= 16'b0;
                reg_file[7] = 16'h2;
            end else begin
                result <= 16'b0;
                reg_file[7] = 16'h0;
            end
            file = $fopen("registers.hex", "w");
            if (file) begin
                $display("Writing modified data...");
                // Write each modified memory value to the new file
                for (i = 0; i < 8; i = i + 1) begin
                    $fwrite(file, "%h\n", reg_file[i]);  // Write as hexadecimal
                    $display("Data written to register file successfully. %h",reg_file[i]);
                end
                $fclose(file);  // Close the file
                $display("Data written to register file successfully.");
            end else begin
                $display("Error: Could not open file for writing.");
            end
        end else if (ismov_reg) begin
            result <= B;
        end else if (isor_reg) begin
            result <= A | B;
        end else if (isand_reg) begin
            result <= A & B;
        end else if (isnot_reg) begin
            result <= ~A;
        end else if (islsl_reg) begin
            result <= A << B;
        end else if (islsr_reg) begin
            result <= A >> B;
        end else begin
            result <= 16'b0;
        end
        isadd_reg <= isadd;
        isld_reg <= isld;
        isst_reg <= isst;
        issub_reg <= issub;
        ismul_reg <= ismul;
        iscmp_reg <= iscmp;
        ismov_reg <= ismov;
        isor_reg <= isor;
        isand_reg <= isand;
        isnot_reg <= isnot;
        islsl_reg <= islsl;
        islsr_reg <= islsr;
        isimmediate_reg <= isimmediate;
        op1_reg <= op1;
        op2_reg <= op2;    
        instrout_reg <= instrin;
        instrout_reg1 <= instrout_reg;
    end
    assign aluresult = result;
    assign instrout = instrout_reg1;
endmodule

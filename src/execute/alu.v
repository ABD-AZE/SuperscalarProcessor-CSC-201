module alu(
    input wire reset,
    input wire clk,
    input wire [11:0] alusignals,
    input wire [15:0] instrin,
    input wire [15:0] op1,
    input wire [15:0] op2,
    input wire [4:0] immx,
    input wire iswb,
    input wire isimmediate,
    input wire is_branch_takenin,
    output wire [15:0] aluresult,
    output wire [15:0] instrout,
    output wire isld1,
    output wire isst1,
    output wire [15:0] op2_out,
    output wire iswb_out
);

    // Internal Registers
    reg [15:0] op2_1;
    reg isld1_1;
    reg isst1_1;
    reg iswb1_reg;
    reg iswb1_1;
    reg [15:0] reg_file [7:0];
    reg [15:0] A;
    reg [15:0] B;
    wire isadd, issub, ismul, isld, isst, iscmp, ismov, isor, isand, isnot, islsl, islsr;

    // ALU Control Signals
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

    // Internal State
    reg isadd_reg, isld_reg, isst_reg, issub_reg, ismul_reg, iscmp_reg, ismov_reg, isor_reg, isand_reg, isnot_reg, islsl_reg, islsr_reg;
    reg isimmediate_reg;
    reg [15:0] op1_reg, op2_reg;
    reg [4:0] immx_reg;
    reg [15:0] result;
    reg [15:0] instrout_reg, instrout_reg1;
    reg [15:0] result_1;

    // Initialize Internal Registers
    initial begin
        $readmemh("registers.hex", reg_file);
        isadd_reg = 0; isld_reg = 0; isst_reg = 0; issub_reg = 0; ismul_reg = 0;
        iscmp_reg = 0; ismov_reg = 0; isor_reg = 0; isand_reg = 0; isnot_reg = 0;
        islsl_reg = 0; islsr_reg = 0; isimmediate_reg = 0;
        op1_reg = 16'b0; op2_reg = 16'b0; immx_reg = 5'b0;
        instrout_reg = 16'b0; instrout_reg1 = 16'b0;
        result = 16'b0;
    end
    // ALU Logic
    always @(posedge clk) begin
        if (is_branch_takenin || reset) begin
            result <= 16'h0;
            instrout_reg <= 16'h0;
        end else begin
            // Operand Selection
            if (isimmediate) begin
                A = op1;
                B = immx;
            end else begin
                A = op1;
                B = op2;
            end

            // Perform ALU Operation
            if (isadd||isld||isst) result <= A + B;
            else if (issub) result <= A - B;
            else if (ismul) result <= A * B;
            else if (iscmp) begin
                if (A == B) result <= 16'b1;
                else if (A > B) result <= 16'h2;
                else result <= 16'h0;
            end else if (ismov) result <= B;
            else if (isor) result <= A | B;
            else if (isand) result <= A & B;
            else if (isnot) result <= ~A;
            else if (islsl) result <= A << B;
            else if (islsr) result <= A >> B;
            else result <= 16'b0;
        end

        // Handle Branch Taken
        if (!is_branch_takenin) instrout_reg <= instrin;

        instrout_reg1 <= instrout_reg;
        result_1 <= result;
        op2_reg <= op2;
        op2_1 <= op2_reg;
        isld1_1 <= isld_reg;
        isst1_1 <= isst_reg;
        iswb1_reg <= iswb;
        iswb1_1 <= iswb1_reg;
    end

    // Output Assignments
    assign aluresult = result;
    assign instrout = instrout_reg;
    assign op2_out = op2_reg;
    assign iswb_out = iswb1_reg;
    assign isld1 = isld_reg;
    assign isst1 = isst_reg;
endmodule

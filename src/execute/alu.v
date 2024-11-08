// update the flags register and do the required calculations

module alu(
    input wire clk,
    input wire [11:0] alusignals,
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
    input wire isimmediate,
    output reg [15:0] aluresult
);
    wire [15:0] A = op1;
    wire [15:0] B = isimmediate ? immx : op2;
    wire isadd = alusignals[0];
    wire isld = alusignals[1];
    wire isst = alusignals[2];
    wire issub = alusignals[3];
    wire ismul = alusignals[4];
    wire iscmp = alusignals[5];
    wire ismov = alusignals[6];
    wire isor = alusignals[7];
    wire isand = alusignals[8];
    wire isnot = alusignals[9];
    wire islsl = alusignals[10];
    wire islsr = alusignals[11];
    reg [15:0] result;
    always @(posedge clk) begin
        if (isadd) begin
            result <= A + B;
        end else if (isld) begin
            result <= A + B;
        end else if (isst) begin
            result <= A + B;
        end else if (issub) begin
            result <= A - B;
        end else if (ismul) begin
            result <= A * B;
        end else if (iscmp) begin
            result <= A - B;
        end else if (ismov) begin
            result <= B;
        end else if (isor) begin
            result <= A | B;
        end else if (isand) begin
            result <= A & B;
        end else if (isnot) begin
            result <= ~A;
        end else if (islsl) begin
            result <= A << B;
        end else if (islsr) begin
            result <= A >> B;
        end else begin
            result <= 16'b0;
        end
    end
    always @(*) begin
        aluresult <= result;
    end
endmodule

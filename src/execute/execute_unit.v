module ExecuteUnit (
    input wire clk,                           // Added clock input for synchronization
    input wire [31:0] pc1, pc2,               // Program counters for each pipeline
    input wire [31:0] opA1, opA2,             // Operands A for each pipeline
    input wire [31:0] opB1, opB2,             // Operands B for each pipeline
    input wire [3:0] aluControl1, aluControl2, // ALU control signals for each pipeline
    input wire isBranch1, isBranch2,           // Branch indicators for each pipeline
    input wire isRet1, isRet2,                 // Return indicators for each pipeline
    input wire [31:0] branchTarget1, branchTarget2, // Branch targets for each pipeline
    input wire isBeq1, isBeq2,                 // Branch equal signals
    input wire isBgt1, isBgt2,                 // Branch greater-than signals
    output reg [31:0] aluResult1, aluResult2,  // ALU results
    output reg isBranchTaken1, isBranchTaken2, // Branch taken indicators
    output reg [31:0] branchPC1, branchPC2     // Next PCs if branches are taken
);

    // Instantiate ALU for Pipeline 1
    alu alu1 (
        .clk(clk),                           // Pass the clock signal
        .alusignals(aluControl1),
        .op1(opA1[15:0]),
        .op2(opB1[15:0]),
        .immx(opB1[4:0]),                     // Assuming lower bits for immediate
        .isimmediate(1'b0),                   // Update if needed
        .aluresult(aluResult1)               // Output is now 32 bits
    );

    // Instantiate ALU for Pipeline 2
    alu alu2 (
        .clk(clk),                           // Pass the clock signal
        .alusignals(aluControl2),
        .op1(opA2[15:0]),
        .op2(opB2[15:0]),
        .immx(opB2[4:0]),                     // Assuming lower bits for immediate
        .isimmediate(1'b0),                   // Update if needed
        .aluresult(aluResult2)               // Output is now 32 bits
    );

    // Branch logic for Pipeline 1
    always @(*) begin
        if (isBranch1) begin
            if ((isBeq1 && aluResult1 == 0) || (isBgt1 && aluResult1 > 0)) begin
                isBranchTaken1 = 1;
                branchPC1 = branchTarget1;
            end else begin
                isBranchTaken1 = 0;
                branchPC1 = pc1 + 4; // Next sequential PC
            end
        end else if (isRet1) begin
            isBranchTaken1 = 1;
            branchPC1 = aluResult1; // Assuming aluResult contains return address
        end else begin
            isBranchTaken1 = 0;
            branchPC1 = pc1 + 4;
        end
    end

    // Branch logic for Pipeline 2
    always @(*) begin
        if (isBranch2) begin
            if ((isBeq2 && aluResult2 == 0) || (isBgt2 && aluResult2 > 0)) begin
                isBranchTaken2 = 1;
                branchPC2 = branchTarget2;
            end else begin
                isBranchTaken2 = 0;
                branchPC2 = pc2 +  4; // Next sequential PC
            end
        end else if (isRet2) begin
            isBranchTaken2 = 1;
            branchPC2 = aluResult2; // Assuming aluResult contains return address
        end else begin
            isBranchTaken2 = 0;
            branchPC2 = pc2 + 4;
        end
    end

endmodule

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
    output reg [31:0] aluresult // Changed to 32 bits
);
    wire [15:0] A = op1;
    wire [15:0] B = isimmediate ? immx : op2;

    always @(posedge clk) begin
        if (alusignals[0]) begin
            aluresult <= A + B;
        end else if (alusignals[1]) begin
            aluresult <= A + B; // This line is redundant
        end else if (alusignals[2]) begin
            aluresult <= A + B; // This line is redundant
        end else if (alusignals[3]) begin
            aluresult <= A - B;
        end else if (alusignals[4]) begin
            aluresult <= A * B;
        end else if (alusignals[5]) begin
            aluresult <= A - B; // This line is redundant
        end else if (alusignals[6]) begin
            aluresult <= B;
        end else if (alusignals[7]) begin
            aluresult <= A | B;
        end else if (alusignals[8]) begin
            aluresult <= A & B;
        end else if (alusignals[9]) begin
            aluresult <= ~A;
        end else if (alusignals[10]) begin
            aluresult <= A << B;
        end else if (alusignals[11]) begin
            aluresult <= A >> B;
        end else begin
            aluresult <= 32'b0; // Changed to 32 bits
        end
    end
endmodule

module ExecuteUnit (
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
    ALU alu1 (
        .opA(opA1),
        .opB(opB1),
        .aluControl(aluControl1),
        .aluResult(aluResult1)
    );

    // Instantiate ALU for Pipeline 2
    ALU alu2 (
        .opA(opA2),
        .opB(opB2),
        .aluControl(aluControl2),
        .aluResult(aluResult2)
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
                branchPC2 = pc2 + 4; // Next sequential PC
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

module ExecuteUnit (
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
    ALU alu1 (
        .opA(opA1),
        .opB(opB1),
        .aluControl(aluControl1),
        .aluResult(aluResult1)
    );

    // Instantiate ALU for Pipeline 2
    ALU alu2 (
        .opA(opA2),
        .opB(opB2),
        .aluControl(aluControl2),
        .aluResult(aluResult2)
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
                branchPC2 = pc2 + 4; // Next sequential PC
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

module ALU (
    input wire [31:0] opA, opB,
    input wire [3:0] aluControl,
    output reg [31:0] aluResult
);
    always @(*) begin
        case (aluControl)
            4'b0000: aluResult = opA + opB;        // ADD
            4'b0001: aluResult = opA - opB;        // SUB
            4'b0010: aluResult = opA & opB;        // AND
            4'b0011: aluResult = opA | opB;        // OR
            4'b0100: aluResult = opA ^ opB;        // XOR
            // Add more operations as needed
            default: aluResult = 32'b0;
        endcase
    end
endmodule


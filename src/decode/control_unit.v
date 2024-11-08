module control_unit(
    input wire clk,
    input wire reset,
    input wire stall,
    input wire [3:0] opcode,  // 4-bit opcode from decode unit
    output reg isadd,
    output reg issub,
    output reg ismul,
    output reg isld,
    output reg isst,
    output reg iscmp,
    output reg ismov,
    output reg isor,
    output reg isand,
    output reg isnot,
    output reg islsl,
    output reg islsr,
    output reg isbeq,
    output reg isbgt,
    output reg iswb,
    output reg isubranch
);

    // Opcodes for different operations
    localparam ADD_OP   = 4'b0000;
    localparam SUB_OP   = 4'b0001;
    localparam MUL_OP   = 4'b0010;
    localparam LD_OP    = 4'b0011;
    localparam ST_OP    = 4'b0100;
    localparam CMP_OP   = 4'b0101;
    localparam MOV_OP   = 4'b0110;
    localparam OR_OP    = 4'b0111;
    localparam AND_OP   = 4'b1000;
    localparam LSL_OP   = 4'b1010;
    localparam LSR_OP   = 4'b1011;
    localparam NOT_OP   = 4'b1001;
    localparam BEQ_OP   = 4'b1101;
    localparam BGT_OP   = 4'b1110;
    localparam WB_OP    = 4'b1111;
    localparam UBRANCH_OP = 4'b1100;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all outputs to 0
            isadd      <= 0;
            issub      <= 0;
            ismul      <= 0;
            isld       <= 0;
            isst       <= 0;
            iscmp      <= 0;
            ismov      <= 0;
            isor       <= 0;
            isand      <= 0;
            isnot      <= 0;
            islsl      <= 0;
            islsr      <= 0;
            isbeq      <= 0;
            isbgt      <= 0;
            iswb       <= 0;
            isubranch  <= 0;
        end else if (!stall) begin
            // Reset all the flags to 0 before decoding
            isadd      <= 0;
            issub      <= 0;
            ismul      <= 0;
            isld       <= 0;
            isst       <= 0;
            iscmp      <= 0;
            ismov      <= 0;
            isor       <= 0;
            isand      <= 0;
            isnot      <= 0;
            islsl      <= 0;
            islsr      <= 0;
            isbeq      <= 0;
            isbgt      <= 0;
            iswb       <= 0;
            isubranch  <= 0;

            case (opcode)
                ADD_OP: begin
                    isadd <= 1;
                    iswb <= 1;    // Writeback enabled for add
                end
                SUB_OP: begin
                    issub <= 1;
                    iswb <= 1;    // Writeback enabled for sub
                end
                MUL_OP: begin
                    ismul <= 1;
                    iswb <= 1;    // Writeback enabled for mul
                end
                AND_OP: begin
                    isand <= 1;
                    iswb <= 1;    // Writeback enabled for and
                end
                OR_OP: begin
                    isor <= 1;
                    iswb <= 1;    // Writeback enabled for or
                end
                NOT_OP: begin
                    isnot <= 1;
                    iswb <= 1;    // Writeback enabled for not
                end
                MOV_OP: begin
                    ismov <= 1;
                    iswb <= 1;    // Writeback enabled for mov
                end
                LD_OP: begin
                    isld <= 1;
                    iswb <= 1;    // Writeback enabled for load
                end
                LSL_OP: begin
                    islsl <= 1;
                    iswb <= 1;    // Writeback enabled for LSL
                end
                LSR_OP: begin
                    islsr <= 1;
                    iswb <= 1;    // Writeback enabled for LSR
                end
                ST_OP: begin
                    isst <= 1;
                    iswb <= 0; // No writeback for store
                end
                CMP_OP: begin
                    iscmp <= 1;
                    iswb <= 0; // No writeback for compare
                end
                BEQ_OP: begin
                    isbeq <= 1;
                    iswb <= 0; // No writeback for branch equal
                end
                BGT_OP: begin
                    isbgt <= 1;
                    iswb <= 0; // No writeback for branch greater
                end
                UBRANCH_OP: begin
                    isubranch <= 1;
                    iswb <= 0; // No writeback for unconditional branch
                end
                default: ; // Do nothing for unrecognized opcodes
            endcase
        end
    end
endmodule

module control_unit(
    input wire clk,
    input wire reset,
    input wire stall,
    // input wire [3:0] opcode,  // 4-bit opcode from decode unit
    input wire [15:0] instr,
    output wire isadd,
    output wire issub,
    output wire ismul,
    output wire isld,
    output wire isst,
    output wire iscmp,
    output wire ismov,
    output wire isor,
    output wire isand,
    output wire isnot,
    output wire islsl,
    output wire islsr,
    output wire isbeq,
    output wire isbgt,
    output wire iswb,
    output wire isubranch,
    input wire is_branch_taken
);

    // Internal registers
    reg [15:0] stalled_instr;                // Register to hold the instruction during stall
    reg stall_flag;                          // Register to indicate whether the previous cycle was stalled

    reg isadd_next;
    reg issub_next;
    reg ismul_next;
    reg isld_next;
    reg isst_next;
    reg iscmp_next;
    reg ismov_next;
    reg isor_next;
    reg isand_next;
    reg isnot_next;
    reg islsl_next;
    reg islsr_next;
    reg isbeq_next;
    reg isbgt_next;
    reg iswb_next;
    reg isubranch_next;

    reg isadd_reg;
    reg issub_reg;
    reg ismul_reg;
    reg isld_reg;
    reg isst_reg;
    reg iscmp_reg;
    reg ismov_reg;
    reg isor_reg;
    reg isand_reg;
    reg isnot_reg;
    reg islsl_reg;
    reg islsr_reg;
    reg isbeq_reg;
    reg isbgt_reg;
    reg iswb_reg;
    reg isubranch_reg;

    // Assign output wires to internal register values

    // Opcodes for different operations
    localparam ADD_OP      = 4'b0001;
    localparam SUB_OP      = 4'b0010;
    localparam MUL_OP      = 4'b0011;
    localparam LD_OP       = 4'b0100;
    localparam ST_OP       = 4'b0101;
    localparam CMP_OP      = 4'b0110;
    localparam MOV_OP      = 4'b0111;
    localparam OR_OP       = 4'b1000;
    localparam AND_OP      = 4'b1001;
    localparam NOT_OP      = 4'b1010;
    localparam LSL_OP      = 4'b1011;
    localparam UBRANCH_OP  = 4'b1100; // JUMP
    localparam SRL_OP      = 4'b1101;
    localparam BEQ_OP      = 4'b1110;
    localparam BGT_OP      = 4'b1111;

    always @(posedge clk or posedge reset) begin
        if (reset || is_branch_taken) begin
            // Reset all internal registers to 0
            isadd_next      = 0;
            issub_next      = 0;
            ismul_next      = 0;
            isld_next       = 0;
            isst_next       = 0;
            iscmp_next      = 0;
            ismov_next      = 0;
            isor_next       = 0;
            isand_next      = 0;
            isnot_next      = 0;
            islsl_next      = 0;
            islsr_next      = 0;
            isbeq_next      = 0;
            isbgt_next      = 0;
            iswb_next       = 0;
            isubranch_next  = 0;
        end else if (stall) begin
            // During a stall, set outputs to 0 and retain the current instruction
            isadd_next      <= 0;
            issub_next      <= 0;
            ismul_next      <= 0;
            isld_next       <= 0;
            isst_next       <= 0;
            iscmp_next      <= 0;
            ismov_next      <= 0;
            isor_next       <= 0;
            isand_next      <= 0;
            isnot_next      <= 0;
            islsl_next      <= 0;
            islsr_next      <= 0;
            isbeq_next      <= 0;
            isbgt_next      <= 0;
            iswb_next       <= 0;
            isubranch_next  <= 0;
            stalled_instr   = instr;  // Store the current instruction during stall
            stall_flag      = 1;     // Indicate that the stall occurred
        end else if (stall_flag) begin
                // After the stall, decode the stalled instruction
            stall_flag      = 0;
            isadd_next      <= 0;
            issub_next      <= 0;
            ismul_next      <= 0;
            isld_next       <= 0;
            isst_next       <= 0;
            iscmp_next      <= 0;
            ismov_next      <= 0;
            isor_next       <= 0;
            isand_next      <= 0;
            isnot_next      <= 0;
            islsl_next      <= 0;
            islsr_next      <= 0;
            isbeq_next      <= 0;
            isbgt_next      <= 0;
            iswb_next       <= 0;
            isubranch_next  <= 0;
            case (stalled_instr[15:12])
                ADD_OP: begin
                    isadd_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for add
                end
                SUB_OP: begin
                    issub_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for sub
                end
                MUL_OP: begin
                    ismul_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for mul
                end
                AND_OP: begin
                    isand_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for and
                end
                OR_OP: begin
                    isor_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for or
                end
                NOT_OP: begin
                    isnot_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for not
                end
                MOV_OP: begin
                    ismov_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for mov
                end
                LD_OP: begin
                    isld_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for load
                end
                LSL_OP: begin
                    islsl_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for LSL
                end
                SRL_OP: begin
                    islsr_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for SRL
                end
                ST_OP: begin
                    isst_next <= 1;
                    iswb_next <= 0; // No writeback for store
                end
                CMP_OP: begin
                    iscmp_next <= 1;
                    iswb_next <= 0; // No writeback for compare
                end
                BEQ_OP: begin
                    isbeq_next <= 1;
                    iswb_next <= 0; // No writeback for branch equal
                end
                BGT_OP: begin
                    isbgt_next <= 1;
                    iswb_next <= 0; // No writeback for branch greater
                end
                UBRANCH_OP: begin
                    isubranch_next <= 1;
                    iswb_next <= 0; // No writeback for unconditional branch
                end
                default: ; // Do nothing for unrecognized opcodes
            endcase
        end else if (1) begin
            // Reset all the internal registers to 0 before decoding
            isadd_next      <= 0;
            issub_next      <= 0;
            ismul_next      <= 0;
            isld_next       <= 0;
            isst_next       <= 0;
            iscmp_next      <= 0;
            ismov_next      <= 0;
            isor_next       <= 0;
            isand_next      <= 0;
            isnot_next      <= 0;
            islsl_next      <= 0;
            islsr_next      <= 0;
            isbeq_next      <= 0;
            isbgt_next      <= 0;
            iswb_next       <= 0;
            isubranch_next  <= 0;

            case (instr[15:12])
                ADD_OP: begin
                    isadd_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for add
                end
                SUB_OP: begin
                    issub_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for sub
                end
                MUL_OP: begin
                    ismul_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for mul
                end
                AND_OP: begin
                    isand_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for and
                end
                OR_OP: begin
                    isor_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for or
                end
                NOT_OP: begin
                    isnot_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for not
                end
                MOV_OP: begin
                    ismov_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for mov
                end
                LD_OP: begin
                    isld_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for load
                end
                LSL_OP: begin
                    islsl_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for LSL
                end
                SRL_OP: begin
                    islsr_next <= 1;
                    iswb_next <= 1;    // Writeback enabled for SRL
                end
                ST_OP: begin
                    isst_next <= 1;
                    iswb_next <= 0; // No writeback for store
                end
                CMP_OP: begin
                    iscmp_next <= 1;
                    iswb_next <= 0; // No writeback for compare
                end
                BEQ_OP: begin
                    isbeq_next <= 1;
                    iswb_next <= 0; // No writeback for branch equal
                end
                BGT_OP: begin
                    isbgt_next <= 1;
                    iswb_next <= 0; // No writeback for branch greater
                end
                UBRANCH_OP: begin
                    isubranch_next <= 1;
                    iswb_next <= 0; // No writeback for unconditional branch
                end
                default: ; // Do nothing for unrecognized opcodes
            endcase
        end
        // if(stall) begin
        //     isadd_reg      <= 0;
        //     issub_reg      <= 0;
        //     ismul_reg      <= 0;
        //     isld_reg       <= 0;
        //     isst_reg       <= 0;
        //     iscmp_reg      <= 0;
        //     ismov_reg      <= 0;
        //     isor_reg       <= 0;
        //     isand_reg      <= 0;
        //     isnot_reg      <= 0;
        //     islsl_reg      <= 0;
        //     islsr_reg      <= 0;
        //     isbeq_reg      <= 0;
        //     isbgt_reg      <= 0;
        //     iswb_reg       <= 0;
        //     isubranch_reg  <= 0;
        // end
        // else begin
        isadd_reg      <= isadd_next;
        issub_reg      <= issub_next;
        ismul_reg      <= ismul_next;
        isld_reg       <= isld_next;
        isst_reg       <= isst_next;
        iscmp_reg      <= iscmp_next;
        ismov_reg      <= ismov_next;
        isor_reg       <= isor_next;
        isand_reg      <= isand_next;
        isnot_reg      <= isnot_next;
        islsl_reg      <= islsl_next;
        islsr_reg      <= islsr_next;
        isbeq_reg      <= isbeq_next;
        isbgt_reg      <= isbgt_next;
        iswb_reg       <= iswb_next;
        isubranch_reg  <= isubranch_next;
        // end      
    end
    assign isadd      = isadd_next;
    assign issub      = issub_next;
    assign ismul      = ismul_next;
    assign isld       = isld_next;
    assign isst       = isst_next;
    assign iscmp      = iscmp_next;
    assign ismov      = ismov_next;
    assign isor       = isor_next;
    assign isand      = isand_next;
    assign isnot      = isnot_next;
    assign islsl      = islsl_next;
    assign islsr      = islsr_next;
    assign isbeq      = isbeq_next;
    assign isbgt      = isbgt_next;
    assign iswb       = iswb_next;
    assign isubranch  = isubranch_next;
    // always @(*) begin
    //     if(stall) begin
    //         isadd_reg      <= isadd_next;
    //         issub_reg      <= issub_next;
    //         ismul_reg      <= ismul_next;
    //         isld_reg       <= isld_next;
    //         isst_reg       <= isst_next;
    //         iscmp_reg      <= iscmp_next;
    //         ismov_reg      <= ismov_next;
    //         isor_reg       <= isor_next;
    //         isand_reg      <= isand_next;
    //         isnot_reg      <= isnot_next;
    //         islsl_reg      <= islsl_next;
    //         islsr_reg      <= islsr_next;
    //         isbeq_reg      <= isbeq_next;
    //         isbgt_reg      <= isbgt_next;
    //         iswb_reg       <= iswb_next;
    //         isubranch_reg  <= isubranch_next;
    //     end
    // end
endmodule

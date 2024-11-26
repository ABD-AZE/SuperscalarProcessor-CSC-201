module fetch_unit (
    input wire clk,
    input wire reset,
    input wire stall,
    input wire is_branch_taken,              
    input wire [15:0] branch_target,          
    input wire issingleinstr,
    output wire [15:0] instr1,                
    output wire [15:0] instr2              
);
    reg [15:0] pc;                           
    reg [15:0] instruction_memory [0:10];    
    reg [15:0] buffer [1:0];                 
    reg [15:0] instr1_reg;
    reg [15:0] instr2_reg;
    wire [15:0] buffer0,buffer1;
    assign  buffer0 = buffer[0];
    assign  buffer1 = buffer[1];
    initial begin
        $readmemh("instructions.hex", instruction_memory);
        buffer[0] = instruction_memory[0];    
        buffer[1] = instruction_memory[1];    
        instr1_reg = 16'h0;
        instr2_reg = 16'h0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc = 0;
            buffer[0] = 16'b0; 
            buffer[1] = 16'b0; 
            instr1_reg = 16'h0;
            instr2_reg = 16'h0;
        end 
        else if (is_branch_taken) begin
            pc = branch_target;
            buffer[0] = 16'h0; 
            buffer[1] = 16'h0; 
        end
        else if (stall) begin 
            buffer[0] = buffer[0];
            buffer[1] = buffer[1];
        end 
        else begin
            if (!issingleinstr) begin
                buffer[0] = instruction_memory[pc];    
                buffer[1] = instruction_memory[pc + 1];  
                pc = pc + 2;                              
            end else begin
                buffer[0] = instruction_memory[pc];       
                buffer[1] = 16'h0;                        
                pc = pc + 1;                              
            end
        end

        if (!stall) begin
            instr1_reg = buffer[0];
            instr2_reg = buffer[1];
        end
        else begin
            instr1_reg = 16'h0;
            instr2_reg = 16'h0;
        end
    end

    assign instr1 = instr1_reg;
    assign instr2 = instr2_reg;

endmodule
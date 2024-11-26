    module execute_unit (
        input wire [15:0] brachtarget,
        input wire isunconditionalbranch,
        input wire isBeq,
        input wire isBgt,
        input wire reset,
        input wire clk,
        input wire [127:0] regval,
        output wire [15:0] branchpc,
        output wire isbranchtaken
    ); 
        integer file;
        integer i;
        reg [15:0] reg_file [0:7];
        reg [15:0] branchpc_reg;
        reg isbranchtaken_reg; 
        reg [15:0] branchpc_reg1;
        reg [15:0] isbranchtaken_reg1; 
        initial begin
            branchpc_reg <= 16'b0;
            isbranchtaken_reg <= 0;
        end
        always @(regval) begin
            reg_file[0] = regval[15:0];
            reg_file[1] = regval[31:16];
            reg_file[2] = regval[47:32];
            reg_file[3] = regval[63:48];    
            reg_file[4] = regval[79:64];
            reg_file[5] = regval[95:80];
            reg_file[6] = regval[111:96];
            reg_file[7] = regval[127:112];
        end
        always @(posedge clk) begin
            if (reset) begin
                branchpc_reg <= 16'b0;
                isbranchtaken_reg <= 0;
            end
            else if(isunconditionalbranch || (isBeq && reg_file[7]==1) ||(isBgt && reg_file[7]==2)) begin
                branchpc_reg <= brachtarget;
                isbranchtaken_reg <= 1;
            end 
            else begin
                branchpc_reg <= 16'b0;
                isbranchtaken_reg <= 0;
            end
            branchpc_reg1 <= branchpc_reg;
            isbranchtaken_reg1 <= isbranchtaken_reg;
        end
        assign branchpc = branchpc_reg;
        assign isbranchtaken  = isbranchtaken_reg;
    endmodule

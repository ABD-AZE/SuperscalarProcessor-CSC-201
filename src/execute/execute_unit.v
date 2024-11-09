module execute_unit (
    input wire [15:0] brachtarget,
    input wire isunconditionalbranch,
    input wire isBeq,
    input wire isBgt,
    input wire [127:0] regval,
    output wire [15:0] branchpc,
    output wire isbranchtaken
); 
    integer file;
    integer i;
    reg [15:0] reg_file [0:7];
    reg [15:0] branchpc_reg;
    reg [15:0] isbranchtaken_reg; 
    always @(regval) begin
        // Using a loop to assign 16-bit segments to each reg_file entry
        reg_file[0] = regval[15:0];
        reg_file[1] = regval[31:16];
        reg_file[2] = regval[47:32];
        reg_file[3] = regval[63:48];    
        reg_file[4] = regval[79:64];
        reg_file[5] = regval[95:80];
        reg_file[6] = regval[111:96];
        reg_file[7] = regval[127:112];
        for (i = 0; i < 8; i = i + 1) begin
            $display("reg_file[%0d] = %h", i, reg_file[i]);
        end
    end
    always @(*) begin
        if(isunconditionalbranch || (isBeq && reg_file[7]==1) ||(isBgt && reg_file[7]==2)) begin
            branchpc_reg = brachtarget;
            isbranchtaken_reg = 1;
        end 
        else begin
            branchpc_reg = 16'b0;
            isbranchtaken_reg = 0;
        end
    end
    assign branchpc = branchpc_reg;
    assign isbranchtaken  = isbranchtaken_reg;
endmodule
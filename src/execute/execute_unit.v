module execute_unit (
    input wire [15:0] brachtarget,
    input wire isunconditionalbranch,
    input wire isBeq,
    input wire isBgt,
    output reg [15:0] branchpc,
    output reg isbranchtaken
); 
    reg [15:0] reg_file [7:0];
    initial begin
        $readmemh("registers.hex", reg_file);
    end
    wire flag = reg_file[7];

    always @(*) begin
        if(isunconditionalbranch || (isBeq && reg_file[7]==1) ||(isBgt && reg_file[7]==2)) begin
            branchpc = brachtarget;
            isbranchtaken = 1;
        end
        else begin
            branchpc = 16'b0;
            isbranchtaken = 0;
        end
    end
endmodule
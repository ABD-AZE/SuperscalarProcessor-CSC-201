// update the flags register and do the required calculations
module alu(
    input wire clk,
    input wire [12:0] alusignals,
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
        isxor
    */
    input wire [15:0] op1,
    input wire [15:0] op2,
    input wire [4:0] immx,
    input wire isimmediate,
    output reg [15:0] aluresult
);
    integer file;
    integer i;
    reg [15:0] reg_file [7:0];
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
    wire isxor = alusignals[12];
    reg [15:0] result;
    initial begin
        $readmemh("registers.hex", reg_file);
    end
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
        end else if (iscmp) begin // 1 for equal, 2 for greater than  , 0 for less than 
            result <= A - B;
            if (result == 0) begin
                result <= 16'b1;
                reg_file[7] <= 16'b1;
            end else if (result>0) begin
                result <= 16'b0;
                reg_file[7] <= 16'h2;
            end else begin
                result <= 16'b0;
                reg_file[7] <= 16'h0;
            end
        end else if (ismov) begin
            result <= B;
        end else if (isor) begin
            result <= A | B;
        end else if (isand) begin
            result <= A & B;
        end else if (isnot) begin
            result <= ~A;
        end else if (isxor) begin
            result <= A ^ B;
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
        if (iscmp) begin
            file = $fopen("registers.hex", "w");
            if (file) begin
                $display("Writing modified data...");
                // Write each modified memory value to the new file
                for (i = 0; i < 8; i = i + 1) begin
                    $fwrite(file, "%h\n", reg_file[i]);  // Write as hexadecimal
                end
                $fclose(file);  // Close the file
                $display("Data written to register file successfully.");
            end else begin
                $display("Error: Could not open file for writing.");
            end
        end
    end
endmodule

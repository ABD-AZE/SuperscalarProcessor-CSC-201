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
    output wire [15:0] aluresult
);
    integer file;
    integer i;
    reg [15:0] reg_file [7:0];
    reg [15:0] A;
    reg [15:0] B;
    wire isadd;
    wire isld;
    wire isst;
    wire issub;
    wire ismul;
    wire iscmp;
    wire ismov;
    wire isor;
    wire isand;
    wire isnot;
    wire islsl;
    wire islsr;
    wire isxor;
    assign isadd = alusignals[0];
    assign isld = alusignals[1];
    assign isst = alusignals[2];
    assign issub = alusignals[3];
    assign ismul = alusignals[4];
    assign iscmp = alusignals[5];
    assign ismov = alusignals[6];
    assign isor = alusignals[7];
    assign isand = alusignals[8];
    assign isnot = alusignals[9];
    assign islsl = alusignals[10];
    assign islsr = alusignals[11];
    assign isxor = alusignals[12];

    reg [15:0] result;
    initial begin
        $readmemh("registers.hex", reg_file);
    end
    always @(posedge clk) begin
        if (isimmediate) begin
            A <= op1;
            B <= immx;
        end else begin
            A <= op1;
            B <= op2;
        end
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
    assign aluresult = result;
    always @(*) begin
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

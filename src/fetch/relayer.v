module relayer_unit(
    input wire [15:0] instr1_in,
    input wire [15:0]instr2_in,
    output wire [15:0]instr1_o,
    output wire [15:0]instr2_o,
    output wire issingleinstr,
    output wire isstall
);
    parameter nop = 16'h0;
    reg [15:0] buffer1 [0:1];    
    reg [15:0] buffer2 [0:1];
    reg [15:0] singinstr;
    integer i = 0;
    integer p=0;
    initial begin
        buffer1[0] = 16'b0;
        buffer1[1] = 16'b0;
        buffer2[0] = 16'b0;
        buffer2[1] = 16'b0;
        singinstr = 16'b0;
        issingleinstr_reg = 0;
        isstall_reg = 0;
    end
    reg [15:0] instr1;
    reg [15:0] instr2;
    reg isstall_reg;
    reg [15:0] instr1_out;
    reg [15:0] instr2_out;
    reg issingleinstr_reg;
    always @(*) begin
        instr1 = instr1_in;
        instr2 = instr2_in;
        if (singinstr[15:12] != 4'b0) begin
            instr2 = instr1;
            instr1 = singinstr;
        end
        if (instr1[15:12] == nop && instr2[15:12] == nop) begin
            instr1_out=nop;
            instr2_out=nop;
            isstall_reg=0;
        end
        else if(instr1[15:12] == nop) begin
            instr1_out=nop;
            for(i=0;i<2;i=i+1) begin
                if(buffer1[i][15:12]!=nop) begin 
                    if(!((buffer1[i][10:8]!=instr2[7:5]&&instr2[11]==1)||(buffer1[i][10:8]!=instr2[7:5]&&buffer1[i][10:8]!=instr2[4:2]&&instr2[11]==0))) begin
                        p=1;
                    end
                end
            end
            if(p==0) begin
                for(i=0;i<2;i=i+1) begin
                    if(buffer2[i][15:12]!=nop) begin
                        if(!((buffer2[i][10:8]!=instr2[7:5]&&instr2[11]==1)||(buffer2[i][10:8]!=instr2[7:5]&&buffer2[i][10:8]!=instr2[4:2]&&instr2[11]==0))) begin
                            p=1;
                        end
                    end
                end
                if(p==0) begin
                    instr2_out=instr2;
                end
                else begin
                    instr2_out=nop;
                end
            end
            else begin
                instr2_out=nop;
            end
        end
        else begin
            for(i=0;i<2;i=i+1) begin
                if(buffer1[i][15:12]!=nop) begin 
                    if(!((buffer1[i][10:8]!=instr1[7:5]&&instr1[11]==1)||(buffer1[i][10:8]!=instr1[7:5]&&buffer1[i][10:8]!=instr1[4:2]&&instr1[11]==0))) begin
                        p=1;
                    end
                end
            end
            if(p==0) begin
                for(i=0;i<2;i=i+1) begin
                    if(buffer2[i][15:12]!=nop) begin
                        if(!((buffer2[i][10:8]!=instr1[7:5]&&instr1[11]==1)||(buffer2[i][10:8]!=instr1[7:5]&&buffer2[i][10:8]!=instr1[4:2]&&instr1[11]==0))) begin
                            p=1;
                        end
                    end
                end
            end
            if(p==1) begin
                instr1_out = nop;
                instr2_out = nop;
                isstall_reg = 1;
            end
            else begin
                instr1_out = instr1;
                if(instr1!=nop) begin
                    if(!(((instr2[10:8] != instr1[10:8])&&(instr2[10:8]!=instr1[7:5])&&(instr1[11]==1))||((instr2[10:8] != instr1[10:8])&&(instr2[10:8]!=instr1[7:5])&&(instr1[11]==0)&&instr2[10:8]!=instr1[4:2])&&(((instr1[10:8] != instr2[10:8])&&(instr1[10:8]!=instr2[7:5])&&(instr2[11]==1))||((instr1[10:8] != instr2[10:8])&&(instr1[10:8]!=instr2[7:5])&&(instr2[11]==0)&&instr1[10:8]!=instr2[4:2])))) begin
                        p=1;              
                    end     
                    if (p==1) begin
                        instr2_out = nop;
                    end
                end
                else begin
                    p=0;
                end
                if(p==0) begin
                    for(i=0;i<2;i=i+1) begin
                        if(buffer2[i][15:12]!=nop) begin
                            if(!((buffer2[i][10:8]!=instr2[7:5]&&instr2[11]==1)||(buffer2[i][10:8]!=instr2[7:5]&&buffer2[i][10:8]!=instr2[4:2]&&instr2[11]==0))) begin
                                p=1;
                            end
                        end
                    end
                    if(p==0) begin
                        for(i=0;i<2;i=i+1) begin
                            if(buffer1[i][15:12]!=nop) begin
                                if(!((buffer1[i][10:8]!=instr2[7:5]&&instr2[11]==1)||(buffer1[i][10:8]!=instr2[7:5]&&buffer1[i][10:8]!=instr2[4:2]&&instr2[11]==0))) begin
                                    p=1;
                                end
                            end
                        end
                    end
                    if (p==0) begin
                        instr2_out = instr2;
                    end
                    else begin
                        instr2_out = nop;
                    end
                end
                else begin
                    instr2_out = nop;
                end
            end
        end
        for(i=1;i<2;i=i+1) begin
            buffer1[i] = buffer1[i-1];
            buffer2[i] = buffer2[i-1];
        end
        buffer1[0]=instr1_out;
        buffer2[0]=instr2_out;
        if(instr1_out==instr1&&instr2_out!=instr2) begin
            singinstr = instr2;
            issingleinstr_reg = 1;
        end
        else if(instr1_out!=instr1&&instr2_out==instr2) begin
            singinstr = instr1;
            issingleinstr_reg = 1;
        end
        else begin
            issingleinstr_reg = 0;
        end
    end
    assign instr1_o = instr1_out;
    assign instr2_o = instr2_out;
    assign issingleinstr = issingleinstr_reg;
    assign isstall = isstall_reg;
endmodule

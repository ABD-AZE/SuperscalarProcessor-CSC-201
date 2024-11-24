module Top_tb;
    // Instantiate top pipeline module
    top_module top_module();

    // VCD dump for waveform viewing
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, Top_tb);
        #1000;
        $finish;
    end
endmodule

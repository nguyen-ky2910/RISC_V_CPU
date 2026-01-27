`timescale 1ns / 1ps

module tb_RISC_V_CPU();

    reg clk;
    reg rst_n;

    // G?i Module CPU
    RISC_V_CPU caoky (
        .clk(clk),
        .rst_n(rst_n)
    );

    // T?o Clock (Chu k? 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Ch?y mô ph?ng
    initial begin
      

        // Reset CPU
        rst_n = 0;
        #20;
        rst_n = 1;

        // Ch?y trong 200ns r?i d?ng
        #200;
        $finish;
    end

endmodule
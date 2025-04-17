`timescale 1ns / 1ps

// Testbench cho mô-đun Writeback Cycle
module tb_Writeback_Cycle();

    // Khai báo tín hiệu
    reg clk, rst;                       // Clock và reset (chưa dùng)
    reg ResultSrcW;                     // Tín hiệu chọn kết quả
    reg [31:0] PCPlus4W, ALU_ResultW, ReadDataW; // Dữ liệu đầu vào
    wire [31:0] ResultW;                // Kết quả

    // Tích hợp DUT
    writeback_cycle dut (
        .clk(clk),
        .rst(rst),
        .ResultSrcW(ResultSrcW),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW),
        .ResultW(ResultW)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Writeback Cycle...");
        $monitor("Time=%0t | ResultSrcW=%b | ALU_ResultW=%h | ReadDataW=%h | ResultW=%h",
                 $time, ResultSrcW, ALU_ResultW, ReadDataW, ResultW);

        // Khởi tạo
        rst = 0; #20; rst = 1; // Reset
        ResultSrcW = 0; ALU_ResultW = 32'h0000000A; ReadDataW = 32'h0000000B; PCPlus4W = 32'h00000004;
        #20; // Chọn ALU_ResultW
        ResultSrcW = 1; #20; // Chọn ReadDataW

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("writeback_cycle.vcd");
        $dumpvars(0, tb_Writeback_Cycle);
    end

endmodule
`timescale 1ns / 1ps

// Testbench cho mô-đun Pipeline Top
module tb_Pipeline_Top();

    // Khai báo tín hiệu
    reg clk, rst;               // Clock và reset

    // Tích hợp DUT
    Pipeline_top dut (
        .clk(clk),
        .rst(rst)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Pipeline Top...");
        $monitor("Time=%0t | PC=%h | InstrD=%h | ALU_ResultM=%h",
                 $time, dut.fetch.PCD, dut.fetch.InstrD, dut.execute.ALU_ResultM);

        // Khởi tạo
        rst = 0; #20; rst = 1; // Reset
        #200; // Chạy 10 chu kỳ để thực thi các lệnh nạp sẵn

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("pipeline_top.vcd");
        $dumpvars(0, tb_Pipeline_Top);
    end

endmodule
// Định nghĩa testbench để mô phỏng Pipeline Top
`timescale 1ns / 1ps
module tb();

    // Khai báo tín hiệu
    reg clk = 0;                    // Clock khởi tạo bằng 0
    reg rst;                        // Tín hiệu reset

    // Tạo clock với chu kỳ 200ns
    always #100 clk = ~clk;         // Đảo trạng thái clock mỗi 100ns

    // Khởi tạo reset và thời gian mô phỏng
    initial begin
        rst = 1'b0;                 // Đặt reset xuống 0 (active-low)
        #200;                       // Giữ reset trong 200ns
        rst = 1'b1;                 // Bỏ reset
        #1000;                      // Chạy mô phỏng thêm 1000ns
        $finish;                    // Kết thúc mô phỏng
    end

    // Hiển thị thông báo bắt đầu
    initial begin
        $display("Running simulation..."); // In thông báo
        $timeformat(-9, 2, " ns", 10);    // Định dạng thời gian (ns, 2 chữ số thập phân)
    end

    // Tích hợp DUT (Device Under Test)
    Pipeline_top dut (
        .clk(clk),                  // Truyền clock
        .rst(rst)                   // Truyền reset
    );

endmodule
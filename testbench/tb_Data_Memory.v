`timescale 1ns / 1ps

// Testbench cho mô-đun Data Memory
module tb_Data_Memory();

    // Khai báo tín hiệu
    reg clk, rst;               // Clock và reset
    reg WE;                     // Tín hiệu ghi
    reg [31:0] A, WD;           // Địa chỉ và dữ liệu ghi
    wire [31:0] RD;             // Dữ liệu đọc

    // Tích hợp DUT
    Data_Memory dut (
        .clk(clk),
        .rst(rst),
        .WE(WE),
        .A(A),
        .WD(WD),
        .RD(RD)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Data Memory...");
        $monitor("Time=%0t | A=%h | WE=%b | WD=%h | RD=%h",
                 $time, A, WE, WD, RD);

        // Khởi tạo
        rst = 0; #20; rst = 1; // Reset trong 20ns
        WE = 0; A = 32'h00000004; WD = 32'h00000000; #20; // Đọc mem[1] = 6
        A = 32'h00000000; #20; // Đọc mem[0] = 0

        // Kiểm tra ghi
        WE = 1; A = 32'h00000008; WD = 32'h0000000A; #20; // Ghi mem[2] = 10
        WE = 0; #20; // Đọc lại mem[2]

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("data_memory.vcd");
        $dumpvars(0, tb_Data_Memory);
    end

endmodule
`timescale 1ns / 1ps

// Testbench cho mô-đun Register File
module tb_Register_File();

    // Khai báo tín hiệu
    reg clk, rst, WE3;          // Clock, reset, tín hiệu ghi
    reg [4:0] A1, A2, A3;       // Địa chỉ thanh ghi
    reg [31:0] WD3;             // Dữ liệu ghi
    wire [31:0] RD1, RD2;       // Dữ liệu đọc

    // Tích hợp DUT
    Register_File dut (
        .clk(clk),
        .rst(rst),
        .WE3(WE3),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Register File...");
        $monitor("Time=%0t | A1=%h | A2=%h | A3=%h | WE3=%b | WD3=%h | RD1=%h | RD2=%h",
                 $time, A1, A2, A3, WE3, WD3, RD1, RD2);

        // Khởi tạo
        rst = 0; WE3 = 0; A1 = 5'h00; A2 = 5'h00; A3 = 5'h00; WD3 = 32'h00000000;
        #20; rst = 1; // Reset

        // Kiểm tra ghi và đọc
        WE3 = 1; A3 = 5'h05; WD3 = 32'h0000000A; #20; // Ghi x5 = 10
        A1 = 5'h05; A2 = 5'h05; #20; // Đọc x5
        WE3 = 1; A3 = 5'h06; WD3 = 32'h0000000B; #20; // Ghi x6 = 11
        A1 = 5'h05; A2 = 5'h06; #20; // Đọc x5, x6

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("register_file.vcd");
        $dumpvars(0, tb_Register_File);
    end

endmodule
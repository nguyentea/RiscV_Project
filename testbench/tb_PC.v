`timescale 1ns / 1ps

// Testbench cho mô-đun PC Module
module tb_PC();

    // Khai báo tín hiệu
    reg clk, rst;               // Clock và reset
    reg [31:0] PC_Next;         // PC tiếp theo
    wire [31:0] PC;             // PC hiện tại

    // Tích hợp DUT
    PC_Module dut (
        .clk(clk),
        .rst(rst),
        .PC_Next(PC_Next),
        .PC(PC)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra PC Module...");
        $monitor("Time=%0t | PC_Next=%h | PC=%h",
                 $time, PC_Next, PC);

        // Khởi tạo
        rst = 0; PC_Next = 32'h00000000; #20; rst = 1; // Reset
        PC_Next = 32'h00000004; #20; // Cập nhật PC = 4
        PC_Next = 32'h00000008; #20; // Cập nhật PC = 8

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("pc.vcd");
        $dumpvars(0, tb_PC);
    end

endmodule
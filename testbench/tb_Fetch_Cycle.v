`timescale 1ns / 1ps

// Testbench cho mô-đun Fetch Cycle
module tb_Fetch_Cycle();

    // Khai báo tín hiệu
    reg clk, rst;               // Clock và reset
    reg PCSrcE;                 // Tín hiệu chọn PC
    reg [31:0] PCTargetE;       // Địa chỉ nhảy
    wire [31:0] InstrD, PCD, PCPlus4D; // Đầu ra

    // Tích hợp DUT
    fetch_cycle dut (
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Fetch Cycle...");
        $monitor("Time=%0t | PCD=%h | InstrD=%h | PCPlus4D=%h",
                 $time, PCD, InstrD, PCPlus4D);

        // Khởi tạo
        rst = 0; PCSrcE = 0; PCTargetE = 32'h00000000; #20; rst = 1; // Reset
        #20; // Lấy lệnh đầu tiên (PC=0)
        PCSrcE = 1; PCTargetE = 32'h00000010; #20; // Nhảy đến PC=16
        PCSrcE = 0; #20; // Tiếp tục PC+4

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("fetch_cycle.vcd");
        $dumpvars(0, tb_Fetch_Cycle);
    end

endmodule
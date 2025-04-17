`timescale 1ns / 1ps

// Testbench cho mô-đun Hazard Unit
module tb_Hazard_unit();

    // Khai báo tín hiệu
    reg rst;                    // Reset
    reg RegWriteM, RegWriteW;   // Tín hiệu ghi thanh ghi
    reg [4:0] RD_M, RD_W, Rs1_E, Rs2_E; // Thanh ghi đích và nguồn
    wire [1:0] ForwardAE, ForwardBE; // Tín hiệu forwarding

    // Tích hợp DUT
    hazard_unit dut (
        .rst(rst),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RD_M(RD_M),
        .RD_W(RD_W),
        .Rs1_E(Rs1_E),
        .Rs2_E(Rs2_E),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Hazard Unit...");
        $monitor("Time=%0t | Rs1_E=%h | Rs2_E=%h | RD_M=%h | RD_W=%h | ForwardAE=%b | ForwardBE=%b",
                 $time, Rs1_E, Rs2_E, RD_M, RD_W, ForwardAE, ForwardBE);

        // Khởi tạo
        rst = 0; #10; rst = 1; // Reset trong 10ns
        RegWriteM = 0; RegWriteW = 0;
        RD_M = 5'h00; RD_W = 5'h00;
        Rs1_E = 5'h05; Rs2_E = 5'h06;
        #10; // Không forward

        // Kiểm tra forwarding từ Memory
        RegWriteM = 1; RD_M = 5'h05; #10; // ForwardAE = 10
        // Kiểm tra forwarding từ Write-back
        RegWriteM = 0; RegWriteW = 1; RD_W = 5'h06; #10; // ForwardBE = 01

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("hazard_unit.vcd");
        $dumpvars(0, tb_Hazard_unit);
    end

endmodule
`timescale 1ns / 1ps

// Testbench cho mô-đun Sign Extend
module tb_Sign_Extend();

    // Khai báo tín hiệu
    reg [31:0] In;              // Lệnh đầu vào
    reg [1:0] ImmSrc;           // Chọn loại immediate
    wire [31:0] Imm_Ext;        // Immediate mở rộng

    // Tích hợp DUT
    Sign_Extend dut (
        .In(In),
        .ImmSrc(ImmSrc),
        .Imm_Ext(Imm_Ext)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Sign Extend...");
        $monitor("Time=%0t | In=%h | ImmSrc=%b | Imm_Ext=%h",
                 $time, In, ImmSrc, Imm_Ext);

        // Kiểm tra I-type
        In = 32'h00500313; ImmSrc = 2'b00; #10; // addi x6, x0, 5
        // Kiểm tra S-type
        In = 32'h0064A423; ImmSrc = 2'b01; #10; // sw x6, 8(x9)
        // Kiểm tra trường hợp mặc định
        ImmSrc = 2'b10; #10; // Mặc định = 0

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("sign_extend.vcd");
        $dumpvars(0, tb_Sign_Extend);
    end

endmodule
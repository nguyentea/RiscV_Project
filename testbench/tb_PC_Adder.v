`timescale 1ns / 1ps

// Testbench cho mô-đun PC Adder
module tb_PC_Adder();

    // Khai báo tín hiệu
    reg [31:0] a, b;            // Toán hạng đầu vào
    wire [31:0] c;              // Kết quả cộng

    // Tích hợp DUT
    PC_Adder dut (
        .a(a),
        .b(b),
        .c(c)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra PC Adder...");
        $monitor("Time=%0t | a=%h | b=%h | c=%h",
                 $time, a, b, c);

        // Kiểm tra các trường hợp
        a = 32'h00000000; b = 32'h00000004; #10; // 0 + 4 = 4
        a = 32'h00000010; b = 32'h00000008; #10; // 16 + 8 = 24
        a = 32'h000000FF; b = 32'h00000001; #10; // 255 + 1 = 256

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("pc_adder.vcd");
        $dumpvars(0, tb_PC_Adder);
    end

endmodule
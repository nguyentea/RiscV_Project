`timescale 1ns / 1ps

// Testbench cho mô-đun Mux và Mux_3_by_1
module tb_Mux();

    // Khai báo tín hiệu cho Mux 2-to-1
    reg [31:0] a, b;            // Đầu vào
    reg s;                      // Tín hiệu chọn
    wire [31:0] c;              // Đầu ra

    // Khai báo tín hiệu cho Mux 3-to-1
    reg [31:0] a3, b3, c3;      // Đầu vào
    reg [1:0] s3;               // Tín hiệu chọn
    wire [31:0] d;              // Đầu ra

    // Tích hợp DUT
    Mux mux2 (
        .a(a),
        .b(b),
        .s(s),
        .c(c)
    );

    Mux_3_by_1 mux3 (
        .a(a3),
        .b(b3),
        .c(c3),
        .s(s3),
        .d(d)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Mux...");
        $monitor("Time=%0t | Mux2: a=%h | b=%h | s=%b | c=%h | Mux3: a3=%h | b3=%h | c3=%h | s3=%b | d=%h",
                 $time, a, b, s, c, a3, b3, c3, s3, d);

        // Kiểm tra Mux 2-to-1
        a = 32'h0000000A; b = 32'h0000000B; s = 0; #10; // Chọn a
        s = 1; #10; // Chọn b

        // Kiểm tra Mux 3-to-1
        a3 = 32'h0000000A; b3 = 32'h0000000B; c3 = 32'h0000000C;
        s3 = 2'b00; #10; // Chọn a3
        s3 = 2'b01; #10; // Chọn b3
        s3 = 2'b10; #10; // Chọn c3

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("mux.vcd");
        $dumpvars(0, tb_Mux);
    end

endmodule
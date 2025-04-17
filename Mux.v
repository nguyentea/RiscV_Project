// Định nghĩa mô-đun Mux, bao gồm Mux 2-to-1 và 3-to-1
module Mux (
    input [31:0] a, b,      // Hai đầu vào 32-bit
    input s,                // Tín hiệu chọn
    output [31:0] c         // Đầu ra 32-bit
);

    // Logic Mux 2-to-1: chọn a nếu s=0, b nếu s=1
    assign c = (~s) ? a : b;

endmodule

// Định nghĩa mô-đun Mux 3-to-1
module Mux_3_by_1 (
    input [31:0] a, b, c,   // Ba đầu vào 32-bit
    input [1:0] s,          // Tín hiệu chọn 2-bit
    output [31:0] d         // Đầu ra 32-bit
);

    // Logic Mux 3-to-1
    assign d = (s == 2'b00) ? a :           // Chọn a nếu s=00
               (s == 2'b01) ? b :           // Chọn b nếu s=01
               (s == 2'b10) ? c :           // Chọn c nếu s=10
               32'h00000000;                // Mặc định trả về 0 nếu s=11

endmodule
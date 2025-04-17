// Định nghĩa mô-đun PC Adder tính PC+4 hoặc địa chỉ nhảy
module PC_Adder (
    input [31:0] a, b,      // Hai toán hạng 32-bit (PC, offset)
    output [31:0] c         // Kết quả cộng
);

    // Logic cộng
    assign c = a + b;

endmodule
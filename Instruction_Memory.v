// Định nghĩa mô-đun Instruction Memory lưu trữ lệnh RISC-V
module Instruction_Memory (
    input [31:0] A,     // Địa chỉ đọc lệnh (PC) 32-bit
    output [31:0] RD    // Lệnh đọc ra 32-bit
);

    // Mảng bộ nhớ lưu trữ lệnh, kích thước 256 word (1KB)
    reg [31:0] mem [0:255];

    // Khởi tạo bộ nhớ với các lệnh mẫu
    initial begin
        mem[0] = 32'hFFC4A303;  // Lệnh lw x6, -4(x9)
        mem[1] = 32'h00832383;  // Lệnh lw x7, 8(x6)
        mem[2] = 32'h0064A423;  // Lệnh sw x6, 8(x9)
        mem[3] = 32'h00B62423;  // Lệnh sw x11, 8(x12)
        mem[4] = 32'h0062E233;  // Lệnh or x4, x5, x6
        mem[5] = 32'h00B62423;  // Lệnh sw x11, 8(x12)
    end

    // Gán lệnh đọc từ bộ nhớ tại địa chỉ A chia cho 4 (word addressing)
    assign RD = mem[A >> 2];

endmodule
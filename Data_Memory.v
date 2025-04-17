// Định nghĩa mô-đun Data Memory lưu trữ dữ liệu
module Data_Memory (
    input clk, rst,             // Clock và reset
    input WE,                   // Tín hiệu ghi (Write Enable)
    input [31:0] A, WD,         // Địa chỉ và dữ liệu ghi
    output [31:0] RD            // Dữ liệu đọc
);

    // Mảng bộ nhớ, kích thước 256 word (1KB)
    reg [31:0] mem [0:255];

    // Khởi tạo bộ nhớ với dữ liệu mẫu
    initial begin
        mem[0] = 32'h00000000;  // Địa chỉ 0: 0
        mem[1] = 32'h00000006;  // Địa chỉ 1: 6
        mem[2] = 32'h00000000;  // Địa chỉ 2: 0
        mem[3] = 32'h00000000;  // Địa chỉ 3: 0
    end

    // Logic ghi đồng bộ
    always @(posedge clk) begin
        if (WE)                 // Nếu tín hiệu ghi bật
            mem[A >> 2] <= WD;  // Ghi dữ liệu vào địa chỉ A chia 4
    end

    // Gán dữ liệu đọc từ bộ nhớ
    assign RD = (rst == 1'b0) ? 32'h00000000 : mem[A >> 2];

endmodule
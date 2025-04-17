// Định nghĩa mô-đun Register File lưu trữ 32 thanh ghi 32-bit
module Register_File (
    input clk, rst, WE3,        // Clock, reset, tín hiệu ghi
    input [4:0] A1, A2, A3,     // Địa chỉ thanh ghi đọc (rs1, rs2) và ghi (rd)
    input [31:0] WD3,           // Dữ liệu ghi
    output [31:0] RD1, RD2      // Dữ liệu đọc từ rs1, rs2
);

    // Mảng 32 thanh ghi 32-bit
    reg [31:0] Register [31:0];

    // Logic ghi đồng bộ
    always @(posedge clk) begin
        if (WE3 & (A3 != 5'h00))    // Nếu tín hiệu ghi bật và A3 không phải x0
            Register[A3] <= WD3;    // Ghi dữ liệu vào thanh ghi A3
    end

    // Gán dữ liệu đọc
    assign RD1 = (rst == 1'b0) ? 32'd0 : Register[A1]; // Đọc từ A1, trả 0 nếu reset
    assign RD2 = (rst == 1'b0) ? 32'd0 : Register[A2]; // Đọc từ A2, trả 0 nếu reset

    // Khởi tạo tất cả thanh ghi về 0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            Register[i] = 32'h00000000;
    end

endmodule
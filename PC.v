// Định nghĩa mô-đun PC Module lưu trữ Program Counter
module PC_Module (
    input clk,                      // Clock
    input rst,                      // Reset
    input [31:0] PC_Next,           // PC tiếp theo
    output reg [31:0] PC            // PC hiện tại
);

    // Logic cập nhật PC
    always @(posedge clk) begin
        if (rst == 1'b0)            // Nếu reset, đặt PC về 0
            PC <= 32'b0;
        else                        // Nếu không, cập nhật PC từ PC_Next
            PC <= PC_Next;
    end

endmodule
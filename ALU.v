// Định nghĩa mô-đun ALU (Arithmetic Logic Unit) thực hiện các phép toán số học và logic
module ALU (
    input [31:0] A, B,              // Hai toán hạng đầu vào 32-bit
    input [2:0] ALUControl,         // Tín hiệu điều khiển chọn phép toán (3-bit)
    output reg [31:0] ALU_Result,   // Kết quả phép toán 32-bit
    output Zero                     // Cờ Zero, bằng 1 nếu kết quả là 0
);

    // Khối always xử lý các phép toán dựa trên ALUControl
    always @(*) begin
        case (ALUControl)
            3'b000: ALU_Result = A + B;            // Phép cộng
            3'b001: ALU_Result = A - B;            // Phép trừ
            3'b010: ALU_Result = A & B;            // Phép AND
            3'b011: ALU_Result = A | B;            // Phép OR
            3'b100: ALU_Result = A ^ B;            // Phép XOR
            3'b101: ALU_Result = ($signed(A) < $signed(B)) ? 32'h00000001 : 32'h00000000; // Phép so sánh nhỏ hơn (SLT)
            default: ALU_Result = 32'h00000000;    // Mặc định trả về 0 nếu ALUControl không hợp lệ
        endcase
    end

    // Gán cờ Zero: bằng 1 nếu ALU_Result là 0, ngược lại là 0
    assign Zero = (ALU_Result == 32'h00000000) ? 1'b1 : 1'b0;

endmodule
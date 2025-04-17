// Định nghĩa mô-đun Main Decoder tạo tín hiệu điều khiển từ opcode
module Main_Decoder (
    input [6:0] Op,                     // Opcode 7-bit
    output RegWrite,                    // Tín hiệu ghi thanh ghi
    output [1:0] ImmSrc,                // Tín hiệu chọn loại immediate
    output MemWrite, ResultSrc, Branch, // Tín hiệu ghi bộ nhớ, chọn kết quả, nhánh
    output ALUSrc,                      // Tín hiệu chọn nguồn ALU
    output [1:0] ALUOp                  // Tín hiệu điều khiển ALU
);

    // Dây kết nối nội bộ cho các tín hiệu điều khiển
    reg [8:0] controls;

    // Gán các tín hiệu điều khiển từ controls
    assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp} = controls;

    // Logic giải mã opcode
    always @(*) begin
        case(Op)
            7'b0000011: controls = 9'b100100100; // Load (lw)
            7'b0100011: controls = 9'b001101000; // Store (sw)
            7'b0110011: controls = 9'b100000010; // R-type
            7'b0010011: controls = 9'b100100000; // I-type (như addi)
            7'b1100011: controls = 9'b010000001; // Branch (beq)
            default: controls = 9'b000000000;    // Mặc định: không hoạt động
        endcase
    end

endmodule
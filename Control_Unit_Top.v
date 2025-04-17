// Định nghĩa mô-đun Control Unit tổng hợp, tạo tín hiệu điều khiển cho pipeline
module Control_Unit_Top (
    input [6:0] Op, funct7,         // Opcode (7-bit) và funct7 (7-bit) từ lệnh
    input [2:0] funct3,             // funct3 (3-bit) từ lệnh
    output RegWrite, ALUSrc,        // Tín hiệu điều khiển: ghi thanh ghi, chọn nguồn ALU
    output MemWrite, ResultSrc,     // Tín hiệu điều khiển: ghi bộ nhớ, chọn kết quả
    output Branch,                  // Tín hiệu điều khiển nhánh
    output [1:0] ImmSrc,            // Tín hiệu chọn loại immediate
    output [2:0] ALUControl         // Tín hiệu điều khiển ALU
);

    // Dây kết nối nội bộ cho ALUOp từ Main Decoder
    wire [1:0] ALUOp;

    // Tích hợp mô-đun Main Decoder
    Main_Decoder main_decoder_inst (
        .Op(Op),                    // Truyền opcode vào Main Decoder
        .RegWrite(RegWrite),        // Nhận tín hiệu ghi thanh ghi
        .ImmSrc(ImmSrc),            // Nhận tín hiệu chọn immediate
        .MemWrite(MemWrite),        // Nhận tín hiệu ghi bộ nhớ
        .ResultSrc(ResultSrc),      // Nhận tín hiệu chọn kết quả
        .Branch(Branch),            // Nhận tín hiệu nhánh
        .ALUSrc(ALUSrc),            // Nhận tín hiệu chọn nguồn ALU
        .ALUOp(ALUOp)               // Nhận tín hiệu ALUOp
    );

    // Tích hợp mô-đun ALU Decoder
    ALU_Decoder alu_decoder_inst (
        .ALUOp(ALUOp),              // Truyền ALUOp từ Main Decoder
        .funct3(funct3),            // Truyền funct3 từ đầu vào
        .funct7(funct7),
        //.funct7(funct7[5]),         // Truyền bit 5 của funct7 (chỉ dùng cho ADD/SUB)
        .ALUControl(ALUControl)     // Nhận tín hiệu điều khiển ALU
    );

endmodule
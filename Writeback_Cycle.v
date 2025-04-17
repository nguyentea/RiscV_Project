// Định nghĩa mô-đun Writeback Cycle, xử lý giai đoạn ghi ngược
module writeback_cycle (
    input clk, rst,                     // Clock và reset (chưa dùng)
    input ResultSrcW,                   // Tín hiệu chọn kết quả
    input [31:0] PCPlus4W,              // PC+4 từ Memory
    input [31:0] ALU_ResultW,           // Kết quả ALU từ Memory
    input [31:0] ReadDataW,             // Dữ liệu đọc từ Memory
    output [31:0] ResultW               // Kết quả cuối cùng
);

    // Tích hợp mô-đun Mux để chọn kết quả
    Mux result_mux (
        .a(ALU_ResultW),                // Chọn kết quả ALU
        .b(ReadDataW),                  // Chọn dữ liệu từ bộ nhớ
        .s(ResultSrcW),                 // Tín hiệu chọn
        .c(ResultW)                     // Kết quả cuối
    );

endmodule
`timescale 1ns / 1ps

// Testbench cho mô-đun Main Decoder
module tb_Main_Decoder();

    // Khai báo tín hiệu
    reg [6:0] Op;               // Opcode
    wire RegWrite, ALUSrc, MemWrite, ResultSrc, Branch; // Tín hiệu điều khiển
    wire [1:0] ImmSrc, ALUOp;   // Chọn immediate và ALUOp

    // Tích hợp DUT
    Main_Decoder dut (
        .Op(Op),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Main Decoder...");
        $monitor("Time=%0t | Op=%h | RegWrite=%b | ImmSrc=%b | ALUSrc=%b | MemWrite=%b | ResultSrc=%b | Branch=%b | ALUOp=%b",
                 $time, Op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp);

        // Kiểm tra các loại lệnh
        Op = 7'b0000011; #10; // Load (lw)
        Op = 7'b0100011; #10; // Store (sw)
        Op = 7'b0110011; #10; // R-type
        Op = 7'b0010011; #10; // I-type
        Op = 7'b1100011; #10; // Branch
        Op = 7'b1111111; #10; // Opcode không hợp lệ

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("main_decoder.vcd");
        $dumpvars(0, tb_Main_Decoder);
    end

endmodule
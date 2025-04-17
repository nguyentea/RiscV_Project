`timescale 1ns / 1ps

// Testbench cho mô-đun Control Unit Top
module tb_Control_Unit_Top();

    // Khai báo tín hiệu
    reg [6:0] Op, funct7;       // Opcode và funct7
    reg [2:0] funct3;           // funct3
    wire RegWrite, ALUSrc, MemWrite, ResultSrc, Branch; // Tín hiệu điều khiển
    wire [1:0] ImmSrc;          // Chọn immediate
    wire [2:0] ALUControl;      // Điều khiển ALU

    // Tích hợp DUT
    Control_Unit_Top dut (
        .Op(Op),
        .funct7(funct7),
        .funct3(funct3),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ImmSrc(ImmSrc),
        .ALUControl(ALUControl)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Control Unit Top...");
        $monitor("Time=%0t | Op=%h | funct7=%h | funct3=%h | RegWrite=%b | ALUSrc=%b | MemWrite=%b | ResultSrc=%b | Branch=%b | ImmSrc=%b | ALUControl=%b",
                 $time, Op, funct7, funct3, RegWrite, ALUSrc, MemWrite, ResultSrc, Branch, ImmSrc, ALUControl);

        // Kiểm tra các loại lệnh
        Op = 7'b0000011; funct3 = 3'b000; funct7 = 7'h00; #10; // Load (lw)
        Op = 7'b0100011; funct3 = 3'b000; funct7 = 7'h00; #10; // Store (sw)
        Op = 7'b0110011; funct3 = 3'b000; funct7 = 7'h00; #10; // R-type ADD
        Op = 7'b0110011; funct3 = 3'b000; funct7 = 7'h20; #10; // R-type SUB
        Op = 7'b0110011; funct3 = 3'b111; funct7 = 7'h00; #10; // R-type AND
        Op = 7'b1100011; funct3 = 3'b000; funct7 = 7'h00; #10; // Branch (beq)

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("control_unit.vcd");
        $dumpvars(0, tb_Control_Unit_Top);
    end

endmodule
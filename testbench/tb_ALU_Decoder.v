`timescale 1ns / 1ps

// Testbench cho mô-đun ALU Decoder
module tb_ALU_Decoder();

    // Khai báo tín hiệu
    reg [1:0] ALUOp;            // ALUOp
    reg [2:0] funct3;           // funct3
    reg [6:0] funct7;           // funct7
    wire [2:0] ALUControl;      // Điều khiển ALU

    // Tích hợp DUT
    ALU_Decoder dut (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUControl)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra ALU Decoder...");
        $monitor("Time=%0t | ALUOp=%b | funct3=%b | funct7=%h | ALUControl=%b",
                 $time, ALUOp, funct3, funct7, ALUControl);

        // Kiểm tra các trường hợp
        ALUOp = 2'b00; funct3 = 3'b000; funct7 = 7'h00; #10; // Load/Store: ADD
        ALUOp = 2'b01; funct3 = 3'b000; funct7 = 7'h00; #10; // Branch: SUB
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'h00; #10; // R-type: ADD
        ALUOp = 2'b10; funct3 = 3'b000; funct7 = 7'h20; #10; // R-type: SUB
        ALUOp = 2'b10; funct3 = 3'b111; funct7 = 7'h00; #10; // R-type: AND
        ALUOp = 2'b10; funct3 = 3'b110; funct7 = 7'h00; #10; // R-type: OR

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("alu_decoder.vcd");
        $dumpvars(0, tb_ALU_Decoder);
    end

endmodule
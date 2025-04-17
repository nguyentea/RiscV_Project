`timescale 1ns / 1ps

// Testbench cho mô-đun ALU
module tb_ALU();

    // Khai báo tín hiệu
    reg [31:0] A, B;            // Toán hạng đầu vào
    reg [2:0] ALUControl;       // Tín hiệu điều khiển ALU
    wire [31:0] ALU_Result;     // Kết quả ALU
    wire Zero;                  // Cờ Zero

    // Tích hợp DUT
    ALU dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALU_Result(ALU_Result),
        .Zero(Zero)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra ALU...");
        $monitor("Time=%0t | A=%h | B=%h | ALUControl=%b | ALU_Result=%h | Zero=%b",
                 $time, A, B, ALUControl, ALU_Result, Zero);

        // Kiểm tra các phép toán
        A = 32'h0000000A; B = 32'h00000005; // A=10, B=5
        ALUControl = 3'b000; #10; // ADD: 10 + 5 = 15
        ALUControl = 3'b001; #10; // SUB: 10 - 5 = 5
        ALUControl = 3'b010; #10; // AND: 10 & 5
        ALUControl = 3'b011; #10; // OR: 10 | 5
        ALUControl = 3'b100; #10; // XOR: 10 ^ 5
        ALUControl = 3'b101; #10; // SLT: A < B ? 1 : 0
        A = 32'h00000000; B = 32'h00000000; // A=0, B=0
        ALUControl = 3'b000; #10; // ADD: 0 + 0 = 0 (Zero=1)

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_ALU);
    end

endmodule
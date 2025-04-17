`timescale 1ns / 1ps

// Testbench cho mô-đun Decode Cycle
module tb_Decode_Cycle();

    // Khai báo tín hiệu
    reg clk, rst;                           // Clock và reset
    reg [31:0] InstrD, PCD, PCPlus4D;       // Lệnh, PC, PC+4
    reg RegWriteW;                          // Tín hiệu ghi thanh ghi
    reg [4:0] RDW;                          // Thanh ghi đích
    reg [31:0] ResultW;                     // Kết quả ghi
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE; // Tín hiệu điều khiển
    wire [2:0] ALUControlE;                 // Điều khiển ALU
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E; // Dữ liệu đầu ra
    wire [4:0] RD_E, RS1_E, RS2_E;          // Thanh ghi

    // Tích hợp DUT
    decode_cycle dut (
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW),
        .RDW(RDW),
        .ResultW(ResultW),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .RS1_E(RS1_E),
        .RS2_E(RS2_E)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Decode Cycle...");
        $monitor("Time=%0t | InstrD=%h | RD1_E=%h | RD2_E=%h | Imm_Ext_E=%h | ALUControlE=%b",
                 $time, InstrD, RD1_E, RD2_E, Imm_Ext_E, ALUControlE);

        // Khởi tạo
        rst = 0; #20; rst = 1; // Reset trong 20ns
        InstrD = 32'h00500313; // addi x6, x0, 5
        PCD = 32'h00000000; PCPlus4D = 32'h00000004;
        RegWriteW = 0; RDW = 5'h00; ResultW = 32'h00000000;
        #20; // Chờ 1 chu kỳ clock để lưu vào thanh ghi đường ống

        // Kiểm tra ghi thanh ghi
        RegWriteW = 1; RDW = 5'h06; ResultW = 32'h0000000A; // Ghi x6 = 10
        InstrD = 32'h006283B3; // add x7, x5, x6
        #20;

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("decode_cycle.vcd");
        $dumpvars(0, tb_Decode_Cycle);
    end

endmodule
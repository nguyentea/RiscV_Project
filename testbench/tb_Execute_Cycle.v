`timescale 1ns / 1ps

// Testbench cho mô-đun Execute Cycle
module tb_Execute_Cycle();

    // Khai báo tín hiệu
    reg clk, rst;                           // Clock và reset
    reg RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE; // Tín hiệu điều khiển
    reg [2:0] ALUControlE;                  // Điều khiển ALU
    reg [31:0] RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E; // Dữ liệu đầu vào
    reg [4:0] RD_E;                         // Thanh ghi đích
    reg [1:0] ForwardA_E, ForwardB_E;       // Tín hiệu forwarding
    reg [31:0] ResultW;                     // Kết quả từ Write-back
    wire PCSrcE;                            // Tín hiệu nhánh
    wire [31:0] PCTargetE, ALU_ResultM, WriteDataM, PCPlus4M; // Đầu ra
    wire RegWriteM, MemWriteM, ResultSrcM;  // Tín hiệu điều khiển
    wire [4:0] RD_M;                        // Thanh ghi đích

    // Tích hợp DUT
    execute_cycle dut (
        .clk(clk),
        .rst(rst),
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
        .ForwardA_E(ForwardA_E),
        .ForwardB_E(ForwardB_E),
        .ResultW(ResultW),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Execute Cycle...");
        $monitor("Time=%0t | ALU_ResultM=%h | WriteDataM=%h | PCSrcE=%b",
                 $time, ALU_ResultM, WriteDataM, PCSrcE);

        // Khởi tạo
        rst = 0; #20; rst = 1; // Reset trong 20ns
        RegWriteE = 1; ALUSrcE = 0; MemWriteE = 0; ResultSrcE = 0; BranchE = 0;
        ALUControlE = 3'b000; // ADD
        RD1_E = 32'h0000000A; RD2_E = 32'h00000005; // A=10, B=5
        Imm_Ext_E = 32'h00000000; PCE = 32'h00000000; PCPlus4E = 32'h00000004;
        RD_E = 5'h07; ForwardA_E = 2'b00; ForwardB_E = 2'b00; ResultW = 32'h00000000;
        #20; // Kiểm tra ADD: 10 + 5 = 15

        // Kiểm tra nhánh
        BranchE = 1; ALUControlE = 3'b001; RD1_E = 32'h00000000; RD2_E = 32'h00000000; // SUB: 0 - 0
        #20; // PCSrcE = 1 (Zero = 1)

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("execute_cycle.vcd");
        $dumpvars(0, tb_Execute_Cycle);
    end

endmodule
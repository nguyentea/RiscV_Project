`timescale 1ns / 1ps

// Testbench cho mô-đun Memory Cycle
module tb_Memory_Cycle();

    // Khai báo tín hiệu
    reg clk, rst;                           // Clock và reset
    reg RegWriteM, MemWriteM, ResultSrcM;   // Tín hiệu điều khiển
    reg [4:0] RD_M;                         // Thanh ghi đích
    reg [31:0] PCPlus4M, WriteDataM, ALU_ResultM; // Dữ liệu đầu vào
    wire RegWriteW, ResultSrcW;             // Tín hiệu điều khiển
    wire [4:0] RD_W;                        // Thanh ghi đích
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW; // Đầu ra

    // Tích hợp DUT
    memory_cycle dut (
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .RD_W(RD_W),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW)
    );

    // Tạo clock
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Chu kỳ clock 20ns
    end

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Memory Cycle...");
        $monitor("Time=%0t | ALU_ResultW=%h | ReadDataW=%h | RegWriteW=%b",
                 $time, ALU_ResultW, ReadDataW, RegWriteW);

        // Khởi tạo
        rst = 0; #20; rst = 1; // Reset
        RegWriteM = 1; MemWriteM = 0; ResultSrcM = 1; RD_M = 5'h07;
        PCPlus4M = 32'h00000004; WriteDataM = 32'h0000000A; ALU_ResultM = 32'h00000004;
        #20; // Kiểm tra đọc mem[1] = 6
        MemWriteM = 1; ALU_ResultM = 32'h00000008; WriteDataM = 32'h0000000B; #20; // Ghi mem[2] = 11

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("memory_cycle.vcd");
        $dumpvars(0, tb_Memory_Cycle);
    end

endmodule
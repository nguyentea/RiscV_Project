// Định nghĩa mô-đun Pipeline Top tích hợp toàn bộ pipeline
`timescale 1ns / 1ns
module Pipeline_top (
    input clk,                      // Clock
    input rst                       // Reset
);

    // Dây kết nối nội bộ
    wire PCSrcE, RegWriteW, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, RegWriteM, MemWriteM, ResultSrcM, ResultSrcW;
    wire [2:0] ALUControlE;         // Tín hiệu điều khiển ALU
    wire [4:0] RD_E, RD_M, RDW;     // Thanh ghi đích
    wire [31:0] PCTargetE, InstrD, PCD, PCPlus4D, ResultW, RD1_E, RD2_E, Imm_Ext_E, PCE, PCPlus4E, PCPlus4M, WriteDataM, ALU_ResultM;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW; // Dữ liệu giai đoạn Write-back
    wire [4:0] RS1_E, RS2_E;        // Thanh ghi nguồn
    wire [1:0] ForwardBE, ForwardAE; // Tín hiệu forwarding

    // Tích hợp mô-đun Fetch
    fetch_cycle fetch (
        .clk(clk),                  // Truyền clock
        .rst(rst),                  // Truyền reset
        .PCSrcE(PCSrcE),            // Truyền tín hiệu chọn PC
        .PCTargetE(PCTargetE),      // Truyền địa chỉ nhảy
        .InstrD(InstrD),            // Nhận lệnh
        .PCD(PCD),                  // Nhận PC
        .PCPlus4D(PCPlus4D)         // Nhận PC+4
    );

    // Tích hợp mô-đun Decode
    decode_cycle decode (
        .clk(clk),                  // Truyền clock
        .rst(rst),                  // Truyền reset
        .InstrD(InstrD),            // Truyền lệnh
        .PCD(PCD),                  // Truyền PC
        .PCPlus4D(PCPlus4D),        // Truyền PC+4
        .RegWriteW(RegWriteW),      // Truyền tín hiệu ghi thanh ghi
        .RDW(RDW),                  // Truyền thanh ghi đích
        .ResultW(ResultW),          // Truyền kết quả ghi
        .RegWriteE(RegWriteE),      // Nhận tín hiệu ghi thanh ghi
        .ALUSrcE(ALUSrcE),          // Nhận tín hiệu chọn nguồn ALU
        .MemWriteE(MemWriteE),      // Nhận tín hiệu ghi bộ nhớ
        .ResultSrcE(ResultSrcE),    // Nhận tín hiệu chọn kết quả
        .BranchE(BranchE),          // Nhận tín hiệu nhánh
        .ALUControlE(ALUControlE),  // Nhận tín hiệu điều khiển ALU
        .RD1_E(RD1_E),              // Nhận dữ liệu thanh ghi rs1
        .RD2_E(RD2_E),              // Nhận dữ liệu thanh ghi rs2
        .Imm_Ext_E(Imm_Ext_E),      // Nhận immediate mở rộng
        .RD_E(RD_E),                // Nhận thanh ghi đích
        .PCE(PCE),                  // Nhận PC
        .PCPlus4E(PCPlus4E),        // Nhận PC+4
        .RS1_E(RS1_E),              // Nhận thanh ghi nguồn rs1
        .RS2_E(RS2_E)               // Nhận thanh ghi nguồn rs2
    );

    // Tích hợp mô-đun Execute
    execute_cycle execute (
        .clk(clk),                  // Truyền clock
        .rst(rst),                  // Truyền reset
        .RegWriteE(RegWriteE),      // Truyền tín hiệu ghi thanh ghi
        .ALUSrcE(ALUSrcE),          // Truyền tín hiệu chọn nguồn ALU
        .MemWriteE(MemWriteE),      // Truyền tín hiệu ghi bộ nhớ
        .ResultSrcE(ResultSrcE),    // Truyền tín hiệu chọn kết quả
        .BranchE(BranchE),          // Truyền tín hiệu nhánh
        .ALUControlE(ALUControlE),  // Truyền tín hiệu điều khiển ALU
        .RD1_E(RD1_E),              // Truyền dữ liệu thanh ghi rs1
        .RD2_E(RD2_E),              // Truyền dữ liệu thanh ghi rs2
        .Imm_Ext_E(Imm_Ext_E),      // Truyền immediate mở rộng
        .RD_E(RD_E),                // Truyền thanh ghi đích
        .PCE(PCE),                  // Truyền PC
        .PCPlus4E(PCPlus4E),        // Truyền PC+4
        .PCSrcE(PCSrcE),            // Nhận tín hiệu chọn PC
        .PCTargetE(PCTargetE),      // Nhận địa chỉ nhảy
        .RegWriteM(RegWriteM),      // Nhận tín hiệu ghi thanh ghi
        .MemWriteM(MemWriteM),      // Nhận tín hiệu ghi bộ nhớ
        .ResultSrcM(ResultSrcM),    // Nhận tín hiệu chọn kết quả
        .RD_M(RD_M),                // Nhận thanh ghi đích
        .PCPlus4M(PCPlus4M),        // Nhận PC+4
        .WriteDataM(WriteDataM),    // Nhận dữ liệu ghi
        .ALU_ResultM(ALU_ResultM),  // Nhận kết quả ALU
        .ResultW(ResultW),          // Truyền kết quả từ Write-back
        .ForwardA_E(ForwardAE),     // Truyền tín hiệu forwarding A
        .ForwardB_E(ForwardBE)      // Truyền tín hiệu forwarding B
    );

    // Tích hợp mô-đun Memory
    memory_cycle memory (
        .clk(clk),                  // Truyền clock
        .rst(rst),                  // Truyền reset
        .RegWriteM(RegWriteM),      // Truyền tín hiệu ghi thanh ghi
        .MemWriteM(MemWriteM),      // Truyền tín hiệu ghi bộ nhớ
        .ResultSrcM(ResultSrcM),    // Truyền tín hiệu chọn kết quả
        .RD_M(RD_M),                // Truyền thanh ghi đích
        .PCPlus4M(PCPlus4M),        // Truyền PC+4
        .WriteDataM(WriteDataM),    // Truyền dữ liệu ghi
        .ALU_ResultM(ALU_ResultM),  // Truyền kết quả ALU
        .RegWriteW(RegWriteW),      // Nhận tín hiệu ghi thanh ghi
        .ResultSrcW(ResultSrcW),    // Nhận tín hiệu chọn kết quả
        .RD_W(RDW),                 // Nhận thanh ghi đích
        .PCPlus4W(PCPlus4W),        // Nhận PC+4
        .ALU_ResultW(ALU_ResultW),  // Nhận kết quả ALU
        .ReadDataW(ReadDataW)       // Nhận dữ liệu đọc
    );

    // Tích hợp mô-đun Write-back
    writeback_cycle writeBack (
        .clk(clk),                  // Truyền clock
        .rst(rst),                  // Truyền reset
        .ResultSrcW(ResultSrcW),    // Truyền tín hiệu chọn kết quả
        .PCPlus4W(PCPlus4W),        // Truyền PC+4
        .ALU_ResultW(ALU_ResultW),  // Truyền kết quả ALU
        .ReadDataW(ReadDataW),      // Truyền dữ liệu đọc
        .ResultW(ResultW)           // Nhận kết quả cuối
    );

    // Tích hợp mô-đun Hazard Unit
    hazard_unit Forwarding_Block (
        .rst(rst),                  // Truyền reset
        .RegWriteM(RegWriteM),      // Truyền tín hiệu ghi thanh ghi
        .RegWriteW(RegWriteW),      // Truyền tín hiệu ghi thanh ghi
        .RD_M(RD_M),                // Truyền thanh ghi đích
        .RD_W(RDW),                 // Truyền thanh ghi đích
        .Rs1_E(RS1_E),              // Truyền thanh ghi nguồn rs1
        .Rs2_E(RS2_E),              // Truyền thanh ghi nguồn rs2
        .ForwardAE(ForwardAE),      // Nhận tín hiệu forwarding A
        .ForwardBE(ForwardBE)       // Nhận tín hiệu forwarding B
    );

endmodule
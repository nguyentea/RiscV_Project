// Định nghĩa mô-đun Execute Cycle, xử lý giai đoạn thực thi lệnh trong pipeline
module execute_cycle (
    input clk, rst,                             // Clock và reset
    input RegWriteE, ALUSrcE, MemWriteE,        // Tín hiệu điều khiển từ Decode
    input ResultSrcE, BranchE,                  // Tín hiệu điều khiển từ Decode
    input [2:0] ALUControlE,                    // Tín hiệu điều khiển ALU
    input [31:0] RD1_E, RD2_E, Imm_Ext_E,       // Dữ liệu thanh ghi và immediate
    input [4:0] RD_E,                           // Thanh ghi đích
    input [31:0] PCE, PCPlus4E,                 // PC và PC+4
    input [1:0] ForwardA_E, ForwardB_E,         // Tín hiệu forwarding
    input [31:0] ResultW,                       // Kết quả từ Write-back
    output PCSrcE,                              // Tín hiệu chọn PC (nhánh)
    output [31:0] PCTargetE,                    // Địa chỉ nhảy
    output RegWriteM, MemWriteM, ResultSrcM,    // Tín hiệu điều khiển cho Memory
    output [4:0] RD_M,                          // Thanh ghi đích cho Memory
    output [31:0] PCPlus4M, WriteDataM,         // PC+4 và dữ liệu ghi cho Memory
    output [31:0] ALU_ResultM                   // Kết quả ALU cho Memory
);

    // Dây kết nối nội bộ
    wire [31:0] SrcA_E, SrcB_E, ALU_ResultE, WriteDataE;
    wire ZeroE;

    // Mux chọn toán hạng A
    Mux_3_by_1 srcA_mux (
        .a(RD1_E),                  // Giá trị từ thanh ghi rs1
        .b(ResultW),                // Giá trị từ Write-back
        .c(ALU_ResultM),            // Giá trị từ Memory (không dùng ở đây)
        .s(ForwardA_E),             // Tín hiệu chọn forwarding
        .d(SrcA_E)                  // Toán hạng A cho ALU
    );

    // Mux chọn toán hạng B
    Mux srcB_mux (
        .a(RD2_E),                  // Giá trị từ thanh ghi rs2
        .b(Imm_Ext_E),              // Giá trị immediate
        .s(ALUSrcE),                // Tín hiệu chọn nguồn (thanh ghi hoặc immediate)
        .c(WriteDataE)              // Toán hạng B cho ALU hoặc dữ liệu ghi
    );

    // Mux chọn toán hạng B sau forwarding
    Mux_3_by_1 srcB_forward_mux (
        .a(WriteDataE),             // Giá trị từ mux trước
        .b(ResultW),                // Giá trị từ Write-back
        .c(ALU_ResultM),            // Giá trị từ Memory (không dùng ở đây)
        .s(ForwardB_E),             // Tín hiệu chọn forwarding
        .d(SrcB_E)                  // Toán hạng B cuối cùng cho ALU
    );

    // Tích hợp mô-đun ALU
    ALU alu (
        .A(SrcA_E),                 // Toán hạng A
        .B(SrcB_E),                 // Toán hạng B
        .ALUControl(ALUControlE),   // Tín hiệu điều khiển ALU
        .ALU_Result(ALU_ResultE),   // Kết quả ALU
        .Zero(ZeroE)                // Cờ Zero
    );

    // Tích hợp mô-đun PC Adder cho địa chỉ nhảy
    PC_Adder pc_adder (
        .a(PCE),                    // PC hiện tại
        .b(Imm_Ext_E),              // Immediate mở rộng
        .c(PCTargetE)               // Địa chỉ nhảy
    );

    // Tín hiệu chọn PC cho nhánh
    assign PCSrcE = BranchE & ZeroE; // Chọn nhảy nếu là lệnh nhánh và Zero = 1

    // Thanh ghi đường ống EX/MEM
    reg RegWriteE_r, MemWriteE_r, ResultSrcE_r;
    reg [31:0] ALU_ResultE_r, WriteDataE_r, PCPlus4E_r;
    reg [4:0] RD_E_r;

    // Logic thanh ghi đường ống
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin      // Nếu reset, đặt tất cả thanh ghi về 0
            RegWriteE_r <= 1'b0;
            MemWriteE_r <= 1'b0;
            ResultSrcE_r <= 1'b0;
            ALU_ResultE_r <= 32'h00000000;
            WriteDataE_r <= 32'h00000000;
            PCPlus4E_r <= 32'h00000000;
            RD_E_r <= 5'h00;
        end
        else begin                  // Nếu không reset, lưu giá trị vào thanh ghi
            RegWriteE_r <= RegWriteE;
            MemWriteE_r <= MemWriteE;
            ResultSrcE_r <= ResultSrcE;
            ALU_ResultE_r <= ALU_ResultE;
            WriteDataE_r <= WriteDataE;
            PCPlus4E_r <= PCPlus4E;
            RD_E_r <= RD_E;
        end
    end

    // Gán đầu ra cho giai đoạn Memory
    assign RegWriteM = RegWriteE_r;
    assign MemWriteM = MemWriteE_r;
    assign ResultSrcM = ResultSrcE_r;
    assign ALU_ResultM = ALU_ResultE_r;
    assign WriteDataM = WriteDataE_r;
    assign PCPlus4M = PCPlus4E_r;
    assign RD_M = RD_E_r;

endmodule
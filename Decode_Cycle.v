// Định nghĩa mô-đun Decode Cycle, xử lý giai đoạn giải mã lệnh trong pipeline
module decode_cycle (
    input clk, rst,                             // Clock và reset
    input [31:0] InstrD, PCD, PCPlus4D,         // Lệnh, PC, PC+4 từ Fetch
    input RegWriteW,                            // Tín hiệu ghi thanh ghi từ Write-back
    input [4:0] RDW,                            // Thanh ghi đích từ Write-back
    input [31:0] ResultW,                       // Kết quả ghi từ Write-back
    output RegWriteE, ALUSrcE, MemWriteE,       // Tín hiệu điều khiển cho Execute
    output ResultSrcE, BranchE,                 // Tín hiệu điều khiển cho Execute
    output [2:0] ALUControlE,                   // Tín hiệu điều khiển ALU cho Execute
    output [31:0] RD1_E, RD2_E, Imm_Ext_E,      // Dữ liệu thanh ghi và immediate cho Execute
    output [4:0] RD_E,                          // Thanh ghi đích cho Execute
    output [31:0] PCE, PCPlus4E,                // PC và PC+4 cho Execute
    output [4:0] RS1_E, RS2_E                   // Thanh ghi nguồn cho Execute
);

    // Dây kết nối nội bộ
    wire [1:0] ImmSrcD;
    wire RegWriteD, ALUSrcD, MemWriteD, ResultSrcD, BranchD;
    wire [2:0] ALUControlD;
    wire [31:0] RD1_D, RD2_D, Imm_Ext_D;

    // Tích hợp mô-đun Control Unit
    Control_Unit_Top control (
        .Op(InstrD[6:0]),                   // Truyền opcode từ lệnh
        .funct7(InstrD[31:25]),             // Truyền funct7 từ lệnh
        .funct3(InstrD[14:12]),             // Truyền funct3 từ lệnh
        .RegWrite(RegWriteD),               // Nhận tín hiệu ghi thanh ghi
        .ALUSrc(ALUSrcD),                   // Nhận tín hiệu chọn nguồn ALU
        .MemWrite(MemWriteD),               // Nhận tín hiệu ghi bộ nhớ
        .ResultSrc(ResultSrcD),             // Nhận tín hiệu chọn kết quả
        .Branch(BranchD),                   // Nhận tín hiệu nhánh
        .ImmSrc(ImmSrcD),                   // Nhận tín hiệu chọn immediate
        .ALUControl(ALUControlD)            // Nhận tín hiệu điều khiển ALU
    );

    // Tích hợp mô-đun Register File
    Register_File rf (
        .clk(clk),                          // Truyền clock
        .rst(rst),                          // Truyền reset
        .WE3(RegWriteW),                    // Truyền tín hiệu ghi từ Write-back
        .A1(InstrD[19:15]),                 // Địa chỉ thanh ghi nguồn rs1
        .A2(InstrD[24:20]),                 // Địa chỉ thanh ghi nguồn rs2
        .A3(RDW),                           // Địa chỉ thanh ghi đích từ Write-back
        .WD3(ResultW),                      // Dữ liệu ghi từ Write-back
        .RD1(RD1_D),                        // Nhận dữ liệu thanh ghi rs1
        .RD2(RD2_D)                         // Nhận dữ liệu thanh ghi rs2
    );

    // Tích hợp mô-đun Sign Extend
    Sign_Extend se (
        .In(InstrD),                        // Truyền lệnh đầy đủ
        .ImmSrc(ImmSrcD),                   // Truyền tín hiệu chọn immediate
        .Imm_Ext(Imm_Ext_D)                 // Nhận immediate mở rộng dấu
    );

    // Thanh ghi đường ống ID/EX
    reg RegWriteD_r, ALUSrcD_r, MemWriteD_r, ResultSrcD_r, BranchD_r;
    reg [2:0] ALUControlD_r;
    reg [31:0] RD1_D_r, RD2_D_r, Imm_Ext_D_r, PCD_r, PCPlus4D_r;
    reg [4:0] RS1_D_r, RS2_D_r, RD_D_r;

    // Logic thanh ghi đường ống
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin              // Nếu reset, đặt tất cả thanh ghi về 0
            RegWriteD_r <= 1'b0;
            ALUSrcD_r <= 1'b0;
            MemWriteD_r <= 1'b0;
            ResultSrcD_r <= 1'b0;
            BranchD_r <= 1'b0;
            ALUControlD_r <= 3'b000;
            RD1_D_r <= 32'h00000000;
            RD2_D_r <= 32'h00000000;
            Imm_Ext_D_r <= 32'h00000000;
            PCD_r <= 32'h00000000;
            PCPlus4D_r <= 32'h00000000;
            RS1_D_r <= 5'h00;
            RS2_D_r <= 5'h00;
            RD_D_r <= 5'h00;
        end
        else begin                          // Nếu không reset, lưu giá trị vào thanh ghi
            RegWriteD_r <= RegWriteD;
            ALUSrcD_r <= ALUSrcD;
            MemWriteD_r <= MemWriteD;
            ResultSrcD_r <= ResultSrcD;
            BranchD_r <= BranchD;
            ALUControlD_r <= ALUControlD;
            RD1_D_r <= RD1_D;
            RD2_D_r <= RD2_D;
            Imm_Ext_D_r <= Imm_Ext_D;
            PCD_r <= PCD;
            PCPlus4D_r <= PCPlus4D;
            RS1_D_r <= InstrD[19:15];       // Lưu thanh ghi nguồn rs1
            RS2_D_r <= InstrD[24:20];       // Lưu thanh ghi nguồn rs2
            RD_D_r <= InstrD[11:7];         // Lưu thanh ghi đích rd
        end
    end

    // Gán đầu ra cho giai đoạn Execute
    assign RegWriteE = RegWriteD_r;
    assign ALUSrcE = ALUSrcD_r;
    assign MemWriteE = MemWriteD_r;
    assign ResultSrcE = ResultSrcD_r;
    assign BranchE = BranchD_r;
    assign ALUControlE = ALUControlD_r;
    assign RD1_E = RD1_D_r;
    assign RD2_E = RD2_D_r;
    assign Imm_Ext_E = Imm_Ext_D_r;
    assign PCE = PCD_r;
    assign PCPlus4E = PCPlus4D_r;
    assign RD_E = RD_D_r;
    assign RS1_E = RS1_D_r;
    assign RS2_E = RS2_D_r;

endmodule
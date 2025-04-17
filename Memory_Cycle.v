// Bản quyền MERL-DSU 2023
// Định nghĩa mô-đun Memory Cycle, xử lý giai đoạn truy cập bộ nhớ
module memory_cycle (
    input clk, rst,                             // Clock và reset
    input RegWriteM, MemWriteM, ResultSrcM,     // Tín hiệu điều khiển từ Execute
    input [4:0] RD_M,                           // Thanh ghi đích
    input [31:0] PCPlus4M, WriteDataM,          // PC+4, dữ liệu ghi
    input [31:0] ALU_ResultM,                   // Kết quả ALU
    output RegWriteW, ResultSrcW,               // Tín hiệu điều khiển cho Write-back
    output [4:0] RD_W,                          // Thanh ghi đích
    output [31:0] PCPlus4W, ALU_ResultW,        // PC+4, kết quả ALU
    output [31:0] ReadDataW                     // Dữ liệu đọc từ bộ nhớ
);

    // Dây kết nối nội bộ
    wire [31:0] ReadDataM;

    // Thanh ghi đường ống MEM/WB
    reg RegWriteM_r, ResultSrcM_r;
    reg [4:0] RD_M_r;
    reg [31:0] PCPlus4M_r, ALU_ResultM_r, ReadDataM_r;

    // Tích hợp mô-đun Data Memory
    Data_Memory dmem (
        .clk(clk),                      // Truyền clock
        .rst(rst),                      // Truyền reset
        .WE(MemWriteM),                 // Truyền tín hiệu ghi
        .WD(WriteDataM),                // Truyền dữ liệu ghi
        .A(ALU_ResultM),                // Truyền địa chỉ
        .RD(ReadDataM)                  // Nhận dữ liệu đọc
    );

    // Logic thanh ghi đường ống
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin          // Nếu reset, đặt tất cả thanh ghi về 0
            RegWriteM_r <= 1'b0;
            ResultSrcM_r <= 1'b0;
            RD_M_r <= 5'h00;
            PCPlus4M_r <= 32'h00000000;
            ALU_ResultM_r <= 32'h00000000;
            ReadDataM_r <= 32'h00000000;
        end
        else begin                      // Nếu không reset, lưu giá trị
            RegWriteM_r <= RegWriteM;
            ResultSrcM_r <= ResultSrcM;
            RD_M_r <= RD_M;
            PCPlus4M_r <= PCPlus4M;
            ALU_ResultM_r <= ALU_ResultM;
            ReadDataM_r <= ReadDataM;
        end
    end

    // Gán đầu ra cho giai đoạn Write-back
    assign RegWriteW = RegWriteM_r;
    assign ResultSrcW = ResultSrcM_r;
    assign RD_W = RD_M_r;
    assign PCPlus4W = PCPlus4M_r;
    assign ALU_ResultW = ALU_ResultM_r;
    assign ReadDataW = ReadDataM_r;

endmodule
// Định nghĩa mô-đun Fetch Cycle, xử lý giai đoạn lấy lệnh trong pipeline
module fetch_cycle (
    input clk, rst,                     // Clock và reset
    input PCSrcE,                       // Tín hiệu chọn PC (nhánh)
    input [31:0] PCTargetE,             // Địa chỉ nhảy từ Execute
    output [31:0] InstrD, PCD, PCPlus4D // Lệnh, PC, PC+4 cho Decode
);

    // Dây kết nối nội bộ
    wire [31:0] PCF, PC_Next, PCPlus4F, InstrF;

    // Mux chọn PC
    Mux pc_mux (
        .a(PCPlus4F),                   // PC+4
        .b(PCTargetE),                  // Địa chỉ nhảy
        .s(PCSrcE),                     // Tín hiệu chọn (nhánh)
        .c(PC_Next)                     // PC tiếp theo
    );

    // Tích hợp mô-đun PC
    PC_Module pc (
        .clk(clk),                      // Truyền clock
        .rst(rst),                      // Truyền reset
        .PC_Next(PC_Next),              // Truyền PC tiếp theo
        .PC(PCF)                        // Nhận PC hiện tại
    );

    // Tích hợp mô-đun Instruction Memory
    Instruction_Memory imem (
        .A(PCF),                        // Truyền địa chỉ PC
        .RD(InstrF)                     // Nhận lệnh
    );

    // Tích hợp mô-đun PC Adder
    PC_Adder pc_adder (
        .a(PCF),                        // Truyền PC hiện tại
        .b(32'h00000004),               // Cộng 4 (kích thước lệnh)
        .c(PCPlus4F)                    // Nhận PC+4
    );

    // Thanh ghi đường ống IF/ID
    reg [31:0] InstrF_reg, PCF_reg, PCPlus4F_reg;

    // Logic thanh ghi đường ống
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin          // Nếu reset, đặt tất cả thanh ghi về 0
            InstrF_reg <= 32'h00000000;
            PCF_reg <= 32'h00000000;
            PCPlus4F_reg <= 32'h00000000;
        end
        else begin                      // Nếu không reset, lưu giá trị
            InstrF_reg <= InstrF;
            PCF_reg <= PCF;
            PCPlus4F_reg <= PCPlus4F;
        end
    end

    // Gán đầu ra cho giai đoạn Decode
    assign InstrD = InstrF_reg;
    assign PCD = PCF_reg;
    assign PCPlus4D = PCPlus4F_reg;

endmodule
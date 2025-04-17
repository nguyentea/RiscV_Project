// Định nghĩa mô-đun ALU Decoder tạo tín hiệu điều khiển ALU
module ALU_Decoder (
    input [1:0] ALUOp,          // Tín hiệu ALUOp từ Main Decoder
    input [2:0] funct3,         // funct3 từ lệnh
    input [6:0] funct7,         // funct7 từ lệnh
    output reg [2:0] ALUControl // Tín hiệu điều khiển ALU
);

    // Logic tạo ALUControl
    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl = 3'b000; // Load/Store: ADD
            2'b01: ALUControl = 3'b001; // Branch: SUB
            2'b10: begin                // R-type hoặc I-type
                case(funct3)
                    3'b000: ALUControl = (funct7[5]) ? 3'b001 : 3'b000; // SUB nếu funct7[5]=1, ADD nếu không
                    3'b010: ALUControl = 3'b101; // SLT
                    3'b110: ALUControl = 3'b011; // OR
                    3'b111: ALUControl = 3'b010; // AND
                    3'b100: ALUControl = 3'b100; // XOR
                    default: ALUControl = 3'b000; // Mặc định: ADD
                endcase
            end
            default: ALUControl = 3'b000; // Mặc định: ADD
        endcase
    end

endmodule
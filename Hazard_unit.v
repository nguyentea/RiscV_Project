// Định nghĩa mô-đun Hazard Unit xử lý data hazard bằng forwarding
module hazard_unit (
    input rst,                      // Tín hiệu reset
    input RegWriteM, RegWriteW,     // Tín hiệu ghi thanh ghi từ Memory và Write-back
    input [4:0] RD_M, RD_W,         // Thanh ghi đích từ Memory và Write-back
    input [4:0] Rs1_E, Rs2_E,       // Thanh ghi nguồn từ Execute
    output reg [1:0] ForwardAE, ForwardBE // Tín hiệu forwarding cho toán hạng A và B
);

    // Logic xử lý forwarding
    always @(*) begin
        if (rst == 1'b0) begin      // Nếu reset, không forwarding
            ForwardAE = 2'b00;
            ForwardBE = 2'b00;
        end
        else begin
            // Forwarding cho toán hạng A
            if ((RegWriteM == 1'b1) && (RD_M != 5'h00) && (RD_M == Rs1_E))
                ForwardAE = 2'b10;  // Forward từ giai đoạn Memory
            else if ((RegWriteW == 1'b1) && (RD_W != 5'h00) && (RD_W == Rs1_E))
                ForwardAE = 2'b01;  // Forward từ giai đoạn Write-back
            else
                ForwardAE = 2'b00;  // Không forward, dùng giá trị từ thanh ghi

            // Forwarding cho toán hạng B
            if ((RegWriteM == 1'b1) && (RD_M != 5'h00) && (RD_M == Rs2_E))
                ForwardBE = 2'b10;  // Forward từ giai đoạn Memory
            else if ((RegWriteW == 1'b1) && (RD_W != 5'h00) && (RD_W == Rs2_E))
                ForwardBE = 2'b01;  // Forward từ giai đoạn Write-back
            else
                ForwardBE = 2'b00;  // Không forward, dùng giá trị từ thanh ghi
        end
    end

endmodule
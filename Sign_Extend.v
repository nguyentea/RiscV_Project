// Định nghĩa mô-đun Sign Extend mở rộng dấu cho immediate
module Sign_Extend (
    input [31:0] In,            // Lệnh đầu vào 32-bit
    input [1:0] ImmSrc,         // Tín hiệu chọn loại immediate
    output [31:0] Imm_Ext       // Immediate mở rộng dấu
);

    // Logic mở rộng dấu
    assign Imm_Ext = (ImmSrc == 2'b00) ? {{20{In[31]}}, In[31:20]} :                    // I-type
                     (ImmSrc == 2'b01) ? {{20{In[31]}}, In[31:25], In[11:7]} :         // S-type
                     32'h00000000;                                                     // Mặc định trả về 0

endmodule
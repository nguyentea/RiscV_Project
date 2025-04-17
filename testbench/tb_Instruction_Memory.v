`timescale 1ns / 1ps

// Testbench cho mô-đun Instruction Memory
module tb_Instruction_Memory();

    // Khai báo tín hiệu
    reg [31:0] A;               // Địa chỉ đọc (PC)
    wire [31:0] RD;             // Lệnh đọc ra

    // Tích hợp DUT
    Instruction_Memory dut (
        .A(A),
        .RD(RD)
    );

    // Trình tự kiểm tra
    initial begin
        $display("Bắt đầu kiểm tra Instruction Memory...");
        $monitor("Time=%0t | A=%h | RD=%h", $time, A, RD);

        // Kiểm tra các lệnh nạp sẵn
        A = 32'h00000000; #10; // mem[0] = lw x6, -4(x9)
        A = 32'h00000004; #10; // mem[1] = lw x7, 8(x6)
        A = 32'h00000008; #10; // mem[2] = sw x6, 8(x9)
        A = 32'h0000000C; #10; // mem[3] = sw x11, 8(x12)
        A = 32'h00000010; #10; // mem[4] = or x4, x5, x6
        A = 32'h00000014; #10; // mem[5] = sw x11, 8(x12)

        $finish; // Kết thúc mô phỏng
    end

    // Xuất dạng sóng
    initial begin
        $dumpfile("imem.vcd");
        $dumpvars(0, tb_Instruction_Memory);
    end

endmodule
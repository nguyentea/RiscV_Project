`timescale 1ns / 1ps

// Testbench cho mô-đun Pipeline_top
module tb_pipeline();

// Parameters
parameter CLK_PERIOD = 200; // Chu kỳ clock là 200ns (mỗi nửa chu kỳ 100ns)
parameter RESET_TIME = 400; // Thời gian giữ reset là 400ns
parameter SIM_TIME = 10000; // Tổng thời gian mô phỏng là 10000ns

// Signals
reg clk;                    // Tín hiệu clock
reg rst;                    // Tín hiệu reset

// Instantiate DUT (Device Under Test)
Pipeline_top dut (          // Tích hợp Pipeline_top
    .clk(clk),              // Kết nối clock
    .rst(rst)               // Kết nối reset
);

// Block 1: Clock Generation
initial begin               // Khối tạo clock
    clk = 0;                // Khởi tạo clock bằng 0
    forever #(CLK_PERIOD/2) clk = ~clk; // Đảo clock mỗi 100ns
end

// Block 2: Reset Control
task reset_phase;           // Task thực hiện pha reset
    begin
        $display("PHASE: Reset Phase at %0t", $time); // In thông báo pha reset
        rst = 1'b0;         // Đặt reset xuống 0 (active-low)
        #RESET_TIME;        // Chờ 400ns
        rst = 1'b1;         // Bỏ reset
        $display("Reset deasserted at %0t", $time); // In thông báo bỏ reset
    end
endtask

// Block 3: Initialization Phase
task init_phase;            // Task thực hiện pha khởi tạo
    begin
        $display("PHASE: Initialization Phase at %0t", $time); // In thông báo pha khởi tạo
        $display("Program loaded into Instruction Memory"); // In thông báo chương trình nạp sẵn
    end
endtask

// Block 4: Execution Phase
task execution_phase;       // Task thực hiện pha thực thi
    begin
        $display("PHASE: Execution Phase at %0t", $time); // In thông báo pha thực thi
        #SIM_TIME;          // Chờ 10000ns
    end
endtask

// Block 5: Termination Phase
task termination_phase;     // Task thực hiện pha kết thúc
    integer i;              // Biến integer cho vòng lặp
    begin
        $display("PHASE: Termination Phase at %0t", $time); // In thông báo pha kết thúc
        $display("Final Register File State:"); // In tiêu đề trạng thái thanh ghi
        for (i = 0; i < 32; i = i + 1) begin // Vòng lặp in 32 thanh ghi
            $display("x%0d = %h", i, dut.decode.rf.Register[i]); // In giá trị thanh ghi
        end
        $display("Final Data Memory State (first 5 locations):"); // In tiêu đề trạng thái bộ nhớ
        for (i = 0; i < 5; i = i + 1) begin // Vòng lặp in 5 vị trí bộ nhớ
            $display("mem[%0d] = %h", i, dut.memory.dmem.mem[i]); // In giá trị bộ nhớ
        end
        $finish;            // Kết thúc mô phỏng
    end
endtask

// Block 6: Signal Monitoring
initial begin               // Khối giám sát tín hiệu
    $display("Starting Simulation..."); // In thông báo bắt đầu
    $timeformat(-9, 2, " ns", 10); // Định dạng thời gian: ns, 2 chữ số thập phân
    $monitor("Time=%0t | PC=%h | InstrD=%h | ALU_ResultM=%h | WriteDataM=%h",
             $time, dut.fetch.PCF_reg, dut.fetch.InstrD,
             dut.execute.ALU_ResultM, dut.execute.WriteDataM); // Giám sát tín hiệu chính
end

// Block 7: Dump Waveform (VCD)
initial begin               // Khối xuất VCD
    $dumpfile("pipeline.vcd"); // Tệp VCD
    $dumpvars(0, tb_pipeline); // Xuất tất cả tín hiệu
    $dumpvars(1, dut.fetch.InstrF_reg);      // Xuất lệnh IF/ID
    $dumpvars(1, dut.fetch.PCF_reg);         // Xuất PC IF/ID
    $dumpvars(1, dut.fetch.PCPlus4F_reg);    // Xuất PC+4 IF/ID
    $dumpvars(1, dut.decode.RD1_D_r);        // Xuất rs1 ID/EX
    $dumpvars(1, dut.decode.RD2_D_r);        // Xuất rs2 ID/EX
    $dumpvars(1, dut.decode.Imm_Ext_D_r);    // Xuất immediate ID/EX
    $dumpvars(1, dut.execute.ResultE_r);     // Xuất kết quả ALU EX/MEM
    $dumpvars(1, dut.execute.RD2_E_r);       // Xuất dữ liệu ghi EX/MEM
    $dumpvars(1, dut.memory.ReadDataM_r);    // Xuất dữ liệu đọc MEM/WB
    $dumpvars(1, dut.memory.ALU_ResultM_r);  // Xuất kết quả ALU MEM/WB
end

// Block 8: Test Sequence
initial begin               // Khối chạy trình tự kiểm tra
    reset_phase();          // Chạy pha reset
    init_phase();           // Chạy pha khởi tạo
    execution_phase();      // Chạy pha thực thi
    termination_phase();    // Chạy pha kết thúc
end

endmodule
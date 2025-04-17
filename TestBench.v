// Định nghĩa thời gian mô phỏng: 1ns cho mỗi đơn vị thời gian, độ chính xác 1ps
`timescale 1ns / 1ps

// Định nghĩa mô-đun testbench cho Pipeline_top
module tb_pipeline();

// Parameters
parameter CLK_PERIOD = 200; // Chu kỳ clock là 200ns (mỗi nửa chu kỳ 100ns)
parameter RESET_TIME = 400; // Thời gian giữ reset là 400ns
parameter SIM_TIME = 10000; // Tổng thời gian mô phỏng là 10000ns

// Signals
reg clk;                    // Tín hiệu clock (đăng ký)
reg rst;                    // Tín hiệu reset (đăng ký)

// Instantiate DUT (Device Under Test)
Pipeline_top dut (          // Tích hợp mô-đun Pipeline_top (DUT - Device Under Test)
    .clk(clk),              // Kết nối clock của testbench với DUT
    .rst(rst)               // Kết nối reset của testbench với DUT
);

// Block 1: Clock Generation
initial begin               // Khối khởi tạo để tạo tín hiệu clock
    clk = 0;                // Khởi tạo clock bằng 0
    forever #(CLK_PERIOD/2) clk = ~clk; // Đảo trạng thái clock mỗi nửa chu kỳ (100ns)
end

// Block 2: Reset Control
task reset_phase;           // Định nghĩa task để thực hiện pha reset
    begin
        $display("PHASE: Reset Phase at %0t", $time); // In thông báo bắt đầu pha reset với thời gian hiện tại
        rst = 1'b0;         // Đặt reset xuống 0 (active-low reset)
        #RESET_TIME;        // Chờ 400ns để giữ reset
        rst = 1'b1;         // Bỏ reset (deassert)
        $display("Reset deasserted at %0t", $time); // In thông báo khi bỏ reset với thời gian
    end
endtask

// Block 3: Initialization Phase
task init_phase;            // Định nghĩa task để thực hiện pha khởi tạo
    begin
        $display("PHASE: Initialization Phase at %0t", $time); // In thông báo bắt đầu pha khởi tạo
        // Program is preloaded in Instruction_Memory.v or via $readmemh
        $display("Program loaded into Instruction Memory"); // In thông báo chương trình đã được nạp (giả định nạp sẵn hoặc qua $readmemh)
    end
endtask

// Block 4: Execution Phase
task execution_phase;       // Định nghĩa task để thực hiện pha thực thi
    begin
        $display("PHASE: Execution Phase at %0t", $time); // In thông báo bắt đầu pha thực thi
        #SIM_TIME;          // Chờ 10000ns để chạy mô phỏng
    end
endtask

// Block 5: Termination Phase
task termination_phase;     // Định nghĩa task để thực hiện pha kết thúc
    integer i;              // Khai báo biến i kiểu integer (tương thích Verilog)
    begin
        $display("PHASE: Termination Phase at %0t", $time); // In thông báo bắt đầu pha kết thúc
        // Display final register file values
        $display("Final Register File State:"); // In tiêu đề trạng thái cuối của Register File
        for (i = 0; i < 32; i = i + 1) begin // Vòng lặp để in giá trị 32 thanh ghi
            $display("x%0d = %h", i, dut.decode.rf.Register[i]); // In giá trị thanh ghi x[i] ở dạng hex
        end
        // Display memory state (first 5 locations)
        $display("Final Data Memory State (first 5 locations):"); // In tiêu đề trạng thái cuối của Data Memory
        for (i = 0; i < 5; i = i + 1) begin // Vòng lặp để in 5 vị trí bộ nhớ đầu tiên
            $display("mem[%0d] = %h", i, dut.memory.dmem.mem[i]); // In giá trị bộ nhớ mem[i] ở dạng hex
        end
        $finish;            // Kết thúc mô phỏng
    end
endtask

// Block 6: Signal Monitoring
initial begin               // Khối khởi tạo để giám sát tín hiệu
    $display("Starting Simulation..."); // In thông báo bắt đầu mô phỏng
    $timeformat(-9, 2, " ns", 10); // Định dạng thời gian: ns, 2 chữ số thập phân, độ dài tối thiểu 10 ký tự
    // Monitor key pipeline signals
    $monitor("Time=%0t | PC=%h | InstrD=%h | ALU_ResultM=%h | WriteDataM=%h",
             $time,             // In thời gian hiện tại
             dut.fetch.PCF_reg, // In giá trị PC từ Fetch (IF/ID)
             dut.fetch.InstrD,  // In lệnh từ Fetch (IF/ID)
             dut.execute.ALU_ResultM, // In kết quả ALU từ Execute (EX/MEM)
             dut.execute.WriteDataM); // In dữ liệu ghi từ Execute (EX/MEM)
end

// Block 7: Dump Waveform (VCD)
initial begin               // Khối khởi tạo để xuất dạng sóng VCD
    $dumpfile("pipeline.vcd"); // Đặt tên tệp VCD là pipeline.vcd
    $dumpvars(0, tb_pipeline); // Xuất tất cả tín hiệu trong tb_pipeline
    // Dump pipeline register signals
    $dumpvars(1, dut.fetch.InstrF_reg);      // Xuất tín hiệu lệnh từ IF/ID
    $dumpvars(1, dut.fetch.PCF_reg);         // Xuất tín hiệu PC từ IF/ID
    $dumpvars(1, dut.fetch.PCPlus4F_reg);    // Xuất tín hiệu PC+4 từ IF/ID
    $dumpvars(1, dut.decode.RD1_D_r);        // Xuất dữ liệu thanh ghi rs1 từ ID/EX
    $dumpvars(1, dut.decode.RD2_D_r);        // Xuất dữ liệu thanh ghi rs2 từ ID/EX
    $dumpvars(1, dut.decode.Imm_Ext_D_r);    // Xuất immediate mở rộng từ ID/EX
    $dumpvars(1, dut.execute.ResultE_r);     // Xuất kết quả ALU từ EX/MEM
    $dumpvars(1, dut.execute.RD2_E_r);       // Xuất dữ liệu ghi từ EX/MEM
    $dumpvars(1, dut.memory.ReadDataM_r);    // Xuất dữ liệu đọc bộ nhớ từ MEM/WB
    $dumpvars(1, dut.memory.ALU_ResultM_r);  // Xuất kết quả ALU từ MEM/WB
end

// Block 8: Test Sequence
initial begin               // Khối khởi tạo để chạy trình tự kiểm tra
    reset_phase();          // Gọi task reset_phase để thực hiện pha reset
    init_phase();           // Gọi task init_phase để thực hiện pha khởi tạo
    execution_phase();      // Gọi task execution_phase để thực hiện pha thực thi
    termination_phase();    // Gọi task termination_phase để thực hiện pha kết thúc
end

endmodule
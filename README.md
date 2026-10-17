# AXI4 RAM - SystemVerilog Testbench

AXI4 RAM (single outstanding write/read, 4-bit address, 32-bit data) with a class-based SystemVerilog testbench.

## Layout
- `rtl/` - `ram_design.sv` (memory), `ram_axi_design.sv` (AXI wrapper)
- `tb/` - interface, transaction, generator, driver, receiver (monitor), scoreboard (with address coverage), environment, test, top
- `eda_playground/` - `design.sv` and `testbench.sv`: the same code merged into two files so it pastes straight into EDA Playground

## Run on EDA Playground
Link: https://edaplayground.com/x/i_JV

Settings: Testbench + Design = SystemVerilog/Verilog, simulator = Synopsys VCS / Aldec Riviera-PRO / Questa (any one that supports SV classes), top module = `test_top`.

## Results
<img width="937" height="765" alt="image" src="https://github.com/user-attachments/assets/7eb0de83-4c74-4a39-b1db-4853f129f46c" />

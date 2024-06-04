#!/bin/bash
rm work-*.cf

ghdl -a --std=08 ../../Packages/Constant_Package.vhdl
ghdl -a --std=08 ../../Packages/Types_Package.vhdl
ghdl -a --std=08 ../../Packages/Util_Functions_Package.vhdl

#ALU
ghdl -a --std=08 ../../Komponenten/ALU/my_shifter.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_half_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_n_bit_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_xor.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_or.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_and.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_alu.vhdl
ghdl -a --std=08 ../../Komponenten/MUX/gen_mux.vhdl
ghdl -a --std=08 ../../Komponenten/MUX/gen_mux4.vhdl
ghdl -a --std=08 ../../Komponenten/SignExtender/sign_extender.vhdl

#Decoder
ghdl -a --std=08 ../../Komponenten/Decoder/decoder.vhdl

#Register
ghdl -a --std=08 ../../Komponenten/Register/gen_register.vhdl

#Registerfile
ghdl -a --std=08 ../../Komponenten/Registerfile/register_file.vhdl


ghdl -a --std=08 ../../Komponenten/Cache/instruction_cache.vhdl
ghdl -a --std=08 ../../Komponenten/Register/ControlWordRegister.vhdl

ghdl -a --std=08 ../../Komponenten/RISCV/riub_riscv.vhdl

ghdl -a  --std=08 riub_riscv_tb.vhdl
ghdl -e  --std=08 riub_only_RISC_V_tb
ghdl -r  --std=08 riub_only_RISC_V_tb --stop-time=10ms --vcd=vcd_riub.vcd
#gtkwave ri_only_risc_v.vcd
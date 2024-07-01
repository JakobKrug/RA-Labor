#!/bin/bash
rm work-obj*.cf

#Analyse Packages
ghdl -a --std=08 ../../Packages/Constant_Package.vhdl
ghdl -a --std=08 ../../Packages/Type_Package.vhdl
ghdl -a --std=08 ../../Packages/Util_Functions_Package.vhdl
ghdl -a --std=08 ../../Packages/Util_Asm_Package.vhdl

#Analyse and Test ALU
ghdl -a --std=08 ../../Komponenten/ALU/my_shifter.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_half_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_n_bit_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_xor.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_or.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_and.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_alu.vhdl

#Takes a while since it tests a lot of cases
# ghdl -a  --std=08 ../ALU/my_alu_tb.vhdl
# ghdl -e  --std=08 my_alu_tb
# ghdl -r  --std=08 my_alu_tb

#Analyse and Test MUX
ghdl -a --std=08 ../../Komponenten/MUX/gen_mux.vhdl
ghdl -a --std=08 ../../Komponenten/MUX/gen_mux4.vhdl

ghdl -a  --std=08 ../MUX/gen_mux_tb.vhdl
ghdl -e  --std=08 gen_mux_tb
ghdl -r  --std=08 gen_mux_tb

#Analyse and Test the Sign Extender
ghdl -a --std=08 ../../Komponenten/SignExtender/sign_extender.vhdl

#Takes a while since it tests a lot of cases
# ghdl -a  --std=08 ../SignExtender/sign_extender_tb.vhdl
# ghdl -e  --std=08 sign_extender_tb
# ghdl -r  --std=08 sign_extender_tb

#Decoder
ghdl -a --std=08 ../../Komponenten/Decoder/decoder.vhdl

#Register
ghdl -a --std=08 ../../Komponenten/Register/gen_register_flush.vhdl
ghdl -a --std=08 ../../Komponenten/Register/gen_register_pc.vhdl

#Registerfile
ghdl -a --std=08 ../../Komponenten/Registerfile/register_file.vhdl

#Memory
ghdl -a --std=08 ../../Komponenten/DataMemory/data_memory.vhdl

ghdl -a --std=08 ../../Komponenten/Cache/instruction_cache.vhdl
ghdl -a --std=08 ../../Komponenten/Register/ControlWordRegister.vhdl

ghdl -a --std=08 ../../Risc-V/riubs_only_RISC_V.vhdl

ghdl -a  --std=08 riubs_only_RISC_V_tb.vhdl
ghdl -e  --std=08 riubs_only_RISC_V_tb
ghdl -r  --std=08 riubs_only_RISC_V_tb --vcd=vcd_riubs.vcd
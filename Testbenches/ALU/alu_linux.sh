#!/bin/bash
rm work-*.cf

ghdl -a --std=08 ../../Packages/Constant_Package.vhdl
 
ghdl -a --std=08 ../../Komponenten/ALU/my_shifter.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_half_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_n_bit_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_xor.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_or.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_and.vhdl

ghdl -a --std=08 ../../Komponenten/ALU/my_alu.vhdl

ghdl -a --std=08 my_alu_tb.vhdl
ghdl -e --std=08 my_alu_tb
ghdl -r --std=08 my_alu_tb --vcd=my_alu_tb.vcd --stop-time=200ns
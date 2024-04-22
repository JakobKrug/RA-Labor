#!/bin/bash
rm work-*.cf

ghdl -a ../../Packages/Constant_Package.vhdl

ghdl -a ../../Komponenten/ALU/my_shifter.vhdl
ghdl -a ../../Komponenten/ALU/my_half_adder.vhdl
ghdl -a ../../Komponenten/ALU/my_full_adder.vhdl
ghdl -a ../../Komponenten/ALU/my_gen_n_bit_full_adder.vhdl
ghdl -a ../../Komponenten/ALU/my_gen_xor.vhdl
ghdl -a ../../Komponenten/ALU/my_gen_or.vhdl
ghdl -a ../../Komponenten/ALU/my_gen_and.vhdl

ghdl -a ../../Komponenten/ALU/my_alu.vhdl

ghdl -a my_alu_tb.vhdl
ghdl -e my_alu_tb
ghdl -r my_alu_tb --vcd=my_alu_tb.vcd
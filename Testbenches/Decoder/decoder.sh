#!/bin/bash
rm work-*.cf

ghdl -a --std=08 ../../Packages/Constant_Package.vhdl
ghdl -a --std=08 ../../Packages/Type_Package.vhdl

ghdl -a --std=08 ../../Komponenten/ALU/my_shifter.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_half_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_n_bit_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_xor.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_or.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_and.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_alu.vhdl

ghdl -a --std=08 ../../Komponenten/Decoder/decoder.vhdl

ghdl -a --std=08 decoder_tb.vhdl
ghdl -e --std=08 decoder_tb
ghdl -r --std=08 decoder_tb --stop-time=200ns --vcd=decoder_tb.vcd
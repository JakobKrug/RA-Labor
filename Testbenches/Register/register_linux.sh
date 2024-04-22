#!/bin/bash
rm work-*.cf

ghdl -a ../../Packages/Constant_Package.vhdl

ghdl -a ../../Komponenten/Register/gen_register.vhdl

ghdl -a gen_register_tb.vhdl
ghdl -e gen_register_tb
ghdl -r gen_register_tb --vcd=gen_register_tb.vcd
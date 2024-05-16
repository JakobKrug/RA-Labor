#!/bin/bash
rm work-*.cf

ghdl -a --std=08 ../../Packages/Constant_Package.vhdl
ghdl -a --std=08 ../../Packages/Types_Package.vhdl

ghdl -a --std=08 ../../Komponenten/Registerfile/register_file.vhdl

ghdl -a --std=08 register_file_tb.vhdl
ghdl -e --std=08 register_file_tb
ghdl -r --std=08 register_file_tb --stop-time=200ns --vcd=register_file_tb.vcd
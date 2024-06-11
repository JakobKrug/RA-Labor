#!/bin/bash
rm work-*.cf

ghdl -a --std=08 ../../Packages/Constant_Package.vhdl
ghdl -a --std=08 ../../Packages/Types_Package.vhdl

ghdl -a --std=08 ../../Komponenten/DataMemory/data_memory.vhdl

ghdl -a --std=08 data_memory_tb.vhdl
ghdl -e --std=08 data_memory_tb
ghdl -r --std=08 data_memory_tb --stop-time=200ns --vcd=data_memory_tb.vcd
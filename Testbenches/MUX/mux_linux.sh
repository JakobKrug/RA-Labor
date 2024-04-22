#!/bin/bash
rm work-*.cf

ghdl -a ../../Constant_Package.vhdl

ghdl -a ../../Komponenten/MUX/gen_mux.vhdl

ghdl -a gen_mux_tb.vhdl
ghdl -e gen_mux_tb
ghdl -r gen_mux_tb --vcd=gen_mux_tb.vcd --stop-time=1ms
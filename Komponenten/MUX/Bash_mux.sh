#!/bin/bash
ghdl -a ../../Packages/Constant_Package.vhdl
ghdl -a ../../Komponent/MUX/gen_mux.vhdl
ghdl -a ../../Testbench/MUX/gen_mux_tb.vhdl
ghdl -e gen_mux_tb
ghdl -r gen_mux_tb --vcd=gen_mux_tb.vcd

#!/bin/bash
rm work-*.cf

ghdl -a --std=08 ../../Packages/Constant_Package.vhdl
ghdl -a --std=08 ../../Packages/Types_Package.vhdl

ghdl -a --std=08 ../../Komponenten/Decoder/decoder.vhdl

ghdl -a --std=08 decoder_tb.vhdl
ghdl -e --std=08 decoder_tb
ghdl -r --std=08 decoder_tb --vcd=decoder_tb.vcd
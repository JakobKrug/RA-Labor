#!/bin/bash
rm work-*.cf

ghdl -a --std=08 ../../Packages/Constant_Package.vhdl
ghdl -a --std=08 ../../Packages/Types_Package.vhdl
ghdl -a --std=08 ../../Packages/Util_Functions_Package.vhdl

ghdl -a --std=08 ../../Komponenten/SignExtender/sign_extender.vhdl

ghdl -a --std=08 sign_extender_tb.vhdl
ghdl -e --std=08 sign_extender_tb
ghdl -r --std=08 sign_extender_tb --stop-time=200ns --vcd=sign_extender_tb.vcd
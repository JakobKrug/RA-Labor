#!/bin/bash

script_path=$(realpath $0)
#each dirname goes one folder up
project_dir=$(dirname $(dirname $(dirname $script_path)))

vhdl_dir="$project_dir/Komponenten/ALU"
tb_dir="$project_dir/Testbenches/ALU"

rm work-*.cf
ghdl -a "$project_dir/Constant_Package.vhdl"

ghdl -a "$vhdl_dir"/my_shifter.vhdl
ghdl -a "$vhdl_dir"/my_half_adder.vhdl
ghdl -a "$vhdl_dir"/my_full_adder.vhdl
ghdl -a "$vhdl_dir"/my_gen_n_bit_full_adder.vhdl
ghdl -a "$vhdl_dir"/my_gen_or.vhdl
ghdl -a "$vhdl_dir"/my_gen_xor.vhdl
ghdl -a "$vhdl_dir"/my_gen_and.vhdl

ghdl -a "$project_dir/my_alu.vhdl"

ghdl -a "$tb_dir"/my_alu_tb.vhdl
ghdl -e "$tb_dir"/my_alu_tb
ghdl -r "$tb_dir"/my_alu_tb --vcd=my_alu.vcd
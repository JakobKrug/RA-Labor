-- ========================================================================
-- Author:       Niklas Gutsmiedl
-- Last updated: 25.03.2024
-- Description:  Some functions that help with writing shorter and more
--               readable code. They are only used in testbenches!
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constant_package.all;
use work.types_package.all;

package util_functions_package is

    -- Function interface declaration. For implemenation, see package body below

    function Asm2Std(instr : string;token1 : integer;token2 : integer;token3 : integer) return std_logic_vector;

end package util_functions_package;

package body util_functions_package is

    -- construct an R-format instruction using the alu opcode (NOT the instruction opcode: see Constant_Package.vhdl)

    function Asm2Std(instr : string;token1 : integer;token2 : integer;token3 : integer) return std_logic_vector is
        variable opcode       : std_logic_vector(6 downto 0);
        variable funct3       : std_logic_vector(2 downto 0);
        variable funct7       : std_logic_vector(6 downto 0);
        variable rd           : std_logic_vector(4 downto 0);
        variable rs1          : std_logic_vector(4 downto 0);
        variable rs2          : std_logic_vector(4 downto 0);
        variable imm          : std_logic_vector(11 downto 0);
        variable machine_word : std_logic_vector(31 downto 0) := (others => '0');
    begin
        if instr = "ADDI" then
            opcode := I_OP_INS; -- I-type
            funct3 := "000";
            rd     := std_logic_vector(to_unsigned(token1, 5));
            rs1    := std_logic_vector(to_unsigned(token2, 5));
            -- Immediate-Wert als 12-bit 2's Komplement
            imm          := std_logic_vector(to_signed(((token3)), 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "ADD" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "000";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SUB" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "000";
            funct7       := "0100000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "AND" then
            opcode       := R_OP_INS;
            funct3       := "111";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "XOR" then
            opcode       := R_OP_INS;
            funct3       := "100";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "OR" then
            opcode       := R_OP_INS;
            funct3       := "110";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SLL" then
            opcode       := R_OP_INS;
            funct3       := "001";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SRL" then
            opcode       := R_OP_INS;
            funct3       := "101";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SRA" then
            opcode       := R_OP_INS;
            funct3       := "101";
            funct7       := "0100000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SLT" then
            opcode       := R_OP_INS;
            funct3       := "010";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SLTU" then
            opcode := R_OP_INS;
            funct3 := "011";
            funct7 := "0000000";
            rd     := std_logic_vector(to_unsigned(token1, 5));
            rs1    := std_logic_vector(to_unsigned(token2, 5));
            rs2    := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SHIFTR" then
            opcode := R_OP_INS;
            funct3 := "100";
            funct7 := "0000000";
            rd     := std_logic_vector(to_unsigned(token1, 5));
            rs1    := std_logic_vector(to_unsigned(token2, 5));
            rs2    := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;
        else
            -- Unsupported instruction
            machine_word := (others => 'X');
        end if;

        return machine_word;
    end function;
end package body util_functions_package;
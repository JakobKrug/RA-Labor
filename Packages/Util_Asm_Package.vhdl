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

package util_asm_package is

    -- Function interface declaration. For implemenation, see package body below

    function Asm2Std(instr : string;token1 : integer;token2 : integer;token3 : integer) return std_logic_vector;

end package util_asm_package;

package body util_asm_package is

    -- construct an R-format instruction using the alu opcode (NOT the instruction opcode: see Constant_Package.vhdl)

    function Asm2Std(instr : string;token1 : integer;token2 : integer;token3 : integer) return std_logic_vector is
        variable opcode       : std_logic_vector(6 downto 0);
        variable funct3       : std_logic_vector(2 downto 0);
        variable funct7       : std_logic_vector(6 downto 0);
        variable rd           : std_logic_vector(4 downto 0);
        variable rs1          : std_logic_vector(4 downto 0);
        variable rs2          : std_logic_vector(4 downto 0);
        variable imm          : std_logic_vector(11 downto 0);
        variable imm20        : std_logic_vector(19 downto 0);
        variable shamt        : std_logic_vector(4 downto 0);
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
            --
        elsif instr = "AND" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "111";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "ANDI" then
            opcode       := I_OP_INS; -- I-type
            funct3       := "111";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(((token3)), 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "AUIPC" then
            opcode       := AUIPC_OP_INS; -- U-type
            rd           := std_logic_vector(to_unsigned(token1, 5));
            imm20        := std_logic_vector(to_signed(((token2)), 20));
            machine_word := imm20 & rd & opcode;

        elsif instr = "BEQ" then
            opcode       := B_OP_INS; -- B-type
            funct3       := "000";
            rs1          := std_logic_vector(to_unsigned(token1, 5));
            rs2          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm(11) & imm(9 downto 4) & rs2 & rs1 & funct3 & imm(3 downto 0) & imm(10) & opcode;

        elsif instr = "BGE" then
            opcode       := B_OP_INS; -- B-type
            funct3       := "101";
            rs1          := std_logic_vector(to_unsigned(token1, 5));
            rs2          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm(11) & imm(9 downto 4) & rs2 & rs1 & funct3 & imm(3 downto 0) & imm(10) & opcode;

        elsif instr = "BGEU" then
            opcode       := B_OP_INS; -- B-type
            funct3       := "111";
            rs1          := std_logic_vector(to_unsigned(token1, 5));
            rs2          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm(11) & imm(9 downto 4) & rs2 & rs1 & funct3 & imm(3 downto 0) & imm(10) & opcode;

        elsif instr = "BLT" then
            opcode       := B_OP_INS; -- B-type
            funct3       := "100";
            rs1          := std_logic_vector(to_unsigned(token1, 5));
            rs2          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm(11) & imm(9 downto 4) & rs2 & rs1 & funct3 & imm(3 downto 0) & imm(10) & opcode;

        elsif instr = "BLTU" then
            opcode       := B_OP_INS; -- B-type
            funct3       := "110";
            rs1          := std_logic_vector(to_unsigned(token1, 5));
            rs2          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed (token3, 12));
            machine_word := imm(11) & imm(9 downto 4) & rs2 & rs1 & funct3 & imm(3 downto 0) & imm(10) & opcode;

        elsif instr = "BNE" then
            opcode       := B_OP_INS; -- B-type
            funct3       := "001";
            rs1          := std_logic_vector(to_unsigned(token1, 5));
            rs2          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed (token3, 12));
            machine_word := imm(11) & imm(9 downto 4) & rs2 & rs1 & funct3 & imm(3 downto 0) & imm(10) & opcode;

        elsif instr = "JAL" then
            opcode       := JAL_OP_INS; -- J-type
            rd           := std_logic_vector(to_unsigned(token1, 5));
            imm20        := std_logic_vector(to_signed(token2, 20));
            machine_word := imm20(19) & imm20(9 downto 0) & imm20(10) & imm20(18 downto 11) & rd & opcode;

        elsif instr = "JALR" then
            opcode       := JALR_OP_INS; -- I-type
            funct3       := "000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "LB" then
            opcode       := L_OP_INS; -- I-type
            funct3       := "000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token3, 5));
            imm          := std_logic_vector(to_signed(token2, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "LBU" then
            opcode       := L_OP_INS; -- I-type
            funct3       := "100";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token3, 5));
            imm          := std_logic_vector(to_signed(token2, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "LH" then
            opcode       := L_OP_INS; -- I-type
            funct3       := "001";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token3, 5));
            imm          := std_logic_vector(to_signed(token2, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "LHU" then
            opcode       := L_OP_INS; -- I-type
            funct3       := "101";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token3, 5));
            imm          := std_logic_vector(to_signed(token2, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "LUI" then
            opcode       := LUI_OP_INS; -- U-type
            rd           := std_logic_vector(to_unsigned(token1, 5));
            imm20        := std_logic_vector(to_signed(token2, 20));
            machine_word := imm20 & rd & opcode;

        elsif instr = "LW" then
            opcode       := L_OP_INS; -- I-type
            funct3       := "010";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token3, 5));
            imm          := std_logic_vector(to_signed(token2, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "OR" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "110";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "ORI" then
            opcode       := I_OP_INS; -- I-type
            funct3       := "110";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "SB" then
            opcode       := S_OP_INS; -- S-type
            funct3       := "000";
            rs1          := std_logic_vector(to_unsigned(token3, 5));
            rs2          := std_logic_vector(to_unsigned(token1, 5));
            imm          := std_logic_vector(to_signed(token2, 12));
            machine_word := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;

        elsif instr = "SH" then
            opcode       := S_OP_INS; -- S-type
            funct3       := "001";
            rs1          := std_logic_vector(to_unsigned(token3, 5));
            rs2          := std_logic_vector(to_unsigned(token1, 5));
            imm          := std_logic_vector(to_signed(token2, 12));
            machine_word := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;

        elsif instr = "SW" then
            opcode       := S_OP_INS; -- S-type
            funct3       := "010";
            rs1          := std_logic_vector(to_unsigned(token3, 5));
            rs2          := std_logic_vector(to_unsigned(token1, 5));
            imm          := std_logic_vector(to_signed(token2, 12));
            machine_word := imm(11 downto 5) & rs2 & rs1 & funct3 & imm(4 downto 0) & opcode;

        elsif instr = "SLL" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "001";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SLLI" then
            opcode       := I_OP_INS;
            funct3       := "001";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            shamt        := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & shamt & rs1 & funct3 & rd & opcode;

        elsif instr = "SLT" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "010";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SLTI" then
            opcode       := I_OP_INS; -- I-type
            funct3       := "010";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "SLTIU" then
            opcode       := I_OP_INS; -- I-type
            funct3       := "011";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;

        elsif instr = "SLTU" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "011";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SRA" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "101";
            funct7       := "0100000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SRAI" then
            opcode       := I_OP_INS;
            funct3       := "101";
            funct7       := "0100000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            shamt        := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & shamt & rs1 & funct3 & rd & opcode;
        elsif instr = "SRL" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "101";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "SRLI" then
            opcode       := I_OP_INS;
            funct3       := "101";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            shamt        := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & shamt & rs1 & funct3 & rd & opcode;

        elsif instr = "XOR" then
            opcode       := R_OP_INS; -- R-type
            funct3       := "100";
            funct7       := "0000000";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            rs2          := std_logic_vector(to_unsigned(token3, 5));
            machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

        elsif instr = "XORI" then
            opcode       := I_OP_INS; -- I-type
            funct3       := "100";
            rd           := std_logic_vector(to_unsigned(token1, 5));
            rs1          := std_logic_vector(to_unsigned(token2, 5));
            imm          := std_logic_vector(to_signed(token3, 12));
            machine_word := imm & rs1 & funct3 & rd & opcode;
        else
            -- Unsupported instruction
            machine_word := (others => 'X');
        end if;

        return machine_word;
    end function;

end package body util_asm_package;
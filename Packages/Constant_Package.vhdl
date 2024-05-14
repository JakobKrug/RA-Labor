-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:
-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

-- ========================================================================
-- Author:       Marcel Rieß, with additions by Niklas Gutsmiedl
-- Last updated: 19.03.2024
-- Description:  Holds various constants related to the RV instruction
--               set that are used throughout the implementation
-- ========================================================================

LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;

PACKAGE constant_package IS

    -- General constants
    CONSTANT ALU_OPCODE_WIDTH : INTEGER := 4;
    CONSTANT OPCODE_WIDTH     : INTEGER := 7;
    CONSTANT DATA_WIDTH_GEN   : INTEGER := 8;
    CONSTANT REG_ADR_WIDTH    : INTEGER := 5;
    CONSTANT ADR_WIDTH        : INTEGER := 32;
    CONSTANT WORD_WIDTH       : INTEGER := 32;
    CONSTANT FUNC3_WIDTH      : INTEGER := 3;

    -- Instruction Opcodes for ALU
    CONSTANT AND_ALU_OP : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "0111";
    CONSTANT XOR_ALU_OP : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "0100";
    CONSTANT OR_ALU_OP  : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "0110";

    CONSTANT SLL_ALU_OP : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "0001";
    CONSTANT SRL_ALU_OP : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "0101";
    CONSTANT SRA_OP_ALU : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "1101";

    CONSTANT ADD_OP_ALU : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "0000";
    CONSTANT SUB_OP_ALU : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "1000";

    CONSTANT SLT_OP_ALU  : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "0010";
    CONSTANT SLTU_OP_ALU : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "0011";

    CONSTANT EQ_OP_ALU : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := "1110"; -- Added this to simplify branch implementation

    CONSTANT FUNC3_SHIFTR : STD_LOGIC_VECTOR(FUNC3_WIDTH - 1 DOWNTO 0) := "101";
    CONSTANT FUNC3_BEQ    : STD_LOGIC_VECTOR(FUNC3_WIDTH - 1 DOWNTO 0) := "000";
    CONSTANT FUNC3_BNE    : STD_LOGIC_VECTOR(FUNC3_WIDTH - 1 DOWNTO 0) := "001";
    CONSTANT FUNC3_BLT    : STD_LOGIC_VECTOR(FUNC3_WIDTH - 1 DOWNTO 0) := "100";
    CONSTANT FUNC3_BGE    : STD_LOGIC_VECTOR(FUNC3_WIDTH - 1 DOWNTO 0) := "101";
    CONSTANT FUNC3_BLTU   : STD_LOGIC_VECTOR(FUNC3_WIDTH - 1 DOWNTO 0) := "110";
    CONSTANT FUNC3_BGEU   : STD_LOGIC_VECTOR(FUNC3_WIDTH - 1 DOWNTO 0) := "111";

    -- RISC-V Instruction Opcodes: Since some instructions (e.g. all R-Format instructions) share the same opcode, only one of them is declared here

    -- U-Format
    CONSTANT LUI_OP_INS   : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "0110111"; -- lui
    CONSTANT AUIPC_OP_INS : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "0010111"; -- auipc

    -- J-Format
    CONSTANT JAL_OP_INS : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "1101111"; -- jal

    -- B-Format
    CONSTANT BEQ_OP_INS : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "1100011"; -- beq, all B-Format instructions have the same opcode

    -- S-Format
    CONSTANT SB_OP_INS : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "0100011"; -- sb

    -- I-Format
    CONSTANT JALR_OP_INS : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "1100111"; -- jalr

    CONSTANT LB_OP_INS : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "0000011"; -- lb

    CONSTANT I_OP_INS : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "0010011"; -- addi

    -- R-Format
    CONSTANT R_OP_INS : STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 DOWNTO 0) := "0110011"; -- add

END PACKAGE constant_package;
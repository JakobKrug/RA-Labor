-- Laboratory RA solutions/versuch5
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Niklas Gutsmiedl
-- Last updated: 25.03.2024
-- Description:  Holds various custom types related to the implementation
--               that are used throughout the implementation
-- ========================================================================

library IEEE;
use ieee.std_logic_1164.all;
use work.constant_package.all;

package types_package is

    -- decoder po_output, used to control cpu

    type controlword is record
        ALU_OP       : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0); -- determines the ALU's operation
        I_IMM_SEL    : std_logic;                                       -- used as a MUX selector for i-Format Immediates
        J_IMM_SEL    : std_logic;                                       -- used as a MUX selector for i-Format Immediates
        U_IMM_SEL    : std_logic;                                       -- used as a MUX selector for u-Format Immediates
        SET_PC_SEL   : std_logic;                                       -- used as a MUX selector for u-Format Immediates
        PC_SEL       : std_logic;                                       -- used as a MUX selector to set the PC (only for jalr)
        A_SEL        : std_logic;
        WB_SEL       : std_logic_vector(1 downto 0);     -- used as a MUX selector 
        IS_BRANCH    : std_logic;                        -- used as MUX selector to increment PC (used for B-Format instructions, branches)
        CMP_RESULT   : std_logic;                        -- is set to the expected result for each compare operation, if the branch were to be taken. By using this (and XORing it with the ALU result), the ALU does not need an extra output flag for branching
        DATA_CONTROL : std_logic_vector(4 - 1 downto 0); -- used as an input for the data cache, the first bit is used to differentiate between singed/unsigned, the following two bits determine the bit length (correlates to func3 in instruction) and the last bit is writeEnable.
    end record controlWord;

    -- allows initialization of control words, used in decoder
    constant control_word_init : controlWord :=
    (
    ALU_OP => (others => '0'),
    I_IMM_SEL  => '0',
    J_IMM_SEL  => '0',
    U_IMM_SEL  => '0',
    SET_PC_SEL => '0',
    PC_SEL     => '0',
    A_SEL      => '0',
    WB_SEL     => "00",
    IS_BRANCH  => '0',
    CMP_RESULT => '0',
    DATA_CONTROL => (others => '0')
    );

    -- enum containig all instruction formats, used in decoder

    type t_instruction_type is (rFormat, iFormat, uFormat, bFormat, sFormat, jFormat, nullFormat);

    type memory is array (0 to 2 ** 10 - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- Used for instruction cache

    type registermemory is array (0 to 2 ** REG_ADR_WIDTH - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- used in register file

end package types_package;
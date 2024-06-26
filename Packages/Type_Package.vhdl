-- ========================================================================
-- Author:       Marcel Riess
-- Last updated: 25.05.2024
-- Description:  Holds various custom types related to the implementation
--               that are used throughout the implementation
-- ========================================================================

library IEEE;
use ieee.std_logic_1164.all;
use work.constant_package.all;

package types_package is

    -- decoder po_output, used to control cpu

    type controlword is record
        ALU_OP     : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0); -- determines the ALU's operation
        I_IMM_SEL  : std_logic;                                       -- used as a MUX selector for i-Format Immediates
        PC_SEL     : std_logic;                                       -- used as a MUX selector to set the PC (only for jalr)
        A_SEL      : std_logic;                                       -- used as a MUX selector 
        WB_SEL     : std_logic_vector(1 downto 0);                    -- used as a MUX selector 
        IS_BRANCH  : std_logic;                                       -- used as MUX selector to increment PC (used for B-Format instructions, branches)
        CMP_RESULT : std_logic;                                       -- is set to the expected result for each compare operation, if the branch were to be taken. By using this (and XORing it with the ALU result), the ALU does not need an extra output flag for branching
        MEM_CTR    : std_logic_vector(2 downto 0);                    -- used as an input for the data cache, the first bit is used to differentiate between singed/unsigned, the following two bits determine the bit length (correlates to func3 in instruction) and the last bit is writeEnable.
        MEM_READ   : std_logic;
        MEM_WRITE  : std_logic;
        REG_WRITE  : std_logic;
        IS_JUMP    : std_logic;
    end record controlWord;

    -- allows initialization of control words, used in decoder
    constant control_word_init : controlWord :=
    (
    ALU_OP => (others => '0'),
    I_IMM_SEL  => '0',
    PC_SEL     => '0',
    A_SEL      => '0',
    WB_SEL => (others => '0'),
    IS_BRANCH  => '0',
    CMP_RESULT => '0',
    MEM_CTR => (others => '0'),
    MEM_READ   => '0',
    MEM_WRITE  => '0',
    REG_WRITE  => '0',
    IS_JUMP    => '0'
    );

    -- enum containig all instruction formats, used in decoder

    type t_instruction_type is (rFormat, iFormat, uFormat, bFormat, sFormat, jFormat, nullFormat);

    type memory is array (0 to 2 ** 10 - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- Used for instruction cache

    type registermemory is array (0 to 2 ** REG_ADR_WIDTH - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- used in register file

end package types_package;
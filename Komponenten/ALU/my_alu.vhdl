-- 1. Participant First and Last Name: Jakob Krug
-- 2. Participant First and Last Name: Nicolas Schmidt

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.Constant_Package.all;
entity my_alu is
    generic (
        dataWidth   : integer := DATA_WIDTH_GEN;
        opcodeWidth : integer := ALU_OPCODE_WIDTH
    );

    port (
        pi_op1, pi_op2 : in std_logic_vector(dataWidth - 1 downto 0);
        pi_aluOP       : in std_logic_vector(opcodeWidth - 1 downto 0);
        po_aluOut      : out std_logic_vector(dataWidth - 1 downto 0);
        po_carryOut    : out std_logic;
        po_zero        : out std_logic
    );

end entity my_alu;

architecture arc of my_alu is
    constant C_ZERO                                       : std_logic_vector(dataWidth - 1 downto 0)   := (others => '0');
    constant C_ONE                                        : std_logic_vector (dataWidth - 1 downto 0)  := std_logic_vector(to_signed(1, dataWidth));
    signal s_op1, s_op2                                   : std_logic_vector(dataWidth - 1 downto 0)   := (others => '0');
    signal s_res1, s_res2, s_res3, s_res4, s_res5         : std_logic_vector(dataWidth - 1 downto 0)   := (others => '0');
    signal s_cIn, s_cOut, s_shift_type, s_shift_direction : std_logic                                  := '0';
    signal s_lu_op                                        : std_logic_vector(opcodeWidth - 1 downto 0) := (others => '0');
    signal s_aluOut                                       : std_logic_vector(dataWidth - 1 downto 0)   := (others => '0');
begin
    XOR1  : entity work.my_gen_xor generic map (dataWidth) port map (s_op1, s_op2, s_res1);
    OR1   : entity work.my_gen_or generic map (dataWidth) port map (s_op1, s_op2, s_res2);
    AND1  : entity work.my_gen_and generic map (dataWidth) port map (s_op1, s_op2, s_res3);
    SHIFT : entity work.my_shifter generic map (dataWidth) port map (s_op1, s_op2, s_shift_type, s_shift_direction, s_res4);
    ADD1  : entity work.my_gen_n_bit_full_adder generic map (dataWidth) port map (s_op1, s_op2, s_cIn, s_res5, s_cOut);

    s_op1 <= pi_op1;
    s_op2 <= pi_op2;

    with pi_aluOP select
        s_shift_type <= '0' when SLL_ALU_OP,
        '0' when SRL_ALU_OP,
        '1' when SRA_OP_ALU,
        '0' when others;

    with pi_aluOP select
        s_shift_direction <= '0' when SLL_ALU_OP,
        '1' when SRL_ALU_OP,
        '1' when SRA_OP_ALU,
        '0' when others;

    with pi_aluOP select
        s_cIn <= '0' when ADD_OP_ALU,
        '1' when SUB_OP_ALU,
        '1' when SLT_OP_ALU,
        '1' when SLTU_OP_ALU,
        '0' when others;

    s_aluOut <= s_res1 when pi_aluOP = XOR_ALU_OP
        else
        s_res2 when pi_aluOP = OR_ALU_OP
        else
        s_res3 when pi_aluOP = AND_ALU_OP
        else
        s_res4 when pi_aluOP = SLL_ALU_OP
        else
        s_res4 when pi_aluOP = SRL_ALU_OP
        else
        s_res4 when pi_aluOP = SRA_OP_ALU
        else
        s_res5 when pi_aluOP = ADD_OP_ALU
        else
        s_res5 when pi_aluOP = SUB_OP_ALU
        else
        C_ONE when (pi_aluOP = SLT_OP_ALU and (s_op1(dataWidth - 1) = '1') and (s_op2(dataWidth - 1) = '0'))
        else
        C_ZERO when (pi_aluOP = SLT_OP_ALU and (s_op1(dataWidth - 1) = '0') and (s_op2(dataWidth - 1) = '1'))
        else
        C_ONE when (pi_aluOP = SLT_OP_ALU and (s_res5(dataWidth - 1) = '1'))
        else
        C_ZERO when (pi_aluOP = SLT_OP_ALU)
        else
        C_ONE when (pi_aluOP = SLTU_OP_ALU and (s_op1(dataWidth - 1) = '0') and (s_op2(dataWidth - 1) = '1'))
        else
        C_ONE when (pi_aluOP = SLTU_OP_ALU and (s_op1(dataWidth - 1) = '0') and (s_op2(dataWidth - 1) = '0') and (s_res5(dataWidth - 1) = '1'))
        else
        C_ONE when (pi_aluOP = SLTU_OP_ALU and (s_op1(dataWidth - 1) = '1') and (s_op2(dataWidth - 1) = '1') and (s_res5(dataWidth - 1) = '1'))
        else
        C_ZERO when (pi_aluOP = SLTU_OP_ALU and (s_op1(dataWidth - 1) = '1') and (s_op2(dataWidth - 1) = '0'))
        else
        C_ZERO when (pi_aluOP = SLTU_OP_ALU and (s_op1(dataWidth - 1) = '0') and (s_op2(dataWidth - 1) = '0') and (s_res5(dataWidth - 1) = '0'))
        else
        C_ZERO when (pi_aluOP = SLTU_OP_ALU and (s_op1(dataWidth - 1) = '1') and (s_op2(dataWidth - 1) = '1') and (s_res5(dataWidth - 1) = '0'))
        else
        s_op1;

    po_carryOut <= s_cOut;
    po_aluOut   <= s_aluOut;

    po_zero <= '1' when s_aluOut = C_ZERO else
        '0';

end architecture arc;
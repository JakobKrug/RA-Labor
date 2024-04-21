-- Laboratory RA solutions/versuch1
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß, with additions by Niklas Gutsmiedl
-- Last updated: 19.03.2024
-- Description:  Generic ALU used in the RV Processor. Simultaneously
--               computes results for the following operations, in one clock
--               cyle: add, sub, and, or, xor, sll, srl, sra, slt, sltu, eq
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;

entity my_alu is
-- begin solution:
port(
  P_OP1, P_OP2: in std_logic_vector(G_DATA_WIDTH-1 downto 0);
	P_ALU_OP: in std_logic_vector (G_OP_WIDTH-1 downto 0);
	P_CLK: in std_logic;
	P_ALU_OUT: out std_logic_vector (G_DATA_WIDTH-1 downto 0);
	P_CARRY_OUT: out std_logic
)
  -- end solution!!
end entity my_alu;

architecture behavior of my_alu is

  signal s_op1               : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_op2               : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res1              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res2              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res3              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res4              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res5              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res6              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res7              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res8              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_cin               : std_logic                                   := '0';
  signal s_cout              : std_logic                                   := '0';
  signal s_shiftType         : std_logic                                   := '0';
  signal s_shiftDirection    : std_logic                                   := '0';
  signal s_clk               : std_logic                                   := '0';
  signal s_zeropadding       : std_logic_vector(dataWidth - 1 downto 1) := (others => '0');
  signal s_luOp              : std_logic_vector(opCodeWidth   - 1 downto 0) := (others => '0');

begin

  xor1 : entity work.my_gen_xor
    generic map (
dataWidth
    )
    port map (
s_op1,
 s_op2,
 s_res1
    );

  or1 : entity work.my_gen_or
    generic map (
dataWidth
    )
    port map (
s_op1,
 s_op2,
 s_res2
    );

  and1 : entity work.my_gen_and
    generic map (
dataWidth
    )
    port map (
s_op1,
 s_op2,
 s_res3
    );

  shift : entity work.my_shifter
    generic map (
dataWidth
    )
    port map (
s_op1,
 s_op2,
s_shiftType,
s_shiftDirection,
 s_res4
    );

  add1 : entity work.my_gen_n_bit_full_adder
    generic map (
dataWidth
    )
    port map (
s_op1,
 s_op2,
 s_cin,
 s_res5,
 s_cout
    );

  s_clk <= pi_clk;

  process (s_clk) is
  begin

    if rising_edge(s_clk) then
      s_op1 <= pi_op1;
      s_op2 <= pi_op2;
      if (pi_aluOp = AND_ALU_OP) then
        -- AND
        -- begin solution:
        -- end solution!!
      elsif (pi_aluOp = OR_ALU_OP) then
        -- OR
        -- begin solution:
        -- end solution!!
      elsif (pi_aluOp = XOR_ALU_OP) then
        -- XOR
        -- begin solution:
        -- end solution!!
      elsif (pi_aluOp = SLL_ALU_OP) then
        -- SLL
        -- begin solution:
        s_shift_type <= P_ALU_OP(G_OP_WIDTH-1);
        s_shift_direction <= '0';
        -- end solution!!
      elsif (pi_aluOp = SRL_ALU_OP) then
        -- SRL
        -- begin solution:
        s_shift_type <= P_ALU_OP(G_OP_WIDTH-1);
		  s_shift_direction <= '1';
        -- end solution!!
      elsif (pi_aluOp = SRA_OP_ALU) then
        -- SRA
        -- begin solution:
        s_shift_type <= P_ALU_OP(G_OP_WIDTH-1);
		    s_shift_direction <= '1';
        -- end solution!!
      elsif (pi_aluOp = ADD_OP_ALU) then
        -- ADD
        -- begin solution:
        s_cIn <= P_ALU_OP(G_OP_WIDTH-1);
        -- end solution!!
      elsif (pi_aluOp = SUB_OP_ALU) then
        -- SUB
        -- begin solution:
        s_cIn <= P_ALU_OP(G_OP_WIDTH-1);
        -- end solution!!
      elsif (pi_aluOp = SLT_OP_ALU) then
        -- SLT
        -- begin solution:
        -- end solution!!                                                                                                               -- SLT, uses substraction
      elsif (pi_aluOp = SLTU_OP_ALU) then
        -- SLTU
        -- begin solution:
        -- end solution!!                                                                                                                -- SLTU, uses substraction
      elsif (pi_aluOp = EQ_OP_ALU) then
      else
        -- OTHERS
        -- begin solution:
      -- end solution!!
      end if;
    end if;

    if falling_edge(s_clk) then
      if (pi_aluOp = AND_ALU_OP) then
        -- AND
        -- begin solution:
        P_ALU_OUT <= s_res3;
	      P_CARRY_OUT <= '0';
      -- end solution!!
      elsif (pi_aluOp = OR_ALU_OP) then
        -- OR
        -- begin solution:
        P_ALU_OUT <= s_res2;
	      P_CARRY_OUT <= '0';
      -- end solution!!
      elsif (pi_aluOp = XOR_ALU_OP) then
        -- XOR
        P_ALU_OUT <= s_res1;
	      P_CARRY_OUT <= '0';
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SLL_ALU_OP) then
        -- SLL
        P_ALU_OUT <= s_res4;
	      P_CARRY_OUT <= '0';
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SRL_ALU_OP) then
        -- SRL
        P_ALU_OUT <= s_res4;
	      P_CARRY_OUT <= '0';
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SRA_OP_ALU) then
        -- SRA
        P_ALU_OUT <= s_res4;
	      P_CARRY_OUT <= '0';
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = ADD_OP_ALU) then
        -- ADD
        P_ALU_OUT <= s_res5;
	      P_CARRY_OUT <= s_cOut;
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SUB_OP_ALU) then
        -- SUB
        P_ALU_OUT <= s_res5;
	      P_CARRY_OUT <= s_cOut;
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SLT_OP_ALU) then
        -- SLT
        -- begin solution:
        -- begin solution:
        -- end solution!!                                                                                     -- SLTU
      elsif (pi_aluOp = EQ_OP_ALU) then
        -- begin solution:
        -- end solution!!
      else
        -- OTHERS
        -- begin solution:
        P_ALU_OUT <= (others => '0');
	      P_CARRY_OUT <= '0';
        -- end solution!!
      end if;
    end if;

  end process;

end architecture behavior;

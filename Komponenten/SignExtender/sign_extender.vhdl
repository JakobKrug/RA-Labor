-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date: 30.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
 
-- ========================================================================
-- Description:  Sign extender for a RV32I processor. Takes the entire instruction
--               and produces a 32-Bit value by sign-extending, shifting and piecing
--               together the immedate value in the instruction.
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;
  use work.types_package.all;

entity sign_extender is
-- begin solution:
port(
  pi_instr : in std_logic_vector (WORD_WIDTH -1 downto 0);
  po_uImmediate : out std_logic_vector (WORD_WIDTH -1 downto 0);
  po_iImmediate : out std_logic_vector (WORD_WIDTH -1 downto 0);
  po_bImmediate : out std_logic_vector (WORD_WIDTH -1 downto 0);
  po_jImmediate : out std_logic_vector (WORD_WIDTH -1 downto 0)
);
   -- end solution!!
end entity sign_extender;

architecture arc of sign_extender is
-- begin solution:
begin
prozess: process (pi_instr) is

begin
    po_uImmediate(11 downto 0) <= (others => '0');
    po_uImmediate(31 downto 12) <= pi_instr(31 downto 12);

    po_iImmediate(0) <= pi_instr(20);
    po_iImmediate(4 downto 1) <= pi_instr(24 downto 21);
    po_iImmediate(10 downto 5) <= pi_instr(30 downto 25);
    po_iImmediate(31 downto 11) <= (others => pi_instr(31));

    po_bImmediate(0) <= '0';
    po_bImmediate(4 downto 1) <= pi_instr(11 downto 8);
    po_bImmediate(10 downto 5) <= pi_instr(30 downto 25);
    po_bImmediate(11) <= pi_instr(7);
    po_bImmediate(31 downto 12) <= (others => pi_instr(31));

    po_jImmediate(0) <= '0';
    po_jImmediate(4 downto 1) <= pi_instr(24 downto 21);
    po_jImmediate(10 downto 5) <= pi_instr(30 downto 25);
    po_jImmediate(11) <= pi_instr(20);
    po_jImmediate(19 downto 12) <= pi_instr(19 downto 12);
    po_jImmediate(24 downto 21) <= pi_instr(24 downto 21);
    po_jImmediate(31 downto 20) <= (others => pi_instr(31));
end process;
 -- end solution!!
end architecture arc;
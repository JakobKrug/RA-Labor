-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:
 
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
    pi_instr : in std_logic_vector(word_width - 1 downto 0);
    po_iImmediate, po_uImmediate, po_bImmediate, po_jImmediate : out std_logic_vector(word_width - 1 downto 0)
);
   -- end solution!!
end entity sign_extender;

architecture arc of sign_extender is
-- begin solution:
begin
    process (pi_instr)
        variable sign_extended : std_logic_vector(WORD_WIDTH - 1 downto 0);
    begin
        -- Perform sign extension based on RISC-V specification
        sign_extended := (others => pi_instr(31)); -- Fill with sign bit

        -- Assign sign-extended value to respective outputs
        po_iImmediate <= sign_extended(31 downto 20) & pi_instr(19 downto 0); -- I-type Immediate
        po_uImmediate <= (others => '0') & pi_instr(19 downto 0);             -- U-type Immediate
        po_bImmediate <= sign_extended(31) & pi_instr(7) & pi_instr(30 downto 25) & pi_instr(11 downto 8) & (others => '0'); -- B-type Immediate
        po_jImmediate <= sign_extended(31) & pi_instr(19 downto 12) & pi_instr(20) & pi_instr(30 downto 21) & (others => '0'); -- J-type Immediate
    end process;
 -- end solution!!
end architecture arc;

-- Laboratory RA solutions/versuch3
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Jakob Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

-- ========================================================================
-- Author:       Niklas Gutsmiedl
-- Last updated: 02.2024
-- Description:  Register to hold signals of type controlWord,
--               as defined in Types_Package.vhdl. Used as phase registers  
--               for the control path in the RV pipeline
-- ========================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.all;
use work.Constant_Package.all;
use work.Types_Package.all;

entity ControlWordRegister is

    port (
        pi_rst         : in std_logic;
        pi_clk         : in std_logic;
        pi_controlWord : in controlWord  := CONTROL_WORD_INIT;
        po_controlWord : out controlWord := CONTROL_WORD_INIT
    );
end ControlWordRegister;

architecture behavior of ControlWordRegister is
    signal s_controlWord : controlWord := CONTROL_WORD_INIT;
begin

    process (pi_clk, pi_rst)

    begin

        if (pi_rst) then s_controlWord                <= CONTROL_WORD_INIT;
        elsif rising_edge (pi_clk) then s_controlWord <= pi_controlWord;
        end if;
    end process;

    po_controlWord <= s_controlWord;
end behavior;
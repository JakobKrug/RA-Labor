-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.all;
use work.Constant_Package.all;
use work.Types_Package.all;

entity ControlWordRegister is

    port
    (
        pi_rst         : in std_logic;
        pi_clk         : in std_logic;
        pi_controlWord : in controlWord  := control_word_init; -- incoming control word
        po_controlWord : out controlWord := control_word_init  -- outgoing control word
    );
end ControlWordRegister;

architecture arc1 of ControlWordRegister is
    signal s_controlWord : controlWord := control_word_init;
begin
    process (pi_clk, pi_rst)
    begin
        if (pi_rst) then
            s_controlWord <= control_word_init;
        elsif rising_edge (pi_clk) then
            s_controlWord <= pi_controlWord; -- update register contents on falling clock edge
        end if;
    end process;
    po_controlWord <= s_controlWord;
end arc1;
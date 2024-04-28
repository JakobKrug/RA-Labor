-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:
 
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.Constant_package.all;
  use work.types_package.all;

entity decoder is
-- begin solution:
port(
    pi_clk : in std_logic := (others <= '0');
    pi_instruction : in std_logic_vector(WORD_WIDTH - 1 downto 0);
    po_controlWord : out record:controlWord
);
-- end solution!!
end entity decoder;


architecture arc of decoder is
-- begin solution:
begin
    process(pi_clk);
    begin 
    if rising_edge(pi_clk)
    
    end if;
    end process;
 -- end solution!!
end architecture;
-- 1. Participant First and Last Name: Jakob Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
library ieee;
use ieee.std_logic_1164.all;

entity my_half_adder is
    port (
        pi_a, pi_b          : in std_logic;
        po_sum, po_carryOut : out std_logic
    );
end my_half_adder;

architecture dataflow of my_half_adder is
    signal s_temp : std_logic;
begin
    po_sum      <= ((pi_a nand pi_a) nand pi_b) nand (pi_a nand (pi_b nand pi_b));
    po_carryOut <= (pi_a nand pi_b) nand (pi_a nand pi_b);
end dataflow;
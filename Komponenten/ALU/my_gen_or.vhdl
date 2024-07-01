-- 1. Participant First and Last Name: Jakob Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.Constant_Package.all;

entity my_gen_or is
    generic (
        dataWidth : integer := 8
    );
    port (
        op1, op2 : in std_logic_vector(dataWidth - 1 downto 0);
        res      : out std_logic_vector(dataWidth - 1 downto 0)
    );
end entity;

architecture dataflow of my_gen_or is
begin
    res <= op1 or op2;
end architecture;
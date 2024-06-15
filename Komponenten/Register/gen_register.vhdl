-- Laboratory RA solutions/versuch1
-- Sommersemester 24
-- Group Details
-- Lab Date: 23.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_Package.all;

entity gen_register is
    -- begin solution:
    generic (
        registerWidth : integer := 32
    );
    port (
        pi_clk, pi_rst, pi_flush : in std_logic                                     := '0';
        pi_data                  : in std_logic_vector(registerWidth - 1 downto 0)  := (others => '0');
        po_data                  : out std_logic_vector(registerWidth - 1 downto 0) := (others => '0')
    );
    -- end solution!!
end gen_register;

architecture behavior of gen_register is
    -- begin solution:
begin
    process (pi_clk, pi_rst, pi_flush) is
    begin
        if (pi_rst = '1') then
            po_data <= (others => '0');
        elsif (rising_edge(pi_clk)) then
            if (pi_flush = '1') then
                po_data <= (others => '0');
            else
                po_data <= pi_data;
            end if;
        end if;
    end process;
    -- end solution!!
end behavior;
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
    generic (
        registerWidth : integer := REG_ADR_WIDTH
    );
    port (
        pi_data : in std_logic_vector(registerWidth - 1 downto 0);
        pi_clk  : in std_logic                                     := '0';
        pi_rst  : in std_logic                                     := '0';
        po_data : out std_logic_vector(registerWidth - 1 downto 0) := (others => '0')
    );
end gen_register;

architecture behavior of gen_register is
    signal s_current_data : std_logic_vector(registerWidth - 1 downto 0) := (others => '0');
begin
    process (pi_clk, pi_rst, s_current_data)
    begin
        if falling_edge(pi_clk) then
            s_current_data <= pi_data;
        end if;
        if (pi_rst = '1') then
            s_current_data <= (others => '0');
        end if;
        po_data <= s_current_data;
    end process;
end behavior;
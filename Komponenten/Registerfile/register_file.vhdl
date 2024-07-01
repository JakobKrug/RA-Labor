-- 1. Participant First and Last Name: Nicolas Schmidt 
-- 2. Participant First and Last Name: Jakob Krug
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constant_package.all;
use work.types_package.all;
use work.Util_Functions_Package.all;

entity register_file is
    -- begin solution:
    generic
    (
        wordWidth     : integer := WORD_WIDTH;
        registerWidth : integer := REG_ADR_WIDTH;
        regAmount     : integer := 2 ** REG_ADR_WIDTH
    );
    port
    (
        pi_clk, pi_rst, pi_writeEnable                    : in std_logic;
        pi_readRegAddr1, pi_readRegAddr2, pi_writeRegAddr : in std_logic_vector (registerWidth - 1 downto 0) := (others => '0');
        pi_writeRegData                                   : in std_logic_vector (wordWidth - 1 downto 0)     := (others => '0');
        po_readRegData1, po_readRegData2                  : out std_logic_vector (wordWidth - 1 downto 0)    := (others => '0');
        po_registerOut                                    : out registermemory
    );
    -- end solution!!
end entity register_file;

architecture behavior of register_file is
    -- begin solution:
    signal s_regs : registermemory                                := (others => (others => '0'));
    signal s_null : std_logic_vector (registerWidth - 1 downto 0) := (others => '0');
begin
    process (pi_clk, pi_rst, pi_writeEnable)
    begin
        if pi_rst = '1' then
            s_regs <= (others => (others => '0'));
        elsif pi_rst = '0' then
            if falling_edge(pi_clk) then
                if pi_writeEnable = '1' then
                    if pi_writeRegAddr /= s_null then
                        s_regs(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
                    end if;
                end if;
                po_readRegData1 <= s_regs(to_integer(unsigned(pi_readRegAddr1)));
                po_readRegData2 <= s_regs(to_integer(unsigned(pi_readRegAddr2)));
            end if;
        end if;
        po_registerOut <= s_regs;
    end process;
    -- end solution!!
end architecture behavior;
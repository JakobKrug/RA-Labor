-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Nicolas Schmidt 
-- 2. Participant First and Last Name: Jakob Krug

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.types_package.all;
use work.constant_package.all;

entity register_file is
    -- begin solution:
    generic (
        WORD_WIDTH : integer := WORD_WIDTH;
        ADDR_WIDTH : integer := REG_ADR_WIDTH;
        REG_AMOUNT : integer := 2 ** (REG_ADR_WIDTH)
    );
    port (
        pi_clk          : in std_logic;
        pi_rst          : in std_logic;
        pi_readRegAddr1 : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        pi_readRegAddr2 : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        pi_writeRegAddr : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
        pi_writeRegData : in std_logic_vector(WORD_WIDTH - 1 downto 0);
        pi_writeEnable  : in std_logic;
        po_readRegData1 : out std_logic_vector(WORD_WIDTH - 1 downto 0);
        po_readRegData2 : out std_logic_vector(WORD_WIDTH - 1 downto 0);
        po_registerOut  : out registermemory
    );
    -- end solution!!
end entity register_file;

architecture arc of register_file is
    signal s_registers : registermemory := (others => (others => '0'));
    -- begin solution:
begin

    process (pi_clk, pi_rst)
    begin

        if (pi_rst = '1') then
            s_registers <= (others => (others => '0'));
        else
            if (falling_edge(pi_clk)) then
                if (pi_writeEnable = '1') then
                    if (to_integer(unsigned(pi_writeRegAddr)) /= 0) then
                        s_registers(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
                    end if;
                end if;
            end if;
        end if;
    end process;
    po_registerOut <= s_registers;
    po_readRegData1 <= s_registers(to_integer(unsigned(pi_readRegAddr1)));
    po_readRegData2 <= s_registers(to_integer(unsigned(pi_readRegAddr2)));
    -- end solution!!
end architecture arc;
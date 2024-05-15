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
use work.constant_package.all;
use work.types_package.all;

entity register_file is
    generic (
        word_width : integer := WORD_WIDTH;
        adr_width  : integer := REG_ADR_WIDTH;
        reg_amount : integer := 2 ** REG_ADR_WIDTH
    );
    port (
        pi_clk          : in std_logic                                    := '0';
        pi_rst          : in std_logic                                    := '0';
        pi_readRegAddr1 : in std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
        pi_readRegAddr2 : in std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
        pi_writeRegAddr : in std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
        pi_writeRegData : in std_logic_vector(WORD_WIDTH - 1 downto 0)    := (others => '0');
        pi_writeEnable  : in std_logic                                    := '0';
        po_readRegData1 : out std_logic_vector(WORD_WIDTH - 1 downto 0)   := (others => '0');
        po_readRegData2 : out std_logic_vector(WORD_WIDTH - 1 downto 0)   := (others => '0');
        po_registerOut  : out registermemory                              := (others => (others => '0'))
    );
end entity register_file;

architecture arc of register_file is
    signal s_regs  : registermemory                            := (others => (others => '0'));
    signal s_init  : boolean                                   := false;
    constant REG_0 : std_logic_vector(word_width - 1 downto 0) := (others => '0');
begin
    process (pi_clk, pi_rst, pi_writeEnable)
    begin
        if (pi_rst = '1') then
            s_regs <= (others => (others => '0'));
        elsif rising_edge(pi_clk) then
            po_readRegData1 <= s_regs(to_integer(unsigned(pi_readRegAddr1)));
            po_readRegData2 <= s_regs(to_integer(unsigned(pi_readRegAddr2)));
            if pi_writeEnable = '1' and (to_integer(unsigned(pi_writeRegAddr))) /= 0 then
                s_regs(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
            end if;
        end if;
    end process;
    po_registerOut <= s_regs;
end architecture arc;
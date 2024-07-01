-- 1. Participant First and Last Name: Jakob Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constant_package.all;
use work.util_functions_package.all;
use work.types_package.all;

entity instruction_cache is
    generic
    (
        adr_width : integer := ADR_WIDTH;
        mem_size  : integer := 2 ** 10
    );
    port
    (
        pi_adr              : in std_logic_vector(adr_width - 1 downto 0) := (others => '0');
        pi_clk              : in std_logic;
        pi_instructionCache : in memory                                     := (others => (others => '0'));
        po_instruction      : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0')
    );
end entity instruction_cache;

architecture behavior of instruction_cache is
    signal s_input      : std_logic_vector(ADR_WIDTH - 1 downto 0) := (others => '0');
    signal instructions : memory                                   := (others => (others => '0'));
begin
    instructions <= pi_instructionCache;
    process (pi_clk) is
    begin
        if rising_edge(pi_clk) then
            po_instruction <= instructions(to_integer(unsigned(pi_adr)));
        end if;
    end process;
end architecture behavior;
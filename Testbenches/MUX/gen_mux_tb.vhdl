-- Laboratory RA solutions/versuch1
-- Sommersemester 24
-- Group Details
-- Lab Date: 23.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constant_package.all;

entity gen_mux_tb is
end entity gen_mux_tb;

architecture behavior of gen_mux_tb is

    signal s_first    : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_second   : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_selector : std_logic                                     := '0';
    signal s_output   : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');

begin
    MUX : entity work.gen_mux(dataflow)
        generic map(
            DATA_WIDTH_GEN
        )
        port map(
            pi_first    => s_first,
            pi_second   => s_second,
            pi_selector => s_selector,
            po_output   => s_output
        );

    process
    begin
        for i in 0 to (2 ** DATA_WIDTH_GEN) - 1 loop
            s_selector <= '0';
            wait for 5 ns;

            s_first <= std_logic_vector(to_unsigned(i, DATA_WIDTH_GEN));

            assert s_first = s_output report "Had an error with input:" & integer'image(i) severity error;
            wait for 5 ns;

            s_selector <= '1';
            wait for 5 ns;

            s_second <= std_logic_vector(to_unsigned(i, DATA_WIDTH_GEN));

            assert s_output = s_second report "Had an error with input:" & integer'image(i) severity error;
        end loop;
        wait for 5 ns;

        assert false report "end of test" severity note;
        wait;
    end process;
end architecture behavior;
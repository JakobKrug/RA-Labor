-- Laboratory RA solutions/versuch1
-- Sommersemester 24
-- Group Details
-- Lab Date: 23.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.constant_package.ALL;

ENTITY gen_mux_tb IS
END ENTITY gen_mux_tb;

ARCHITECTURE behavior OF gen_mux_tb IS

    SIGNAL s_first    : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_second   : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_selector : STD_LOGIC                                     := '0';
    SIGNAL s_output   : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN
    MUX : ENTITY work.gen_mux(dataflow)
        GENERIC MAP(
            DATA_WIDTH_GEN
        )
        PORT MAP(
            pi_first    => s_first,
            pi_second   => s_second,
            pi_selector => s_selector,
            po_output   => s_output
        );

    PROCESS
    BEGIN
        FOR i IN 0 TO (2 ** DATA_WIDTH_GEN) - 1 LOOP
            s_selector <= '0';
            WAIT FOR 5 ns;

            s_first <= STD_LOGIC_VECTOR(to_unsigned(i, DATA_WIDTH_GEN));

            ASSERT s_first = s_output REPORT "Had an error with input:" & INTEGER'image(i) SEVERITY error;
            WAIT FOR 5 ns;

            s_selector <= '1';
            WAIT FOR 5 ns;

            s_second <= STD_LOGIC_VECTOR(to_unsigned(i, DATA_WIDTH_GEN));

            ASSERT s_output = s_second REPORT "Had an error with input:" & INTEGER'image(i) SEVERITY error;
        END LOOP;
        WAIT FOR 5 ns;

        ASSERT false REPORT "end of test" SEVERITY note;
        WAIT;
    END PROCESS;
END ARCHITECTURE behavior;
-- Laboratory RA solutions/versuch1
-- Sommersemester 24
-- Group Details
-- Lab Date: 23.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.constant_package.ALL;

ENTITY gen_mux IS
    GENERIC (
        dataWidth : INTEGER := DATA_WIDTH_GEN
    );
    PORT (
        pi_first    : IN STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)  := (OTHERS => '0');
        pi_second   : IN STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)  := (OTHERS => '0');
        pi_selector : IN STD_LOGIC                                 := '0';
        po_output   : OUT STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY gen_mux;

ARCHITECTURE dataflow OF gen_mux IS
BEGIN
    po_output <= pi_first WHEN pi_selector = '0' ELSE
        pi_second WHEN pi_selector = '1';
END ARCHITECTURE dataflow;
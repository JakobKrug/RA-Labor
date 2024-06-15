-- Laboratory RA solutions/versuch5
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

library ieee;
use ieee.std_logic_1164.all;
use work.constant_package.all;

entity gen_mux4 is

    generic (
        word_width : integer := WORD_WIDTH
    );
    port (
        pi_first    : in std_logic_vector(word_width - 1 downto 0)  := (others => '0'); -- firstInput
        pi_second   : in std_logic_vector(word_width - 1 downto 0)  := (others => '0'); -- secondInput
        pi_third    : in std_logic_vector(word_width - 1 downto 0)  := (others => '0');
        pi_four     : in std_logic_vector(word_width - 1 downto 0)  := (others => '0');
        pi_selector : in std_logic_vector(1 downto 0)               := "00";
        po_output   : out std_logic_vector(word_width - 1 downto 0) := (others => '0') -- Selected Output
    );

end entity gen_mux4;

architecture dataflow of gen_mux4 is

begin
    with pi_selector select
        po_output <= pi_first when "00",
        pi_second when "01",
        pi_third when "10",
        pi_four when others;
end architecture dataflow;
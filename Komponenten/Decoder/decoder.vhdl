-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:
 
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.Constant_package.all;
  use work.types_package.all;

entity decoder is
-- begin solution:
-- generic(
--     WORD_WIDTH : integer := WORD_WIDTH
-- );
port(
    pi_clk : in std_logic := '0';
    pi_instruction : in std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    po_controlWord : out controlWord
);
-- end solution!!
end entity decoder;


architecture arc of decoder is
-- begin solution:
signal test : std_logic_vector(3 downto 0) := (others => '0');
begin
    po_controlWord <= control_word_init;
    process(pi_clk)
    variable v_insFormat : t_instruction_type;
    begin 
        if rising_edge(pi_clk) then
            case pi_instruction(OPCODE_WIDTH - 1 downto 0) is
                when ADD_OP_INS => v_insFormat := rFormat;
                when others => v_insFormat := nullFormat;
            end case;

            case v_insformat is
                when rFormat => po_controlWord.ALU_OP <= ;
                when others => po_controlWord <= control_word_init;
            end case;
        end if;
    end process;
 -- end solution!!
end architecture;
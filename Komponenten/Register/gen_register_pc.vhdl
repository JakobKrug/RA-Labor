library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_Package.all;

entity gen_register_pc is
-- begin solution:
  generic (
    registerWidth : integer := WORD_WIDTH
  );
  port (
    pi_clk  : in std_logic;
    pi_rst  : in std_logic;
    pi_data : in std_logic_vector(registerWidth -1 downto 0) := (others => '0'); -- incoming data
    po_data : out std_logic_vector(registerWidth -1 downto 0) :="11111111111111111111111111111100" -- outgoing data
  );
-- end solution!!
end gen_register_pc;

architecture arc1 of gen_register_pc is
-- begin solution:
  signal s_data : std_logic_vector(registerWidth -1 downto 0) := (others => '0');

    begin
    
    process (pi_clk,pi_rst)

    begin
        if (pi_rst) then
            s_data <="11111111111111111111111111111100";
        elsif rising_edge (pi_clk) then
            s_data <= pi_data; -- update register contents on falling clock edge
        end if;
    end process;

    po_data <= s_data;
-- end solution!!
end arc1;

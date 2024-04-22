-- Laboratory RA solutions/versuch1
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_Package.all;

entity gen_register_tb is
end entity gen_register_tb;

architecture testbench of gen_register_tb is


  signal s_data_in : std_logic_vector(REG_ARD_WIDTH - 1 downto 0) := (others => '0');
  signal s_data_out : std_logic_vector(REG_ARD_WIDTH - 1 downto 0) := (others => '0');
  signal s_clk : std_logic := '0'; 
  signal s_reconstant : std_logic := '0';
  
 component gen_register is 
  port(
   pi_data : in std_logic_vector(registerWidth - 1 downto 0);
   pi_clk : in std_logic := '0';
   pi_rst : in std_logic := '0';
   po_data : out std_logic_vector(registerWidth - 1 downto 0) := (others => '0')
   );
 end component;

process
  variable v_error_count : integer := 0;
begin
 for i in 0 to (2**REG_ADR_WIDTH) - 1 loop
   s_clk <= '1'; --rising edge 
   wait for 5 ns;
   s_clk <= '0'; --falling edge 
   wait for 5 ns;
   
   s_data_in <= std_logic_vector(to_unsigned(i,REG_ADR_WIDTH));
   
   assert s_data_in = s_data_out 
   report "Had an error width input:" & integer'image(i) serity error;
   end loop;
   wait for 10 ns;
   
   s_rst <= '1';
   wait for 10 ns;
   
   for i in 0 to REG_ADR_WIDTH - 1 loop
       if s_data_out(i) /= '0' then 
         v_error_count := v_error_count + 1;
        end if;
   end loop;
   
   s_rst <= '0';
   wait for 10 ns;
   
   assert v_error_count = 0
     report "Had ann error with resetting the register" severity error;
     wait for 10 ns;
     
   assert false report "end of test" severity note;
   wait;
  end process;
end architecture testbench;

Reference: https://www.physicsforums.com/threads/vhdl-register-file-test-bench.581281/bench;

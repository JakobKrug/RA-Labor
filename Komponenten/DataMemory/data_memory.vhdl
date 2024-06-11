-- ========================================================================
-- Author:       Marcel Riess
-- Last updated: 30.05.2024
-- Description:  Generic data cache (read only) with debug port,
--               to allow writing data in testbenches
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all; 
  use work.types_package.all;

entity data_memory is
  generic (
    adr_width : integer := ADR_WIDTH;   -- Address Bus width of instruction memory (in RISCVI: 32)
    mem_size  : integer := 2 ** 10      -- Size of instruction cache
  );
  port (
    pi_adr                :  in   std_logic_vector(adr_width - 1 downto 0)  := (others => '0');             -- Adress of the instruction to select
    pi_clk                :  in   std_logic;
    pi_rst                :  in   std_logic;
    pi_ctrmem             :  in   std_logic_vector(3 - 1 downto 0) := (others => '0'); 
    pi_write              :  in   std_logic;
    pi_read               :  in   std_logic;
    pi_writedata          :  in   std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0'); 
    po_readdata           : out   std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    po_debugdatamemory    : out   memory :=(others => (others => '0'))     
  );
end entity data_memory;

architecture behavior of data_memory is

  signal s_data       : memory := (others => (others => '0'));
  signal s_readdata :std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0'); 

begin
  process (pi_clk) is
  variable sign_extenderbyte : std_logic_vector(24-1 downto 0);
  variable sign_extenderhalf : std_logic_vector(16-1 downto 0);
  begin

    if falling_edge(pi_clk) then
              sign_extenderbyte := (others => s_data(to_integer(unsigned(pi_adr(9 downto 0))))(7));
              sign_extenderhalf := (others => s_data(to_integer(unsigned(pi_adr(9 downto 0))))(15));
      if (pi_write) then 
                case pi_ctrmem is
                    when SB_OP =>
                        s_data(to_integer(unsigned(pi_adr(9 downto 0))))(7 downto 0) <= pi_writedata(7 downto 0);
                    when SH_OP =>
                        s_data(to_integer(unsigned(pi_adr(9 downto 0))))(15 downto 0) <= pi_writedata(15 downto 0);
                    when SW_OP =>
                        s_data(to_integer(unsigned(pi_adr(9 downto 0)))) <= pi_writedata;
                    when others =>
                        -- Default case falls notwendig
                        null;
                end case;
      end if;
      if (pi_read) then 

                case pi_ctrmem is
                    when LBU_OP =>
                        s_readdata <= "000000000000000000000000" & s_data(to_integer(unsigned(pi_adr(9 downto 0))))(7 downto 0);
                    when LHU_OP =>
                        s_readdata <= "0000000000000000" &         s_data(to_integer(unsigned(pi_adr(9 downto 0))))(15 downto 0);
                    when LW_OP =>
                        s_readdata <= s_data(to_integer(unsigned(pi_adr(9 downto 0))));
                    when LB_OP =>
                        s_readdata <= sign_extenderbyte & s_data(to_integer(unsigned(pi_adr(9 downto 0))))(7 downto 0);
                    when LH_OP =>
                        s_readdata <= sign_extenderhalf & s_data(to_integer(unsigned(pi_adr(9 downto 0))))(15 downto 0);
                    when others =>
                        -- Default case falls notwendig
                        null;
                end case;
      end if;
    end if;

  end process;
  po_readdata<=s_readdata;
  po_debugdatamemory<=s_data;
end architecture behavior;

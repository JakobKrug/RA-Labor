-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 16.06.2024
-- Description:  R-Only-RISC-V foran incomplete RV32I implementation, support
--               only R-Instructions. 
--
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;
use work.Util_Asm_Package.all;
entity riubs_only_RISC_V_tb is

end entity riubs_only_RISC_V_tb;

architecture structure of riubs_only_RISC_V_tb is

    constant PERIOD          : time := 10 ns;
    signal s_clk             : std_logic;
    signal s_rst             : std_logic;
    signal count             : integer                       := 0;
    signal test              : integer                       := 0;
    signal s_branch_amount   : std_logic_vector(11 downto 0) := std_logic_vector(to_signed((32), 12));
    signal s_branch_amount2  : std_logic_vector(11 downto 0) := std_logic_vector(to_signed((-34), 12));
    signal s_registersOut    : registerMemory                := (others => (others => '0'));
    signal s_debugdatamemory : memory                        := (others => (others => '0'));
    signal s_instructions    : memory                        := (others => (others => '0'));

begin

    -- begin solution:
    riubs_only_riscv : entity work.riubs_only_RISC_V
        -- begin solution:
        port map
        (
            pi_rst             => s_rst,
            pi_clk             => s_clk,
            pi_instruction     => s_instructions,
            po_registersOut    => s_registersOut,
            po_debugdatamemory => s_debugdatamemory
        );
    -- end solution!!
    process (s_clk) is

    begin

        if rising_edge(s_clk) then
            --report "i-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & "in cycle" &  integer'image(count);    
            if test = 1 then
                if (count = 7) then
                    assert (to_integer(signed(s_registersOut (1))) = 9) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 8) then
                    assert (to_integer(signed(s_registersOut (2))) = 8) report "ADDI-Operation failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 12) then
                    assert (to_integer(signed(s_registersOut (3))) = 1) report "SLTI-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 13) then
                    assert (to_integer(signed(s_registersOut (4))) = 1) report "SLTIU-Operation failed. Register 4 contains " & integer'image(to_integer(signed(s_registersOut(4)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 14) then
                    assert (to_integer(signed(s_registersOut (5))) = 11) report "XORI-Operation failed. Register 5 contains " & integer'image(to_integer(signed(s_registersOut(5)))) & " but should contain " & integer'image(11) severity error;
                end if;
                if (count = 15) then
                    assert (to_integer(signed(s_registersOut (6))) = 13) report "ORI-Operation failed. Register 6 contains " & integer'image(to_integer(signed(s_registersOut(6)))) & " but should contain " & integer'image(13) severity error;
                end if;
                if (count = 16) then
                    assert (to_integer(signed(s_registersOut (7))) = 1) report "ANDI-Operation failed. Register 7 contains " & integer'image(to_integer(signed(s_registersOut(7)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 17) then
                    assert (to_integer(signed(s_registersOut (8))) = 288) report "SLLI-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(288) severity error;
                end if;
                if (count = 20) then
                    assert (to_integer(signed(s_registersOut (9))) = 2) report "SRLI-Operation failed. Register 9 contains " & integer'image(to_integer(signed(s_registersOut(9)))) & " but should contain " & integer'image(2) severity error;
                end if;
                if (count = 21) then
                    assert (to_integer(signed(s_registersOut (10))) = 4) report "SRAI-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(4) severity error;
                end if;
                if (count = 22) then
                    assert (to_integer(signed(s_registersOut (11))) = 60) report "SRAI-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(60) severity error;
                end if;
                if (count = 23) then
                    assert (to_integer(signed(s_registersOut (6))) = 13) report "JALR-Operation failed. Register 6 contains " & integer'image(to_integer(signed(s_registersOut(6)))) & " but should contain " & integer'image(13) severity error;
                end if;
            elsif test = 2 then
                if (count = 7) then
                    assert (to_integer(signed(s_registersOut (1))) = 9) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 8) then
                    assert (to_integer(signed(s_registersOut (2))) = 8) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 12) then
                    assert (to_integer(signed(s_registersOut (8))) = 17) report "ADD-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
                end if;
                if (count = 13) then
                    assert (to_integer(signed(s_registersOut (11))) = 1) report "SUB-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 14) then
                    assert (to_integer(signed(s_registersOut (12))) =- 1) report "SUB-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
                end if;
                if (count = 15) then
                    assert (to_integer(signed(s_registersOut (3))) = 8) report "AND-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 16) then
                    assert (to_integer(signed(s_registersOut (4))) = 9) report "OR-Operation failed. Register 4 contains " & integer'image(to_integer(signed(s_registersOut(4)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 17) then
                    assert (to_integer(signed(s_registersOut (5))) = 8) report "SRA-Operation failed. Register 5 contains " & integer'image(to_integer(signed(s_registersOut(5)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 20) then
                    assert (to_integer(signed(s_registersOut (6))) = 8) report "SRL-Operation failed. Register 6 contains " & integer'image(to_integer(signed(s_registersOut(6)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 21) then
                    assert (to_integer(signed(s_registersOut (7))) = 1) report "XOR-Operation failed. Register 7 contains " & integer'image(to_integer(signed(s_registersOut(7)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 22) then
                    assert (to_integer(signed(s_registersOut (9))) = 1) report "SLTU-Operation failed. Register 9 contains " & integer'image(to_integer(signed(s_registersOut(9)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 23) then
                    assert (to_integer(signed(s_registersOut (10))) = 1) report "SLT-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 24) then
                    assert (to_integer(signed(s_registersOut (13))) = 2304) report "SLL-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(2304) severity error;
                end if;

            elsif test = 3 then
                if (count = 7) then
                    assert (to_integer(signed(s_registersOut (1))) = 9) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 8) then
                    assert (to_integer(signed(s_registersOut (2))) = 8) report "ADDI-Operation failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 12) then
                    assert (to_integer(signed(s_registersOut (3))) = 16396) report "AUIPC-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(16396) severity error;
                end if;
                if (count = 13) then
                    assert (to_integer(signed(s_registersOut (4))) = 16384) report "LUI-Operation failed. Register 4 contains " & integer'image(to_integer(signed(s_registersOut(4)))) & " but should contain " & integer'image(16384) severity error;
                end if;
                if (count = 14) then
                    assert (to_integer(signed(s_registersOut (5))) = 24) report "JAL-Operation failed. Register 5 contains " & integer'image(to_integer(signed(s_registersOut(5)))) & " but should contain " & integer'image(24) severity error;
                end if;

            elsif test = 4 then
                if (count = 7) then
                    assert (to_integer(signed(s_registersOut (1))) = 9) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 8) then
                    assert (to_integer(signed(s_registersOut (2))) = 8) report "ADDI-Operation failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 13) then
                    assert (to_integer(signed(s_registersOut (3))) = 9) report "BEQ-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 22) then
                    assert (to_integer(signed(s_registersOut (3))) = 9) report "BNE-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 27) then
                    assert (to_integer(signed(s_registersOut (3))) = 8) report "BLT-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 36) then
                    assert (to_integer(signed(s_registersOut (3))) = 12) report "BGEU-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(12) severity error;
                end if;
                if (count = 40) then
                    assert (to_integer(signed(s_registersOut (3))) = 5) report "BLTU-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(5) severity error;
                end if;

            elsif test = 5 then
                if (count = 7) then
                    assert (to_integer(signed(s_registersOut(1))) = 682) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(682) severity error;
                end if;
                if (count = 11) then
                    assert (to_integer(signed(s_registersOut(2))) = 698368) report "SLLI-Operation failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(698368) severity error;
                end if;
                if (count = 15) then
                    assert (to_integer(signed(s_registersOut(3))) = 699050) report "ADD-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(699050) severity error;
                end if;
                if (count = 19) then
                    assert (to_integer(signed(s_registersOut(2))) = 715827200) report "SLLI-Operation failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(715827200) severity error;
                end if;
                if (count = 23) then
                    assert (to_integer(signed(s_registersOut(3))) = 715827882) report "ADD-Operation failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(715827882) severity error;
                end if;
                if (count = 27) then
                    assert (to_integer(signed(s_registersOut(2))) =- 1431655768) report "SLLI-Operation failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(-1431655768) severity error;
                end if;
                if (count = 31) then
                    assert (to_integer(signed(s_registersOut(3))) =- 1431655766) report "ADD-Operation failed. Register 3 contains " & integer'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & integer'image(-1431655766) severity error;
                end if;
                if (count = 35) then
                    assert (to_integer(signed(s_debugdatamemory(9))) = to_integer(signed(s_registersOut(3)))) report "SW-Operation failed. Memory at address 9 contains " & integer'image(to_integer(signed(s_debugdatamemory(9)))) & " but should contain " & integer'image(to_integer(signed(s_registersOut(3)))) severity error;
                end if;       
                if (count = 36) then
                    assert (to_integer(signed(s_debugdatamemory(8))) = to_integer(unsigned(s_registersOut(3)(15 downto 0)))) report "SH-Operation failed. Memory at address 8 contains " & integer'image(to_integer(signed(s_debugdatamemory(8)))) & " but should contain " & integer'image(to_integer(unsigned(s_registersOut(3)(15 downto 0)))) severity error;
                end if;
                if (count = 37) then
                    assert (to_integer(signed(s_debugdatamemory(7))) = to_integer(unsigned(s_registersOut(3)(7 downto 0)))) report "SB-Operation failed. Memory at address 8 contains " & integer'image(to_integer(signed(s_debugdatamemory(7)))) & " but should contain " & integer'image(to_integer(unsigned(s_registersOut(3)(7 downto 0)))) severity error;
                end if;
                if (count = 39) then
                    assert (to_integer(signed(s_registersOut(6))) =- 1431655766) report "LW-Operation failed. Register 6 contains " & integer'image(to_integer(signed(s_registersOut(6)))) & " but should contain " & integer'image(to_integer(signed(s_debugdatamemory(9)))) severity error;
                end if;
                if (count = 40) then
                    assert (to_integer(signed(s_registersOut(5))) = to_integer(signed(s_debugdatamemory(9)(15 downto 0)))) report "LH-Operation failed. Register 5 contains " & integer'image(to_integer(signed(s_registersOut(5)))) & " but should contain " & integer'image(to_integer(signed(s_debugdatamemory(9)(15 downto 0)))) severity error;
                end if;
                if (count = 41) then
                    assert (to_integer(signed(s_registersOut(4))) = to_integer(signed(s_debugdatamemory(9)(7 downto 0)))) report "LB-Operation failed. Register 4 contains " & integer'image(to_integer(signed(s_registersOut(4)))) & " but should contain " & integer'image(to_integer(signed(s_debugdatamemory(9)(7 downto 0)))) severity error;
                end if;
                if (count = 42) then
                    assert (to_integer(signed(s_registersOut(5))) = to_integer(unsigned(s_debugdatamemory(9)(15 downto 0)))) report "LHU-Operation failed. Register 5 contains " & integer'image(to_integer(unsigned(s_registersOut(5)))) & " but should contain " & integer'image(to_integer(unsigned(s_debugdatamemory(9)(15 downto 0)))) severity error;
                end if;
                if (count = 43) then
                    assert (to_integer(signed(s_registersOut(4))) = to_integer(unsigned(s_debugdatamemory(9)(7 downto 0)))) report "LBU-Operation failed. Register 4 contains " & integer'image(to_integer(unsigned(s_registersOut(4)))) & " but should contain " & integer'image(to_integer(unsigned(s_debugdatamemory(9)(7 downto 0)))) severity error;
                end if;

            elsif test = 6 then -- Versuch 7
            elsif test = 6 then
                if (count = 6) then
                    assert (to_integer(signed(s_registersOut(1))) = 9) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 7) then
                    assert (to_integer(signed(s_registersOut(2))) = 8) report "ADDI-Operation failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 8) then
                    assert (to_integer(signed(s_registersOut(17))) = 0) report "Load-Operation failed. Register 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(0) severity error;
                end if;
                if (count = 9) then
                    assert (to_integer(signed(s_registersOut(17))) = 0) report "Load-Operation failed. Register 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(0) severity error;
                end if;
                if (count = 10) then
                    assert (to_integer(signed(s_registersOut(17))) = 0) report "Load-Operation failed. Register 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(0) severity error;
                end if;
                if (count = 11) then
                    assert (to_integer(signed(s_registersOut(10))) = 9) report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 12) then
                    assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
                end if;
                if (count = 13) then
                    assert (to_integer(signed(s_registersOut(11))) = 1) report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 14) then
                    assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
                end if;
                if (count = 16) then
                    assert (to_integer(signed(s_registersOut(12))) = 25) report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) severity error;
                end if;
                if (count = 17) then
                    assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
                end if;
                if (count = 20) then
                    assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 56) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 56) severity error;
                end if;
                if (count = 21) then
                    assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 60) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 60) severity error;
                end if;
                if (count = 22) then
                    assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(8 * 2 ** 12) severity error;
                end if;
                if (count = 23) then
                    assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(29 * 2 ** 12) severity error;
                end if;
                if (count = 24) then
                    assert (to_integer(signed(s_registersOut(15))) = 76) report "JAL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(76) severity error;
                end if;
                if (count = 36) then
                    assert (to_integer(signed(s_registersOut(1))) = 9) report "Branch-Operation failed flushing. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 42) then
                    assert (to_integer(signed(s_registersOut(1))) = 0) report "Branch-Operation failed flushing. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(0) severity error;
                end if;
                if (count = 37) then
                    assert (to_integer(signed(s_registersOut(10))) = 0) report "ADDI-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(0) severity error;
                end if;
                if (count = 54) then
                    assert (to_integer(signed(s_registersOut(15))) = 212) report "JARL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(212) severity error;
                end if;
                if (count = 55) then
                    assert (to_integer(signed(s_debugdatamemory(4))) = to_integer(signed(s_registersOut(13)))) report "Store-Operation failed. Memory at adress 4 contains " & integer'image(to_integer(signed(s_debugdatamemory(4)))) & " but should contain " & integer'image(to_integer(signed(s_registersOut(13)))) severity error;
                end if;
                if (count = 56) then
                    assert (to_integer(signed(s_debugdatamemory(5))) = to_integer(unsigned(s_registersOut(14)(15 downto 0)))) report "Store-Operation failed. Memory at adress 5 contains " & integer'image(to_integer(signed(s_debugdatamemory(5)))) & " but should contain " & integer'image(to_integer(unsigned(s_registersOut(14)(15 downto 0)))) severity error;
                end if;
                if (count = 57) then
                    assert (to_integer(signed(s_debugdatamemory(6))) = to_integer(unsigned(s_registersOut(12)(7 downto 0)))) report "Store-Operation failed. Memory at adress 6 contains " & integer'image(to_integer(signed(s_debugdatamemory(6)))) & " but should contain " & integer'image(to_integer(unsigned(s_registersOut(12)(7 downto 0)))) severity error;
                end if;

                if (count = 60) then
                    assert (to_integer(signed(s_registersOut(17))) = to_integer(signed(s_debugdatamemory(4)(15 downto 0)))) report "Load-Operation failed. Memory at adress 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(to_integer(signed(s_debugdatamemory(4)(15 downto 0)))) severity error;
                end if;
                if (count = 61) then
                    assert (to_integer(signed(s_registersOut(17))) = to_integer(signed(s_debugdatamemory(5)(7 downto 0)))) report "Load-Operation failed. Memory at adress 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(to_integer(signed(s_debugdatamemory(5)(7 downto 0)))) severity error;
                end if;
                if (count = 62) then
                    assert (to_integer(signed(s_registersOut(17))) = to_integer(signed(s_debugdatamemory(6)(7 downto 0)))) report "Load-Operation failed. Memory at adress 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(to_integer(signed(s_debugdatamemory(6)(7 downto 0)))) severity error;
                end if;

                if (count = 63) then
                    assert (to_integer(signed(s_registersOut(10))) = 9) report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 64) then
                    assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
                end if;
                if (count = 65) then
                    assert (to_integer(signed(s_registersOut(11))) = 1) report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) severity error;
                end if;
                if (count = 66) then
                    assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
                end if;
                if (count = 68) then
                    assert (to_integer(signed(s_registersOut(12))) = 25) report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) severity error;
                end if;
                if (count = 69) then
                    assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
                end if;
                if (count = 72) then
                    assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 56) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 56) severity error;
                end if;
                if (count = 73) then
                    assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 60) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 60) severity error;
                end if;
                if (count = 74) then
                    assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(8 * 2 ** 12) severity error;
                end if;
                if (count = 75) then
                    assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(29 * 2 ** 12) severity error;
                end if;
                if (count = 76) then
                    assert (to_integer(signed(s_registersOut(15))) = 76) report "JAL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(76) severity error;
                end if;
                if (count = 108) then
                    assert (to_integer(signed(s_registersOut(15))) = 212) report "JALR-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(212) severity error;
                end if;
            end if;
        end if;

    end process;

    process is
    begin
        -- Test 1
        test           <= 1;
        s_instructions <= (
            4  => Asm2Std("ADDI", 1, 0, 9),   --x1 = 9
            8  => Asm2Std("ADDI", 2, 0, 8),   --x2 = 8
            24 => Asm2Std("SLTI", 3, 1, 10),  --x3 = 1, da x1 < 10
            28 => Asm2Std("SLTIU", 4, 2, 10), --x4 = 1, da x1 < 10
            32 => Asm2Std("XORI", 5, 1, 2),   --x5 = x1 XOR 2 = 1001 XOR 10 = 1011 = 11
            36 => Asm2Std("ORI", 6, 1, 5),    --x6 = x1 OR 5 = 1001 OR 101 = 1101 = 13
            40 => Asm2Std("ANDI", 7, 1, 5),   --x7 = x1 AND 5 = 1001 AND 101 = 1 = 1
            44 => Asm2Std("SLLI", 8, 1, 5),   --x8 = x1 << 5 = 100100000 = 288
            48 => Asm2Std("SRLI", 9, 1, 2),   --x9 = x1 >> 2 = 10 = 2
            52 => Asm2Std("SRAI", 10, 1, 1),  --x9 = x1 >> 1 = 10 = 4
            56 => Asm2Std("JALR", 11, 0, 0),  --x11 = PC+4 = 13
            others => (others => '0')
            );
        s_rst <= '1';
        wait for PERIOD / 2;
        s_rst <= '0';

        for i in 1 to 200 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            count <= i;
            wait for PERIOD / 2;
        end loop;
        report "End of tests for I-Instructions!!!";
        -- Test 2
        test <= 2;
        wait for PERIOD / 2;
        s_rst <= '1';
        wait for PERIOD / 2;
        s_rst          <= '0';
        s_instructions <= (
            4  => Asm2Std("ADDI", 1, 0, 9),  --x1 = 9
            8  => Asm2Std("ADDI", 2, 0, 8),  --x2 = 8
            24 => Asm2Std("ADD", 8, 1, 2),   --x8 = x1 ADD x2 = 17
            28 => Asm2Std("SUB", 11, 1, 2),  --x11 = x1 SUB x2 = 1
            32 => Asm2Std("SUB", 12, 2, 1),  --x12 = x2 SUB x1 = -1
            36 => Asm2Std("AND", 3, 2, 1),   --x3 = x2 AND x1 = 1001 AND 1000 = 1000 = 8
            40 => Asm2Std("OR", 4, 2, 1),    --x4 = x2 OR x1 = 1001 OR 1000 = 1001 = 9
            44 => Asm2Std("SRA", 5, 8, 11),  --x5 = x8 >> x11 = 17 >> 1 = 10001 >> 1 = 1000 = 8
            48 => Asm2Std("SRL", 6, 8, 11),  --x6 = x8 >> x11 = 17 >> 1 = 10001 >> 1 = 1000 = 8
            52 => Asm2Std("XOR", 7, 1, 2),   --x7 = x1 XOR x2 = 1001 XOR 1000 = 1 = 1
            56 => Asm2Std("SLTU", 9, 2, 1),  --x9 = 1, da x2 < x1
            60 => Asm2Std("SLT", 10, 11, 8), --x10 = 1, da x11 < x8
            64 => Asm2Std("SLL", 13, 1, 2),  --x13 = x1 << x2 = 9 << 8 = 100100000000 = 2304

            others => (others => '0')
            );

        for i in 1 to 200 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            count <= i;
            wait for PERIOD / 2;
        end loop;
        report "End of tests for R/I-Instructions!!!";

        -- Test 3
        test <= 3;
        wait for PERIOD / 2;
        s_rst <= '1';
        wait for PERIOD / 2;
        s_rst          <= '0';
        s_instructions <= (
            4  => Asm2Std("ADDI", 1, 0, 9),  --x1 = 9
            8  => Asm2Std("ADDI", 2, 0, 8),  --x2 = 8
            12 => Asm2Std("AUIPC", 3, 4, 0), --x3 = PC + (4 << 12) = 12 + 16384 = 16396
            16 => Asm2Std("LUI", 4, 4, 0),   --x4 = 4 << 12 = 16384
            20 => Asm2Std("JAL", 5, 0, 0),   --x5 = PC+4 = 24
            others => (others => '0')
            );

        for i in 1 to 200 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            count <= i;
            wait for PERIOD / 2;
        end loop;
        report "End of tests for R/I/U-Instructions!!!";
        -- Test 4
        test <= 4;
        wait for PERIOD / 2;
        s_rst <= '1';
        wait for PERIOD / 2;
        s_rst          <= '0';
        s_instructions <= (
            4   => Asm2Std("ADDI", 1, 0, 9),  --x1 = 9
            8   => Asm2Std("ADDI", 2, 0, 8),  --x2 = 8
            24  => Asm2Std("BEQ", 1, 2, 4),   --jump if x1 = x2 to PC+4
            28  => Asm2Std("ADDI", 3, 0, 9),  --x3 = 9
            48  => Asm2Std("BNE", 1, 2, 4),   --jump if x1 != x2 to PC+4
            52  => Asm2Std("ADDI", 3, 0, 11), --x3 = 9 => instr is skipped
            72  => Asm2Std("BLT", 1, 2, 4),   --jump if x1 < x2 to PC+4
            76  => Asm2Std("ADDI", 3, 0, 8),  --x3 = 8
            96  => Asm2Std("BGEU", 1, 2, 4),  --jump if x1 >= x2 to PC+4
            100 => Asm2Std("ADDI", 3, 0, 10), --x3 = 8 = > instr is skipped
            104 => Asm2Std("ADDI", 3, 0, 12), --x3 = 12
            108 => Asm2std("BGE", 1, 2, 4),   --jump if x1 > x2 to PC+4
            112 => Asm2Std("ADDI", 3, 0, 14), --x3 = 12 instr is skipped
            116 => Asm2Std("BLTU", 1, 2, 4),  --jump if x1 =< x2 to PC+4
            120 => Asm2Std("ADDI", 3, 0, 5),  --x3 = 5
            others => (others => '0')
            );

        for i in 1 to 50 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            count <= i;
            wait for PERIOD / 2;
        end loop;
        report "End of tests for R/I/U/B-Instructions!!!";
        -- Test 5
        test <= 5;
        wait for PERIOD / 2;
        s_rst <= '1';
        wait for PERIOD / 2;
        s_rst          <= '0';
        s_instructions <= (
            4   => Asm2Std("ADDI", 1, 0, 682), --x1 = 682
            20  => Asm2Std("SLLI", 2, 1, 10), --x2 = x1 << 10 = 1010101010 << 10 = 10101010100000000000 = 698368
            36  => Asm2Std("ADD", 3, 1, 2), --x3 = x1 ADD x2 = 682 + 698368 = 699050
            52  => Asm2Std("SLLI", 2, 3, 10), --x2 = x3 << 10 = 10101010101010101010 << 10 = 101010101010101010100000000000 = 715827200
            68  => Asm2Std("ADD", 3, 1, 2), --x3 = x1 ADD x2 = 682 + 715827200 = 715827882
            84  => Asm2Std("SLLI", 2, 3, 2), --x2 = x3 << 2 = 715827882 << 2 = 101010101010101010101010101010 << 2 = sign-bit->1 0101010101010101010101010101000 = -1431655768
            100 => Asm2Std("ADDI", 3, 2, 2), --x3 = x2 ADD 2 = -1431655768 ADD 2 = -1431655766
            116 => Asm2Std("SW", 3, 9, 0), --store x3 at m9
            120 => Asm2Std("SH", 3, 8, 0), --store half of x3 at m8
            124 => Asm2Std("SB", 3, 7, 0), --store quarter of x3 at m7
            132 => Asm2Std("LW", 6, 9, 0), --load m9 into x6
            136 => Asm2Std("LH", 5, 9, 0), --load m9 into half of x5
            140 => Asm2Std("LB", 4, 9, 0), --load m9 into quarter of x4
            144 => Asm2Std("LHU", 5, 9, 0), --load m9 into half of x5 unsigned
            148 => Asm2Std("LBU", 4, 9, 0), --load m9 into quarter of x4 unsigned
            others => (others => '0')
            );

        for i in 1 to 50 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            count <= i;
            wait for PERIOD / 2;
        end loop;
        report "End of tests for R/I/U/B/S-Instructions!!!";
        test <= 6;
        wait for PERIOD / 2;
        s_rst <= '1';
        wait for PERIOD / 2;
        s_rst          <= '0';
        s_instructions <= (
            0   => Asm2Std("ADDI", 1, 0, 9),
            4   => Asm2Std("ADDI", 2, 0, 8),
            8   => Asm2Std("LH", 17, 4, 0),
            12  => Asm2Std("LBU", 17, 5, 0),
            16  => Asm2Std("LB", 17, 6, 0),
            20  => Asm2Std("OR", 10, 1, 2),
            24  => Asm2Std("ADD", 8, 1, 2),
            28  => Asm2Std("SUB", 11, 1, 2),
            32  => Asm2Std("SUB", 12, 2, 1),
            36  => Asm2Std("SW", 1, 3, 0),
            40  => Asm2Std("ADD", 12, 2, 8),
            44  => Asm2Std("SUB", 12, 2, 1),
            48  => Asm2Std("AND", 12, 2, 1),
            52  => Asm2Std("XOR", 12, 1, 2),
            56  => Asm2Std("AUIPC", 14, 1, 0),
            60  => Asm2Std("AUIPC", 14, 1, 0),
            64  => Asm2Std("LUI", 13, 8, 0),
            68  => Asm2Std("LUI", 13, 29, 0),
            72  => Asm2Std("JAL", 15, 36, 0),
            148 => Asm2Std("BNE", 2, 1, 32),
            152 => Asm2Std("XORI", 11, 0, 0),
            156 => Asm2Std("ADDI", 11, 0, 0),
            160 => Asm2Std("ADDI", 1, 0, 0),
            164 => Asm2Std("ADDI", 2, 0, 0),
            168 => Asm2Std("ADDI", 8, 0, 0),

            176 => Asm2Std("SW", 13, 4, 0),
            180 => Asm2Std("SH", 14, 5, 0),
            184 => Asm2Std("SB", 12, 6, 0),

            208 => Asm2Std("JALR", 15, 15, -76),
            212 => Asm2Std("BEQ", 2, 1, 32),
            216 => Asm2Std("ANDI", 10, 0, 0),
            220 => Asm2Std("BNE", 2, 1, -34),
            224 => Asm2Std("ADDI", 1, 0, 20),
            others => (others => '0')
            );
        for i in 1 to 200 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            count <= i;
            wait for PERIOD / 2;
        end loop;
        report "End of tests for Versuch7-Instructions!!!";
        report "End of test RIUBS!!!";
        wait;

    end process;

end architecture;
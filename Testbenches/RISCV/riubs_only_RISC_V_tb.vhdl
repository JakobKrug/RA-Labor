-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 25.04.2024
-- Description:  R-Only-RISC-V foran incomplete RV32I implementation, support
--               only R-Instructions. 
--
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;
use work.util_functions_package.all;
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
    signal s_instructions    : memory                        := (
        others => (others => '0')
    );

begin

    -- begin solution:
    riub_only_riscv : entity work.riubs_only_RISC_V
        -- begin solution:
        port map(
            pi_rst             => s_rst,
            pi_clk             => s_clk,
            pi_instruction     => s_instructions,
            po_registersOut    => s_registersOut,
            po_debugdatamemory => s_debugdatamemory
        );
    -- end solution!!
    process (s_clk) is

    begin
        -- Increment the variable by 1

        if rising_edge(s_clk) then
            if test = 1 then
                if (count = 6) then
                    assert (to_integer(signed(s_registersOut(1))) = 9) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 7) then
                    assert (to_integer(signed(s_registersOut(2))) = 8) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) severity error;
                end if;

            elsif test = 2 then
                if (count = 6) then
                    assert (to_integer(signed(s_registersOut(1))) = 9) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
                end if;
                if (count = 7) then
                    assert (to_integer(signed(s_registersOut(2))) = 8) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) severity error;
                end if;
                if (count = 10) then
                    assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
                end if;
                if (count = 11) then
                    assert (to_integer(signed(s_registersOut(11))) =- 1) report "SUB-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(-1) severity error;
                end if;
                if (count = 12) then
                    assert (to_integer(signed(s_registersOut(12))) = 1) report "SUB-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(1) severity error;
                end if;
            end if;

        elsif test = 3 then
            if (count = 6) then
                assert (to_integer(signed(s_registersOut(1))) = 9) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
            end if;
            if (count = 7) then
                assert (to_integer(signed(s_registersOut(2))) = 8) report "ADDI-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) severity error;
            end if;
            if (count = 10) then
                assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
            end if;
            if (count = 11) then
                assert (to_integer(signed(s_registersOut(11))) =- 1) report "SUB-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (count = 12) then
                assert (to_integer(signed(s_registersOut(12))) = 1) report "SUB-Operation failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(1) severity error;
            end if;
            count <= count + 1;
        end if;

    end process;

    process is
    begin
        s_instructions <= (
            4 => Asm2Std("ADDI", 1, 0, 9),
            8 => Asm2Std("ADDI", 2, 0, 8),
            others => (others => '0')
            );
        s_rst <= '1';
        wait for PERIOD / 2;
        test  <= 1;
        s_rst <= '0';

        for i in 0 to 15 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            wait for PERIOD / 2;
        end loop;
        report "End of tests for I-Instructions!!!";

        s_instructions <= (
            4  => Asm2Std("ADDI", 1, 0, 9),
            8  => Asm2Std("ADDI", 2, 0, 8),
            24 => Asm2Std("ADD", 8, 1, 2),
            28 => Asm2Std("SUB", 11, 1, 2),
            32 => Asm2Std("SUB", 12, 2, 1),
            others => (others => '0')
            );
        s_rst <= '1';
        wait for PERIOD / 2;
        test  <= 2;
        s_rst <= '0';

        for i in 0 to 15 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            wait for PERIOD / 2;
        end loop;
        report "End of tests for R/I-Instructions!!!";

        s_instructions <= (
            4  => Asm2Std("ADDI", 1, 0, 9),
            8  => Asm2Std("ADDI", 2, 0, 8),
            24 => Asm2Std("ADD", 8, 1, 2),
            28 => Asm2Std("SUB", 11, 1, 2),
            32 => Asm2Std("SUB", 12, 2, 1),
            36 => Asm2Std("SW_OP", 1, 2, 4),
            others => (others => '0')
            );
        s_rst <= '1';
        wait for PERIOD / 2;
        test  <= 2;
        s_rst <= '0';

        for i in 0 to 15 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            wait for PERIOD / 2;
        end loop;
        report "End of tests for R/I/S-Instructions!!!";
        report "End of test RIUBS!!!";
        wait;

    end process;

end architecture;
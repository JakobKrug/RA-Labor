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

            elsif test = 3 then
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
                    assert (to_integer(unsigned(s_registersOut(17))) = to_integer(unsigned(s_debugdatamemory(5)(7 downto 0)))) report "Load-Operation failed. Memory at adress 17 contains " & integer'image(to_integer(unsigned(s_registersOut(17)))) & " but should contain " & integer'image(to_integer(unsigned(s_debugdatamemory(5)(7 downto 0)))) severity error;
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
                if (count = 105) then
                    assert (to_integer(signed(s_registersOut(15))) = 212) report "JARL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(212) severity error;
                end if;
                count <= count + 1;
            end if;
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

        for i in 0 to 200 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            wait for PERIOD / 2;
        end loop;
        report "End of tests for R/I-Instructions!!!";

        s_instructions <= (
            0  => Asm2Std("ADDI", 1, 0, 9),     -- I-Format instruction: ADDI x1, x0, 9
            4  => Asm2Std("ADDI", 2, 0, 8),     -- I-Format instruction: ADDI x2, x0, 8
            8  => Asm2Std("LH_OP", 17, 0, 4),   -- L-Format instruction: LH x17, 4(x0)
            12 => Asm2Std("LBU_OP", 17, 0, 5),  -- L-Format instruction: LBU x17, 5(x0)
            16 => Asm2Std("LB_OP", 17, 0, 6),   -- L-Format instruction: LB x17, 6(x0)
            20 => Asm2Std("OR", 10, 1, 2),      -- R-Format instruction: OR x10, x1, x2
            24 => Asm2Std("ADD", 8, 1, 2),      -- R-Format instruction: ADD x8, x1, x2
            28 => Asm2Std("SUB", 11, 1, 2),     -- R-Format instruction: SUB x11, x1, x2
            32 => Asm2Std("SUB", 12, 2, 1),     -- R-Format instruction: SUB x12, x2, x1
            36 => Asm2Std("SW_OP", 3, 1, 0),    -- S-Format instruction: SW x3, 1(x0)
            40 => Asm2Std("ADD", 12, 2, 8),     -- R-Format instruction: ADD x12, x2, x8
            44 => Asm2Std("SUB", 12, 2, 1),     -- R-Format instruction: SUB x12, x2, x1
            48 => Asm2Std("AND", 12, 2, 1),     -- R-Format instruction: AND x12, x2, x1
            52 => Asm2Std("XOR", 12, 2, 1),     -- R-Format instruction: XOR x12, x2, x1
            56 => Asm2Std("AUIPC", 14, 0, 1),   -- AUIPC instruction: AUIPC x14, 1
            60 => Asm2Std("AUIPC", 14, 0, 1),   -- AUIPC instruction: AUIPC x14, 1
            64 => Asm2Std("LUI", 13, 0, 8),     -- LUI instruction: LUI x13, 8
            68 => Asm2Std("LUI", 13, 0, 29),    -- LUI instruction: LUI x13, 29
            72 => Asm2Std("JAL", 15, 0, 18432), -- JAL instruction: JAL x15, 18432
            --148 => Asm2Std("BNE", 1, 2, to_integer(s_branch_amount)),  -- B-Format instruction: BNE x1, x2, s_branch_amount
            152 => Asm2Std("XORI", 11, 0, 0),       -- I-Format instruction: XORI x11, x0, 0
            156 => Asm2Std("SUBI", 11, 0, 0),       -- I-Format instruction: SUBI x11, x0, 0
            160 => Asm2Std("ADDI", 1, 0, 0),        -- I-Format instruction: ADDI x1, x0, 0
            164 => Asm2Std("ADDI", 2, 0, 0),        -- I-Format instruction: ADDI x2, x0, 0
            168 => Asm2Std("ADDI", 8, 0, 0),        -- I-Format instruction: ADDI x8, x0, 0
            172 => Asm2Std("SW_OP", 4, 13, 0),      -- S-Format instruction: SW x13, 4(x0)
            176 => Asm2Std("SH_OP", 5, 14, 0),      -- S-Format instruction: SH x14, 5(x0)
            180 => Asm2Std("SB_OP", 6, 12, 0),      -- S-Format instruction: SB x12, 6(x0)
            208 => Asm2Std("JALR_OP", 15, 15, -76), -- JALR instruction: JALR x15, x15, -76
            --212 => Asm2Std("BEQ", 1, 2, to_integer(s_branch_amount)),  -- B-Format instruction: BEQ x1, x2, s_branch_amount
            216 => Asm2Std("ANDI", 10, 0, 0), -- I-Format instruction: ANDI x10, x0, 0
            --220 => Asm2Std("BNE", 1, 2, to_integer(s_branch_amount2)), -- B-Format instruction: BNE x1, x2, s_branch_amount2
            224 => Asm2Std("ADDI", 1, 0, 20), -- I-Format instruction: ADDI x1, x0, 20
            others => (others => '0')
            );
        s_rst <= '1';
        wait for PERIOD / 2;
        test  <= 2;
        s_rst <= '0';

        for i in 0 to 200 loop
            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            wait for PERIOD / 2;
        end loop;
        report "End of tests for Versuch7-Instructions!!!";
        report "End of test RIUBS!!!";
        wait;

    end process;

end architecture;
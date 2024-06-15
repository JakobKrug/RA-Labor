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
entity riu_riscv_tb is

end entity riu_riscv_tb;

architecture structure of riu_riscv_tb is

    constant PERIOD : time := 10 ns;
    signal s_clk    : std_logic;
    signal count    : integer := 0;

    signal s_registersOut : registerMemory := (others => (others => '0'));
    signal s_instructions : memory         := (
        0   => std_logic_vector'(std_logic_vector(to_signed(9, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        4   => std_logic_vector'(std_logic_vector(to_signed(8, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        20  => std_logic_vector'("0" & OR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & OR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(10, REG_ADR_WIDTH)) & R_OP_INS),
        24  => std_logic_vector'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & R_OP_INS),
        28  => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & R_OP_INS),
        32  => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        40  => std_logic_vector'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        44  => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        48  => std_logic_vector'("0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        52  => std_logic_vector'("0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        56  => std_logic_vector'(std_logic_vector(to_signed(1, 20)) & std_logic_vector(to_unsigned(14, REG_ADR_WIDTH)) & AUIPC_OP_INS),
        60  => std_logic_vector'(std_logic_vector(to_signed(1, 20)) & std_logic_vector(to_unsigned(14, REG_ADR_WIDTH)) & AUIPC_OP_INS),
        64  => std_logic_vector'(std_logic_vector(to_signed(8, 20)) & std_logic_vector(to_unsigned(13, REG_ADR_WIDTH)) & LUI_OP_INS),
        68  => std_logic_vector'(std_logic_vector(to_signed(29, 20)) & std_logic_vector(to_unsigned(13, REG_ADR_WIDTH)) & LUI_OP_INS),
        72  => std_logic_vector'(std_logic_vector(to_signed(18432, 20)) & std_logic_vector(to_unsigned(15, REG_ADR_WIDTH)) & JAL_OP_INS),
        148 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(10, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        152 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        156 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        160 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS),  -- I-Befehle 
        164 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS),  -- I-Befehle 
        168 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & I_OP_INS),  -- I-Befehle 
        172 => std_logic_vector'(std_logic_vector(to_signed(-76, 12)) & std_logic_vector(to_unsigned(15, REG_ADR_WIDTH)) & "000" & std_logic_vector(to_unsigned(15, REG_ADR_WIDTH)) & JALR_OP_INS),
        others => (others => '0')
    );

begin

    -- begin solution:
    riu_only_riscv : entity work.riubs_riscv
        -- begin solution:
        port map(
            pi_clk          => s_clk,
            pi_rst          => '0',
            pi_instruction  => s_instructions,
            po_registersOut => s_registersOut
        );
    -- end solution!!
    process (s_clk) is

    begin
        -- Increment the variable by 1

        if rising_edge(s_clk) then
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
                assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 60) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 60) severity error;
            end if;
            if (count = 21) then
                assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 64) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 64) severity error;
            end if;
            if (count = 22) then
                assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(8 * 2 ** 12) severity error;
            end if;
            if (count = 23) then
                assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(29 * 2 ** 12) severity error;
            end if;
            if (count = 24) then
                assert (to_integer(signed(s_registersOut(15))) = 76) report "JAL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(72) severity error;
            end if;

            if (count = 29) then
                assert (to_integer(signed(s_registersOut(10))) = 0) report "ADDI-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(0) severity error;
            end if;
            if (count = 35) then
                assert (to_integer(signed(s_registersOut(15))) = 176) report "JARL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(176) severity error;
            end if;
            if (count = 45) then
                assert (to_integer(signed(s_registersOut(10))) = 9) report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) severity error;
            end if;
            if (count = 46) then
                assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
            end if;
            if (count = 47) then
                assert (to_integer(signed(s_registersOut(11))) = 1) report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) severity error;
            end if;
            if (count = 48) then
                assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (count = 50) then
                assert (to_integer(signed(s_registersOut(12))) = 25) report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) severity error;
            end if;
            if (count = 51) then
                assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (count = 54) then
                assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 60) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 60) severity error;
            end if;
            if (count = 55) then
                assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 64) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 64) severity error;
            end if;
            if (count = 56) then
                assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(8 * 2 ** 12) severity error;
            end if;
            if (count = 57) then
                assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(29 * 2 ** 12) severity error;
            end if;
            if (count = 58) then
                assert (to_integer(signed(s_registersOut(15))) = 76) report "JAL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(72) severity error;
            end if;
            if (count = 70) then
                assert (to_integer(signed(s_registersOut(15))) = 176) report "JARL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(176) severity error;
            end if;
            -- report "JARL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & "in cycle" &  integer'image(count);
            count <= count + 1;
        end if;

    end process;

    process is
    begin
        for i in 0 to 100 loop

            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            wait for PERIOD / 2;

        end loop;
        report "End of test RIU!!!";
        wait;

    end process;

end architecture;
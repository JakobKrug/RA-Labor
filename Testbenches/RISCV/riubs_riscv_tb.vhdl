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
entity riubs_only_RISC_V_tb is

end entity riubs_only_RISC_V_tb;

architecture structure of riubs_only_RISC_V_tb is

    constant PERIOD          : time := 10 ns;
    signal s_clk             : std_logic;
    signal s_rst             : std_logic;
    signal count             : integer                       := 0;
    signal s_branch_amount   : std_logic_vector(11 downto 0) := std_logic_vector(to_signed((32), 12));
    signal s_branch_amount2  : std_logic_vector(11 downto 0) := std_logic_vector(to_signed((-34), 12));
    signal s_registersOut    : registerMemory                := (others => (others => '0'));
    signal s_debugdatamemory : memory                        := (others => (others => '0'));
    signal s_instructions    : memory                        := (
        0   => std_logic_vector'(std_logic_vector(to_signed(9, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        4   => std_logic_vector'(std_logic_vector(to_signed(8, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        8   => std_logic_vector' ("000000000100" & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & LH_OP & std_logic_vector(to_unsigned(17, REG_ADR_WIDTH)) & L_OP_INS),                                                       -- L-Befehle 
        12  => std_logic_vector'("000000000101" & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & LBU_OP & std_logic_vector(to_unsigned(17, REG_ADR_WIDTH)) & L_OP_INS),                                                       -- L-Befehle 
        16  => std_logic_vector'("000000000110" & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & LB_OP & std_logic_vector(to_unsigned(17, REG_ADR_WIDTH)) & L_OP_INS),                                                        -- L-Befehle 
        20  => std_logic_vector'("0" & OR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & OR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(10, REG_ADR_WIDTH)) & R_OP_INS),
        24  => std_logic_vector'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & R_OP_INS),
        28  => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & R_OP_INS),
        32  => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        36  => std_logic_vector'("0000000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & SW_OP & "00011" & S_OP_INS), -- S-Befehle 
        40  => std_logic_vector'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        44  => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        48  => std_logic_vector'("0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        52  => std_logic_vector'("0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        56  => std_logic_vector'(std_logic_vector(to_signed(1, 20)) & std_logic_vector(to_unsigned(14, REG_ADR_WIDTH)) & AUIPC_OP_INS),
        60  => std_logic_vector'(std_logic_vector(to_signed(1, 20)) & std_logic_vector(to_unsigned(14, REG_ADR_WIDTH)) & AUIPC_OP_INS),
        64  => std_logic_vector'(std_logic_vector(to_signed(8, 20)) & std_logic_vector(to_unsigned(13, REG_ADR_WIDTH)) & LUI_OP_INS),
        68  => std_logic_vector'(std_logic_vector(to_signed(29, 20)) & std_logic_vector(to_unsigned(13, REG_ADR_WIDTH)) & LUI_OP_INS),
        72  => std_logic_vector'(std_logic_vector(to_signed(18432, 20)) & std_logic_vector(to_unsigned(15, REG_ADR_WIDTH)) & JAL_OP_INS),
        148 => std_logic_vector'(s_branch_amount(11) & s_branch_amount (9 downto 4) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & FUNC3_BNE & s_branch_amount(3 downto 0) & s_branch_amount(10) & B_OP_INS), -- B-Format instructions all have the same opcode
        152 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & I_OP_INS),                                    -- I-Befehle 
        156 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & I_OP_INS),                                    -- I-Befehle 
        160 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS),                                     -- I-Befehle 
        164 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS),                                     -- I-Befehle 
        168 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & I_OP_INS),                                     -- I-Befehle 
        172 => std_logic_vector'("0000000" & std_logic_vector(to_unsigned(13, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & SW_OP & "00100" & S_OP_INS),                                                                                       -- S-Befehle 
        176 => std_logic_vector'("0000000" & std_logic_vector(to_unsigned(14, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & SH_OP & "00101" & S_OP_INS),                                                                                       -- S-Befehle 
        180 => std_logic_vector'("0000000" & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & SB_OP & "00110" & S_OP_INS),                                                                                       -- S-Befehle 
        208 => std_logic_vector'(std_logic_vector(to_signed(-76, 12)) & std_logic_vector(to_unsigned(15, REG_ADR_WIDTH)) & "000" & std_logic_vector(to_unsigned(15, REG_ADR_WIDTH)) & JALR_OP_INS),
        212 => std_logic_vector'(s_branch_amount(11) & s_branch_amount (9 downto 4) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & FUNC3_BEQ & s_branch_amount(3 downto 0) & s_branch_amount(10) & B_OP_INS),     -- B-Format instructions all have the same opcode
        216 => std_logic_vector'(std_logic_vector(to_signed(0, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(10, REG_ADR_WIDTH)) & I_OP_INS),                                        -- I-Befehle 
        220 => std_logic_vector'(s_branch_amount2(11) & s_branch_amount2 (9 downto 4) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & FUNC3_BNE & s_branch_amount2(3 downto 0) & s_branch_amount2(10) & B_OP_INS), -- B-Format instructions all have the same opcode
        224 => std_logic_vector'(std_logic_vector(to_signed(20, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS),                                        -- I-Befehle 
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
--report "i-Operation failed. Memory 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & "in cycle" &  integer'image(count);    
            --report "i-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & "in cycle" &  integer'image(count);  
            if (count = 8) then assert (to_integer(signed(s_registersOut(17))) = 0) report "Load-Operation failed. Register 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(0) severity error;
            end if;
            if (count = 9) then assert (to_integer(signed(s_registersOut(17))) = 0) report "Load-Operation failed. Register 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(0) severity error;
            end if;
            if (count = 10) then assert (to_integer(signed(s_registersOut(17))) = 0) report "Load-Operation failed. Register 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(0) severity error;
            end if;
            if (count = 11) then assert (to_integer(signed(s_registersOut(10))) = 9) report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) severity error;
            end if;
            if (count = 12) then assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
            end if;
            if (count = 13) then assert (to_integer(signed(s_registersOut(11))) = 1) report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) severity error;
            end if;
            if (count = 14) then assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (count = 16) then assert (to_integer(signed(s_registersOut(12))) = 25) report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) severity error;
            end if;
            if (count = 17) then assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (count = 20) then assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 56) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 56) severity error;
            end if;
            if (count = 21) then assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 60) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 60) severity error;
            end if;
            if (count = 22) then assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(8 * 2 ** 12) severity error;
            end if;
            if (count = 23) then assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(29 * 2 ** 12) severity error;
            end if;
            if (count = 24) then assert (to_integer(signed(s_registersOut(15))) = 76) report "JAL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(76) severity error;
            end if;
            if (count = 36) then assert (to_integer(signed(s_registersOut(1))) = 9) report "Branch-Operation failed flushing. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) severity error;
            end if;
            if (count = 42) then assert (to_integer(signed(s_registersOut(1))) = 0) report "Branch-Operation failed flushing. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(0) severity error;
            end if;
            if (count = 37) then assert (to_integer(signed(s_registersOut(10))) = 0) report "ADDI-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(0) severity error;
            end if;
            if (count = 54) then assert (to_integer(signed(s_registersOut(15))) = 212) report "JARL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(212) severity error;
            end if;
            if (count = 55) then assert (to_integer(signed(s_debugdatamemory(4))) = to_integer(signed(s_registersOut(13)))) report "Store-Operation failed. Memory at adress 4 contains " & integer'image(to_integer(signed(s_debugdatamemory(4)))) & " but should contain " & integer'image(to_integer(signed(s_registersOut(13)))) severity error;
            end if;
            if (count = 56) then assert (to_integer(signed(s_debugdatamemory(5))) = to_integer(unsigned(s_registersOut(14)(15 downto 0)))) report "Store-Operation failed. Memory at adress 5 contains " & integer'image(to_integer(signed(s_debugdatamemory(5)))) & " but should contain " & integer'image(to_integer(unsigned(s_registersOut(14)(15 downto 0)))) severity error;
            end if;
            if (count = 57) then assert (to_integer(signed(s_debugdatamemory(6))) = to_integer(unsigned(s_registersOut(12)(7 downto 0)))) report "Store-Operation failed. Memory at adress 6 contains " & integer'image(to_integer(signed(s_debugdatamemory(6)))) & " but should contain " & integer'image(to_integer(unsigned(s_registersOut(12)(7 downto 0)))) severity error;
            end if;

            if (count = 60) then assert (to_integer(signed(s_registersOut(17))) = to_integer(signed(s_debugdatamemory(4)(15 downto 0)))) report "Load-Operation failed. Memory at adress 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(to_integer(signed(s_debugdatamemory(4)(15 downto 0)))) severity error;
            end if;
            if (count = 61) then assert (to_integer(unsigned(s_registersOut(17))) = to_integer(unsigned(s_debugdatamemory(5)(7 downto 0)))) report "Load-Operation failed. Memory at adress 17 contains " & integer'image(to_integer(unsigned(s_registersOut(17)))) & " but should contain " & integer'image(to_integer(unsigned(s_debugdatamemory(5)(7 downto 0)))) severity error;
            end if;
            if (count = 62) then assert (to_integer(signed(s_registersOut(17))) = to_integer(signed(s_debugdatamemory(6)(7 downto 0)))) report "Load-Operation failed. Memory at adress 17 contains " & integer'image(to_integer(signed(s_registersOut(17)))) & " but should contain " & integer'image(to_integer(signed(s_debugdatamemory(6)(7 downto 0)))) severity error;
            end if;

            if (count = 63) then assert (to_integer(signed(s_registersOut(10))) = 9) report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) severity error;
            end if;
            if (count = 64) then assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
            end if;
            if (count = 65) then assert (to_integer(signed(s_registersOut(11))) = 1) report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) severity error;
            end if;
            if (count = 66) then assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (count = 68) then assert (to_integer(signed(s_registersOut(12))) = 25) report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) severity error;
            end if;
            if (count = 69) then assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (count = 72) then assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 56) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 56) severity error;
            end if;
            if (count = 73) then assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 60) report "AUIPC-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & integer'image(1 * 2 ** 12 + 60) severity error;
            end if;
            if (count = 74) then assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(8 * 2 ** 12) severity error;
            end if;
            if (count = 75) then assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(29 * 2 ** 12) severity error;
            end if;
            if (count = 76) then assert (to_integer(signed(s_registersOut(15))) = 76) report "JAL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(76) severity error;
            end if;
            if (count = 105) then assert (to_integer(signed(s_registersOut(15))) = 212) report "JARL-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & integer'image(212) severity error;
            end if;

            count <= count + 1;
        end if;

    end process;

    process is
    begin

        s_rst <= '1';
        wait for PERIOD / 2;
        s_rst <= '0';
        for i in 0 to 200 loop

            s_clk <= '0';
            wait for PERIOD / 2;
            s_clk <= '1';
            wait for PERIOD / 2;

        end loop;
        report "End of test RIUBS!!!";
        wait;

    end process;

end architecture;
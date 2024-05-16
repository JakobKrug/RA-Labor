-- Laboratory RA solutions/versuch3
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Nicolas Schmidt
-- 2. Participant First and Last Name: Jakob Krug
-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

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

entity riu_only_RISC_V_tb is
end entity riu_only_RISC_V_tb;

architecture structure of riu_only_RISC_V_tb is

    constant PERIOD              : time                                      := 10 ns;
    constant ADD_FOUR_TO_ADDRESS : std_logic_vector(WORD_WIDTH - 1 downto 0) := std_logic_vector(to_signed((4), WORD_WIDTH));
    --signals
    --begin solution:
    signal s_clk  : std_logic := '0';
    signal s_clk2 : std_logic := '0';
    signal s_rst  : std_logic := '0';
    --PC
    signal s_pcIn_carryIn : std_logic                                 := '0';
    signal s_pc_sum       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pcOut        : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --Instruction Cache
    signal s_instructionCache : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_instrCache_out   : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --rs Registers
    signal s_id_ex_rs     : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_ex_mem_rs    : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_writeRegAddr : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    --decoder
    signal s_decoder_out : controlWord := control_word_init;
    --instr Registers
    signal s_id_ex_instr  : controlWord := control_word_init;
    signal s_ex_mem_instr : controlWord := control_word_init;
    signal s_mem_wb_instr : controlWord := control_word_init;
    --register_file
    signal s_readRegData1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegData2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_aluIn_op1    : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_rs2_out      : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --ALU
    signal s_alu_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --ALU Registers
    signal s_ex_mem_alures : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_writeRegData  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --immediate specific
    signal s_signExtender_out   : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signExtenderI_out  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signExtenderU_out  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_aluIn_op2          : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_extended_immediate : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --U-Type specific
    signal s_extended_immediate_wb1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_extended_immediate_wb2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_alu_wb                 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --end solution!!
    signal s_registersOut : registerMemory := (others => (others => '0'));
    signal s_instructions : memory         := (
        0  => std_logic_vector'(std_logic_vector(to_signed(9, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        4  => std_logic_vector'(std_logic_vector(to_signed(8, 12)) & std_logic_vector(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        24 => std_logic_vector'("0" & OR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & OR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(10, REG_ADR_WIDTH)) & R_OP_INS),
        28 => std_logic_vector'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & R_OP_INS),
        32 => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & R_OP_INS),
        36 => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        44 => std_logic_vector'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        48 => std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        52 => std_logic_vector'("0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        56 => std_logic_vector'("0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        68 => std_logic_vector'(std_logic_vector(to_signed(8, 20)) & std_logic_vector(to_unsigned(13, REG_ADR_WIDTH)) & LUI_OP_INS),
        72 => std_logic_vector'(std_logic_vector(to_signed(29, 20)) & std_logic_vector(to_unsigned(13, REG_ADR_WIDTH)) & LUI_OP_INS),
        others => (others => '0')
    );

begin
    --PC
    my_gen_n_bit_full_adder : entity work.my_gen_n_bit_full_adder
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_OP1     => ADD_FOUR_TO_ADDRESS,
            pi_OP2     => s_pcOut,
            pi_carryIn => s_pcIn_carryIn,
            po_sum     => s_pc_sum
        );

    pc : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_pc_sum,
            po_data => s_pcOut
        );
    --End of PC
    --Instruction Cache
    instruction_cache : entity work.instruction_cache
        generic map(
            ADR_WIDTH
        )
        port map(
            pi_adr              => s_pcOut,
            pi_clk              => s_clk,
            pi_instructionCache => s_instructions,
            po_instruction      => s_instructionCache
        );

    --Instruction Cache -> Decoder and Registerfile
    if_id_instr : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_instructionCache,
            po_data => s_instrCache_out
        );
    --End of Instrucion Cache
    --Decoder
    decoder : entity work.decoder
        port map(
            pi_clk         => s_clk,
            pi_instruction => s_instrCache_out,
            po_controlWord => s_decoder_out
        );
    -- End of Decoder
    --Immediate Register
    immediate_sign_extender : entity work.sign_extender
        port map(
            pi_instr      => s_instrCache_out,
            po_iImmediate => s_signExtenderI_out,
            po_uImmediate => s_signExtenderU_out
        );
    process (s_signExtenderI_out, s_signExtenderU_out) begin
        if s_decoder_out.I_IMM_SEL = '1' then
            s_signExtender_out <= s_signExtenderI_out;
        elsif s_decoder_out.U_IMM_SEL = '1' then
            s_signExtender_out <= s_signExtenderU_out;
        end if;
    end process;

    immediate_register : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_signExtender_out,
            po_data => s_extended_immediate
        );

    immediate_register_1 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_extended_immediate,
            po_data => s_extended_immediate_wb1
        );

    immediate_register_2 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_extended_immediate_wb1,
            po_data => s_extended_immediate_wb2
        );
    --End of Immediate Register
    --Immediate Selector
    immediate_selector : entity work.gen_mux4
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk      => s_clk,
            pi_rst      => s_rst,
            pi_first    => s_ex_mem_alures,
            pi_second   => s_extended_immediate_wb1,
            pi_selector => mem_wb_instr.U_IMM_SEL,
            po_output   => s_alu_wb
        )
        --2nd Clock Cylce after Instruction Fetch
        id_ex_rs : entity work.gen_register
            generic map(
                REG_ADR_WIDTH
            )
            port map(
                pi_clk  => s_clk2,
                pi_rst  => s_rst,
                pi_data => s_instrCache_out(11 downto 7),
                po_data => s_id_ex_rs
            );

    id_ex_instr : entity work.ControlWordRegister
        port map(
            pi_clk         => s_clk2,
            pi_rst         => s_rst,
            pi_controlWord => s_decoder_out,
            po_controlWord => s_id_ex_instr
        );
    --End of 2nd Clock Cycle after Instruction Fetch
    --3rd Clock Cycle after Instruction Fetch
    ex_mem_rs : entity work.gen_register
        generic map(
            REG_ADR_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_id_ex_rs,
            po_data => s_ex_mem_rs
        );
    ex_mem_instr : entity work.ControlWordRegister
        port map(
            pi_clk         => s_clk2,
            pi_rst         => s_rst,
            pi_controlWord => s_id_ex_instr,
            po_controlWord => s_ex_mem_instr
        );
    --End of 3rd Clock Cycle after Instruction Fetch
    --4th Clock Cycle after Instruction Fetch
    mem_wb_rs : entity work.gen_register
        generic map(
            REG_ADR_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_ex_mem_rs,
            po_data => s_writeRegAddr
        );
    mem_wb_instr : entity work.ControlWordRegister
        port map(
            pi_clk         => s_clk2,
            pi_rst         => s_rst,
            pi_controlWord => s_ex_mem_instr,
            po_controlWord => s_mem_wb_instr
        );
    --End of 4th Clock Cycle after Instruction Fetch
    --Registerfile
    register_file : entity work.register_file
        port map(
            pi_clk          => s_clk,
            pi_rst          => s_rst,
            pi_readRegAddr1 => s_instrCache_out(19 downto 15),
            pi_readRegAddr2 => s_instrCache_out(24 downto 20),
            pi_writeRegAddr => s_writeRegAddr,
            pi_writeEnable  => not(s_decoder_out.IS_BRANCH),
            pi_writeRegData => s_writeRegData,
            po_readRegData1 => s_readRegData1,
            po_readRegData2 => s_readRegData2,
            po_registerOut  => s_registersOut
        );

    id_ex_op1 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_readRegData1,
            po_data => s_aluIn_op1
        );
    --Type Selector
    type_selector : entity work.gen_mux
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_first    => s_rs2_out,
            pi_second   => s_extended_immediate,
            pi_selector => s_id_ex_instr.I_IMM_SEL,
            po_output   => s_aluIn_op2
        );
    id_ex_op2 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_readRegData2,
            po_data => s_rs2_out
        );
    --End of Registerfile
    --ALU
    my_alu : entity work.my_alu
        generic map(
            WORD_WIDTH,
            ALU_OPCODE_WIDTH
        )
        port map(
            pi_OP1    => s_aluIn_op1,
            pi_OP2    => s_aluIn_op2,
            pi_aluOp  => s_id_ex_instr.ALU_OP,
            pi_clk    => s_clk,
            po_aluOut => s_alu_out
        );

    ex_mem_alures : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_alu_out,
            po_data => s_ex_mem_alures
        );

    ex_wb_alures : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_alu_wb,
            po_data => s_writeRegData
        );
    --End of ALU
    process is
    begin
        s_clk <= '0';
        wait for PERIOD / 2;

        for i in 0 to 100 loop
            s_clk <= '1';
            wait for PERIOD / 2;
            s_clk <= '0';
            wait for PERIOD / 2;

            if (i = 10) then
                assert (to_integer(signed(s_registersOut(10))) = 9) report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) severity error;
            end if;
            if (i = 11) then
                assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) severity error;
            end if;
            if (i = 12) then
                assert (to_integer(signed(s_registersOut(11))) = 1) report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) severity error;
            end if;
            if (i = 13) then
                assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (i = 15) then
                assert (to_integer(signed(s_registersOut(12))) = 25) report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) severity error;
            end if;
            if (i = 16) then
                assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) severity error;
            end if;
            if (i = 21) then
                assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(8 * 2 ** 12) severity error;
            end if;
            if (i = 22) then
                assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & integer'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & integer'image(29 * 2 ** 12) severity error;
            end if;

        end loop;
        report "End of test RIU!!!";
        wait;

    end process;

    process is
    begin
        wait for PERIOD / 4;
        for i in 0 to 200 loop

            s_clk2 <= '0';
            wait for PERIOD / 2;
            s_clk2 <= '1';
            wait for PERIOD / 2;

        end loop;

        wait;

    end process;
end architecture;
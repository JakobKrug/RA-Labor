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

entity R_I_only_RISC_V_tb is
end entity R_I_only_RISC_V_tb;

architecture structure of R_I_only_RISC_V_tb is

    constant PERIOD : TIME := 10 ns;
    constant ADD_FOUR_TO_ADDRESS : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := STD_LOGIC_VECTOR(to_signed((4), WORD_WIDTH));
    --signals
    --begin solution:
    signal s_clk : STD_LOGIC := '0';
    signal s_clk2 : STD_LOGIC := '0';
    signal s_rst : STD_LOGIC := '0';
    --my_gen_n_bit_full_adder
    signal s_carryIn_fa : STD_LOGIC := '0';
    signal s_sum_fa : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_carryOut_fa : STD_LOGIC := '0';
    --pc
    signal s_pc_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --instruction_cache
    signal s_instruction_cache_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --if_id_instr
    signal s_decoder_in : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --id_ex_rs
    signal s_data_id_ex_rs : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    --ex_mem_rs
    signal s_data_ex_mem_rs : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    --mem_wb_rs
    signal s_writeRegAddr : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    --decoder
    signal s_decoder_out : controlWord := control_word_init;
    --id_ex_instr
    signal s_data_id_ex_instr : controlWord := control_word_init;
    --ex_mem_instr
    signal s_data_ex_mem_instr : controlWord := control_word_init;
    --mem_wb_instr
    signal s_data_mem_wb_instr : controlWord := control_word_init;
    --register_file
    signal s_read_reg_data1_register_file : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_read_reg_data2_register_file : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --id_ex_op1
    signal s_data_id_ex_op1 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --id_ex_op2
    signal s_data_id_ex_op2 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --my_alu
    signal s_alu_out_my_alu : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_carry_out_my_alu : STD_LOGIC := '0';
    --ex_mem_alures
    signal s_data_ex_mem_alures : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --mem_wb_alures
    signal s_data_mem_wb_alures : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --immediate specific
    signal s_immediate_register : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_aluIn_op2 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_extended_immediate : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --end solution!!
    signal s_registersOut : registerMemory := (others => (others => '0'));
    signal s_instructions : memory := (
        4 => STD_LOGIC_VECTOR'("000000001001" & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS),
        8 => STD_LOGIC_VECTOR'("000000001000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS),

        24 => STD_LOGIC_VECTOR'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(8, REG_ADR_WIDTH)) & R_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert

        28 => STD_LOGIC_VECTOR'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(11, REG_ADR_WIDTH)) & R_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert

        32 => STD_LOGIC_VECTOR'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert

        36 => STD_LOGIC_VECTOR'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(8, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert

        40 => STD_LOGIC_VECTOR'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert

        44 => STD_LOGIC_VECTOR'("0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert

        48 => STD_LOGIC_VECTOR'("0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        others => (others => '0')
    );

begin
    --PC
    my_gen_n_bit_full_adder : entity work.my_gen_n_bit_full_adder
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_OP1 => ADD_FOUR_TO_ADDRESS,
            pi_OP2 => s_pc_out,
            pi_carryIn => s_carryIn_fa,
            po_sum => s_sum_fa,
            po_carryOut => s_carryOut_fa
        );

    pc : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_sum_fa,
            po_data => s_pc_out
        );
    --End of PC
    --Instruction Cache
    instruction_cache : entity work.instruction_cache
        generic map(
            ADR_WIDTH
        )
        port map(
            pi_adr => s_pc_out,
            pi_clk => s_clk,
            pi_instructionCache => s_instructions,
            po_instruction => s_instruction_cache_out
        );

    --Instruction Cache -> Decoder and Registerfile
    if_id_instr : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_instruction_cache_out,
            po_data => s_decoder_in
        );
    --End of Instrucion Cache
    --Decoder
    decoder : entity work.decoder
        port map(
            pi_clk => s_clk,
            pi_instruction => s_decoder_in,
            po_controlWord => s_decoder_out
        );
    -- End of Decoder
    --Immediate Register
    immediate_register : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_immediate_register,
            po_data => s_extended_immediate
        );
    immediate_sign_extender : entity work.sign_extender
        port map(
            pi_instr => s_decoder_in,
            po_iImmediate => s_immediate_register
        );
    --End of Immediate Register
    --2nd Clock Cylce after Instruction Fetch
    id_ex_rs : entity work.gen_register
        generic map(
            REG_ADR_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_decoder_in(11 downto 7),
            po_data => s_data_id_ex_rs
        );

    id_ex_instr : entity work.ControlWordRegister
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_controlWord => s_decoder_out,
            po_controlWord => s_data_id_ex_instr
        );
    --End of 2nd Clock Cycle after Instruction Fetch
    --3rd Clock Cycle after Instruction Fetch
    ex_mem_rs : entity work.gen_register
        generic map(
            REG_ADR_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_data_id_ex_rs,
            po_data => s_data_ex_mem_rs
        );
    ex_mem_instr : entity work.ControlWordRegister
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_controlWord => s_data_id_ex_instr,
            po_controlWord => s_data_ex_mem_instr
        );
    --End of 3rd Clock Cycle after Instruction Fetch
    --4th Clock Cycle after Instruction Fetch
    mem_wb_rs : entity work.gen_register
        generic map(
            REG_ADR_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_data_ex_mem_rs,
            po_data => s_writeRegAddr
        );
    mem_wb_instr : entity work.ControlWordRegister
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_controlWord => s_data_ex_mem_instr,
            po_controlWord => s_data_mem_wb_instr
        );
    --End of 4th Clock Cycle after Instruction Fetch
    --Registerfile
    register_file : entity work.register_file
        port map(
            pi_clk => s_clk,
            pi_rst => s_rst,
            pi_readRegAddr1 => s_decoder_in(19 downto 15),
            pi_readRegAddr2 => s_decoder_in(24 downto 20),
            pi_writeRegAddr => s_writeRegAddr,
            pi_writeEnable => not(s_decoder_out.IS_BRANCH),
            pi_writeRegData => s_data_mem_wb_alures,
            po_readRegData1 => s_read_reg_data1_register_file,
            po_readRegData2 => s_read_reg_data2_register_file,
            po_registerOut => s_registersOut
        );

    id_ex_op1 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_read_reg_data1_register_file,
            po_data => s_data_id_ex_op1
        );
    --Type Selector
    type_selector : entity work.gen_mux
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_first => s_data_id_ex_op2,
            pi_second => s_extended_immediate,
            pi_selector => s_data_id_ex_instr.I_IMM_SEL,
            po_output => s_aluIn_op2
        );
    id_ex_op2 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_read_reg_data2_register_file,
            po_data => s_data_id_ex_op2
        );
    --End of Registerfile
    --ALU
    my_alu : entity work.my_alu
        generic map(
            WORD_WIDTH,
            ALU_OPCODE_WIDTH
        )
        port map(
            pi_OP1 => s_data_id_ex_op1,
            pi_OP2 => s_aluIn_op2,
            pi_aluOp => s_data_id_ex_instr.ALU_OP,
            pi_clk => s_clk,
            po_aluOut => s_alu_out_my_alu,
            po_carryOut => s_carry_out_my_alu
        );

    ex_mem_alures : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_alu_out_my_alu,
            po_data => s_data_ex_mem_alures
        );

    ex_wb_alures : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_data_ex_mem_alures,
            po_data => s_data_mem_wb_alures
        );
    --End of ALU
    process is
    begin
        s_clk <= '0';
        wait for PERIOD / 2;

        for i in 0 to 15 loop
            s_clk <= '1';
            wait for PERIOD / 2;
            s_clk <= '0';
            wait for PERIOD / 2;

            if (i = 5) then
                assert (to_integer(signed(s_registersOut(1))) = 9)
                report "ADDI-Operation failed. Register 1 contains " & INTEGER'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & INTEGER'image(9) & " after cycle 5"
                    severity error;
            end if;

            if (i = 6) then
                assert (to_integer(signed(s_registersOut(2))) = 8)
                report "ADDI-Operation failed. Register 2 contains " & INTEGER'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & INTEGER'image(8) & " after cycle 6"
                    severity error;
            end if;

            if (i = 10) then
                assert (to_integer(signed(s_registersOut(8))) = 17)
                report "ADD-Operation failed. Register 8 contains " & INTEGER'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & INTEGER'image(17) & " after cycle 10"
                    severity error;
            end if;

            if (i = 11) then
                assert (to_integer(signed(s_registersOut(11))) = 1)
                report "SUB-Operation failed. Register 11 contains " & INTEGER'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & INTEGER'image(1) & " after cycle 6"
                    severity error;
            end if;

            if (i = 12) then
                assert (to_integer(signed(s_registersOut(12))) = 1)
                report "SUB-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(1) & " after cycle 8"
                    severity error;

            end if;
            if (i = 13) then
                assert (to_integer(signed(s_registersOut(12))) = 25)
                report "ADD-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(25) & " after cycle 7"
                    severity error;
            end if;

            if (i = 14) then
                assert (to_integer(signed(s_registersOut(12))) =- 1)
                report "SUB-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(-1) & " after cycle 8"
                    severity error;
            end if;
        end loop;
        report "End of test!!!";
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
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

    constant PERIOD : TIME := 10 ns;
    constant ADD_FOUR_TO_ADDRESS : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := STD_LOGIC_VECTOR(to_signed((4), WORD_WIDTH));
    --signals
    --begin solution:
    signal s_clk : STD_LOGIC := '0';
    signal s_clk2 : STD_LOGIC := '0';
    signal s_rst : STD_LOGIC := '0';
    --PC
    signal s_pcIn_carryIn : STD_LOGIC := '0';
    signal s_pc_sum : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pcIn : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pcOut : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --Instruction Cache
    signal s_instructionCache : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_instrCache_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --rs Registers
    signal s_id_ex_rs : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_ex_mem_rs : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_writeRegAddr : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    --decoder
    signal s_decoder_out : controlWord := control_word_init;
    --instr Registers
    signal s_ex_instr : controlWord := control_word_init;
    signal s_mem_instr : controlWord := control_word_init;
    signal s_wb_instr : controlWord := control_word_init;
    --register_file
    signal s_readRegData1 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegData2 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_ex_op1 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_rs2_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --ALU
    signal s_alu_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --ALU Registers
    signal s_mem_alu : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_wb_alu : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_writeRegData : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --immediate specific
    signal s_signExtender_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signExtenderI_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signExtenderU_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signExtenderJ_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_typeSelector_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_extendedImmediate_id : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --U-Type specific
    signal s_extendedImmediate_ex : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_extendedImmediate_wb : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_alu_wb : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --AUIPC
    signal s_pc_if : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pc_id : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pc_of : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pc_ex : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_aluIn_op1 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_aluIn_op2 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --PC+4
    signal s_pc_id4 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pc_ex4 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pc_mem4 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pc_wb4 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
    --end solution!!
    signal s_registersOut : registerMemory := (others => (others => '0'));
    signal s_instructions : memory := (
        0 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(9, 12)) & STD_LOGIC_VECTOR(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        4 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(8, 12)) & STD_LOGIC_VECTOR(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        24 => STD_LOGIC_VECTOR'("0" & OR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & OR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(10, REG_ADR_WIDTH)) & R_OP_INS),
        28 => STD_LOGIC_VECTOR'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(8, REG_ADR_WIDTH)) & R_OP_INS),
        32 => STD_LOGIC_VECTOR'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(11, REG_ADR_WIDTH)) & R_OP_INS),
        36 => STD_LOGIC_VECTOR'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        44 => STD_LOGIC_VECTOR'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(8, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        48 => STD_LOGIC_VECTOR'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        52 => STD_LOGIC_VECTOR'("0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        56 => STD_LOGIC_VECTOR'("0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(12, REG_ADR_WIDTH)) & R_OP_INS),
        60 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(1, 20)) & STD_LOGIC_VECTOR(to_unsigned(14, REG_ADR_WIDTH)) & AUIPC_OP_INS),
        64 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(1, 20)) & STD_LOGIC_VECTOR(to_unsigned(14, REG_ADR_WIDTH)) & AUIPC_OP_INS),
        68 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(8, 20)) & STD_LOGIC_VECTOR(to_unsigned(13, REG_ADR_WIDTH)) & LUI_OP_INS),
        72 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(29, 20)) & STD_LOGIC_VECTOR(to_unsigned(13, REG_ADR_WIDTH)) & LUI_OP_INS),
        76 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(18432, 20)) & STD_LOGIC_VECTOR(to_unsigned(15, REG_ADR_WIDTH)) & JAL_OP_INS),
        148 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(0, 12)) & STD_LOGIC_VECTOR(to_unsigned(0, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(10, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        152 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(0, 12)) & STD_LOGIC_VECTOR(to_unsigned(0, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(11, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        156 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(0, 12)) & STD_LOGIC_VECTOR(to_unsigned(0, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(11, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        160 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(0, 12)) & STD_LOGIC_VECTOR(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        164 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(0, 12)) & STD_LOGIC_VECTOR(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        168 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(0, 12)) & STD_LOGIC_VECTOR(to_unsigned(0, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & STD_LOGIC_VECTOR(to_unsigned(8, REG_ADR_WIDTH)) & I_OP_INS), -- I-Befehle 
        172 => STD_LOGIC_VECTOR'(STD_LOGIC_VECTOR(to_signed(-80, 12)) & STD_LOGIC_VECTOR(to_unsigned(15, REG_ADR_WIDTH)) & "000" & STD_LOGIC_VECTOR(to_unsigned(15, REG_ADR_WIDTH)) & JALR_OP_INS),
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
            pi_OP2 => s_pcOut,
            pi_carryIn => s_pcIn_carryIn,
            po_sum => s_pc_sum
        );
    pc_mux : entity work.gen_mux
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_first => s_pc_sum,
            pi_second => s_mem_alu,
            pi_selector => s_mem_instr.PC_SEL,
            po_output => s_pcIn
        );
    pc : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_pcIn,
            po_data => s_pcOut
        );
    --End of PC
    --Pipline Register für PC+4
    if_id_pc4: entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_pc_sum,
            po_data => s_pc_id4
        );
    if_ex_pc4 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_pc_id4,
            po_data => s_pc_ex4
        );
    ex_mem_pc4 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_pc_ex4,
            po_data => s_pc_mem4
        );
    mem_wb_pc4 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_pc_mem4,
            po_data => s_pc_wb4
        );

    --MUX decides between PC+4 and aluop1 using
    alu_mux : entity work.gen_mux
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_first => s_ex_op1,
            pi_second => s_pc_mem4,
            pi_selector => s_ex_instr.A_SEL,
            po_output => s_aluIn_op1
        );
    --Instruction Cache
    instruction_cache : entity work.instruction_cache
        generic map(
            ADR_WIDTH
        )
        port map(
            pi_adr => s_pcOut,
            pi_clk => s_clk,
            pi_instructionCache => s_instructions,
            po_instruction => s_instructionCache
        );

    --Instruction Cache -> Decoder and Registerfile
    if_id_instr : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_instructionCache,
            po_data => s_instrCache_out
        );
    --End of Instrucion Cache
    --Decoder
    decoder : entity work.decoder
        port map(
            pi_clk => s_clk,
            pi_instruction => s_instrCache_out,
            po_controlWord => s_decoder_out
        );
    -- End of Decoder
    --Immediate Register
    immediate_sign_extender : entity work.sign_extender
        port map(
            pi_instr => s_instrCache_out,
            po_iImmediate => s_signExtenderI_out,
            po_uImmediate => s_signExtenderU_out,
            po_jImmediate => s_signExtenderJ_out
        );

    with s_instrCache_out(6 downto 0) select
    s_signExtender_out <= s_signExtenderI_out when "0010011",
        s_signExtenderU_out when LUI_OP_INS,
        s_signExtenderU_out when AUIPC_OP_INS,
        s_signExtenderJ_out when JAL_OP_INS,
        s_signExtenderI_out when JALR_OP_INS,
        (others => '0') when others;

    id_ex_immediate_register : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_signExtender_out,
            po_data => s_extendedImmediate_id
        );
    ex_mem_immediate_register : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_extendedImmediate_id,
            po_data => s_extendedImmediate_ex
        );
    wb_immediate_register : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_extendedImmediate_ex,
            po_data => s_extendedImmediate_wb
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
            pi_data => s_instrCache_out(11 downto 7),
            po_data => s_id_ex_rs
        );

    id_ex_instr : entity work.ControlWordRegister
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_controlWord => s_decoder_out,
            po_controlWord => s_ex_instr
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
            pi_data => s_id_ex_rs,
            po_data => s_ex_mem_rs
        );
    ex_mem_instr : entity work.ControlWordRegister
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_controlWord => s_ex_instr,
            po_controlWord => s_mem_instr
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
            pi_data => s_ex_mem_rs,
            po_data => s_writeRegAddr
        );
    mem_wb_instr : entity work.ControlWordRegister
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_controlWord => s_mem_instr,
            po_controlWord => s_wb_instr
        );
    --End of 4th Clock Cycle after Instruction Fetch
    --Registerfile
    register_file : entity work.register_file
        port map(
            pi_clk => s_clk,
            pi_rst => s_rst,
            pi_readRegAddr1 => s_instrCache_out(19 downto 15),
            pi_readRegAddr2 => s_instrCache_out(24 downto 20),
            pi_writeRegAddr => s_writeRegAddr,
            pi_writeEnable => not(s_ex_instr.IS_BRANCH),
            pi_writeRegData => s_writeRegData,
            po_readRegData1 => s_readRegData1,
            po_readRegData2 => s_readRegData2,
            po_registerOut => s_registersOut
        );

    id_ex_op1 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_readRegData1,
            po_data => s_ex_op1
        );
    id_ex_op2 : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_readRegData2,
            po_data => s_rs2_out
        );
    --End of Registerfile
    --Type Selector
    type_selector : entity work.gen_mux
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_first => s_rs2_out,
            pi_second => s_extendedImmediate_id,
            pi_selector => s_ex_instr.I_IMM_SEL,
            po_output => s_aluIn_op2
        );
    --WB Selector
    wb_selector : entity work.gen_mux4
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_first => s_wb_alu,
            pi_second => s_extendedImmediate_wb,
            pi_third => s_pc_wb4,
            pi_selector => s_wb_instr.WB_SEL,
            po_output => s_writeRegData
        );
    --ALU
    my_alu : entity work.my_alu
        generic map(
            WORD_WIDTH,
            ALU_OPCODE_WIDTH
        )
        port map(
            pi_OP1 => s_aluIn_op1,
            pi_OP2 => s_aluIn_op2,
            pi_aluOp => s_ex_instr.ALU_OP,
            pi_clk => s_clk,
            po_aluOut => s_alu_out
        );

    ex_mem_alures : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_alu_out,
            po_data => s_mem_alu
        );

    ex_wb_alures : entity work.gen_register
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => s_clk2,
            pi_rst => s_rst,
            pi_data => s_mem_alu,
            po_data => s_wb_alu
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
                assert (to_integer(signed(s_registersOut(10))) = 9) report "OR-Operation failed. Register 10 contains " & INTEGER'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & INTEGER'image(9) severity error;
            end if;
            if (i = 11) then
                assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 8 contains " & INTEGER'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & INTEGER'image(17) severity error;
            end if;
            if (i = 12) then
                assert (to_integer(signed(s_registersOut(11))) = 1) report "SUB-Operation failed. Register 11 contains " & INTEGER'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & INTEGER'image(1) severity error;
            end if;
            if (i = 13) then
                assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(-1) severity error;
            end if;
            if (i = 15) then
                assert (to_integer(signed(s_registersOut(12))) = 25) report "ADD-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(25) severity error;
            end if;
            if (i = 16) then
                assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(-1) severity error;
            end if;
            if (i = 19) then
                assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 60) report "AUIPC-Operation failed. Register 14 contains " & INTEGER'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & INTEGER'image(1 * 2 ** 12 + 60) severity error;
            end if;
            if (i = 20) then
                assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 64) report "AUIPC-Operation failed. Register 14 contains " & INTEGER'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & INTEGER'image(1 * 2 ** 12 + 64) severity error;
            end if;
            if (i = 21) then
                assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & INTEGER'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & INTEGER'image(8 * 2 ** 12) severity error;
            end if;
            if (i = 22) then
                assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & INTEGER'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & INTEGER'image(29 * 2 ** 12) severity error;
            end if;
            if (i = 23) then
                assert (to_integer(signed(s_registersOut(15))) = 80) report "JAL-Operation failed. Register 15 contains " & INTEGER'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & INTEGER'image(80) severity error;
            end if;

            if (i = 28) then
                assert (to_integer(signed(s_registersOut(10))) = 0) report "ADDI-Operation failed. Register 10 contains " & INTEGER'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & INTEGER'image(0) severity error;
            end if;
            if (i = 33) then
                assert (to_integer(signed(s_registersOut(15))) = 176) report "JARL-Operation failed. Register 15 contains " & INTEGER'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & INTEGER'image(176) severity error;
            end if;

            if (i = 44) then
                assert (to_integer(signed(s_registersOut(10))) = 9) report "OR-Operation failed. Register 10 contains " & INTEGER'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & INTEGER'image(9) severity error;
            end if;
            if (i = 45) then
                assert (to_integer(signed(s_registersOut(8))) = 17) report "ADD-Operation failed. Register 8 contains " & INTEGER'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & INTEGER'image(17) severity error;
            end if;
            if (i = 46) then
                assert (to_integer(signed(s_registersOut(11))) = 1) report "SUB-Operation failed. Register 11 contains " & INTEGER'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & INTEGER'image(1) severity error;
            end if;
            if (i = 47) then
                assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(-1) severity error;
            end if;
            if (i = 48) then
                assert (to_integer(signed(s_registersOut(12))) = 25) report "ADD-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(25) severity error;
            end if;
            if (i = 49) then
                assert (to_integer(signed(s_registersOut(12))) =- 1) report "SUB-Operation failed. Register 12 contains " & INTEGER'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & INTEGER'image(-1) severity error;
            end if;
            if (i = 52) then
                assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 60) report "AUIPC-Operation failed. Register 14 contains " & INTEGER'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & INTEGER'image(1 * 2 ** 12 + 60) severity error;
            end if;
            if (i = 53) then
                assert (to_integer(signed(s_registersOut(14))) = 1 * 2 ** 12 + 64) report "AUIPC-Operation failed. Register 14 contains " & INTEGER'image(to_integer(signed(s_registersOut(14)))) & " but should contain " & INTEGER'image(1 * 2 ** 12 + 64) severity error;
            end if;
            if (i = 54) then
                assert (to_integer(unsigned(s_registersOut(13))) = 8 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & INTEGER'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & INTEGER'image(8 * 2 ** 12) severity error;
            end if;
            if (i = 55) then
                assert (to_integer(signed(s_registersOut(13))) = 29 * 2 ** 12) report "LUI-Operation failed. Register 13 contains " & INTEGER'image(to_integer(signed(s_registersOut(13)))) & " but should contain " & INTEGER'image(29 * 2 ** 12) severity error;
            end if;
            if (i = 56) then
                assert (to_integer(signed(s_registersOut(15))) = 80) report "JAL-Operation failed. Register 15 contains " & INTEGER'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & INTEGER'image(80) severity error;
            end if;
            if (i = 66) then
                assert (to_integer(signed(s_registersOut(15))) = 176) report "JARL-Operation failed. Register 15 contains " & INTEGER'image(to_integer(signed(s_registersOut(15)))) & " but should contain " & INTEGER'image(176) severity error;
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
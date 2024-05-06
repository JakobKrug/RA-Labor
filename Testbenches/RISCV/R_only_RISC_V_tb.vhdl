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

entity R_only_RISC_V_tb is
end entity R_only_RISC_V_tb;

architecture structure of R_only_RISC_V_tb is

    constant PERIOD                : time                                           := 10 ns;
    constant ADD_FOUR_TO_ADDRESS   : std_logic_vector(WORD_WIDTH - 1 downto 0)      := std_logic_vector(to_signed((4), WORD_WIDTH));
    --signals
    --begin solution:
    signal s_clk : std_logic := '0';
    signal s_clk2 : std_logic := '0';
    signal s_rst : std_logic := '0';
    --my_gen_n_bit_full_adder
    signal s_op1_fa : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_op2_fa : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_carryIn_fa : std_logic := '0';
    signal s_sum_fa : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --pc
    signal s_data_pc : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --instruction_cache
    signal s_adr_ic : memory := (others => (others => '0'));
    signal s_instruction_ic : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_instruction_cache_ic : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --if_id_instr
    signal s_data_if_id_instr : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --id_ex_rs
    signal s_data_id_ex_rs : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    --ex_mem_rs
    signal s_data_ex_mem_rs : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    --mem_wb_rs
    signal s_data_mem_wb_rs : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    --decoder
    signal s_control_word_decoder : controlWord := control_word_init;
    --id_ex_instr
    signal s_data_id_ex_instr : controlWord := control_word_init;
    --ex_mem_instr
    signal s_data_ex_mem_instr : controlWord := control_word_init;
    --mem_wb_instr
    signal s_data_mem_wb_instr : controlWord := control_word_init;
    --register_file
    signal s_read_reg_data1_register_file : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_read_reg_data2_register_file : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --id_ex_op1
    signal s_data_id_ex_op1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --id_ex_op2
    signal s_data_id_ex_op2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --my_alu
    signal s_alu_out_my_alu : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_carry_out_my_alu : std_logic := '0';
    --ex_mem_alures
    signal s_data_ex_mem_alures : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --mem_wb_alures
    signal s_data_mem_wb_alures : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    --end solution!!
    signal   s_registersOut : registerMemory := (others => (others => '0'));                                                                                                       
    signal   s_instructions : memory:= (
        4=> std_logic_vector'("0" & OR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & OR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(10, REG_ADR_WIDTH)) & ADD_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        8=> std_logic_vector'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & ADD_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        12=> std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & ADD_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        16=> std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        24=> std_logic_vector'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        28=> std_logic_vector'("0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        32=> std_logic_vector'("0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        36=> std_logic_vector'("0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        others => (others => '0')
    );

begin
    my_gen_n_bit_full_adder: entity work.my_gen_n_bit_full_adder
    port map(
        pi_OP1 => s_op1_fa,
        pi_OP2 => s_op2_fa,
        pi_carryIn => s_carryIn_fa,
        po_sum => s_sum_fa
    );

    pc: entity work.gen_register
    generic map(
        WORD_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_sum_fa,
        po_data => s_data_pc
    );
    
    instruction_cache: entity work.instruction_cache
    port map(
        pi_adr => s_data_pc,
        pi_clk => s_clk,
        pi_instructionCache => s_instructions,
        po_instruction => s_instruction_ic
    );

    if_id_instr: entity work.gen_register
    generic map(
        WORD_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_instruction_ic,
        po_data => s_data_if_id_instr
    ); 

    id_ex_rs: entity work.gen_register
    generic map(
        REG_ADR_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_data_if_id_instr(REG_ADR_WIDTH - 1 downto 0),
        po_data => s_data_id_ex_rs
    );

    ex_mem_rs: entity work.gen_register
    generic map(
        REG_ADR_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_data_id_ex_rs,
        po_data => s_data_ex_mem_rs
    );

    mem_wb_rs: entity work.gen_register
    generic map(
        REG_ADR_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_data_ex_mem_rs,
        po_data => s_data_mem_wb_rs
    );

    decoder: entity work.decoder
    port map(
        pi_clk => s_clk,
        pi_instruction => s_data_if_id_instr,
        po_controlWord => s_control_word_decoder
    );

    id_ex_instr: entity work.ControlWordRegister
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_controlWord => s_control_word_decoder,
        po_controlWord => s_data_id_ex_instr
    );

    ex_mem_instr: entity work.ControlWordRegister
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_controlWord => s_data_id_ex_instr,
        po_controlWord => s_data_ex_mem_instr
    );

    mem_wb_instr: entity work.ControlWordRegister 
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_controlWord => s_data_ex_mem_instr,
        po_controlWord => s_data_mem_wb_instr
    );

    process(s_data_if_id_instr)
    begin
        report (to_string(s_data_if_id_instr));
        report (to_string(s_instructions(4)));
        report (to_string(s_instruction_ic(4)));
    end process;

    register_file: entity work.register_file
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_writeEnable => not(s_data_mem_wb_instr.IS_BRANCH),
        pi_readRegAddr1 => s_data_if_id_instr(19 downto 15),
        pi_readRegAddr2 => s_data_if_id_instr(19 downto 15),
        pi_writeRegAddr => s_data_mem_wb_rs,
        pi_writeRegData => s_data_mem_wb_alures,
        po_readRegData1 => s_read_reg_data1_register_file,
        po_readRegData2 => s_read_reg_data2_register_file,
        po_registerOut => s_registersOut
    );

    id_ex_op1: entity work.gen_register
    generic map(
        WORD_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_read_reg_data1_register_file,
        po_data => s_data_id_ex_op1
    );

    id_ex_op2: entity work.gen_register
    generic map(
        WORD_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_read_reg_data2_register_file,
        po_data => s_data_id_ex_op2
    );

    my_alu: entity work.my_alu
    generic map(
        WORD_WIDTH,
        ALU_OPCODE_WIDTH
    )
    port map(
        pi_OP1 => s_data_id_ex_op1,
        pi_OP2 => s_data_id_ex_op2,
        pi_aluOp => s_data_id_ex_instr.ALU_OP,
        pi_clk => s_clk,
        po_aluOut => s_alu_out_my_alu,
        po_carryOut => s_carry_out_my_alu
    );

    ex_mem_alures: entity work.gen_register
    generic map(
        WORD_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_alu_out_my_alu,
        po_data => s_data_ex_mem_alures
    );

    ex_wb_alures: entity work.gen_register
    generic map(
        WORD_WIDTH
    )
    port map(
        pi_clk => s_clk2,
        pi_rst => s_rst,
        pi_data => s_data_ex_mem_alures,
        po_data => s_data_mem_wb_alures
    );

    process is
    begin
    s_clk <= '0';
    wait for PERIOD / 2;

    for i in 0 to 14 loop
        s_clk <= '1';
        wait for PERIOD / 2;
        s_clk <= '0';
        wait for PERIOD / 2;

    if (i = 5) then -- after 5 clock clock cycles
        assert (to_integer(signed(s_registersOut(10))) = 9)
            report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) & " after cycle 4"
            severity error;
        end if;

    if (i = 6) then -- after 6 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(8)))= 17)
            report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) & " after cycle 5"
            severity error;
        end if;

        if (i =7) then -- after 6 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(11))) = 1)
            report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) & " after cycle 6"
            severity error;
        end if;

        if (i = 9) then -- after 8 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(12))) = 1)
            report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(1) & " after cycle 8"
            severity error;

        end if;
        if (i = 10) then -- after 7 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(12))) = 25)
            report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) & " after cycle 7"
            severity error;
        end if;

            if (i = 11) then -- after 9 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(12))) = -1)
            report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) & " after cycle 8"
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
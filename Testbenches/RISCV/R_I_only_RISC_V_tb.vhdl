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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constant_package.ALL;
USE work.types_package.ALL;
USE work.util_functions_package.ALL;

ENTITY R_I_only_RISC_V_tb IS
END ENTITY R_I_only_RISC_V_tb;

ARCHITECTURE structure OF R_I_only_RISC_V_tb IS

    CONSTANT PERIOD              : TIME                                      := 10 ns;
    CONSTANT ADD_FOUR_TO_ADDRESS : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := STD_LOGIC_VECTOR(to_signed((4), WORD_WIDTH));
    --signals
    --begin solution:
    SIGNAL s_clk  : STD_LOGIC := '0';
    SIGNAL s_clk2 : STD_LOGIC := '0';
    SIGNAL s_rst  : STD_LOGIC := '0';
    --my_gen_n_bit_full_adder
    SIGNAL s_carryIn_fa  : STD_LOGIC                                 := '0';
    SIGNAL s_sum_fa      : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_carryOut_fa : STD_LOGIC                                 := '0';
    --pc
    SIGNAL s_pc_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --instruction_cache
    SIGNAL s_instruction_cache_out : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --if_id_instr
    SIGNAL s_decoder_in : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --id_ex_rs
    SIGNAL s_data_id_ex_rs : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --ex_mem_rs
    SIGNAL s_data_ex_mem_rs : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --mem_wb_rs
    SIGNAL s_writeRegAddr : STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --decoder
    SIGNAL s_decoder_out : controlWord := control_word_init;
    --id_ex_instr
    SIGNAL s_data_id_ex_instr : controlWord := control_word_init;
    --ex_mem_instr
    SIGNAL s_data_ex_mem_instr : controlWord := control_word_init;
    --mem_wb_instr
    SIGNAL s_data_mem_wb_instr : controlWord := control_word_init;
    --register_file
    SIGNAL s_read_reg_data1_register_file : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_read_reg_data2_register_file : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --id_ex_op1
    SIGNAL s_data_id_ex_op1 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --id_ex_op2
    SIGNAL s_data_id_ex_op2 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --my_alu
    SIGNAL s_alu_out_my_alu   : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_carry_out_my_alu : STD_LOGIC                                 := '0';
    --ex_mem_alures
    SIGNAL s_data_ex_mem_alures : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --mem_wb_alures
    SIGNAL s_data_mem_wb_alures : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --immediate specific
    SIGNAL s_immediate_register1           : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_immediate_register2           : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL s_aluIn_op2 : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    signal s_extended_immediate : STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
    --end solution!!
    SIGNAL s_registersOut : registerMemory := (OTHERS => (OTHERS => '0'));
    SIGNAL s_instructions : memory         := (
        4 => STD_LOGIC_VECTOR'("000000001001" & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 DOWNTO 0) & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & I_OP_INS),
        8 => STD_LOGIC_VECTOR'("000000001000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 DOWNTO 0) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS),
        12  => STD_LOGIC_VECTOR'("0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & STD_LOGIC_VECTOR(to_unsigned(1, REG_ADR_WIDTH)) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 DOWNTO 0) & STD_LOGIC_VECTOR(to_unsigned(3, REG_ADR_WIDTH)) & R_OP_INS),  -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
        16 => STD_LOGIC_VECTOR'("000000001000" & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 DOWNTO 0) & STD_LOGIC_VECTOR(to_unsigned(2, REG_ADR_WIDTH)) & I_OP_INS),
        OTHERS => (OTHERS => '0')
    );

BEGIN
    --PC
    my_gen_n_bit_full_adder : ENTITY work.my_gen_n_bit_full_adder
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_OP1      => ADD_FOUR_TO_ADDRESS,
            pi_OP2      => s_pc_out,
            pi_carryIn  => s_carryIn_fa,
            po_sum      => s_sum_fa,
            po_carryOut => s_carryOut_fa
        );

    pc : ENTITY work.gen_register
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_sum_fa,
            po_data => s_pc_out
        );
    --End of PC
    --Instruction Cache
    instruction_cache : ENTITY work.instruction_cache
        GENERIC MAP(
            ADR_WIDTH
        )
        PORT MAP(
            pi_adr              => s_pc_out,
            pi_clk              => s_clk,
            pi_instructionCache => s_instructions,
            po_instruction      => s_instruction_cache_out
        );

    --Instruction Cache -> Decoder and Registerfile
    if_id_instr : ENTITY work.gen_register
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_instruction_cache_out,
            po_data => s_decoder_in
        );
    --End of Instrucion Cache
    --Decoder
    decoder : ENTITY work.decoder
        PORT MAP(
            pi_clk         => s_clk,
            pi_instruction => s_decoder_in,
            po_controlWord => s_decoder_out
        );
    -- End of Decoder
    --Immediate Register
    immediate_register1 : ENTITY work.gen_register
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_immediate_register1,
            po_data => s_extended_immediate
        );
    -- immediate_register2 : ENTITY work.gen_register
    -- GENERIC MAP(
    --     WORD_WIDTH
    -- )
    -- PORT MAP(
    --     pi_clk  => s_clk2,
    --     pi_rst  => s_rst,
    --     pi_data => s_immediate_register2,
    --     po_data => s_extended_immediate
    -- );
    immediate_sign_extender : entity work.sign_extender
    port map(
        pi_instr => s_decoder_in,
        po_iImmediate => s_immediate_register1
    );
    --End of Immediate Register
    --2nd Clock Cylce after Instruction Fetch
    id_ex_rs : ENTITY work.gen_register
        GENERIC MAP(
            REG_ADR_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_decoder_in(11 DOWNTO 7),
            po_data => s_data_id_ex_rs
        );

    id_ex_instr : ENTITY work.ControlWordRegister
        PORT MAP(
            pi_clk         => s_clk2,
            pi_rst         => s_rst,
            pi_controlWord => s_decoder_out,
            po_controlWord => s_data_id_ex_instr
        );
    --End of 2nd Clock Cycle after Instruction Fetch
    --3rd Clock Cycle after Instruction Fetch
    ex_mem_rs : ENTITY work.gen_register
        GENERIC MAP(
            REG_ADR_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_data_id_ex_rs,
            po_data => s_data_ex_mem_rs
        );
    ex_mem_instr : ENTITY work.ControlWordRegister
        PORT MAP(
            pi_clk         => s_clk2,
            pi_rst         => s_rst,
            pi_controlWord => s_data_id_ex_instr,
            po_controlWord => s_data_ex_mem_instr
        );
    --End of 3rd Clock Cycle after Instruction Fetch
    --4th Clock Cycle after Instruction Fetch
    mem_wb_rs : ENTITY work.gen_register
        GENERIC MAP(
            REG_ADR_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_data_ex_mem_rs,
            po_data => s_writeRegAddr
        );
    mem_wb_instr : ENTITY work.ControlWordRegister
        PORT MAP(
            pi_clk         => s_clk2,
            pi_rst         => s_rst,
            pi_controlWord => s_data_ex_mem_instr,
            po_controlWord => s_data_mem_wb_instr
        );
    --End of 4th Clock Cycle after Instruction Fetch
    --Registerfile
    register_file : ENTITY work.register_file
        PORT MAP(
            pi_clk          => s_clk,
            pi_rst          => s_rst,
            pi_readRegAddr1 => s_decoder_in(19 DOWNTO 15),
            pi_readRegAddr2 => s_decoder_in(24 DOWNTO 20),
            pi_writeRegAddr => s_writeRegAddr,
            pi_writeEnable  => NOT(s_decoder_out.IS_BRANCH),
            pi_writeRegData => s_data_mem_wb_alures,
            po_readRegData1 => s_read_reg_data1_register_file,
            po_readRegData2 => s_read_reg_data2_register_file,
            po_registerOut  => s_registersOut
        );

    id_ex_op1 : ENTITY work.gen_register
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_read_reg_data1_register_file,
            po_data => s_data_id_ex_op1
        );
    --Type Selector
    type_selector : ENTITY work.gen_mux
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_first    => s_data_id_ex_op2,
            pi_second   => s_extended_immediate,
            pi_selector => s_data_id_ex_instr.I_IMM_SEL,
            po_output   => s_aluIn_op2
        );
    id_ex_op2 : ENTITY work.gen_register
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_read_reg_data2_register_file,
            po_data => s_data_id_ex_op2
        );
    --End of Registerfile
    --ALU
    my_alu : ENTITY work.my_alu
        GENERIC MAP(
            WORD_WIDTH,
            ALU_OPCODE_WIDTH
        )
        PORT MAP(
            pi_OP1      => s_data_id_ex_op1,
            pi_OP2      => s_aluIn_op2,
            pi_aluOp    => s_decoder_out.ALU_OP,
            pi_clk      => s_clk,
            po_aluOut   => s_alu_out_my_alu,
            po_carryOut => s_carry_out_my_alu
        );

    ex_mem_alures : ENTITY work.gen_register
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_alu_out_my_alu,
            po_data => s_data_ex_mem_alures
        );

    ex_wb_alures : ENTITY work.gen_register
        GENERIC MAP(
            WORD_WIDTH
        )
        PORT MAP(
            pi_clk  => s_clk2,
            pi_rst  => s_rst,
            pi_data => s_data_ex_mem_alures,
            po_data => s_data_mem_wb_alures
        );
    --End of ALU
    PROCESS IS
    BEGIN
        s_clk <= '0';
        WAIT FOR PERIOD / 2;

        FOR i IN 0 TO 14 LOOP
            s_clk <= '1';
            WAIT FOR PERIOD / 2;
            s_clk <= '0';
            WAIT FOR PERIOD / 2;

            IF (i = 5) THEN -- after 5 clock cycles
                ASSERT (to_integer(signed(s_registersOut(1))) = 9)
                REPORT "ADDI-Operation failed. Register 1 contains " & INTEGER'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & INTEGER'image(9) & " after cycle 5"
                    SEVERITY error;
            END IF;

            IF (i = 6) THEN -- after 6 clock cycles, the pi_first result should be written to the RF
                ASSERT (to_integer(signed(s_registersOut(2))) = 8)
                REPORT "ADDI-Operation failed. Register 2 contains " & INTEGER'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & INTEGER'image(8) & " after cycle 6"
                    SEVERITY error;
            END IF;

            IF (i = 7) THEN -- after 7 clock cycles, the pi_first result should be written to the RF
                ASSERT (to_integer(signed(s_registersOut(3))) = 17)
                REPORT "ADD-Operation failed. Register 3 contains " & INTEGER'image(to_integer(signed(s_registersOut(3)))) & " but should contain " & INTEGER'image(17) & " after cycle 7"
                    SEVERITY error;
            END IF;

            IF (i = 8) THEN -- after 7 clock cycles, the pi_first result should be written to the RF
                ASSERT (to_integer(signed(s_registersOut(2))) = 16)
                REPORT "ADDI-Operation failed. Register 2 contains " & INTEGER'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & INTEGER'image(16) & " after cycle 7"
                    SEVERITY error;
            END IF;
        END LOOP;
        REPORT "End of test!!!";
        WAIT;
    END PROCESS;
    PROCESS IS
    BEGIN
        WAIT FOR PERIOD / 4;
        FOR i IN 0 TO 200 LOOP
            s_clk2 <= '0';
            WAIT FOR PERIOD / 2;
            s_clk2 <= '1';
            WAIT FOR PERIOD / 2;
        END LOOP;
        WAIT;
    END PROCESS;
END ARCHITECTURE;
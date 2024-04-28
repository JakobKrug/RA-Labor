-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date: 30.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;


entity decoder_tb is
end entity decoder_tb;

architecture behavior of decoder_tb is

  constant PERIOD : time := 10 ns; -- Example: ClockPERIOD of 10 ns
  signal s_instruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_controlword : controlWord := CONTROL_WORD_INIT;
  signal s_clk : std_logic := '0';

begin

  lu8 : entity work.decoder
    port map(
      pi_instruction => s_instruction,
      po_controlWord => s_controlword,
      pi_clk => s_clk
    );

  lu : process is

    -- For each architecture, check if the instruction format it adds to the decoder is decoded correctly

    variable v_aluoperation : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := ADD_OP_ALU;
    variable v_rs1 : integer := 5;
    variable v_rs2 : integer := 4;
    variable v_rd : integer := 6;
    variable v_expectedcontrolword : controlWord := CONTROL_WORD_INIT;
    variable instr : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    variable func7 : std_logic_vector(6 downto 0)              := "0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000";
    variable func3 : std_logic_vector(2 downto 0)              := ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0);

  begin

    -- R-Format Decoding
    instr := (others => '0');
    func7 := "0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000";
    func3 := ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0);
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & ADD_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := ADD_OP_ALU;
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;

    instr := (others => '0');
    func7 := "0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000";
    func3 := SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0);
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & ADD_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := SUB_OP_ALU;
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;

    instr := (others => '0');
    func7 := "0" & SRA_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000";
    func3 := SRA_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0);
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & ADD_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := SRA_OP_ALU;
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;


        instr := (others => '0');
    func7 := "0" & SRL_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000";
    func3 := SRL_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0);
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & ADD_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := SRL_ALU_OP;
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;


        instr := (others => '0');
    func7 := "0" & SLL_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000";
    func3 := SLL_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0);
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & ADD_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := SLL_ALU_OP;
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;


        instr := (others => '0');
    func7 := "0" & OR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000";
    func3 := OR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0);
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & ADD_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := OR_ALU_OP;
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;


        instr := (others => '0');
    func7 := "0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000";
    func3 := XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0);
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & ADD_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := XOR_ALU_OP;
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;


        instr := (others => '0');
    func7 := "0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000";
    func3 := AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0);
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & ADD_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := AND_ALU_OP;
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;

    instr := (others => '0');
    func7 := "0" & "0"  & "00000";
    func3 := "011";
    s_instruction <= func7 & std_logic_vector(to_unsigned(v_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(v_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(v_rd, REG_ADR_WIDTH)) & "0000011"; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    
    v_expectedControlWord.I_IMM_SEL := '0';
    v_expectedControlWord.ALU_OP := "0000";
    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;
    assert (s_controlword = v_expectedcontrolword)
    report "Error in R-Format decoding"  severity error;



    assert false
    report "end of test"
      severity note;

    wait; --  Wait forever; this will finish the simulation.

  end process lu;

end architecture behavior;

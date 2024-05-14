
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;
  use work.types_package.all;

package util_functions_package is

  -- Function interface declaration. For implemenation, see package body below

  function f_buildinstructionralu (
    alu_op : in std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0);
    adr_rs1 : in integer;
    adr_rs2 : in integer;
    adr_rd : in integer
  ) return std_logic_vector;

  function f_buildinstructionialu (
    alu_op : in std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0);
    adr_rs1 : in integer;
    imm : in integer;
    adr_rd : in integer
  ) return std_logic_vector;

  function f_buildinstructioni (
    opcode : in std_logic_vector(OPCODE_WIDTH - 1 downto 0);
    adr_rs1 : in integer;
    func3: in std_logic_vector(FUNC3_WIDTH -1 downto 0);
    imm : in integer;
    adr_rd : in integer
  ) return std_logic_vector;

  function f_buildinstructionu (
    opcode : in std_logic_vector(OPCODE_WIDTH - 1 downto 0);
    imm : in integer;
    adr_rd : in integer
  ) return std_logic_vector;

  function f_buildinstructionb (
    func3 : in std_logic_vector(FUNC3_WIDTH - 1 downto 0);
    adr_rs1 : in integer;
    adr_rs2 : in integer;
    imm : in integer
  ) return std_logic_vector;

  function f_buildinstructionj (
    imm : in integer;
    adr_rd : in integer
  ) return std_logic_vector;

  function f_controlwordtostring (cw: controlWord) return string;

end package util_functions_package;

package body util_functions_package is

  -- construct an R-format instruction using the alu opcode (NOT the instruction opcode: see Constant_Package.vhdl)

  function f_buildinstructionralu (
    alu_op : in std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0);
    adr_rs1 : in integer;
    adr_rs2 : in integer;
    adr_rd : in integer
  )
        return std_logic_vector is

    variable instr : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    variable func7 : std_logic_vector(6 downto 0)              := "0" & alu_op (ALU_OPCODE_WIDTH - 1) & "00000";
    variable func3 : std_logic_vector(2 downto 0)              := alu_op(ALU_OPCODE_WIDTH - 2 downto 0);

  begin

    -- 7 + 5 + 5 + 3 + 5 + 7 = 32
    instr := func7 & std_logic_vector(to_unsigned(adr_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(adr_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(adr_rd, REG_ADR_WIDTH)) & R_OP_INS; -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    return instr;

  end function f_buildinstructionralu;

  -- construct a I-format instruction using the alu opcode (NOT the instruction opcode: see Constant_Package.vhdl)

  function f_buildinstructionialu (
    alu_op : in std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0);
    adr_rs1 : in integer;
    imm : in integer;
    adr_rd : in integer
  )
        return std_logic_vector is

    variable instr : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    variable func3 : std_logic_vector(2 downto 0)              := alu_op(ALU_OPCODE_WIDTH - 2 downto 0);

  begin

    -- 12 + 5 + 3 + 5 + 7 = 32
    instr := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(adr_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(adr_rd, REG_ADR_WIDTH)) & I_OP_INS; -- I-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    return instr;

  end function f_buildinstructionialu;

  -- construct an I-format instruction using the instruction opcode (used for instructions that don't use the alu)

  function f_buildinstructioni (
    opcode : in std_logic_vector(OPCODE_WIDTH - 1 downto 0);
    adr_rs1 : in integer;
    func3: in std_logic_vector(FUNC3_WIDTH -1 downto 0);
    imm : in integer;
    adr_rd : in integer
  )
        return std_logic_vector is

    variable instr : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  begin

    -- 12 + 5 + 3 + 5 + 7 = 32
    instr := std_logic_vector(to_signed(imm, 12)) & std_logic_vector(to_unsigned(adr_rs1, REG_ADR_WIDTH)) & func3 & std_logic_vector(to_unsigned(adr_rd, REG_ADR_WIDTH)) & opcode; -- for now, this function is only really used by jalr
    return instr;

  end function f_buildinstructioni;

  -- construct an U-format instruction using the instruction opcode (used for instructions that don't use the alu)

  function f_buildinstructionu (
    opcode : in std_logic_vector(OPCODE_WIDTH - 1 downto 0);
    imm : in integer;
    adr_rd : in integer
  )
        return std_logic_vector is

    variable instr : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

  begin

    -- 20 + 5 + 7 = 32
    instr := std_logic_vector(to_signed(imm, 20)) & std_logic_vector(to_unsigned(adr_rd, REG_ADR_WIDTH)) & opcode;
    return instr;

  end function f_buildinstructionu;

  -- construct a B-format instruction, using func3 to specify the branch type (as all B-Format branches have the same opcode)

  function f_buildinstructionb (
    func3 : in std_logic_vector(FUNC3_WIDTH - 1 downto 0);
    adr_rs1 : in integer;
    adr_rs2 : in integer;
    imm : in integer
  )
        return std_logic_vector is

    variable instr : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    variable v_imm : std_logic_vector(12 - 1 downto 0)         := std_logic_vector(to_signed(imm, 12));

  begin

    -- 1 + 6 + 5 + 5  + 3 +  4+ 1 + 7 = 32
    instr := v_imm(11) & v_imm (9 downto 4) & std_logic_vector(to_unsigned(adr_rs2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(adr_rs1, REG_ADR_WIDTH)) & func3 & v_imm(3 downto 0) & v_imm(10) & BEQ_OP_INS; -- B-Format instructions all have the same opcode
    return instr;

  end function f_buildinstructionb;


  function f_buildinstructionj (
    imm : in integer;
    adr_rd : in integer
  ) return std_logic_vector is

    variable instr : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    variable v_imm : std_logic_vector(20 - 1 downto 0)         := std_logic_vector(to_signed(imm, 20));

  begin

    -- 1 + 10 + 1 +8 + 5+7 = 32
    instr := v_imm(19) & v_imm (9 downto 0) & v_imm (10) & v_imm (18 downto 11) & std_logic_vector(to_unsigned(adr_rd, REG_ADR_WIDTH)) & JAL_OP_INS; -- JAL is the only j-format instruction in RV32I
    return instr;

  end function f_buildinstructionj;

  -- Write control word to string, used for debugging in report statements in testbenches

  function f_controlwordtostring (cw: controlWord) return string is

    variable s : string (1 to 115);

  begin

    s := "ALU_OP: " & to_string(cw.ALU_OP) &
         ", I_IMM_SEL: " & to_string(cw.I_IMM_SEL) &
         ", U_IMM_SEL: " & to_string(cw.U_IMM_SEL) &
         ", SET_PC_SEL: " & to_string(cw.SET_PC_SEL) &
         ", PC_SEL: " & to_string(cw.PC_SEL) &
         ", IS_BRANCH: " & to_string (cw.IS_BRANCH) &
         ", CMP_RESULT: " & to_string(cw.CMP_RESULT) &
         ", DATA_CONTROL: " & to_string(cw.DATA_CONTROL);
    return s;

  end function f_controlwordtostring;

end package body util_functions_package;

-- Laboratory RA solutions/versuch1
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name:
 

-- ========================================================================
-- Author:       Marcel Rieß, with additions by Niklas Gutsmiedl
-- Last updated: 19.03.2024
-- Description:  Testbench for the ALU declared in my_alu.vhdl
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;

entity my_alu_tb is
end entity my_alu_tb;

architecture behavior of my_alu_tb is

  signal   s_op1            : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0)   := (others => '0');
  signal   s_op2            : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0)   := (others => '0');
  signal   s_luOut          : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0)   := (others => '0');
  signal   s_expect         : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0)   := (others => '0');
  signal   s_luOp           : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := (others => '0');
  signal   s_carryOut       : std_logic;
  signal   s_shiftType      : std_logic;
  signal   s_shiftDirection : std_logic;
  constant PERIOD           : time                                              := 10 ns; -- Example: ClockPERIOD of 10 ns
  signal   s_clk            : std_logic                                         := '0';

begin

  lu1 : entity work.my_alu
    generic map (DATA_WIDTH_GEN, ALU_OPCODE_WIDTH)
    port map (
      pi_op1       => s_op1,
      pi_op2       => s_op2,
      pi_aluOp     => s_luOp,
      pi_clk       => s_clk,
      po_aluOut    => s_luOut,
      po_carryOut  => s_carryOut
    );

  lu : process is
  begin

    s_clk <= '1';
    wait for PERIOD / 2;
    s_clk <= '0';
    wait for PERIOD / 2;

    for op1_i in - (2 ** (DATA_WIDTH_GEN - 1)) to (2 ** (DATA_WIDTH_GEN - 1) - 1) loop

      s_op1 <= std_logic_vector(to_signed(op1_i, DATA_WIDTH_GEN));

      for op2_i in - (2 ** (DATA_WIDTH_GEN - 1)) to (2 ** (DATA_WIDTH_GEN - 1) - 1) loop

        s_op2 <= std_logic_vector(to_signed(op2_i, DATA_WIDTH_GEN));
        s_clk <= '1';
        wait for PERIOD / 2;
        s_clk <= '0';
        wait for PERIOD / 2;
        -- and
        s_luOp  <= AND_ALU_OP;
        s_expect <= s_op1 and s_op2;
        s_clk    <= '1';
        wait for PERIOD / 2;
        s_clk    <= '0';
        wait for PERIOD / 2;
        assert (s_expect = s_luOut)
          report "Had error in AND-Function "
          severity error;

        -- or
        s_luOp  <= OR_ALU_OP;
        s_expect <= s_op1 or s_op2;
        s_clk    <= '1';
        wait for PERIOD / 2;
        s_clk    <= '0';
        wait for PERIOD / 2;
        assert (s_expect = s_luOut)
          report "Had error in OR-Function "
          severity error;
        -- xor
        s_luOp  <= XOR_ALU_OP;
        s_expect <= s_op1 xor s_op2;
        s_clk    <= '1';
        wait for PERIOD / 2;
        s_clk    <= '0';
        wait for PERIOD / 2;
        assert (s_expect = s_luOut)
          report "Had error in XOR-Function : " & to_string(signed(s_op1)) & " xor " & to_string(signed(s_op2)) & " = " & to_string(signed(s_luOp)) & " = " & to_string(signed(s_luOut))
          severity error;

        if (op2_i >= 0 and op2_i < integer(log2(real(DATA_WIDTH_GEN)))) then
          -- sll
          s_luOp <= SLL_ALU_OP;
          if (op2_i <= 0) then
            s_expect <= s_op1;
          elsif (op2_i < DATA_WIDTH_GEN) then
            s_expect(op2_i - 1 downto 0)                <= (others => '0');
            s_expect(DATA_WIDTH_GEN - 1 downto op2_i) <= s_op1(DATA_WIDTH_GEN - 1 - op2_i downto 0);
          end if;
          s_clk <= '1';
          wait for PERIOD / 2;
          s_clk <= '0';
          wait for PERIOD / 2;
          assert (s_expect = s_luOut)
            report "Had error in sll-Function "
            severity error;

          -- srl
          s_luOp  <= SRL_ALU_OP;
          s_expect <= (others => '0');
          if (op2_i <= 0) then
            s_expect <= s_op1;
          elsif (op2_i < DATA_WIDTH_GEN) then
            s_expect                                        <= (others => '0');
            s_expect(DATA_WIDTH_GEN - 1 - op2_i downto 0) <= s_op1(DATA_WIDTH_GEN - 1 downto op2_i);
          end if;
          s_clk <= '1';
          wait for PERIOD / 2;
          s_clk <= '0';
          wait for PERIOD / 2;
          assert (s_expect = s_luOut)
            report "Had error in srl-Function "
            severity error;

          -- sra
          s_luOp <= SRA_OP_ALU;
          if (op2_i <= 0) then
            s_expect <= s_op1;
          elsif (op2_i < DATA_WIDTH_GEN) then
            s_expect                                        <= (others => s_op1(DATA_WIDTH_GEN - 1));
            s_expect(DATA_WIDTH_GEN - 1 - op2_i downto 0) <= s_op1(DATA_WIDTH_GEN - 1 downto op2_i);
          end if;
          s_clk <= '1';
          wait for PERIOD / 2;
          s_clk <= '0';
          wait for PERIOD / 2;
          assert (s_expect = s_luOut)
            report "Had error in sra-Function"
            severity error;
        end if;

        -- add
        s_luOp <= ADD_OP_ALU;
        s_clk   <= '1';
        wait for PERIOD / 2;
        s_clk   <= '0';
        wait for PERIOD / 2;

        if (((op1_i + op2_i) /= to_integer(signed(s_luOut)))                               -- Summe mit ALU result vergleichen
            and ((op1_i + op2_i - 2 ** DATA_WIDTH_GEN) /= (to_integer(signed(s_luOut)))) -- Überlauf prüfen
            and ((to_integer(signed(s_luOut)) /= (op1_i + op2_i) mod (2 ** (DATA_WIDTH_GEN))))) then
          report integer'image(op1_i) & "+" & integer'image(op2_i) & " ==> " & integer'image(op1_i + op2_i) & " but add-op simulation returns " & integer'image(to_integer(signed(s_luOut)))
            severity error;
        end if;

        -- sub
        s_luOp <= SUB_OP_ALU;
        s_clk   <= '1';
        wait for PERIOD / 2;
        s_clk   <= '0';
        wait for PERIOD / 2;

        if (((op1_i - op2_i) /= to_integer(signed(s_luOut))) and ((op1_i - op2_i - 2 ** DATA_WIDTH_GEN) /= (to_integer(signed(s_luOut)))) and ((to_integer(signed(s_luOut)) /= (op1_i - op2_i) mod (2 ** (DATA_WIDTH_GEN))))) then
          report integer'image(op1_i) & "+" & integer'image(op2_i) & " ==> " & integer'image(op1_i + op2_i) & " but sub-op simulation returns " & integer'image(to_integer(signed(s_luOut)))
            severity error;
        end if;

        -- slt
        s_luOp <= SLT_OP_ALU;
        s_clk   <= '1';
        wait for PERIOD / 2;
        s_clk   <= '0';
        wait for PERIOD / 2;

        if ((op1_i < op2_i) and (to_integer(signed(s_luOut)) /= 1)) then
          report integer'image(op1_i) & "<" & integer'image(op2_i) & " ==> " & boolean'image(op1_i < op2_i) & " but sub-op simulation returns " & to_string(s_luOut)
            severity error;
        elsif ((op1_i >= op2_i) and (to_integer(signed(s_luOut)) /= 0)) then
          report integer'image(op1_i) & "<" & integer'image(op2_i) & " ==> " & boolean'image(op1_i < op2_i) & " but sub-op simulation returns " & to_string(s_luOut)
            severity error;
        end if;

        -- slt
        s_luOp <= SLTU_OP_ALU;
        s_clk   <= '1';
        wait for PERIOD / 2;
        s_clk   <= '0';
        wait for PERIOD / 2;

        if ((op1_i <- 1) and (op2_i <- 1) and (op1_i < op2_i) and (to_integer(signed(s_luOut)) /= 1)) then
          report integer'image(op1_i) & "<" & integer'image(op2_i) & " ==> " & boolean'image(op1_i < op2_i) & " but sub-op simulation returns " & to_string(s_luOut)
            severity error;
        end if;

        -- eq
        s_luOp <= EQ_OP_ALU;
        s_clk   <= '1';
        wait for PERIOD / 2;
        s_clk   <= '0';
        wait for PERIOD / 2;

        if (((op1_i /= op2_i) and  (s_luOut(0) = '1')) or ((op1_i = op2_i) and   (s_luOut(0) = '0'))) then
          report integer'image(op1_i) & "==" & integer'image(op2_i) & " ==> " & to_string(op1_i = op2_i) & " but sub-op simulation returns " & to_string(s_luOut)
            severity error;
        end if;

      end loop;

    end loop;

    assert false
      report "end of ALU test"
      severity note;

    wait;                                                                                   --  Wait forever; this will finish the simulation.

  end process lu;

end architecture behavior;

-- Laboratory RA solutions/versuch1
-- Sommersemester 24
-- Group Details
-- Lab Date: 23.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt

-- ========================================================================
-- Author:       Marcel Rieß, with additions by Niklas Gutsmiedl
-- Last updated: 19.03.2024
-- Description:  Generic ALU used in the RV Processor. Simultaneously
--               computes results for the following operations, in one clock
--               cyle: add, sub, and, or, xor, sll, srl, sra, slt, sltu, eq
-- ========================================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constant_package.ALL;

ENTITY my_alu IS
    -- begin solution:
    GENERIC (
        dataWidth   : INTEGER := DATA_WIDTH_GEN;
        opCodeWidth : INTEGER := OPCODE_WIDTH
    );
    PORT (
        pi_op1, pi_op2 : IN STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0);
        pi_aluOp       : IN STD_LOGIC_VECTOR (opCodeWidth - 1 DOWNTO 0);
        pi_clk         : IN STD_LOGIC;
        po_aluOut      : OUT STD_LOGIC_VECTOR (dataWidth - 1 DOWNTO 0);
        po_carryOut    : OUT STD_LOGIC
    );
    -- end solution!!
END ENTITY my_alu;

ARCHITECTURE behavior OF my_alu IS

    SIGNAL s_op1            : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_op2            : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_res1           : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_res2           : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_res3           : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_res4           : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_res5           : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_res6           : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_res7           : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_res8           : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 0)   := (OTHERS => '0');
    SIGNAL s_cin            : STD_LOGIC                                  := '0';
    SIGNAL s_cout           : STD_LOGIC                                  := '0';
    SIGNAL s_shiftType      : STD_LOGIC                                  := '0';
    SIGNAL s_shiftDirection : STD_LOGIC                                  := '0';
    SIGNAL s_clk            : STD_LOGIC                                  := '0';
    SIGNAL s_zeropadding    : STD_LOGIC_VECTOR(dataWidth - 1 DOWNTO 1)   := (OTHERS => '0');
    SIGNAL s_luOp           : STD_LOGIC_VECTOR(opCodeWidth - 1 DOWNTO 0) := (OTHERS => '0');

BEGIN

    xor1 : ENTITY work.my_gen_xor
        GENERIC MAP(
            dataWidth
        )
        PORT MAP(
            s_op1,
            s_op2,
            s_res1
        );

    or1 : ENTITY work.my_gen_or
        GENERIC MAP(
            dataWidth
        )
        PORT MAP(
            s_op1,
            s_op2,
            s_res2
        );

    and1 : ENTITY work.my_gen_and
        GENERIC MAP(
            dataWidth
        )
        PORT MAP(
            s_op1,
            s_op2,
            s_res3
        );

    shift : ENTITY work.my_shifter
        GENERIC MAP(
            dataWidth
        )
        PORT MAP(
            s_op1,
            s_op2,
            s_shiftType,
            s_shiftDirection,
            s_res4
        );

    add1 : ENTITY work.my_gen_n_bit_full_adder
        GENERIC MAP(
            dataWidth
        )
        PORT MAP(
            s_op1,
            s_op2,
            s_cin,
            s_res5,
            s_cout
        );

    s_clk <= pi_clk;

    PROCESS (s_clk) IS
    BEGIN

        IF rising_edge(s_clk) THEN
            s_op1 <= pi_op1;
            s_op2 <= pi_op2;
            IF (pi_aluOp = AND_ALU_OP) THEN
                -- AND
                -- begin solution:
                -- end solution!!
            ELSIF (pi_aluOp = OR_ALU_OP) THEN
                -- OR
                -- begin solution:
                -- end solution!!
            ELSIF (pi_aluOp = XOR_ALU_OP) THEN
                -- XOR
                -- begin solution:
                -- end solution!!
            ELSIF (pi_aluOp = SLL_ALU_OP) THEN
                -- SLL
                -- begin solution:
                s_shiftType      <= pi_aluOp(opCodeWidth - 1);
                s_shiftDirection <= '0';
                -- end solution!!
            ELSIF (pi_aluOp = SRL_ALU_OP) THEN
                -- SRL
                -- begin solution:
                s_shiftType      <= pi_aluOp(opCodeWidth - 1);
                s_shiftDirection <= '1';
                -- end solution!!
            ELSIF (pi_aluOp = SRA_OP_ALU) THEN
                -- SRA
                -- begin solution:
                s_shiftType      <= pi_aluOp(opCodeWidth - 1);
                s_shiftDirection <= '1';
                -- end solution!!
            ELSIF (pi_aluOp = ADD_OP_ALU) THEN
                -- ADD
                -- begin solution:
                s_cIn <= pi_aluOp(opCodeWidth - 1);
                -- end solution!!
            ELSIF (pi_aluOp = SUB_OP_ALU) THEN
                -- SUB
                -- begin solution:
                s_cIn <= pi_aluOp(opCodeWidth - 1);
                -- end solution!!
            ELSIF (pi_aluOp = SLT_OP_ALU) THEN
                -- SLT
                -- begin solution:
                -- end solution!!
            ELSIF (pi_aluOp = SLTU_OP_ALU) THEN
                -- SLTU
                -- begin solution:
                -- end solution!!
            ELSIF (pi_aluOp = EQ_OP_ALU) THEN
            ELSE
                -- OTHERS
                -- begin solution:
                -- end solution!!
            END IF;
        END IF;

        IF falling_edge(s_clk) THEN
            IF (pi_aluOp = AND_ALU_OP) THEN
                -- AND
                -- begin solution:
                po_aluOut   <= s_res3;
                po_carryOut <= '0';
                -- end solution!!
            ELSIF (pi_aluOp = OR_ALU_OP) THEN
                -- OR
                -- begin solution:
                po_aluOut   <= s_res2;
                po_carryOut <= '0';
                -- end solution!!
            ELSIF (pi_aluOp = XOR_ALU_OP) THEN
                -- XOR
                -- begin solution:
                po_aluOut   <= s_res1;
                po_carryOut <= '0';
                -- end solution!!
            ELSIF (pi_aluOp = SLL_ALU_OP) THEN
                -- SLL
                -- begin solution:
                po_aluOut   <= s_res4;
                po_carryOut <= '0';
                -- end solution!!
            ELSIF (pi_aluOp = SRL_ALU_OP) THEN
                -- SRL
                -- begin solution:
                po_aluOut   <= s_res4;
                po_carryOut <= '0';
                -- end solution!!
            ELSIF (pi_aluOp = SRA_OP_ALU) THEN
                -- SRA
                -- begin solution:
                po_aluOut   <= s_res4;
                po_carryOut <= '0';
                -- end solution!!
            ELSIF (pi_aluOp = ADD_OP_ALU) THEN
                -- ADD
                -- begin solution:
                po_aluOut   <= s_res5;
                po_carryOut <= s_cOut;
                -- end solution!!
            ELSIF (pi_aluOp = SUB_OP_ALU) THEN
                -- SUB
                -- begin solution:
                po_aluOut   <= s_res5;
                po_carryOut <= s_cOut;
                -- end solution!!
            ELSIF (pi_aluOp = SLT_OP_ALU) THEN
                -- SLT
                -- begin solution:
                IF (s_op1 >= s_op2) THEN
                    po_aluOut <= "00000000";
                    po_carryOut <= '0';
                ELSIF (s_op1 < s_op2) THEN
                    po_aluOut <= "00000001";
                    po_carryOut <= '0';
                END IF;
                -- end solution!!
            ELSIF (pi_aluOp = SLTU_OP_ALU) THEN
                -- SLTU
                -- begin solution:
                IF (s_op1 >= s_op2) THEN
                    po_aluOut <= "00000000";
                    po_carryOut <= '0';
                ELSIF (s_op1 < s_op2) THEN
                    po_aluOut <= "00000001";
                    po_carryOut <= '0';
                END IF;
                -- end solution!!
            ELSE
                -- OTHERS
                -- begin solution:
                po_aluOut   <= (OTHERS => '0');
                po_carryOut <= '0';
                -- end solution!!
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE behavior;
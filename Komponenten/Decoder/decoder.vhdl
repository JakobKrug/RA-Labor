-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date: 30.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.Constant_package.ALL;
USE work.types_package.ALL;

ENTITY decoder IS
    -- begin solution:
    -- generic(
    --     WORD_WIDTH : integer := WORD_WIDTH
    -- );
    PORT (
        pi_clk         : IN STD_LOGIC                                 := '0';
        pi_instruction : IN STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
        po_controlWord : OUT controlWord                              := control_word_init
    );
    -- end solution!!
END ENTITY decoder;
ARCHITECTURE arc OF decoder IS
    -- begin solution:
BEGIN
    PROCESS (pi_clk)
        VARIABLE v_insFormat : t_instruction_type;
    BEGIN
        IF rising_edge(pi_clk) THEN
            CASE pi_instruction(OPCODE_WIDTH - 1 DOWNTO 0) IS
                WHEN R_OP_INS => v_insFormat := rFormat;
                WHEN I_OP_INS => v_insFormat := iFormat;
                WHEN OTHERS   => v_insFormat   := nullFormat;
            END CASE;

            CASE v_insFormat IS
                WHEN rFormat => po_controlWord.ALU_OP <= pi_instruction(30) & pi_instruction(14 DOWNTO 12);
                WHEN iFormat => po_controlWord        <= (
                    ALU_OP       => pi_instruction(30) & pi_instruction(14 DOWNTO 12),
                    I_IMM_SEL    => '1',
                    J_IMM_SEL    => '0',
                    U_IMM_SEL    => '0',
                    SET_PC_SEL   => '0',
                    PC_SEL       => '0',
                    IS_BRANCH    => '0',
                    CMP_RESULT   => '0',
                    DATA_CONTROL => (OTHERS => '0')
                    );
                WHEN OTHERS => po_controlWord <= control_word_init;
            END CASE;
        END IF;
    END PROCESS;
    -- end solution!!
END ARCHITECTURE;
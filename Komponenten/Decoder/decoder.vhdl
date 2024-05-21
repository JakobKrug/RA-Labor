-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date: 30.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_package.all;
use work.types_package.all;

entity decoder is
    -- begin solution:
    -- generic(
    --     WORD_WIDTH : integer := WORD_WIDTH
    -- );
    port (
        pi_clk : in STD_LOGIC := '0';
        pi_instruction : in STD_LOGIC_VECTOR(WORD_WIDTH - 1 downto 0) := (others => '0');
        po_controlWord : out controlWord := control_word_init
    );
    -- end solution!!
end entity decoder;
architecture arc of decoder is
    -- begin solution:
begin
    process (pi_clk)
        variable v_insFormat : t_instruction_type;
    begin
        if rising_edge(pi_clk) then
            case pi_instruction(OPCODE_WIDTH - 1 downto 0) is
                when R_OP_INS => v_insFormat := rFormat;
                when I_OP_INS => v_insFormat := iFormat;
                when LUI_OP_INS => v_insFormat := uFormat;
                when AUIPC_OP_INS => v_insFormat := uFormat;
                when JAL_OP_INS => v_insFormat := jFormat;
                when JALR_OP_INS => v_insFormat := jFormat;
                when others => v_insFormat := nullFormat;
            end case;

            case v_insFormat is
                when rFormat => po_controlWord <= (
                    ALU_OP => pi_instruction(30) & pi_instruction(14 downto 12),
                    I_IMM_SEL => '0',
                    J_IMM_SEL => '0',
                    U_IMM_SEL => '0',
                    SET_PC_SEL => '0',
                    PC_SEL => '0',
                    A_SEL => '0',
                    WB_SEL => "00",
                    IS_BRANCH => '0',
                    CMP_RESULT => '0',
                    DATA_CONTROL => (others => '0')
                    );
                when iFormat => po_controlWord <= (
                    ALU_OP => pi_instruction(30) & pi_instruction(14 downto 12),
                    I_IMM_SEL => '1',
                    J_IMM_SEL => '0',
                    U_IMM_SEL => '0',
                    SET_PC_SEL => '0',
                    PC_SEL => '0',
                    A_SEL => '0',
                    WB_SEL => "00",
                    IS_BRANCH => '0',
                    CMP_RESULT => '0',
                    DATA_CONTROL => (others => '0')
                    );
                when uFormat => po_controlWord <= (
                    ALU_OP => ADD_OP_ALU,
                    I_IMM_SEL => '1',
                    J_IMM_SEL => '0',
                    U_IMM_SEL => '0',
                    SET_PC_SEL => '0',
                    PC_SEL => '0',
                    A_SEL => '0',
                    WB_SEL => "00",
                    IS_BRANCH => '0',
                    CMP_RESULT => '0',
                    DATA_CONTROL => (others => '0')
                    );
                when jFormat => po_controlWord <= (
                    ALU_OP => ADD_OP_ALU,
                    I_IMM_SEL => '1',
                    J_IMM_SEL => '0',
                    U_IMM_SEL => '0',
                    SET_PC_SEL => '0',
                    PC_SEL => '1',
                    A_SEL => '0',
                    WB_SEL => "10",
                    IS_BRANCH => '0',
                    CMP_RESULT => '0',
                    DATA_CONTROL => (others => '0')
                    );
                when others => po_controlWord <= control_word_init;
            end case;
            if pi_instruction(OPCODE_WIDTH - 1 downto 0) = LUI_OP_INS then
                po_controlWord.WB_SEL <= "01";
            elsif pi_instruction(OPCODE_WIDTH - 1 downto 0) = AUIPC_OP_INS then
                po_controlWord.A_SEL <= '1';
            elsif pi_instruction(OPCODE_WIDTH - 1 downto 0) = JAL_OP_INS then
                po_controlWord.A_SEL <= '1';
            end if;
        end if;
    end process;
    -- end solution!!
end architecture;
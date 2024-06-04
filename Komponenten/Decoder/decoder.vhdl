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
    generic (
        G_WORD_WIDTH : integer := WORD_WIDTH
    );
    port (
        pi_clk         : in std_logic;
        pi_instruction : in std_logic_vector(G_WORD_WIDTH - 1 downto 0);
        po_controlWord : out controlword := control_word_init
    );
    -- end solution!!
end entity decoder;
architecture arc of decoder is
    -- begin solution:
begin

    process (pi_instruction)
        variable v_insFormat : t_instruction_type;
    begin
        --decode
        case pi_instruction(6 downto 0) is
            when R_OP_INS =>
                v_insFormat := rFormat;
            when I_OP_INS | JALR_OP_INS =>
                v_insFormat := iFormat;
            when LUI_OP_INS | AUIPC_OP_INS | JAL_OP_INS =>
                v_insFormat := uFormat;
            when B_OP_INS =>
                v_insFormat := bFormat;
            when others =>
                v_insFormat := nullFormat;
        end case;
        --write controlword
        case v_insFormat is
                --i-Befehlsformate
            when iFormat =>
                --sonderbehandlung Shift Right Arithmetic
                if (pi_instruction(14 downto 12) = SRA_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0)) then po_controlWord.ALU_OP(3) <= pi_instruction(30);
                else po_controlWord.ALU_OP(3)                                                                               <= '0';
                end if;
                --sonderbehandlung Jump and link Register
                if pi_instruction(6 downto 0) = JALR_OP_INS then po_controlWord.ALU_OP(3 downto 0) <= ADD_OP_ALU;
                    po_controlWord.WB_SEL                                                              <= "10";
                    po_controlWord.PC_SEL                                                              <= '1';
                else po_controlWord.ALU_OP(2 downto 0)                                             <= pi_instruction(14 downto 12);
                    po_controlWord.PC_SEL                                                              <= '0';
                    po_controlWord.WB_SEL                                                              <= "00";
                end if;
                po_controlWord.I_IMM_SEL <= '1';
                po_controlWord.A_SEL     <= '0';
                --R-Befehlsformate
            when rFormat =>
                po_controlWord.ALU_OP(3)          <= pi_instruction(30);
                po_controlWord.ALU_OP(2 downto 0) <= pi_instruction(14 downto 12);
                po_controlWord.I_IMM_SEL          <= '0';
                po_controlWord.A_SEL              <= '0';
                po_controlWord.WB_SEL             <= "00";
                po_controlWord.PC_SEL             <= '0';

                --u-Befehlsformate
            when uFormat =>
                po_controlWord.I_IMM_SEL                                                               <= '1';
                po_controlWord.A_SEL                                                                   <= '1';
                if (pi_instruction(6 downto 0) = AUIPC_OP_INS) then po_controlWord.WB_SEL              <= "00";
                    po_controlWord.PC_SEL                                                                  <= '0';
                elsif (pi_instruction(6 downto 0) = JAL_OP_INS) then po_controlWord.ALU_OP(3 downto 0) <= ADD_OP_ALU;
                    po_controlWord.WB_SEL                                                                  <= "10";
                    po_controlWord.PC_SEL                                                                  <= '1';
                else po_controlWord.WB_SEL                                                             <= "01";
                    po_controlWord.PC_SEL                                                                  <= '0';
                end if;

                --Rest-Befehlsformate
            when bFormat =>
                po_controlWord.ALU_OP     <= XOR_ALU_OP;
                po_controlWord.IS_BRANCH  <= '1';
                po_controlWord.CMP_RESULT <= '1';
            when others =>
                po_controlWord <= control_word_init;
        end case;
    end process;
    -- end solution!!
end architecture;
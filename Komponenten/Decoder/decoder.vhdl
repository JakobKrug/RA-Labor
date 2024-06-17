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
        word_width   : integer := WORD_WIDTH;
        opcode_width : integer := OPCODE_WIDTH

    );
    port (
        pi_clk         : in std_logic;
        pi_instruction : in std_logic_vector (word_width - 1 downto 0) := (others => '0');
        po_controlWord : out controlword
    );
    -- end solution!!
end entity decoder;

architecture arc of decoder is
    -- begin solution:
begin
    process (pi_instruction)
        variable v_insFormat : t_instruction_type;
    begin
        case pi_instruction(opcode_width - 1 downto 0) is
            when R_OP_INS =>
                v_insFormat := rFormat;
            when I_OP_INS | JALR_OP_INS | L_OP_INS =>
                v_insFormat := iFormat;
            when LUI_OP_INS | AUIPC_OP_INS | JAL_OP_INS =>
                v_insFormat := uFormat;
            when B_OP_INS =>
                v_insFormat := bFormat;
            when S_OP_INS =>
                v_insFormat := sFormat;
            when others =>
                v_insFormat := nullFormat;
        end case;

        case v_insFormat is
            when rFormat => po_controlWord <= (
                ALU_OP       => pi_instruction(30) & pi_instruction(14 downto 12),
                I_IMM_SEL    => '0',
                PC_SEL       => '0',
                A_SEL        => '0',
                WB_SEL       => "00",
                IS_BRANCH    => '0',
                CMP_RESULT   => '0',
                MEM_CTR => (others => '0'),
                MEM_READ     => '0',
                MEM_WRITE    => '0',
                REG_WRITE    => '1',
                IS_JUMP      => '0'
                );

            when iFormat =>
                case pi_instruction (6 downto 0) is
                    when I_OP_INS =>
                        po_controlWord <= (
                            ALU_OP     => '0' & pi_instruction(14 downto 12),
                            I_IMM_SEL  => '1',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '0',
                            CMP_RESULT => '0',
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when JALR_OP_INS =>
                        po_controlword <= (
                            ALU_OP => (others => '0'),
                            I_IMM_SEL  => '1',
                            PC_SEL     => '1',
                            A_SEL      => '0',
                            WB_SEL     => "10",
                            IS_BRANCH  => '0',
                            CMP_RESULT => '0',
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when L_OP_INS =>
                        case pi_instruction(14 downto 12) is
                            when LB_OP =>
                                po_controlWord <= (
                                    ALU_OP => (others => '0'),
                                    I_IMM_SEL  => '1',
                                    PC_SEL     => '0',
                                    A_SEL      => '0',
                                    WB_SEL     => "11",
                                    IS_BRANCH  => '0',
                                    CMP_RESULT => '0',
                                    MEM_CTR    => "000",
                                    MEM_READ   => '1',
                                    MEM_WRITE  => '0',
                                    REG_WRITE  => '1',
                                    IS_JUMP    => '0'
                                    );

                            when LH_OP =>
                                po_controlWord <= (
                                    ALU_OP => (others => '0'),
                                    I_IMM_SEL  => '1',
                                    PC_SEL     => '0',
                                    A_SEL      => '0',
                                    WB_SEL     => "11",
                                    IS_BRANCH  => '0',
                                    CMP_RESULT => '0',
                                    MEM_CTR    => "001",
                                    MEM_READ   => '1',
                                    MEM_WRITE  => '0',
                                    REG_WRITE  => '1',
                                    IS_JUMP    => '0'
                                    );

                            when LW_OP =>
                                po_controlWord <= (
                                    ALU_OP => (others => '0'),
                                    I_IMM_SEL  => '1',
                                    PC_SEL     => '0',
                                    A_SEL      => '0',
                                    WB_SEL     => "11",
                                    IS_BRANCH  => '0',
                                    CMP_RESULT => '0',
                                    MEM_CTR    => "010",
                                    MEM_READ   => '1',
                                    MEM_WRITE  => '0',
                                    REG_WRITE  => '1',
                                    IS_JUMP    => '0'
                                    );
                            when LBU_OP =>
                                po_controlWord <= (
                                    ALU_OP => (others => '0'),
                                    I_IMM_SEL  => '1',
                                    PC_SEL     => '0',
                                    A_SEL      => '0',
                                    WB_SEL     => "11",
                                    IS_BRANCH  => '0',
                                    CMP_RESULT => '0',
                                    MEM_CTR    => "100",
                                    MEM_READ   => '1',
                                    MEM_WRITE  => '0',
                                    REG_WRITE  => '1',
                                    IS_JUMP    => '0'
                                    );
                            when LHU_OP =>
                                po_controlWord <= (
                                    ALU_OP => (others => '0'),
                                    I_IMM_SEL  => '1',
                                    PC_SEL     => '0',
                                    A_SEL      => '0',
                                    WB_SEL     => "11",
                                    IS_BRANCH  => '0',
                                    CMP_RESULT => '0',
                                    MEM_CTR    => "101",
                                    MEM_READ   => '1',
                                    MEM_WRITE  => '0',
                                    REG_WRITE  => '1',
                                    IS_JUMP    => '0'
                                    );

                            when others =>
                                po_controlWord <= control_word_init;
                        end case;
                    when others =>
                        po_controlWord <= control_word_init;
                end case;

            when uFormat =>
                case pi_instruction(6 downto 0) is
                    when AUIPC_OP_INS =>
                        po_controlword <= (
                            ALU_OP     => ADD_OP_ALU,
                            I_IMM_SEL  => '1',
                            PC_SEL     => '0',
                            A_SEL      => '1',
                            WB_SEL     => "00",
                            IS_BRANCH  => '0',
                            CMP_RESULT => '0',
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when JAL_OP_INS =>
                        po_controlword <= (
                            ALU_OP => (others => '0'),
                            I_IMM_SEL  => '1',
                            PC_SEL     => '1',
                            A_SEL      => '1',
                            WB_SEL     => "10",
                            IS_BRANCH  => '0',
                            CMP_RESULT => '0',
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when LUI_OP_INS =>
                        po_controlword <= (
                            ALU_OP => (others => '0'),
                            I_IMM_SEL  => '1',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "01",
                            IS_BRANCH  => '0',
                            CMP_RESULT => '0',
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );
                    when others => po_controlWord <= control_word_init;
                end case;

            when bFormat =>
                case pi_instruction(14 downto 12) is
                    when FUNC3_BEQ =>
                        po_controlWord <= (
                            ALU_OP     => pi_instruction(30) & pi_instruction(14 downto 12),
                            I_IMM_SEL  => '0',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '1',
                            CMP_RESULT => pi_instruction(12),
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );
                    when FUNC3_BNE =>
                        po_controlWord <= (
                            ALU_OP     => pi_instruction(30) & pi_instruction(14 downto 12),
                            I_IMM_SEL  => '0',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '1',
                            CMP_RESULT => pi_instruction(12),
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when FUNC3_BLT =>
                        po_controlWord <= (
                            ALU_OP     => pi_instruction(30) & pi_instruction(14 downto 12),
                            I_IMM_SEL  => '0',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '1',
                            CMP_RESULT => pi_instruction(12),
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when FUNC3_BGE =>
                        po_controlWord <= (
                            ALU_OP     => pi_instruction(30) & pi_instruction(14 downto 12),
                            I_IMM_SEL  => '0',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '1',
                            CMP_RESULT => pi_instruction(12),
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when FUNC3_BLTU =>
                        po_controlWord <= (
                            ALU_OP     => pi_instruction(30) & pi_instruction(14 downto 12),
                            I_IMM_SEL  => '0',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '1',
                            CMP_RESULT => pi_instruction(12),
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when FUNC3_BGEU =>
                        po_controlWord <= (
                            ALU_OP     => pi_instruction(30) & pi_instruction(14 downto 12),
                            I_IMM_SEL  => '0',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '1',
                            CMP_RESULT => pi_instruction(12),
                            MEM_CTR => (others => '0'),
                            MEM_READ   => '0',
                            MEM_WRITE  => '0',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );
                    when others => po_controlWord <= control_word_init;

                end case;
            when sFormat =>
                case pi_instruction(14 downto 12) is

                    when SB_OP =>
                        po_controlWord <= (
                            ALU_OP => (others => '0'),
                            I_IMM_SEL  => '1',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '0',
                            CMP_RESULT => '0',
                            MEM_CTR    => "000",
                            MEM_READ   => '0',
                            MEM_WRITE  => '1',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when SH_OP =>
                        po_controlWord <= (
                            ALU_OP => (others => '0'),
                            I_IMM_SEL  => '1',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '0',
                            CMP_RESULT => '0',
                            MEM_CTR    => "001",
                            MEM_READ   => '0',
                            MEM_WRITE  => '1',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when SW_OP =>
                        po_controlWord <= (
                            ALU_OP => (others => '0'),
                            I_IMM_SEL  => '1',
                            PC_SEL     => '0',
                            A_SEL      => '0',
                            WB_SEL     => "00",
                            IS_BRANCH  => '0',
                            CMP_RESULT => '0',
                            MEM_CTR    => "010",
                            MEM_READ   => '0',
                            MEM_WRITE  => '1',
                            REG_WRITE  => '1',
                            IS_JUMP    => '0'
                            );

                    when others =>
                        po_controlWord <= control_word_init;
                end case;
            when others => po_controlWord <= control_word_init;
        end case;
    end process;
end architecture;
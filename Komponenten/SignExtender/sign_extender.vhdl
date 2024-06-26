

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;

entity sign_extender is
    -- begin solution:
    generic
    (
        word_width : integer := WORD_WIDTH
    );
    port
    (
        pi_instr      : in std_logic_vector(word_width - 1 downto 0);
        po_iImmediate : out std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_uImmediate : out std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_bImmediate : out std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_jImmediate : out std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_sImmediate : out std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_out        : out std_logic_vector(word_width - 1 downto 0) := (others => '0')

    );
    -- end solution!!
end entity sign_extender;

architecture arc of sign_extender is
    -- begin solution:
    signal s_instr : std_logic_vector(word_width - 1 downto 0) := (others => '0');
begin
    s_instr <= pi_instr;
    process (s_instr) is
    begin
        case s_instr(6 downto 0) is
            when JALR_OP_INS | L_OP_INS | I_OP_INS => --I-Type
                po_iImmediate(11 downto 0) <= s_instr(31 downto 20);
                if s_instr(31) = '0' then
                    po_iImmediate(31 downto 12) <= (others => '0');
                else
                    po_iImmediate(31 downto 12) <= (others => '1');
                end if;
            when LUI_OP_INS | AUIPC_OP_INS => -- U-Type
                po_uImmediate <= s_instr(31 downto 12) & std_logic_vector(to_unsigned(0, 12));
            when B_OP_INS => --B-Type
                po_bImmediate(12 downto 1) <= s_instr(31) & s_instr(7) & s_instr(30 downto 25) & s_instr(11 downto 8);
                if s_instr(31) = '0' then
                    po_bImmediate(31 downto 13) <= (others => '0');
                else
                    po_bImmediate(31 downto 13) <= (others => '1');
                end if;
            when JAL_OP_INS => --J-Type
                po_jImmediate(20 downto 1) <= s_instr(31) & s_instr(19 downto 12) & s_instr(20) & s_instr(30 downto 21);
                if s_instr(31) = '0' then
                    po_jImmediate(31 downto 21) <= (others => '0');
                else
                    po_jImmediate(31 downto 21) <= (others => '1');
                end if;
            when S_OP_INS => --S-Type
                po_sImmediate(11 downto 5) <= s_instr(31 downto 25);
                po_sImmediate(4 downto 0)  <= s_instr(11 downto 7);
            when others =>

        end case;
    end process;
    -- end solution!!
end architecture arc;
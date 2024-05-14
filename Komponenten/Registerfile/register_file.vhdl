-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Nicolas Schmidt 
-- 2. Participant First and Last Name: Jakob Krug

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.constant_package.ALL;
USE work.types_package.ALL;

ENTITY register_file IS
    GENERIC (
        word_width : INTEGER := WORD_WIDTH;
        adr_width  : INTEGER := REG_ADR_WIDTH;
        reg_amount : INTEGER := 2 ** REG_ADR_WIDTH
    );
    PORT (
        pi_clk          : IN STD_LOGIC                                    := '0';
        pi_rst          : IN STD_LOGIC                                    := '0';
        pi_readRegAddr1 : IN STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
        pi_readRegAddr2 : IN STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
        pi_writeRegAddr : IN STD_LOGIC_VECTOR(REG_ADR_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
        pi_writeRegData : IN STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0)    := (OTHERS => '0');
        pi_writeEnable  : IN STD_LOGIC                                    := '0';
        po_readRegData1 : OUT STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0)   := (OTHERS => '0');
        po_readRegData2 : OUT STD_LOGIC_VECTOR(WORD_WIDTH - 1 DOWNTO 0)   := (OTHERS => '0');
        po_registerOut  : OUT registermemory                              := (OTHERS => (OTHERS => '0'))
    );
END ENTITY register_file;

ARCHITECTURE arc OF register_file IS
    SIGNAL s_regs  : registermemory                            := (OTHERS => (OTHERS => '0'));
    SIGNAL s_init  : BOOLEAN                                   := false;
    CONSTANT REG_0 : STD_LOGIC_VECTOR(word_width - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (pi_clk, pi_rst, pi_writeEnable)
    BEGIN
        IF NOT s_init THEN
            -- s_regs(1) <= std_logic_vector(to_unsigned(9, WORD_WIDTH));
            -- s_regs(2) <= std_logic_vector(to_unsigned(8, WORD_WIDTH));
            s_init <= true;
        END IF;
        IF rising_edge(pi_clk) THEN
            po_readRegData1 <= s_regs(to_integer(unsigned(pi_readRegAddr1)));
            po_readRegData2 <= s_regs(to_integer(unsigned(pi_readRegAddr2)));
            IF pi_writeEnable = '1' THEN
                s_regs(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
            END IF;
            s_regs(0) <= REG_0;
        END IF;
        IF (pi_rst = '1') THEN
            FOR i IN 1 TO reg_amount - 1 LOOP
                s_regs(i) <= s_regs(0);
            END LOOP;
        END IF;
        po_registerOut <= s_regs;
    END PROCESS;
END ARCHITECTURE arc;
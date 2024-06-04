library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use work.CONSTANT_Package.all;

entity my_shifter is
    generic (
        dataWidth : INTEGER := DATA_WIDTH_GEN
    );
    port (
        pi_op1, pi_op2 : in STD_LOGIC_VECTOR(dataWidth - 1 downto 0);
        pi_shiftType, pi_shiftDir : in STD_LOGIC;
        po_res : out STD_LOGIC_VECTOR(dataWidth - 1 downto 0)
    );
end entity;

architecture behavior of my_shifter is
    signal s_shamtInt : INTEGER range 0 to (2 ** (INTEGER(log2(real(dataWidth)))));
    signal s_tmp_val : STD_LOGIC := '0';
begin
    s_shamtInt <= to_integer(unsigned(pi_op2(INTEGER(log2(real(dataWidth))) - 1 downto 0)));
    process (pi_op1, s_shamtInt, pi_shiftType, pi_shiftDir) begin
        -- Set all bits to desired default
        if pi_shiftType = '0' then
            -- Logical shift: all 0
            po_res <= (others => '0');
        else
            -- Arithmetical shift: all to highest input bit
            po_res <= (others => pi_op1(dataWidth - 1));
        end if;
        if pi_shiftDir = '0' then
            po_res(dataWidth - 1 downto s_shamtInt) <= pi_op1(dataWidth - 1 - s_shamtInt downto 0);
        else
            po_res(dataWidth - 1 - s_shamtInt downto 0) <= pi_op1(dataWidth - 1 downto s_shamtInt);
        end if;
    end process;
end architecture behavior;
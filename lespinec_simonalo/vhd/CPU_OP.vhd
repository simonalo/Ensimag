library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_OP is
    port (
        cmd         : in  PO_op_cmd;
        rs1         : in w32;
        rs2         : in w32;
        res         : out w32
    );
end entity;

architecture RTL of CPU_OP is
    signal rs1_signe, rs2_signe : signed(31 downto 0);
    signal resulat : signed(63 downto 0);
begin
    rs1_signe <= rs1(31) & signed(rs1_signe) when cmd.ALU2_signe1 = Signed1 else '0' & rs1_signe;
    rs2_signe <= rs2(31) & signed(rs2_signe) when cmd.ALU2_signe2 = Signed2 else '0' & rs2_signe;

    if cmd.ALU2_op_type = ALU_mul then
        resultat <= rs1_signe * rs2_signe
    end if;

    if cmd.ALU2_res_select = Poids_forts then
        res <= resultat(63 downto 32);
    else
        res <= resultat(31 dowtno 0);
    end if;
end architecture;

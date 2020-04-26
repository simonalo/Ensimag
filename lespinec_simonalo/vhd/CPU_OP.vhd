library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_OP is
    generic (
        mutant           : integer := 0
    );
    port (
        signe1      : in ALU2_signe1;
        signe2      : in ALU2_signe2;
        op_code     : in ALU2_op_type;
        type_result : in ALU2_result_type;
        rs1         : in w32;
        rs2         : in w32;
        res         : out w32
        );
end entity;

architecture RTL of CPU_OP is
    signal rs1_signe, rs2_signe : signed(31 downto 0);
    signal resulat : signed(63 downto 0);
    constant zeros : signed(32 downto 0) := (others => '0');
begin
    rs1_signe <= rs1(31) & signed(rs1_signe) when signe1 = Signed1 else '0' & rs1_signe;
    rs2_signe <= rs2(31) & signed(rs2_signe) when signe2 = Signed2 else '0' & rs2_signe;

    if ALU2_op_type = ALU_mul then
        resultat <= rs1_signe * rs2_signe;
    end if;

    if type_result = Poids_forts then
        res <= resultat(63 downto 32);
    else
        res <= zeros;
    end if;
end architecture;

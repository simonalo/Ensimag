library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.PKG.all;

entity CPU_CND is
    generic (
        mutant      : integer := 0
    );
    port (
        rs1         : in w32;
        alu_y       : in w32;
        IR          : in w32;
        slt         : out std_logic;
        jcond       : out std_logic
    );
end entity;

architecture RTL of CPU_CND is
signal and1, and2, and3, and4, a, b, c, z, s : std_logic;
signal result : signed(32 downto 0);
signal alu_y_signe, rs1_signe : signed(31 downto 0);
signal alu_y_33, rs1_33 : signed(32 downto 0);
signal z_bool, s_bool : boolean;
constant zeros : unsigned(32 downto 0) := (others => '0');
begin
    -- On vérifie si il y a extension de signe
    and1 <= (not IR(12)) and (not IR(6));
    and2 <= (not IR(13)) and IR(6);
    a <= and1 or and2;

    -- On calcule la différence des deux vecteurs sur 33 bits

    -- result <= (rs1(31) & rs1) - (alu_y(31) & alu_y) when (a = '1') else ('0' & rs1) - ('0' & alu_y);
    alu_y_signe <= signed(alu_y);
    rs1_signe <= signed(rs1);
    alu_y_33 <= alu_y_signe(31) & alu_y_signe when (a = '1') else '0' & alu_y_signe;
    rs1_33 <= rs1_signe(31) & rs1_signe when (a = '1') else '0' & rs1_signe;
    result <= rs1_33 - alu_y_33;


    -- On fait le calcule x - y et on atttribut les bonnes valeurs à z et s
   -- z <= '1' when (result = zeros) else '0';

   -- s <= '1' when (result(32) = '1') else '0';

    z_bool <= (result = 0);
    s_bool <= (result(32) = '1');

    z <= '1' when z_bool else '0';
    s <= '1' when s_bool else '0';

    -- On calcule les autres signaux tmeporaires pour avoir la sortie
    b <= IR(12) xor z;
    c <= IR(12) xor s;
    and3 <= b and (not IR(14));
    and4 <= c and IR(14);

    slt <= s;
    jcond <= and3 or and4;
end architecture;

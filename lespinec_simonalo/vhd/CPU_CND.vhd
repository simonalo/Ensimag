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
signal result: std_logic_vector(32 downto 0);
constant zeros : std_logic_vector(32 downto 0) := (others => '0');
begin 
    -- On vérifie si il y a extension de signe
    and1 <= (not IR(12)) and (not IR(6));
    and2 <= (not IR(13)) and IR(6);
    a <= and1 or and2;

    -- On calcule la différence des deux vecteurs sur 33 bits

    -- On calcule les autres signaux tmeporaires pour avoir la sortie
    b <= IR(12) xor z;
    c <= IR(12) xor s;
    and3 <= c and (not IR(14));
    and4 <= c and IR(14);

    slt <= s;
    jcond <= and3 or and4;
end architecture;

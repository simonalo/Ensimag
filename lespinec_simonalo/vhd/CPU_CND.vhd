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
rs1_33, alu_y_33, result: std_logic_vector(32 dowtno 0);
constant zeros : std_logic_vector(32 downto 0) := (others => '0');
begin 
    -- On vérifie si il y a extension de signe
    and1 <= (not IR(12)) and (not IR(6));
    and2 <= (not IR(13)) and IR(6);
    a <= and1 or and2;

    -- On réalise l'extension de signe ou non pour avoir deux vecteurs sur 33 bits
    rs1_33(31 downto 0) := rs1(31 downto 0);
    alu_y_33(31 downto 0) := alu_y(31 downto 0);

    if a='1' then
        rs1_33(32) <= rs1(31);
        alu_y_33(32) <= alu_y(31);
    else
        rs1_33(32) <= '0';
        alu_y_33(32) <= '0';
    end if;

    -- On fait le calcule x - y et on atttribut les bonnes valeurs à z et s
    result <= rs1_33 - alu_y_33;
    if result = zeros then
        z <= '1';
    else 
        z <= '0';
    end if;

    if result(32) = 1 then
        s <= 1;
    else
        s <= 0;
    end if;

    -- On calcule les autres signaux tmeporaires pour avoir la sortie
    b <= IR(12) xor z;
    c <= IR(12) xor s;
    and3 <= c and (not IR(14));
    and4 <= c and IR(14);

    slt <= s;
    jcond <= and3 or and4;
end architecture;

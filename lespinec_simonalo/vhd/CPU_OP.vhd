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
begin
    res <= zeros;
end architecture;

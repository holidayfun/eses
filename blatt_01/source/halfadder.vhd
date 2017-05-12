LIBRARY IEEE ;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
ENTITY halfadder IS
PORT ( A, B : IN BIT ;
S , C : OUT BIT ) ;
END halfadder;
ARCHITECTURE behave OF halfadder IS
BEGIN
S <= A XOR B ;
C <= A AND B ;
END;

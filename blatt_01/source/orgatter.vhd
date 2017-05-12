LIBRARY IEEE ;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
ENTITY orgatter IS
PORT ( A, B : IN BIT ;
Z : OUT BIT ) ;
END orgatter;
ARCHITECTURE behave OF orgatter IS
BEGIN
Z <= A OR B ;
END;

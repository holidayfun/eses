LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;

ENTITY fulladder IS
PORT ( A, B, C_in : IN BIT ;
S , C : OUT BIT ) ;
END fulladder;
ARCHITECTURE struct OF fulladder IS
SIGNAL i1, i2, i3 : bit;
component halfadder is
port(A,B: in bit;
S,C: out bit);
end component;
component ORGATTER
port (A, B: in bit;
Z: out bit);
end component;

BEGIN
U1:HALFADDER port map(A, B, i1, i2);
U2:HALFADDER port map(i1, C_in, S, i3);
U3:ORGATTER port map(i2, i3, C);
END;
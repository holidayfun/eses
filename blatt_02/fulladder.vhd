ENTITY fulladder IS
PORT (  A, B, C_in : IN BIT ;
        S , C : OUT BIT ) ;
END fulladder;

ARCHITECTURE behave OF fulladder IS
BEGIN
        S <= A xor B xor C_in after 1ns;
        C <= (A and B) or (C_in and A) or (C_in and B) after 1ns;
END behave;

ENTITY ripplecarry IS
        GENERIC (N: positive := 8);
        PORT(   A,B: IN BIT_VECTOR(N-1 DOWNTO 0);
                C_in: IN BIT;
                S: OUT BIT_VECTOR(N-1 DOWNTO 0);
                C_out: OUT BIT);
END ripplecarry;


ARCHITECTURE behave OF ripplecarry IS
COMPONENT fulladder
        PORT(   A,B, C_in: IN BIT;
                S, C: OUT BIT);
END COMPONENT;
SIGNAL sig: BIT_VECTOR(N DOWNTO 0);

BEGIN
        sig(0) <= C_in;

        FA: FOR i IN 0 TO N-1 GENERATE
                F1: fulladder PORT MAP(A(i), B(i), sig(i), S(i), sig(i+1));
        END GENERATE;
        C_out <= sig(N);
END;

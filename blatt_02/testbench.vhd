ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS
        COMPONENT ripplecarry
                GENERIC(N: positive := 16);
                PORT(   A,B: IN BIT_VECTOR(N-1 DOWNTO 0);
                        C_in: IN BIT;
                        S: OUT BIT_VECTOR(N-1 DOWNTO 0);
                        C_out: OUT BIT);
        END COMPONENT;
        signal x,y, sum: BIT_VECTOR(15 DOWNTO 0);
        signal c_out: BIT;
        signal c_in : bit;
BEGIN
        UUT: entity work.ripplecarry GENERIC MAP (N => 16) PORT MAP(x,y,c_in, sum, c_out);
        tb: process
                begin
                        x <= "0000000000000001";
                        y <= "0000000000000001";
                        c_in <= '0';
                        wait for 25ns;
                        x <= "0000000000000010";
                        y <= "0000000000000010";
                        c_in <= '0';
                        wait for 25ns;
                        x <= "0000000000000000";
                        y <= "0000000000000100";
                        c_in <= '0';
                        wait for 25ns;
                        x <= "0000000000000000";
                        y <= "0000000000000000";
                        c_in <= '0';
                        wait for 25ns;
                        x <= "1111111111111111";
                        y <= "0000000000000000";
                        c_in <= '1';
                        wait for 25ns;
                        x <= "1111111111111111";
                        y <= "0000000000000001";
                        c_in <= '0';
                        wait for 25ns;
                        wait;
                end process tb;
END;

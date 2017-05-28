LIBRARY IEEE ;
USE IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end testbench;

architecture behave of testbench is
component alu
        port(   clk: in bit;
                reset: in bit;
                opID: in bit_vector(1 downto 0);
                op1_ready: in bit;
                op2_ready: in bit;
                opID_ready: in bit;
                res_ready: out bit;
                data: inout std_logic_vector(31 downto 0));
end component;

signal reset, op1_ready, op2_ready, opID_ready, res_ready: bit;
signal opID: bit_Vector(1 downto 0);
signal data: std_logic_vector(31 downto 0);
signal result: signed(31 downto 0);
signal tmp: signed(31 downto 0);
signal clk: BIT := '0';

begin
DUS: entity work.alu PORT MAP (clk => clk, reset => reset, opID => opID, op1_ready => op1_ready, op2_ready => op2_ready, opID_ready => opID_ready, res_ready => res_ready, data => data);

clk <= NOT clk AFTER 10 ns;

stimulate: process
        begin

--
--Die Clock waits kann man bestimmt vereinfachen, aber nach 6 Stunden Fehlersuche
--habe ich da jetzt leider keinen Nerv mehr dafür, funktioniert auf jeden Fall einwandfrei
--

                --test for 8 + 4 = 12
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                reset <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(8, data'length));

                wait until clk='1';
                wait until clk='0';
                op1_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(4, data'length));

                wait until clk='1';
                wait until clk='0';
                op2_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                opID <= "00";
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                opID_ready <= '1';
                reset <= '0';

                wait until res_ready='1';
                wait until clk='1';
                result <= signed(data);
                wait until clk='1';
                wait until clk='0';
                assert (result=to_signed(12, data'length)) report "Test1.1 Failed!";

                --reset internal signals
                op1_ready <='0';
                op2_ready <='0';
                opID_ready <='0';

                wait until clk='1';
                wait until clk='0';

                --test for 10 + 10 = 20
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                reset <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(10, data'length));

                wait until clk='1';
                wait until clk='0';
                op1_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(10, data'length));

                wait until clk='1';
                wait until clk='0';
                op2_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                opID <= "00";
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                opID_ready <= '1';
                reset <= '0';

                wait until res_ready='1';
                wait until clk='1';
                result <= signed(data);
                wait until clk='1';
                wait until clk='0';
                assert (result=to_signed(20, data'length)) report "Test1.2 Failed!";

                --reset internal signals
                op1_ready <='0';
                op2_ready <='0';
                opID_ready <='0';

                wait until clk='1';
                wait until clk='0';

                --test for 8 - 4 = 4
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                reset <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(8, data'length));

                wait until clk='1';
                wait until clk='0';
                op1_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(4, data'length));

                wait until clk='1';
                wait until clk='0';
                op2_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                opID <= "01";
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                opID_ready <= '1';
                reset <= '0';

                wait until res_ready='1';
                wait until clk='1';
                result <= signed(data);
                wait until clk='1';
                wait until clk='0';
                assert (result=to_signed(4, data'length)) report "Test2.1 Failed!";

                --reset internal signals
                op1_ready <='0';
                op2_ready <='0';
                opID_ready <='0';

                wait until clk='1';
                wait until clk='0';


                --test for 8 - 8 = 0
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                reset <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(8, data'length));

                wait until clk='1';
                wait until clk='0';
                op1_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(8, data'length));

                wait until clk='1';
                wait until clk='0';
                op2_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                opID <= "01";
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                opID_ready <= '1';
                reset <= '0';

                wait until res_ready='1';
                wait until clk='1';
                result <= signed(data);
                wait until clk='1';
                wait until clk='0';
                assert (result=to_signed(0, data'length)) report "Test2.2 Failed!";

                --reset internal signals
                op1_ready <='0';
                op2_ready <='0';
                opID_ready <='0';

                wait until clk='1';
                wait until clk='0';

                --test for 8 * 4 = 32
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                reset <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(8, data'length));

                wait until clk='1';
                wait until clk='0';
                op1_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(4, data'length));

                wait until clk='1';
                wait until clk='0';
                op2_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                opID <= "11";
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                opID_ready <= '1';
                reset <= '0';

                wait until res_ready='1';
                wait until clk='1';
                result <= signed(data);
                wait until clk='1';
                wait until clk='0';
                assert (result=to_signed(32, data'length)) report "Test3.1 Failed!";

                --reset internal signals
                op1_ready <='0';
                op2_ready <='0';
                opID_ready <='0';

                wait until clk='1';
                wait until clk='0';


                --test for 8 * 0 = 0
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                reset <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(8, data'length));

                wait until clk='1';
                wait until clk='0';
                op1_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                data <= std_logic_vector(to_signed(0, data'length));

                wait until clk='1';
                wait until clk='0';
                op2_ready <= '1';

                wait until clk='1';
                wait until clk='0';
                opID <= "11";
                data <= (others => 'Z');
                wait until clk='1';
                wait until clk='0';
                opID_ready <= '1';
                reset <= '0';

                wait until res_ready='1';
                wait until clk='1';
                result <= signed(data);
                wait until clk='1';
                wait until clk='0';
                assert (result=to_signed(0, data'length)) report "Test3.2 Failed!";

                --reset internal signals
                op1_ready <='0';
                op2_ready <='0';
                opID_ready <='0';

                wait until clk='1';
                wait until clk='0';


                wait; --testbench beenden

        end process stimulate;
end behave;

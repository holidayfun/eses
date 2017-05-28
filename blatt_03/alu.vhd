LIBRARY IEEE ;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;

entity alu is
        port(   clk: in bit;
                reset: in bit;
                opID: in bit_vector(1 downto 0);
                op1_ready: in bit;
                op2_ready: in bit;
                opID_ready: in bit;
                res_ready: out bit;
                data: inout std_logic_vector(31 downto 0)
                );
end alu;

architecture behave of alu is

signal op1, op2: signed(31 downto 0);
signal local_opID: bit_vector(1 downto 0);
signal result: signed(31 downto 0);
signal tmp: signed(63 downto 0);
signal tmp_std_logic_vector: std_logic_vector(31 downto 0);

begin
cntrl: process
        begin
        data <= (others => 'Z');
        wait until clk='1' and reset='1'; --warten auf reset
        res_ready <= '0';

        wait until clk='1' and op1_ready='1'; --warten auf operand 1
        --read operand 1
        op1 <= signed(data);
        wait until clk='0';
        wait until clk='1' and op2_ready='1'; --warten auf operand 2
        --read operand 2
        op2 <= signed(data);
        wait until clk='0';
        wait until clk='1' and opID_ready='1'; --auf opID ready warten
        --read opID
        local_opID <= opID;

        wait until clk='0';
        wait until clk='1';
        case local_opID is
                when "00" =>
                        --addition
                        result <= op1 + op2;
                when "11" =>
                        --multiplikation
                        tmp <= op1 * op2;
                        --braucht ein wait, sonst kommt undefined raus
                        wait until clk='0';
                        wait until clk='1';
                        result <= tmp(31 downto 0);
                when others =>
                        --subtraktion
                        result <= op1 - op2;
        end case;

        wait until clk='0';
        wait until clk='1';

        data <= std_logic_vector(result);
        wait until clk='0';
        wait until clk='1';
        res_ready <= '1';
        wait until clk='0';
        wait until clk='1';

        end process cntrl;
end behave;

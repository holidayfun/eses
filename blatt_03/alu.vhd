entity alu is
        port(   clk: in bit;
                reset: in bit;
                opID; in bit_vector(1 downto 0);
                op1_ready: in bit;
                op2_ready: in bit;
                opID_ready: in bit;
                res_ready: out bit;
                data: inout std_logic_vector(31 downto 0)
                );
end alu;

architecture behave of alu is

signal op1, op2: signed(31 downto 0);;
signal local_opID: bit_vector(1 downto 0);
signal result: signed(31 downto 0);
signal tmp: signed(63 downto 0);

begin
cntrl: process
        begin
        wait until clk'edge and clk='1' and reset='1'; --warten auf reset
        res_ready <= 0;
        data <= (others => 'Z');

        wait until clk'edge and clk='1' and op1_ready='1'; --warten auf operand 1
        --read operand 1

        op1 <= data;

        wait until clk'edge and clk='1' and op2_ready='1'; --warten auf operand 2
        --read operand 2

        op2 <= data;

        wait until clk'edge and clk='1' and opID_ready='1'; --auf opID ready warten
        --read opID
        local_opID <= opID;
        case local_opID is
                when '00' =>
                        --addition
                        result <= op1 + op2;
                when '11' =>
                        --multiplikation
                        tmp <= op1 * op2;
                        result <= tmp(31 downto 0);
                when others =>
                        --subtraktion
                        result <= op1 - op2;
        end case;
        data <= result;
        res_ready <= '1';
        end process cntrl;
end behave;

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

signal clk, reset, op1_ready, op2_ready, res_ready: bit;
signal opID: bit_Vector(1 downto 0);
signal data: std_logic_vector(31 downto 0);
signal result: signed(31 downto 0);


begin
DUS: entity alu PORT MAP (clk, reset, opID, op1_ready, op2_ready, opID_ready, res_ready,                        data);

--clock setzen
stimulate: process
        begin
                reset <= 1;
                wait for 5ns;
                --...
                --konvertieren mit std_logic_vector(...) bzw signed(...)
                data <= 5; --konertieren
                wait for 5ns;
                op1_ready <= '1';

                wait for 5ns;

                data <= 4; -- konvertieren

                wait for 5ns;

                op2_ready <= '1';

                wait for 5ns;
                opID <= '00';

                opID_ready <= '1';

                wait for 5ns;

                wait until res_ready='1';

                --assert correct result

        end process stimulate;
end behave;

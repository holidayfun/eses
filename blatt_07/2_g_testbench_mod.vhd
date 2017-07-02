LIBRARY IEEE;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.std_logic_1164.ALL;

entity testbench is
end testbench;

architecture behave of testbench is
component alu is
	PORT(CLK, RESET : IN STD_LOGIC;
		IN0,IN1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		OP: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		RESULT: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
end component;

signal CLK: std_logic := '0';
signal RESET: std_logic;
signal IN0,IN1: std_logic_vector(31 downto 0);
signal OP: std_logic_vector(2 downto 0);
signal RESULT: std_logic_vector(31 downto 0);


begin

CLK <= not CLK after 2500 ps;
DUS: entity work.ALU_ENTITY port map (CLK, RESET, IN0, IN1, OP, RESULT);

stimulate: process
	begin
	wait until clk'event and clk='1';
	RESET <= '1';
	wait until clk'event and clk='1';
	RESET <= '0';
	
	IN0 <= x"1234f001";
	IN1 <= x"93ca123f";
	OP <= "000";

	wait until clk'event and clk='1';
	IN0 <= x"12345678";
	IN1 <= x"45891000";
	OP <= "100";

	wait until clk'event and clk='1';
	
	IN0 <= x"89ad1755";
	IN1 <= x"88899912";
	OP <= "011";

	wait until clk'event and clk='1';
	
	IN0 <= x"11123456";
	IN1 <= x"10000000";
	OP <= "010";

	
	wait until clk'event and clk='1';

	IN0 <= x"01234567";
	IN1 <= x"00001001";
	OP <= "001";

	wait until clk'event and clk='1';
	RESET <= '1';
	IN0 <= x"00000000";
	IN1 <= x"00000000";
	OP <= "000";

	wait until clk'event and clk='1';
	RESET <= '0';
	wait;	
	


end process stimulate;
end behave;

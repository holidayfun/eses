entity testbench is
end testbench;

architecture behave of testbench is
component ampel is
	port(clk, reset, ns_detektor, wo_detektor: in bit;
        	ns_ampel, wo_ampel: out bit_vector(2 downto 0));
end component;

signal clk, reset, ns_detektor, wo_detektor: bit := '0';
signal ns_ampel, wo_ampel: bit_vector(2 downto 0);

begin

DUS: entity work.ampel port map (clk, reset, ns_detektor, wo_detektor, ns_ampel, wo_ampel);

clk <= NOT clk after 2500 ms;

stimulate : process
	begin
	wait until clk'event and clk='1';
	reset <= '1';
	wait until clk'event and clk='1';
	reset <= '0';
	wait until clk'event and clk='1' and ns_ampel = "100";
	
	-- extremfall: so viele autos, dass die Detektoren immer Autos anzeigen
	-- die Ampel halten also exakt 30 bzw 20 Sekunden lang grün bevor sie wechseln

	wo_detektor <= '1';
	ns_detektor <= '1';	

	wait;
end process stimulate;
end behave;

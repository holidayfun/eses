entity ampel is
	port(clk, reset, ns_detektor, wo_detektor: in bit;
		ns_ampel, wo_ampel: out bit_vector(2 downto 0));
end ampel;



architecture behave of ampel is


--ns_g -> nord-sued ist gruen
--ns_r -> nord-sued ist rot
--ns_ry -> nord-sued ist rot-gelb
--ns_y -> nord-sued ist gelb
--entsprechende Benennung fuer wo
type T_STATE is (s_off, s_ns_r_wo_r, s_ns_g_wo_r, s_ns_y_wo_ry, s_ns_r_wo_g, s_ns_ry_wo_y);
signal NEXT_STATE : T_STATE;
signal STATE: T_STATE := s_off;

begin 

fsm:	process(STATE, clk)
	begin
	
	if clk'event and clk='1' then
		if reset = '1' then
			NEXT_STATE <= s_ns_r_wo_r;
			ns_ampel <= "001";
			wo_ampel <= "001";
		else

case STATE is
	when s_off =>
	when s_ns_r_wo_r =>
		NEXT_STATE <= s_ns_g_wo_r;
		ns_ampel <= "100";
		wo_ampel <= "001";	
	when s_ns_g_wo_r =>
		if wo_detektor = '1' then
			NEXT_STATE <= s_ns_y_wo_ry;
			ns_ampel <= "010";
			wo_ampel <= "011";
		end if;
	when s_ns_y_wo_ry =>
		NEXT_STATE <= s_ns_r_wo_g;
		ns_ampel <= "001";
		wo_ampel <= "100";
	when s_ns_r_wo_g =>
		if ns_detektor = '1' then
			NEXT_STATE <= s_ns_ry_wo_y;
			ns_ampel <= "011";
			wo_ampel <= "010";
		end if;
	when s_ns_ry_wo_y =>
		NEXT_STATE <= s_ns_g_wo_r;
		ns_ampel <= "100";
		wo_ampel <= "001";
end case;
		end if;
	end if;		
end process fsm;

REG: 	process(clk)
	begin
	--state an fallender taktflanke aendern, damit ein Zustandswechsel keine 2 Takte braucht
	if clk'event and clk='0' then
		STATE <= NEXT_STATE;
	end if;
end process REG;
		

end behave;

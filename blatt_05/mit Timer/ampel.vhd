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
signal timeout_start, timeout_ack, timeout: bit;
signal timeout_type: bit_vector (1 downto 0);
signal counter : integer := 0;

begin 

fsm:	process(STATE, clk)
	begin
	
	if clk'event and clk='1' then
		if reset = '1' then
			--reset führt in den Zustand, in dem beide Ampeln rot sind
			NEXT_STATE <= s_ns_r_wo_r;
			ns_ampel <= "001";
			wo_ampel <= "001";
		else
			case STATE is
				when s_off =>
				when s_ns_r_wo_r =>
					--ohne trigger direkt ns Ampel im nächsten State auf grün
					--starte Timer, um Ampel mind. 30 Sekunden grün zu halten
					NEXT_STATE <= s_ns_g_wo_r;
					timeout_type <= "11";
					timeout_start <= '1';
					ns_ampel <= "100";
					wo_ampel <= "001";	
				when s_ns_g_wo_r =>
					timeout_start <= '0'; --reset des startsignals
					--blockade, falls timeout noch nicht kam
					if wo_detektor = '1' and timeout='1' then
						NEXT_STATE <= s_ns_y_wo_ry;
						ns_ampel <= "010";
						wo_ampel <= "011";
					end if;
				when s_ns_y_wo_ry =>
					--starte Timer, um Ampel mind. 20 Sekunden grün zu halten
					NEXT_STATE <= s_ns_r_wo_g;
					timeout_type <= "10";
					timeout_start <= '1';
					ns_ampel <= "001";
					wo_ampel <= "100";
				when s_ns_r_wo_g =>
					timeout_start <= '0'; --reset des startsignals
					--blockade, falls timeout noch nicht kam
					if ns_detektor = '1' and timeout='1' then
						NEXT_STATE <= s_ns_ry_wo_y;
						ns_ampel <= "011";
						wo_ampel <= "010";
					end if;
				when s_ns_ry_wo_y =>
					--starte Timer, um Ampel mind. 30 Sekunden grün zu halten
					NEXT_STATE <= s_ns_g_wo_r;
					timeout_type <= "11";
					timeout_start <= '1';
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
		if timeout_start = '1' then
			--blockieren, falls timeout angefordert aber noch nicht acknowledged wurde
			if timeout_ack='1' then
				STATE <= NEXT_STATE;
			end if;
		else
			STATE <= NEXT_STATE;
		end if;
	end if;
end process REG;

timer: 	process(clk)
	begin
	if clk'event and clk='1' then
		timeout <= '0';
		if timeout_start='1' then
			--sende ack zurück
			timeout_ack <= '1';			
			if timeout_type="10" then --20 Sekunden
				counter <= 1;
			elsif timeout_type="11" then --30 Sekunden
				counter <= 3;
			end if;
		else		
			if counter = 1 then
				timeout <= '1';
				timeout_ack <= '0';
			elsif counter > 1 then
				counter <= counter - 1;
			end if;
		end if;
	end if;
end process timer;
end behave;

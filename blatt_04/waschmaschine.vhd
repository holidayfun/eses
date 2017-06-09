entity waschmaschine is
	port(clk, reset, start, abbruch, tuere_zu, wasser_ok, temp_ok,
	     waschen_ok, spuelen_ok, pumpen_taste, pumpen_ok, schleuder_taste,
	     schleudern_ok: IN BIT;
	     
             wasser_auf, heizen, waschen, spuelen, pumpen, schleudern: OUT BIT);
end waschmaschine;

architecture behave of waschmaschine is
type T_STATE is (s_ruhezustand, s_wasser_einlassen, s_heizen, s_waschen, s_spuelen, s_pumpen, s_schleudern,
		 s_abbruch, s_wasser_abpumpen);
signal NEXT_STATE : T_STATE;
signal STATE : T_STATE := s_ruhezustand;

begin

fsm: 	process(STATE, clk)
	begin
	if clk'event and clk='1' then
		if reset = '1' then --reset Taste wurde gedrückt, alles zurücksetzen und in Ruhezustand wechseln
                        wasser_auf <= '0';
	                heizen <= '0';
                        waschen <= '0';
                        spuelen <= '0';
                        pumpen <= '0';
                        schleudern <= '0';
                        NEXT_STATE <= s_ruhezustand;                        
		else	
			case STATE is
				when s_ruhezustand =>
					if (start = '1' and tuere_zu = '1') then
						wasser_auf <= '1';
						NEXT_STATE <= s_wasser_einlassen;
					end if;
				when s_wasser_einlassen =>
					if (abbruch = '1') then --falls abbruch gedrückt  wechsle in Abbruchzustand
						NEXT_STATE <= s_abbruch;
					else
						if (wasser_ok = '1') then
							wasser_auf <= '0';
							heizen <= '1';
							NEXT_STATE <= s_heizen;
						end if;
					end if;
				when s_heizen =>
					if (abbruch = '1') then --falls abbruch gedrückt  wechsle in Abbruchzustand
                                                NEXT_STATE <= s_abbruch;
                                        else
						if (temp_ok = '1') then
							heizen <= '0';
							waschen <= '1';
							NEXT_STATE <= s_waschen;
						end if;
					end if;
				when s_waschen =>
					if (abbruch = '1') then --falls abbruch gedrückt  wechsle in Abbruchzustand
                                                NEXT_STATE <= s_abbruch;
                                        else
						if (waschen_ok = '1') then
                        				waschen <= '0';
							spuelen <= '1';
							NEXT_STATE <= s_spuelen;
						end if;		
                			end if;
				when s_spuelen =>
					if (abbruch = '1') then --falls abbruch gedrückt  wechsle in Abbruchzustand
                                                NEXT_STATE <= s_abbruch;
                                        else
                                                if (spuelen_ok = '1') then
							if (pumpen_taste = '1') then
								pumpen <= '1';
								spuelen <= '0';
								NEXT_STATE <= s_pumpen;
							else
								spuelen <= '0';
								NEXT_STATE <= s_ruhezustand; --fertig
							end if;
						end if;
					end if;
                		when s_pumpen =>
					if (abbruch = '1') then --falls abbruch gedrückt  wechsle in Abbruchzustand
                                                NEXT_STATE <= s_abbruch;
                                        else   
						if (pumpen_ok = '1') then
							if (schleuder_taste = '1') then
								pumpen <= '0';
								schleudern <= '1';
								NEXT_STATE <= s_schleudern;
							else
								pumpen <= '0';
	        		        	        	NEXT_STATE <= s_ruhezustand; --fertig
							end if;
						end if;
					end if;
		                when s_schleudern =>
					if (abbruch = '1') then --falls abbruch gedrückt  wechsle in Abbruchzustand
                                                NEXT_STATE <= s_abbruch;
                                        else 
						if (schleudern_ok = '1') then
							schleudern <= '0';			
		                        		NEXT_STATE <= s_ruhezustand;
						end if;
					end if;
		                when s_abbruch =>
					--setze signale zurück und beginne Abpumpen
 					wasser_auf <= '0';
                                        heizen <= '0';
                                        waschen <= '0';
                                        spuelen <= '0';
                                        schleudern <= '0';

					if (pumpen_ok = '1') then --kein Wasser in der Maschine
						NEXT_STATE <= s_ruhezustand;
					else
						pumpen <= '1';
			                      	NEXT_STATE <= s_wasser_abpumpen;
					end if;
				when s_wasser_abpumpen =>
					if (pumpen_ok = '1') then --pumpen bis kein Wasser mehr in der Maschine ist
                        			pumpen <= '0';
						NEXT_STATE <= s_abbruch;
					end if;
			end case;
		end if;
	end if;
	end process fsm;

REG: 	process(clk)
	begin
		if clk'event and clk = '1' then
			STATE <= NEXT_STATE;
		end if;
	end process REG;

end behave;



entity testbench is
end testbench;

architecture behave of testbench is
component waschmaschine
	port(clk, reset, start, abbruch, tuere_zu, wasser_ok, temp_ok,
             waschen_ok, spuelen_ok, pumpen_taste, pumpen_ok, schleuder_taste,
             schleudern_ok: IN BIT;

             wasser_auf, heizen, waschen, spuelen, pumpen, schleudern: OUT BIT);
end component;

signal clk, reset, start, abbruch, tuere_zu, wasser_ok, temp_ok,
       waschen_ok, spuelen_ok, pumpen_taste, pumpen_ok, schleuder_taste,
       schleudern_ok : BIT := '0';

signal wasser_auf, heizen, waschen, spuelen, pumpen, schleudern : BIT := '0';

begin

DUS: entity work.waschmaschine PORT MAP(clk, reset, start, abbruch, tuere_zu, wasser_ok, temp_ok, 
				waschen_ok, spuelen_ok, pumpen_taste, pumpen_ok, schleuder_taste,
             			schleudern_ok,
             			wasser_auf, heizen, waschen, spuelen, pumpen, schleudern);

clk <= NOT clk AFTER 1 ns;

stimulate: 	process
		begin		
                	wait until clk'event and clk='1'; --starte Stimulation bei steigender Flanke
			tuere_zu <= '1'; --mache die Tuere zu
			pumpen_taste <= '0'; --betätige die Pumpentaste nicht
			schleuder_taste <= '0'; --betätige die Schleuderntaste nicht
			wait until clk'event and clk='1'; --warte bis zur nächsten Taktflanke
			start <= '1'; --starte den Waschgang
			wait until wasser_auf = '1'; --warte bis die Maschine beginnt sich mit Wasser zu fuellen
			wait until clk'event and clk='1'; --und dann bis zur nächsten Flanke
			wasser_ok <= '1'; --singalisiere, dass die Waschmaschine mit Wasser gefuellt ist (simuliert Sendsor)
			start <= '0'; --lasse den Startknopf wieder los	
			wait until heizen = '1'; --warte bis die Maschine beginnt zu heizen
			wait until clk'event and clk = '1'; --und dann bis zur nächsten Flanke
			wasser_ok <= '0'; --zurücksetzen des Sensorwertes
			temp_ok <= '1'; --signalisiere, dass das Wasser warm genug ist
			wait until waschen = '1'; --warte bis die Maschine beginnt zu waschen
			wait until clk'event and clk = '1'; --und dann bis zur nächsten Flanke
			temp_ok <= '0'; --zurücksetzen des Sensorwertes
			waschen_ok <= '1'; --signalisiere, dass das Waschen abgeschlossen ist
			wait until spuelen = '1'; --warte bis die Maschine beginnt zu spuelen
                        wait until clk'event and clk = '1'; --und dann bis zur nächsten Flanke
			waschen_ok <= '0'; --zurücksetzen des Sensorwertes
			spuelen_ok <= '1'; --singalisiere, dass das Spuelen abgeschlpssen ist 

			wait until spuelen = '0'; --warte bis die Maschine fertig ist mit spuelen 
                        wait until clk'event and clk = '1'; --und dann bis zur nächsten Flanke
			spuelen_ok <= '0'; --zurücksetzen des Sensorwertes
			tuere_zu <= '0'; --öffne die Türe
		
			wait for 10 ns; --warte bis zum nächsten Start	

			wait until clk'event and clk='1'; --starte Stimulation bei steigender Flanke
                        tuere_zu <= '1'; --mache die Tuere zu
                        pumpen_taste <= '0'; --betätige die Pumpentaste nicht
                        schleuder_taste <= '0'; --betätige die Schleuderntaste nicht
                        wait until clk'event and clk='1'; --warte bis zur nächsten Taktflanke
                        start <= '1'; --starte den Waschgang
                        wait until wasser_auf = '1'; --warte bis die Maschine beginnt sich mit Wasser zu fuellen
                        wait until clk'event and clk='1'; --und dann bis zur nächsten Flanke
                        wasser_ok <= '1'; --singalisiere, dass die Waschmaschine mit Wasser gefuellt ist (simuliert Sendsor)
                        start <= '0'; --lasse den Startknopf wieder los
                        wait until heizen = '1'; --warte bis die Maschine beginnt zu heizen
                        wait until clk'event and clk = '1'; --und dann bis zur nächsten Flanke
                        wasser_ok <= '0'; --zurücksetzen des Sensorwertes
			
			reset <= '1'; --gebe das Reset Signal
			
			wait for 6 ns; --warte kurz
			reset <= '0'; --setze das Reset Signal zurück
			tuere_zu <= '0'; --öffne die Türe
			
			
			wait for 10 ns; --warte bis zum nächsten Start

			wait until clk'event and clk='1'; --starte Stimulation bei steigender Flanke
                        tuere_zu <= '1'; --mache die Tuere zu
                        pumpen_taste <= '0'; --betätige die Pumpentaste nicht
                        schleuder_taste <= '0'; --betätige die Schleuderntaste nicht
                        wait until clk'event and clk='1'; --warte bis zur nächsten Taktflanke
                        start <= '1'; --starte den Waschgang
                        wait until wasser_auf = '1'; --warte bis die Maschine beginnt sich mit Wasser zu fuellen
                        wait until clk'event and clk='1'; --und dann bis zur nächsten Flanke
                        wasser_ok <= '1'; --singalisiere, dass die Waschmaschine mit Wasser gefuellt ist (simuliert Sendsor)
                        start <= '0'; --lasse den Startknopf wieder los
                        wait until heizen = '1'; --warte bis die Maschine beginnt zu heizen
                        wait until clk'event and clk = '1'; --und dann bis zur nächsten Flanke
                        wasser_ok <= '0'; --zurücksetzen des Sensorwertes
                        
			abbruch <= '1'; --breche den Waschgang ab
			wait until pumpen = '1'; --warten auf Abpumpen
			wait for 2 ns; --etwas Zeit zum Abpumpen
			pumpen_ok <= '1'; --singalisiere, dass fertig gepumpt ist
			wait for 4 ns; --noch kurz warten, anschließend die Signale zurücksetzen
			pumpen_ok <= '0';
			abbruch <= '0';
			tuere_zu <= '0';
			wait; --beende die Stimulation
		end process stimulate;
end behave;


PROCESS(A,B,C,D, E , F ,COND_1,COND_2) BEGIN	
	IF COND_1 = �1 � THEN
		S := 3; #Shift um 3 entsprich 8 * A
		X := E;
		Y := F;
	ELSE
		S := 1;	#Shift um 1 entsprich 2 * A = A + A
		X := D;
		Y := A;
	END IF ;
	# X und Y enthalten Operanden f�r die Multiplikation
	# S enth�lt die Shiftweite f�r den Shift von A
	
	Z1 <= A << S; 
	#Zwischenergebnis M ben�tigen wir im Folgenden in beiden Bl�cken
	M := X * Y;
	
	if COND_1 = '1' THEN
		Z2 <= M;
	ELSE		
		IF (COND_2 = � 1 � ) THEN
			#hier lohnt sich kein Shifter, da wir im 2. Fall sowieso einen Addierer brauchen
			P := A;
			Q := A;
		ELSE
			P := B;
			Q := C;
		END IF ;
		
		TEMP_1 := P + Q
		Z2 <= M + TEMP_1
	END IF;
END PROCESS;
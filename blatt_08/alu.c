// Entwurf und Synthese von Eingebetteten Systemen
// Übungsblatt 10
// 
// C-Implementierung einer ALU
//
// Dustin Peterson
// 10. Juni 2014
//

#include "alu.h"

short alu(char opcode, short in1, short in2) {
	short out = 0;
	switch (opcode) {
		case 0:
			out = in1 * in2;
			break;
		case 1:
			out = in1 - in2;
			break;
		case 2:
			out = in1 + in2;
			break;
		case 3:
			if(in2 != 0)
				out = in1 / in2;
			break;
		default:
			break;
	}
	return out;
}

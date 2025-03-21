; ECH_VAR.INC - declaration of variables used in the AK subroutines

D_Ctr1:	DS	1	; could be more than 1 byte, e.g., for int or float
D_Ctr2:	DS 1	; 1 byte (one GPR) is reserved here and below
D_Ctr3:	DS	1
R_Old:	DS	1
S_Tmp:		DS	1	; scratch pad registers
S_Tmp1:	DS	1
; the above variables could be named like Tmp1 Tmp2 etc, and used in
; the rest of the program if necessary to save RAM (not in the ISR though)

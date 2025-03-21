; list names of your variables one in a row below
; each of them will be allocated a GPR
; and can be referenced by name in your code
; (the assembler will place actual address automatically)
; examples:
;Ctr1	RES	1	; your vaiable, e.g., for counter 1
;Ctr2	RES	1
Temp:	DS	1	; this is used by the examples
mode:   DS	1
previousMode:   DS	1
previousModeSame:   DS	1
configMode:   DS	1
callFunctionMode:   DS	1
pwmCounter:   DS	1
pwmIterationCount:   DS	1
minimumDutyCycle:   DS	1
maximumDutyCycle:   DS	1
pwmCountDown:   DS	1
side2sideCounter:   DS	1
side2sideIterationCount:   DS	1
side2sideResetToOne:   DS	1
side2sideLEDValues:   DS	1
side2sideCountDown:   DS	1
lfsrValue:   DS	1
lfsrCounter:   DS	1
lfsrIterationCount:   DS	1


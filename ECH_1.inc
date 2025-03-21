
; ECH_1.inc - to be put before your SUBROUTINES		


; DEFINITIONS related to the PIC and board used
; DO NOT EDIT ! ! !


; this #include enables use of register and bit names from the datasheet
; consists of 
; SymbolicName EQU NumericalValue   ; equates symbolic names to appropriate bit patterns


; ! the name of the file should match the PIC microcontroller part name

; setting the CONFIG1 configuration bits - required, explained at the end of the lecture course
PROCESSOR   16F887
PAGEWIDTH   132
RADIX       DEC

// CONFIG1
; ============================================
config FOSC = INTRC_NOCLKOUT// Oscillator Selection bits (INTOSCIO oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
config PWRTE = ON       // Power-up Timer Enable bit (PWRT enabled)
config MCLRE = ON       // RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
config CP = OFF         // Code Protection bit (Program memory code protection is disabled)
config CPD = OFF        // Data Code Protection bit (Data memory code protection is disabled)
config BOREN = OFF      // Brown Out Reset Selection bits (BOR disabled)
config IESO = OFF       // Internal External Switchover bit (Internal/External Switchover mode is disabled)
config FCMEN = OFF      // Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
config LVP = OFF        // Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

// CONFIG2
config BOR4V = BOR21V   // Brown-out Reset Selection bit (Brown-out Reset set to 2.1V)
config WRT = OFF        // Flash Program Memory Self Write Enable bits (Write protection off)

// #pragma config statements should precede project file includes.
// Use project enums instead of #define for ON and OFF.
; ============================================
		

		
#include <xc.inc>	
#include "pic16f887.inc"
#include <xc.h>

#include		"ECH_EQU.INC"
		; for EQU statements related to the 44 pin demo board wiring of PORTD and RB0


; ALLOCATION of user RAM, starts where SFRs end at 0x20
PSECT udata_bank0						
		#include 	"VAR.INC"		
		; YOUR VARIABLES from this file
		#include		"ECH_VAR.INC"
		; variables required for subroutines

PSECT udata_shr		

W_TMP:
    DS		1
ST_TMP:
    DS		1


; CODE sections at different addresses

PSECT V_Reset,class=CODE
	MOVLW   HIGH(Main)
	MOVWF   PCLATH
	goto	Main
		; entry on interrupt - address 0x4 fixed by PIC architecture
PSECT V_Interrupt,class=CODE		
	goto	ISR

PSECT code    ; conventional placement of subroutines - before the INITIALISATION


; subroutines prepared for the coursework
#include	"ECH_SUB.INC"


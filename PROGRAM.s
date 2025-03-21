; *** SOME INFORMATION AND INITIALISATION HERE ***   ;{

; operating BUILD CONFIGURATIONS drop down menu in the DEBUG toolbar
; FOR SIMULATIONS with MPLAB SIM: select "Debug" this will switch off delays that take thousands of instructions
; HARDWARE: select "Release" all delays will be on

; Provided code - do not edit  
; This include setups up various configuration bits for the microcontroller
; we are using, and importantly reserves space for variables.
; If you need to use more variables, please place them in VAR.INC, which you
; can find under the "Header Files" folder. The variables listed there will be
; placed in the first memory bank.
; This code has been provided for you to simplify your work, but you should be
; aware that you cannot ignore it.

	
#include	"ECH_1.inc"

; Place your SUBROUTINE(S) (if any) here ...  
;{ 
    
    

ISR:
	btfss	INTF
	goto	I_L2
	call	configModeSet
	bcf	INTF
I_L2:	btfss	T0IF
	goto	I_L3
	call	readADC
	call	modeSet
	bcf	T0IF
I_L3:	retfie
    
;Calls config function for respective mode
configModeSet:
	btfsc	mode,0
	call	configurePWM
	btfsc	mode,1
	call	configureSide2Side
	btfsc	mode,2
	call	configureLFSR
	
	return

;Sets function mode bit high of respective mode so it can be called from main
modeSet:
	;Checks if previous mode same as current one and sets bit 0 high if so
	movf	previousMode,W
	subwf   mode,W
	btfsc   STATUS,2
	bsf	previousModeSame,0

	;Checks if current mode pwm
	btfss	mode,0
	goto	checkSide2Side
	
	;If previous mode different immediately sets function bit high
	btfsc	previousModeSame,0
	goto	$+3
	bsf	callFunctionMode,0
	goto	exitModeSet
	
	;Otherwise loops until appropriate delay
	movf	pwmIterationCount,W
	subwf   pwmCounter,W
	btfsc   STATUS,2
	bsf	callFunctionMode,0
	incf	pwmIterationCount
	goto	exitModeSet
	
checkSide2Side:
	;Checks if current mode side2side
	btfss	mode,1
	goto	checkLFSR
	
	;If previous mode different immediately sets function bit high
	btfsc	previousModeSame,0
	goto	$+3
	bsf	callFunctionMode,1
	goto	exitModeSet
	
	;Otherwise loops until appropriate delay
	movf	side2sideIterationCount,W
	subwf   side2sideCounter,W
	btfsc   STATUS,2
	bsf	callFunctionMode,1
	incf	side2sideIterationCount
	goto	exitModeSet
	
checkLFSR:
	;Checks if current mode lfsr
	btfss	mode,2
	goto	exitModeSet
	
	;If previous mode different immediately sets function bit high
	btfsc	previousModeSame,0
	goto	$+3
	bsf	callFunctionMode,2
	goto	exitModeSet
	
	;Otherwise loops until appropriate delay
	movf	lfsrIterationCount,W
	subwf   lfsrCounter,W
	btfsc   STATUS,2
	bsf	callFunctionMode,2
	incf	lfsrIterationCount
	goto	exitModeSet

;Clears previousModeSame bit 0 and returns
exitModeSet:
	bcf	previousModeSame,0
	movf	mode,W
	movwf	previousMode
	return

;Reads adc value
readADC:
	bsf	ADCON0, 1
	btfsc   ADCON0, 1
	goto    $-1
	
	;Check if under 1/3 range for PWM
	banksel ADRESH
	movlw   01001101B
	subwf   ADRESH,W
	btfsc   STATUS,0
	goto	adc2
	movlw	00000001B
	movwf	mode
	
	;Set pwm duty cycle
	banksel	PR2
	movlw	99
	movwf	PR2

	;PWM type
	banksel CCP1CON
	movlw   01001100B
	movwf   CCP1CON
    
	;Enable timer 2
	banksel T2CON
	bsf	TMR2ON
	
	goto	exit
	
;Check if under 2/3 range for side2sideLED
adc2:	
	banksel ADRESH
	movlw   10101010B
	subwf   ADRESH,W
	btfsc   STATUS,0
	goto	setLFSR
	movlw	00000010B
	movwf	mode
	
	;Disable timer 2
	banksel T2CON
	bcf	TMR2ON

	;Clear CCP1CON
	banksel CCP1CON
	clrf	CCP1CON
	
	goto	exit
	
;Else lfsr
setLFSR:
	movlw	00000100B
	movwf	mode
	
	;Disable timer 2
	banksel T2CON
	bcf	TMR2ON
	
	;Clear CCP1CON
	banksel CCP1CON
	clrf	CCP1CON
	
exit:	return
  
;Sets pwm values from potentiometer
configurePWM:
	;Disable timer 2
	banksel T2CON
	bcf	TMR2ON

	;Clear CCP1CON
	banksel CCP1CON
	clrf	CCP1CON
    
	;Turn on LD6
	movlw	01000000B
	movwf	LEDs
	
	banksel	0
    
	;Speed of variable PWM
	call	Select4
	movwf	Temp
	
	;delay for choice 0
	btfsc	Temp,0
	movlw	1
	
	;delay for choice 1
	btfsc	Temp,1
	movlw	2
	
	;delay for choice 2
	btfsc	Temp,2
	movlw	3
	
	;delay for choice 3
	btfsc	Temp,3
	movlw	4
	
	movwf	pwmCounter
	
	;Minimum duty cycle
	call	Select4
	movwf	Temp
	
	;0% duty cycle for choice 0
	btfsc	Temp,0
	movlw	0
	
	;15% duty cycle for choice 1
	btfsc	Temp,1
	movlw	15
	
	;30% duty cycle for choice 2
	btfsc	Temp,2
	movlw	30
	
	;45% duty cycle for choice 3
	btfsc	Temp,3
	movlw	45
	
	movwf	minimumDutyCycle
	movwf   CCPR1L
	
	;Maximum duty cycle
	call	Select4
	movwf	Temp
	
	;55% duty cycle for choice 0
	btfsc	Temp,0
	movlw	55
	
	;70% duty cycle for choice 1
	btfsc	Temp,1
	movlw	70
	
	;85% duty cycle for choice 2
	btfsc	Temp,2
	movlw	85
	
	;100% duty cycle for choice 3
	btfsc	Temp,3
	movlw	100
	
	movwf	maximumDutyCycle
	
	movlw	00000000B
	movwf	configMode
    
	return

;Sets side2side values from potentiometer
configureSide2Side:
	;Turn on LD7
	movlw	10000000B
	movwf	LEDs
	
	;LED speed
	call	Select4
	movwf	Temp
	
	;delay for choice 0
	btfsc	Temp,0
	movlw	10
	
	;delay for choice 1
	btfsc	Temp,1
	movlw	20
	
	;delay for choice 2
	btfsc	Temp,2
	movlw	30
	
	;delay for choice 3
	btfsc	Temp,3
	movlw	40
	
	movwf	side2sideCounter
	
	;LED direction
	call	Select4
	movwf	Temp
	
	;One direction for choice 0
	btfsc	Temp,0
	movlw	1
	
	;One direction for choice 1
	btfsc	Temp,1
	movlw	1
	
	;Back and forth for choice 2
	btfsc	Temp,2
	movlw	0
	
	;Back and forth for choice 3
	btfsc	Temp,3
	movlw	0
	
	movwf	side2sideResetToOne
	
	movlw	00000000B
	movwf	configMode
    
	return

;Sets lfsr values from potentiometer
configureLFSR:
    
	;Turn on LD6 and LD7
	movlw	11000000B
	movwf	LEDs
    
	;Speed of variable PWM
	call	Select4
	movwf	Temp
	
	;delay for choice 0
	btfsc	Temp,0
	movlw	10
	
	;delay for choice 1
	btfsc	Temp,1
	movlw	20
	
	;delay for choice 2
	btfsc	Temp,2
	movlw	30
	
	;delay for choice 3
	btfsc	Temp,3
	movlw	40
	
	movwf	lfsrCounter
    
	movlw	00000000B
	movwf	configMode
	
	return

;PWM fucntion
PWM:
	;Clear other LEDs
	bcf	LEDs,0
	bcf	LEDs,1
	bcf	LEDs,2
	bcf	LEDs,3
	bcf	LEDs,4
	bcf	LEDs,5
	bcf	LEDs,6
	
	;Check if current duty cycle equal to max
	movf	maximumDutyCycle,W
	subwf   CCPR1L,W
	btfsc   STATUS,2
	
	;If so, pwm counts down
	bsf	pwmCountDown,0
	btfsc	pwmCountDown,0
	goto	countDownPWM
    
	;Otherwise, increase duty cycle
	incf    CCPR1L,F
	goto	exitPWM
	
countDownPWM:
	;Check if current duty cycle equal to min
	movf	minimumDutyCycle,W
	subwf   CCPR1L,W
	btfsc   STATUS,2
	bcf	pwmCountDown,0
    
	;Decrease duty cycle
	decf    CCPR1L,F
	
exitPWM:
	bcf	callFunctionMode,0
	movlw	1
	movwf	pwmIterationCount
	return
 
;side2side function
side2sideLED:
	banksel	0
    
	;Display current value
	movf    side2sideLEDValues,W
	movwf   LEDs
	
	;If countDown bit high then counts down
	btfsc	side2sideCountDown,0
	goto	countDownSide2Side
    
	;Check if LD7 on
	movlw   10000000B
	subwf   side2sideLEDValues,W
	btfsc   STATUS,2
	goto	$+3
    
	;Skips reset if LD7 not on and moves LED
	rlf	side2sideLEDValues,F
	goto    exitSide2Side
    
	;If side2sideResetToOne == 1, resets LEDs to LD1; otherwise moves back down
	btfss   side2sideResetToOne,0
	goto    $+5
	movlw   00000001B
	movf    LEDs
	rlf	side2sideLEDValues,F
	goto    exitSide2Side
	
	bsf	side2sideCountDown,0
	
countDownSide2Side:
	;Make sure no carry bit set
	bcf	STATUS,0
	
	;Move LED down
	rrf	side2sideLEDValues,F
	
	;Check if LD0 on
	movlw   00000001B
	subwf   side2sideLEDValues,W
	btfsc   STATUS,2
	bcf	side2sideCountDown,0
    
exitSide2Side:
	bcf	callFunctionMode,1
	movlw	1
	movwf	side2sideIterationCount
	return

;lfsr function
lfsr:	
	banksel	0
    
	;Display current value
	movf	lfsrValue,W
	
	movwf	PORTD
	
	;Check if output bit 1
	btfss	lfsrValue,0
	goto	$+19
	
	;Flip tap x^4
	btfss	lfsrValue,4
	goto	$+3
	bcf	lfsrValue,4
	goto	$+2
	bsf	lfsrValue,4
	
	;Flip tap x^5
	btfss	lfsrValue,5
	goto	$+3
	bcf	lfsrValue,5
	goto	$+2
	bsf	lfsrValue,5
	
	;Flip tap x^6
	btfss	lfsrValue,6
	goto	$+3
	bcf	lfsrValue,6
	goto	$+2
	bsf	lfsrValue,6
	
	;Shift lfsr
	rrf	lfsrValue,F
	
	;Set input bit
	bsf	lfsrValue,7
	
	;Skips process for output bit 0
	goto	exitLFSR
	
	;Shift lfsr
	rrf	lfsrValue,F
	
	;Clear input bit
	bcf	lfsrValue,7

exitLFSR:
	bcf	callFunctionMode,2
	movlw	1
	movwf	lfsrIterationCount
	return
    
;}
; end of your subroutines
; Provided code - do not edit  
Main:	nop
	
; This include contains code that runs each time your board is turned on, such 
; as configuring the pins, peripherals and flashing the LEDs. Read it to
; understand what is going on.
#include "ECH_INIT.INC"

; Place your INITIALISATION code (if any) here ...   
;{ ***		***************************************************
; e.g.,		movwf	Ctr1 ; etc 
    
	;Enable interrupt for tmr0 and external interrupt
	banksel INTCON
	movlw   10110000B
	movwf   INTCON
    
	;Enable interrupt on falling edge and tmr0 prescaler
	banksel OPTION_REG
	movlw	01000101B
	movwf	OPTION_REG
	
	;Setup PORTA
	banksel	TRISA
	movlw	00000001B
	movwf	TRISA
	
	;Setup PORTB
	banksel	TRISB
	movlw	00000001B
	movwf	TRISB
	
	;Setup PORTC
	banksel TRISC
	movlw   00000000B
	movwf   TRISC
    
	;Setup PORTD
	banksel TRISD
	movlw   00000000B
	movwf   TRISD
	
	;AN0 analog
	banksel ANSEL
	bsf	ANSEL,0
	
	;Left justified ADC
	banksel ADCON1
	movlw   00000000B
	movwf   ADCON1
    
	;Setup ADC and enable
	banksel ADCON0
	movlw   11000001B
	movwf   ADCON0
	
	;Initial PWM duty cycle
	banksel CCPR1L
	movlw   0
	movwf   CCPR1L
	
	banksel	0
	
	;Initial PWM values
	movlw   0
	movwf   minimumDutyCycle
	movlw   100
	movwf   maximumDutyCycle
	movlw	1
	movwf	pwmCounter
    
	;Initial LED values
	movlw   00000001B
	movwf   side2sideLEDValues
	movlw	1
	movwf	side2sideResetToOne
	movlw	30
	movwf	side2sideCounter
	
	;Set lfsr intial values
	movlw	10000000B
	movwf	lfsrValue
	movlw	30
	movwf	lfsrCounter
	
	;Initial iteration values
	movlw	1
	movwf	pwmIterationCount
	movwf	side2sideIterationCount
	movwf	lfsrIterationCount
    
;} 
; end of your initialisation

MLoop:	nop

; place your superloop code here ...  
;{

	btfsc	callFunctionMode,0
	call	PWM
    
	btfsc	callFunctionMode,1
	call	side2sideLED
	
	btfsc	callFunctionMode,2
	call	lfsr
 
;}	
; end of your superloop code

	goto	MLoop

	end

# Embedded_Assembly_Coursework

Coursework program for embedded computing module, completed in assembly. Code located in PROGRAM.S, .inc files are libraries.
 
 
## Coursework Brief

The task is to write a program in assembly that acts as a programmable display using the 8 LEDs. 
The display has three different display modes: 
- Variable PWM 
- Side to side strobing display 
- Linear feedback shift register

When the simulator starts running, one of the above modes should be active and running on the LEDs. The decision about which mode is active is determined by the value of the voltage connected to AN0. You should split the range of the ADC into three ranges to specify which of the modes is currently active, using the ADC connected to AN0 to determine which mode to display. When the voltages on AN0 is changed (using the Stimulus window), the new mode should be made active with only a very short delay, and should continue where that mode last left off. You may need to reconfigure peripherals when moving from one mode to another. It may be worth considering making subroutines to help with this.

By pressing the button with a single press and release (Press button for 100 ms in Stimulus window), your program should enter a configuration mode for the currently active display mode. When your program enters configuration mode, you should use LD7 and LD6 to indicate which display mode is currently being configured and clear the remaining LEDs. Your program should then be ready to receive new configuration values using the ADC and AN0, with the configuration options for the different modes as described below. The configuration option is hence selected using the ADC and AN0, and input using the button (RB0 pulsed low). When the configuration is complete your program should return to display mode after checking which mode should be active – note that because the user has been using the potentiometer this may be a different mode.

### Modes
The required display modes and their configuration options are described below. 

#### Variable PWM

When this mode is active, one LED must be controlled with PWM. You may choose which LED to control as part of your design. The LED should be changing brightness continuously, i.e. changing gradually between two different brightness values. This mode has three configuration options which must be presented to the user in this order: 
1. The speed of the variable PWM (one of four, choose appropriately), i.e. how quickly the display changes between the two brightness values. 
2. The brightness (one of four, please choose appropriately) of the first brightness value 
3. The brightness (one of four) of the second brightness value

#### Side to side strobe

When this mode is active, the display initially consists of a single LED “moving” from side to side from LED 0-7 and back to 0. This mode has two configuration options, which must be presented to the user in this order: 
1. The speed of the motion (one of four, choose appropriately), i.e. the amount of time between one LED turning on and the next LED turning on 
2. Choose between the LED moving back and forth, or just in one direction only, i.e. when the LED gets to LD7 it should next move to LD0 in this mode 

#### Linear feedback shift register 

A LFSR is a means of generating a pseudo random number. When this mode is active, the current value of the 8-bit LFSR you have created will be displayed on the LEDs. If you are not familiar with LFSRs, I suggest you do some searching on how to implement them. The Wikipedia page has good information – you should be producing an 8-bit maximal period Galois LFSR. Note that it is important for the initial value of the LFSR to be chosen with some care – setting it to 0 will not work. 

This mode has one configuration option, which is the speed at which new values are displayed (one of four, choose appropriately).
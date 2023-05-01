/*
 This file is part of the W1209 firmware replacement project
 (https://github.com/mister-grumbler/w1209-firmware).

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 3.

 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 - Modified by RTEK1000
 - Apr/06/2023
 - Arduino sketch converted to Eclipse project
 --> To free up space in program memory (Flash)
 - Mar/27/2023
 - Code adaptation for Arduino IDE sketch.ino
 - Some bug fixes
 - Some functions added
 --> Parameter P0: C1/C2/C3/H1/H2/H3/A1/A2
 - C1: Cooler mode (hysteresis above Threshold)
 - C2: Cooler mode (hysteresis below Threshold)
 - C3: Cooler mode (hysteresis above and below Threshold)
 - H1: Cooler mode (hysteresis below Threshold)
 - H2: Cooler mode (hysteresis above Threshold)
 - H3: Cooler mode (hysteresis above and below Threshold)
 --> Parameter P1: Hysteresis
 --> Parameter P2: Up limit
 (Used in the alert indication; Activated in Parameter P6)
 (Used in Alarm mode Parameter P0: A1 and A2; Activated in Parameter P6)
 --> Parameter P3: Down limit
 (Used in the alert indication; Activated in P6)
 (Used in Alarm mode Parameter P0: A1 and A2; Activated in Parameter P6)
 --> Parameter P4: Temperature sensor offset
 (From -7.0 up to +7.0)
 --> Parameter P5: Delay time before activating the relay
 (From 0 to 10 minutes)
 (Does not affect relay deactivation, deactivation is immediate)
 --> Parameter P6: ON/OFF
 (Alarm mode; Need setup Parameter P2 and P3)
 --> Parameter P7: ON/OFF
 (Threshold value change access blocking)
 (Factory reset lockout with Up "+" and Down "-" keys)
 --> Parameter P8: ON/OFF
 (Automatic brightness reduction after 15 seconds)
 --> Output status indication:
 - Decimal point (DOT) right side off:
 Relay deactivated (contacts open)
 - Decimal point (DOT) right side blinking:
 Relay deactivated (contacts open), but
 Waiting delay time programmed in Parameter P5
 --> Factory reset:
 - Set Parameter P7 in OFF
 - Turn power supply Off
 - Press and hold Up "+" and Down "-" keys
 - Turn power supply On
 - Wait for "rSt" to appear on the display
 - Release all keys
 - Wait for the current temperature to appear
 --> Troubleshoot:
 - Microcontroller resetting:
 Try using a pull up resistor on the reset line
 - Microcontroller no longer responds:
 High voltage return may have occurred through the relay LED
 - The temperature does not correspond to the real:
 Try adjusting the offset Parameter P5
 Try to replace the sensor
 Test using a resistor of NTC equivalent value for 25°C (10k)
 Try modifying the lookup table corresponding to the sensor
 - Display flickering:
 Disconnect STlink programmer from SWIM port (next to display)

 - Note for Arduino IDE and Sduino core:
 Track the size of the code when uploading,
 The maximum I got was 93%
 --> (Sketch uses 7589 bytes (92%))
 --> (Bytes written: 8136)
 --> (Maximum is 8192 bytes)
 - Sduino core:
 --> Select STM8S Board / STM8S103F3 Breadout Board
 --> Programmer ST-link/V2
 --> Connect STlink: GND/SWIM/RST

 References:
 - https://github.com/rtek1000/NTC_Lookup_Table_Generator
 - https://github.com/rtek1000/W1209-firmware-modified
 */

/**
 Button routines.
 */

#include "button.h"
#include "remote.h"
#include "menu.h"

long foo; // compiler bug

void button_init(void) {
	PC_DDR &= ~(BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT); // input
	PC_CR1 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT; // pullup

	PD_DDR &= ~BUTTON4_BIT; // input
	PC_CR1 &= ~BUTTON4_BIT; // no pullup
}

bool buttons_pressed12(void) {
	// return (!get_Button2()) && (!get_Button3());
	return (!get_Button2()) && (!get_Button3());
}

bool buttons_pressed123(void) {
	return (((!get_Button1()) && (!get_Button2()))
			|| ((!get_Button1()) && (!get_Button3())) || buttons_pressed12());
}

void setButton3stateHIGH(void) {
	/* Pull-up with interrupt */
	PC_DDR &= ~BUTTON3_BIT;
}

void setButton3stateLOW(void) {
    /* LOW */
	PC_ODR &= ~BUTTON3_BIT;
	/* Push-pull, fast mode */
	PC_DDR |= BUTTON3_BIT;
}

void enableButton2interrupt(void) {
	PC_CR2 |= BUTTON2_BIT;   // Pull-up with interrupt on pin PC4
}

void disableButton2interrupt(void) {
	PC_CR2 &= ~BUTTON2_BIT;   // Pull-up with Not interrupt on pin PC4
}

bool get_Button1(void) {
	// return ((PC_IDR & BUTTON1_BIT) == BUTTON1_BIT);
	return ((BUTTONS_PORT123 >> 3) & 1);
}

bool get_Button2(void) {
	unsigned char i;
	//disableButton2interrupt();

	for (i = 0; i < 10; i++)
		;

	// bool state = ((PC_IDR & BUTTON2_BIT) == BUTTON2_BIT);
	bool state = ((BUTTONS_PORT123 >> 4) & 1);

	//enableButton2interrupt();
	for (i = 0; i < 10; i++)
		;

	return state;
}

bool get_Button3(void) {
	unsigned char i;

	setButton3stateHIGH();

	for (i = 0; i < 10; i++)
		;

	// return ((PC_IDR & BUTTON3_BIT) == BUTTON3_BIT);
	return ((BUTTONS_PORT123 >> 5) & 1);
}

bool get_Button4(void) {
	return ((BUTTONS_PORT4 >> 6) & 1);
}


void EXTI2_handler() __interrupt (5){
	// disableButton2interrupt();

	restartDebounce();

	receiver_Handle();

	//enableButton2interrupt();
}

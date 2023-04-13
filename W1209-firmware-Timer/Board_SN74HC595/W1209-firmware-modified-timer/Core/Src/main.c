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
 Control functions for main routines.
 - Menu (and Button) tree
 - Display tree
 - Timer tree (using millis() and micros())
 */

// #include "stm8.h"
#include "main.h"
#include "timer.h"
//#include "adc.h"
#include "display.h"
#include "menu.h"
#include "params.h"
#include "relay.h"
#include "button.h"
#include "remote.h"
#include "hc595.h"

// #define SWIM_pin PD1 // In use on display

bool factoryMode = false;

unsigned long millis_5ms;
unsigned long millis_base;
unsigned long millis_100ms;
unsigned long millis_250ms;
unsigned long millis_display1 = 0;

const unsigned char timeoutDisplayDimmRecall = 150; // 100ms x150 = 15s
byte timeoutDisplayDimm = 0;

byte count_refresh = 0;

extern byte menuDisplay;
extern const unsigned char timeoutRecall;

extern byte menuState;

extern byte timeout;

extern bool blink_disp_enabled;

extern byte sender_start;

extern bool remote_enabled;

extern unsigned char store_timeout;

//static unsigned char status;

void main(void) {
	/*
	 Pin PD1 in use for Display
	 CFG->GCR |= 0x01; // disable SWIM interface enabled at wiring-init.c file SDUINO core

	 Free the SWIM pin (STlink port) to be used as a general I/O-Pin
	 https://github.com/tenbaht/sduino/blob/development/sduino/stm8/cores/sduino/wiring-init.c

	 Do not arbitrarily disable this function SWIM in STM8S001 (has no RESET pin)

	 */

	CLK_CKDIVR = 0x00;  // Set the frequency to 16 MHz

	enableInterrupts();

	initTimer();

	initMainControl();

	button_init();

	initDisplay();

	initRelay();

	initSerialReceiver();

	loadParamsEEPROM();

	if (getParamById(PARAM_LOCK_BUTTONS)) {
		menuDisplay = menuState = MENU_EEPROM_LOCKED;

	} else {
		factoryMode = buttons_pressed12(); //(!digitalRead(BTN2_pin)) && (!digitalRead(BTN3_pin));

		if (factoryMode == true) {
			menuDisplay = menuState = MENU_EEPROM_RESET;

			resetParamsEEPROM();

		}
	}

	while((get_Button1() == false) || (get_Button2() == false));

	initParamsEEPROM();

	while (1) {
		// put your main code here, to run repeatedly:
		millis_base = millis();

		if ((millis_base - millis_5ms) >= 5) {
			millis_5ms = millis_base;

			refreshDisplay();

//			ADC_handler();

			mainControl();

			if (menuState == MENU_ROOT) {
				refreshRelay();

				serial_sender();
			}
		} else {
			if ((millis_base - millis_100ms) >= 100) {
				millis_100ms = millis_base;

				if (store_timeout > 0) {
					store_timeout--;

					if (store_timeout == 0) {
						storeParams();
					}
				}

				if (menuState > MENU_ROOT) {
					if (!((timeout--) > 0)) {

						if (menuState == MENU_EEPROM_LOCKED) {
							menuDisplay = menuState = MENU_EEPROM_LOCKED2;

							timeout = timeoutRecall / 3;

						} else {
							enableTimerCount();

							restoreRelayState();

							menuDisplay = menuState = MENU_ROOT;
							remote_enabled = true;
						}

						blink_disp_enabled = false;

					}
				}

				if (getParamById(PARAM_AUTO_BRIGHT)) {
					if (timeoutDisplayDimm == timeoutDisplayDimmRecall) {
						dimmerBrightness(brightnessHigh); // clearer
					}

					if (timeoutDisplayDimm > 0) {
						timeoutDisplayDimm--;
					} else {
						dimmerBrightness(brightnessLow); // darker
					}
				}
			}
			if ((millis_base - millis_250ms) >= 250) {
				millis_250ms = millis_base;

				set_serial_sender();

				sender_start = true; // uncoment this to send data

			}

//			mainDisplay();
		}
	}
}


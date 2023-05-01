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
   - Mar/27/2023
   - Code adaptation for Arduino IDE sketch.ino
   - Some bug fixes
   - Some functions added
   - Note: Track the size of the code when uploading,
     The maximum I got was 93%
     --> (Sketch uses 7589 bytes (92%))
     --> (Bytes written: 8136)
     --> (Maximum is 8192 bytes)

   References:
   - https://github.com/rtek1000/NTC_Lookup_Table_Generator
   - https://github.com/rtek1000/W1209-firmware-modified
*/

#include "menu.h"
#include "button.h"
#include "relay.h"
#include "params.h"

bool BTN1_old = false;
bool BTN2_old = false;
bool BTN3_old = false;

unsigned long BTN1_longPress = 0;
unsigned long BTN2_longPress = 0;
unsigned long BTN3_longPress = 0;

bool isBTN1_longPress = false;
bool isBTN2_longPress = false;
bool isBTN3_longPress = false;

#define buttonLongPressTime 1500
#define buttonFastPulseTime 50

// unsigned long BTN1_fastPulse = 0;
unsigned long BTN2_fastPulse = 0;
unsigned long BTN3_fastPulse = 0;

byte func_refresh = 0;

byte menuState = MENU_ROOT;

const unsigned char timeoutRecall = 20; // 250ms x20 = 5s
byte timeout = 7;

extern const unsigned char timeoutDisplayDimmRecall; // 250ms x20 = 15s
extern byte timeoutDisplayDimm;

extern bool blinkSpeed;

extern byte menuDisplay;
extern bool blink_disp;
extern bool blink_disp_enabled;

void initMainControl(void){
	timeoutDisplayDimm = timeoutDisplayDimmRecall;
}

void mainControl(void) {
	unsigned long millis_control = millis();

	if (buttons_pressed123())
		return;

	if (get_Button1() == false) { //(!digitalRead(BTN1_pin)) {
		if (BTN1_old == false) {
			BTN1_old = true;

			BTN1_longPress = millis_control;

			isBTN1_longPress = false;

			timeout = timeoutRecall;
		} else {
			if ((millis_control - BTN1_longPress) > buttonLongPressTime) {
				if (menuState == MENU_ROOT) {
					menuDisplay = menuState = MENU_SELECT_PARAM;

					BTN1_longPress = millis_control;

					setParamId(PARAM_RELAY_MODE);

					blink_disp_enabled = false;

					timeout = timeoutRecall;

				} else if (menuState == MENU_SELECT_PARAM) {
					BTN1_longPress = millis_control;

					menuDisplay = menuState = MENU_ROOT;

					timeout = timeoutRecall;
				}

				isBTN1_longPress = true;
			}
		}
	} else {
		BTN1_longPress = millis_control;

		if (BTN1_old == true) {
			BTN1_old = false;

			if (isBTN1_longPress == false) {
				if (menuState == MENU_ROOT) {
					if ((getParamById(PARAM_RELAY_MODE) == RELAY_MODE_A1)
							|| (getParamById(PARAM_RELAY_MODE) == RELAY_MODE_A2)) {
						menuState = menuDisplay = MENU_ALARM;
					} else {
						menuState = menuDisplay = MENU_SET_THRESHOLD;
					}

					blink_disp_enabled = true;

					blinkSpeed = false;

					timeout = timeoutRecall;

					setParamId(PARAM_THRESHOLD);

				} else if ((menuState == MENU_SET_THRESHOLD)
						|| (menuState == MENU_ALARM)
						|| (menuState == MENU_ALARM_HIGH)
						|| (menuState == MENU_ALARM_LOW)) {
					menuDisplay = menuState = MENU_ROOT;

					blink_disp_enabled = false;

					storeParams();

				} else {
					if (menuState == MENU_SELECT_PARAM) {
						menuDisplay = menuState = MENU_CHANGE_PARAM;

					} else if (menuState == MENU_CHANGE_PARAM) {
						menuDisplay = menuState = MENU_SELECT_PARAM;

						storeParams();
					}
				}
			}

			isBTN1_longPress = false;
		}
	}

	if (get_Button2() == false) { // (!digitalRead(BTN2_pin)) {
		timeoutDisplayDimm = timeoutDisplayDimmRecall;

		if (BTN2_old == false) {
			BTN2_old = true;

			BTN2_longPress = millis_control;

			timeout = timeoutRecall;

		} else {
			if ((millis_control - BTN2_longPress) > buttonLongPressTime) {
				if ((millis_control - BTN2_fastPulse) > buttonFastPulseTime) {
					BTN2_fastPulse = millis_control;

					if (menuState == MENU_SELECT_PARAM) {
						incParamId();

					} else if (menuState >= MENU_SET_THRESHOLD) {
						if ((getParamById(PARAM_LOCK_BUTTONS))
								&& (menuState == MENU_SET_THRESHOLD)) {
							menuDisplay = MENU_EEPROM_LOCKED2;

						} else {
							incParam();

						}
					}

					timeout = timeoutRecall;

				}

				isBTN2_longPress = true;
			}
		}
	} else {
		BTN2_longPress = millis_control;

		if (BTN2_old == true) {
			BTN2_old = false;

			if (isBTN2_longPress == false) {
				if (menuState == MENU_SELECT_PARAM) {
					incParamId();

				} else if (menuState >= MENU_SET_THRESHOLD) {
					if ((menuState == MENU_ALARM)
							|| (menuState == MENU_ALARM_LOW)) {
						menuDisplay = menuState = MENU_ALARM_HIGH;

					} else if ((getParamById(PARAM_LOCK_BUTTONS))
							&& (menuState == MENU_SET_THRESHOLD)) {
						menuDisplay = MENU_EEPROM_LOCKED2;

					} else {
						incParam();

					}
				}

				timeout = timeoutRecall;
			}

			isBTN2_longPress = false;
		}
	}

	if (get_Button3() == false) { // (!digitalRead(BTN3_pin)) {
		timeoutDisplayDimm = timeoutDisplayDimmRecall;

		if (BTN3_old == false) {
			BTN3_old = true;

			BTN3_longPress = millis_control;

			timeout = timeoutRecall;

		} else {
			if ((millis_control - BTN3_longPress) > buttonLongPressTime) {
				if ((millis_control - BTN3_fastPulse) > buttonFastPulseTime) {
					BTN3_fastPulse = millis_control;

					if (menuState == MENU_SELECT_PARAM) {
						decParamId();

					} else if (menuState >= MENU_SET_THRESHOLD) {
						if ((getParamById(PARAM_LOCK_BUTTONS))
								&& (menuState == MENU_SET_THRESHOLD)) {
							menuDisplay = MENU_EEPROM_LOCKED2;

						} else {
							decParam();

						}

					}

					timeout = timeoutRecall;

				}

				isBTN3_longPress = true;
			}
		}
	} else {
		BTN3_longPress = millis_control;

		if (BTN3_old == true) {
			BTN3_old = false;

			if (isBTN3_longPress == false) {
				if (menuState == MENU_SELECT_PARAM) {
					decParamId();

				} else if (menuState >= MENU_SET_THRESHOLD) {
					if ((menuState == MENU_ALARM)
							|| (menuState == MENU_ALARM_HIGH)) {
						menuDisplay = menuState = MENU_ALARM_LOW;

					} else if ((getParamById(PARAM_LOCK_BUTTONS))
							&& (menuState == MENU_SET_THRESHOLD)) {
						menuDisplay = MENU_EEPROM_LOCKED2;

					} else {
						decParam();

					}

				}

				timeout = timeoutRecall;
			}

			isBTN3_longPress = false;
		}
	}
}

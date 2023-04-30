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

/**
 Control functions for the seven-segment display (SSD).
 */

//#include <Arduino.h>
#include "display.h"
#include "params.h"
#include "menu.h"
#include "relay.h"
#include "adc.h"
#include "hc164.h"

//#include "stm8s003/gpio.h"

/* Definitions for display */
// 1st display
// Port C controls digits: 1, 2, 3
#define SSD_DIGIT_123_PORT   PC_ODR

// PC.5
#define SSD_DIGIT_1_BIT     0x20
// PC.6
#define SSD_DIGIT_2_BIT     0x40
// PC.7
#define SSD_DIGIT_3_BIT     0x80

// 2nd display
// Port B controls digits: 1
#define SSD_DIGIT2_1_PORT   PB_ODR
// Port C controls digits: 2, 3
#define SSD_DIGIT2_23_PORT   PC_ODR

// PB.4
#define SSD_DIGIT2_1_BIT     0x10
// PC.3
#define SSD_DIGIT2_2_BIT     0x08
// PC.4
#define SSD_DIGIT2_3_BIT     0x10

const unsigned char Hex2CharMap[] = { '0', '1', '2', '3', '4', '5', '6', '7',
		'8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

static char activeDigitId;
//static unsigned char displayAC[3];
//static unsigned char displayD[3];
static unsigned char displayData[3];
static unsigned char displayData2[3];

static void setDigit(unsigned char, unsigned char, bool);
static void setDigit2(unsigned char, unsigned char, bool);

static bool displayOff = false;
static bool testMode = false;

static bool controlDotStatus = false;

static bool lowBrightness = false;
#define brightnessPWMtime 2500 // Higher value: clearer
#define brightnessPWMtime2A 1200 // Higher value: clearer
#define brightnessPWMtime2B 500 // Higher value: clearer

unsigned char *stringBuffer1;

bool alternate_display = false;
byte menuDisplay = 0;
bool blink_disp = false;
bool blink_disp_enabled = false;
bool blinkSpeed = false;
unsigned char *stringBuffer;

unsigned long millis_display2 = 0;

int temp = 0;

//extern volatile unsigned int data_received;

void setDisplayDot(unsigned char id, bool val);

void dimmerBrightness(bool _state) {
	lowBrightness = !_state;
}

void controlDot(bool _state) {
	controlDotStatus = _state;
}

/**
 @brief Configure appropriate bits for GPIO ports, initialize static
 variables and set test mode for display.
 */
void initDisplay() {
	HC164_init();

	PC_DDR |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT
			| SSD_DIGIT_3_BIT | SSD_DIGIT2_2_BIT
			| SSD_DIGIT2_3_BIT;

	PC_CR1 |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT
			| SSD_DIGIT_3_BIT | SSD_DIGIT2_2_BIT
			| SSD_DIGIT2_3_BIT;

	PB_DDR |= SSD_DIGIT2_1_BIT;

	PB_CR1 |= SSD_DIGIT2_1_BIT;

	displayOff = false;

	activeDigitId = 0;

	setDisplayTestMode(true); //, "");

	setLED(true);

	for (int i = 0; i < 200; i++) {
		refreshDisplay();

		delay(3);
	}

	setLED(false);

	setDisplayTestMode(false); //, "");
}

void mainDisplay(void) {
	unsigned char sensor_fail = 0;
	unsigned char paramMsg[] = "P0";
	unsigned char alarmMsg[] = "AL1";
//	int _MAX_TEMPERATURE;
//	int _MIN_TEMPERATURE;

	if ((millis() - millis_display2) < (500 >> blinkSpeed)) {
		return;
	} else {
		millis_display2 = millis();
	}

	blink_disp = !blink_disp;

	blinkLED(blink_disp);
//	controlDot(getRelayState(blink_disp));
//	controlDot(true);

	setDisplayOff(!blink_disp & blink_disp_enabled);

	switch (menuDisplay) {
	case MENU_ROOT:
		sensor_fail = getSensorFail();

		if (sensor_fail != sensor_ok) {
			if (sensor_fail == sensor_fail_HHH) {
				setDisplayStr("HHH", true);

			} else {
				setDisplayStr("LLL", true);
			}

			blinkSpeed = blink_disp_enabled = true;

		} else {
			blink_disp_enabled = false;

			temp = getTemperature();
			setDisplayInt(temp, true);

			if(getParamById (PARAM_RELAY_MODE) < RELAY_MODE_A1) {
				paramToString(PARAM_THRESHOLD, stringBuffer);

				setDisplayStr(stringBuffer, false);
			} else {
				if (getParamById(PARAM_RELAY_MODE) == RELAY_MODE_A2) {
					alarmMsg[2] = '2';
				}

				setDisplayStr((unsigned char*) &alarmMsg, false);
			}

			if (getParamById(PARAM_OVERHEAT_INDICATION)) {
				if ((temp < (getParamById(PARAM_MIN_TEMPERATURE) * 10))
						|| (temp >= (getParamById(PARAM_MAX_TEMPERATURE) * 10))) {
					blinkSpeed = blink_disp_enabled = true;
				} else {
					blinkSpeed = blink_disp_enabled = false;
				}
			} else {
				setDisplayOff(0);
			}

		}

		break;

	case MENU_SET_THRESHOLD:
		paramToString(PARAM_THRESHOLD, stringBuffer);

		setDisplayStr(stringBuffer, true);

		break;

	case MENU_SELECT_PARAM:
		paramMsg[1] = '0' + getParamId();

		setDisplayStr((unsigned char*) &paramMsg, true);

		break;

	case MENU_CHANGE_PARAM:
		paramToString(getParamId(), stringBuffer);

		setDisplayStr(stringBuffer, true);

		break;

	case MENU_EEPROM_LOCKED:
		paramMsg[1] = '7';

		setDisplayStr((unsigned char*) &paramMsg, true);

		break;

	case MENU_EEPROM_LOCKED2:
		setDisplayStr("LOC", true);

		break;

	case MENU_ALARM:
//		  _MIN_TEMPERATURE = getParamById (PARAM_MIN_TEMPERATURE) * 10;
//		  _MAX_TEMPERATURE = getParamById (PARAM_MAX_TEMPERATURE) * 10;
//
//		  setDisplayInt(_MAX_TEMPERATURE, true);
//		  setDisplayInt(_MIN_TEMPERATURE, false);

		if (getParamById(PARAM_RELAY_MODE) == RELAY_MODE_A2) {
			alarmMsg[2] = '2';
		}

		setDisplayStr((unsigned char*) &alarmMsg, true);

		break;

	case MENU_EEPROM_RESET:
		setDisplayStr("RST", true);

		break;

	default:
		// statements
		break;

	}
}

/**
 @brief This function is being called during timer's interrupt
 request so keep it extremely small and fast. During this call
 the data from display's buffer being used to drive appropriate
 GPIO pins of microcontroller.
 */
void refreshDisplay() {
	enableDigit(3); // all segments off
	enableDigit2(3); // all segments off

	set_hc164(0, false);

	if(alternate_display == true) {
		if (!displayOff) {
			set_hc164(displayData[activeDigitId],
					((activeDigitId == 0) && (controlDotStatus)));
		} else {
			set_hc164(0,
					((activeDigitId == 0) && (controlDotStatus)));
		}

		enableDigit(activeDigitId);

		if (lowBrightness) {
			int i = brightnessPWMtime;

			while (i--)
				;

			enableDigit(3);
		}
	} else {
		if (!displayOff) {
			set_hc164(displayData2[activeDigitId],
					((activeDigitId == 0) && (controlDotStatus)));
		} else {
			set_hc164(0,
					((activeDigitId == 0) && (controlDotStatus)));
		}

		enableDigit2(activeDigitId);

		if (lowBrightness) {
			int i = brightnessPWMtime2B;

			while (i--)
				;

			enableDigit2(3);
		} else {
			int i = brightnessPWMtime2A;

			while (i--)
				;

			enableDigit2(3);
		}
	}

	if(alternate_display == true){
		if (activeDigitId <= 0) {
			activeDigitId = 2;
		} else {
			activeDigitId--;
		}
	}

	alternate_display = !alternate_display;

	if (activeDigitId == 2) {
		mainDisplay();
	}
}

/**
 @brief Enables/disables a test mode of SSDisplay. While in this mode
 the test message will be displayed and any attempts to update
 display's buffer will be ignored.
 @param val
 value to be set: true - enable test mode, false - disable test mode.
 */
void setDisplayTestMode(bool val) //, char* str)
{
	testMode = val;

	if (val == true) {
		setDisplayStr("8.8.8.", true);
		setDisplayStr("8.8.8.", false);
	}
}

/**
 @brief Enable/disable display.
 @param val
 value to be set: true - display off, false - display on.
 */
void setDisplayOff(bool val) {
	displayOff = val;
}

/**
 @brief Sets dot in the buffer of display at position pointed by id
 to the state defined by val.
 @param id
 identifier of digit 0..2
 @param val
 state of dot to be set: true - enable, false - disable.
 */
void setDisplayDot(unsigned char id, bool val) {
	set_segment_dot(displayData, id, val);
}

void setDisplayInt(int _value, bool sel_disp) {
	itofpa(_value, (char*) stringBuffer1, 0);
	setDisplayStr(stringBuffer1, sel_disp);
}

/**
 @brief Sets symbols of given null-terminated string into display's buffer.
 @param val
 pointer to the null-terminated string.
 */
void setDisplayStr(const unsigned char *val, bool sel_disp) {
	unsigned char i, d;

// get number of display digit(s) required to show given string.
	for (i = 0, d = 0; *(val + i) != 0; i++, d++) {
		if (*(val + i) == '.' && i > 0 && *(val + i - 1) != '.')
			d--;
	}

// at this point d = required digits
// but SSD have 3 digits only. So rest is doesn't matters.
	if (d > 3) {
		d = 3;
	}

// disable the digit if it is not needed.
	for (i = 3 - d; i > 0; i--) {
		if(sel_disp == true){
			setDigit(3 - i, ' ', false);
		} else {
			setDigit2(3 - i, ' ', false);
		}
	}

// set values for digits.
	for (i = 0; d != 0 && *val + i != 0; i++, d--) {
		if (*(val + i + 1) == '.') {
			if(sel_disp == true){
				setDigit(d - 1, *(val + i), !displayOff);
			} else {
				setDigit2(d - 1, *(val + i), !displayOff);
			}
			i++;
		} else {
			if(sel_disp == true){
				setDigit(d - 1, *(val + i), false);
			} else {
				setDigit2(d - 1, *(val + i), false);
			}
		}
	}
}

/**
 @brief
 Enable the digit with given ID on SSD and rest of digits are disabled.

 @param id
 The ID = 0 corresponds to the right most digit on the display.
 Accepted values are: 0, 1, 2, any other value will disable display.
 */
void enableDigit(unsigned char id) {
	switch (id) {
	case 0:
		SSD_DIGIT_123_PORT &= ~SSD_DIGIT_1_BIT;
		SSD_DIGIT_123_PORT |= (SSD_DIGIT_2_BIT | SSD_DIGIT_3_BIT);
		break;

	case 1:
		SSD_DIGIT_123_PORT &= ~SSD_DIGIT_2_BIT;
		SSD_DIGIT_123_PORT |= (SSD_DIGIT_1_BIT | SSD_DIGIT_3_BIT);
		break;

	case 2:
		SSD_DIGIT_123_PORT &= ~SSD_DIGIT_3_BIT;
		SSD_DIGIT_123_PORT |= (SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT);
		break;

	default:
		SSD_DIGIT_123_PORT |= (SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT
				| SSD_DIGIT_3_BIT);
		break;
	}
}

void enableDigit2(unsigned char id) {
	switch (id) {
	case 0:
		SSD_DIGIT2_1_PORT &= ~SSD_DIGIT2_1_BIT;
		SSD_DIGIT2_23_PORT |= (SSD_DIGIT2_2_BIT | SSD_DIGIT2_3_BIT);
		break;

	case 1:
		SSD_DIGIT2_1_PORT |= SSD_DIGIT2_1_BIT;
		SSD_DIGIT2_23_PORT &= ~SSD_DIGIT2_2_BIT;
		SSD_DIGIT2_23_PORT |= SSD_DIGIT2_3_BIT;
		break;

	case 2:
		SSD_DIGIT2_1_PORT |= SSD_DIGIT2_1_BIT;
		SSD_DIGIT2_23_PORT |= SSD_DIGIT2_2_BIT;
		SSD_DIGIT2_23_PORT &= ~SSD_DIGIT2_3_BIT;
		break;

	default:
		SSD_DIGIT2_1_PORT |= SSD_DIGIT2_1_BIT;
		SSD_DIGIT2_23_PORT |= (SSD_DIGIT2_2_BIT | SSD_DIGIT2_3_BIT);
		break;
	}
}

/**
 @brief Sets bits within display's buffer appropriate to given value.
 So this symbol will be shown on display during refreshDisplay() call.
 When test mode is enabled the display's buffer will not be updated.

 The list of segments as they located on display:
 _2_       _1_       _0_
 <A>       <A>       <A>
 F   B     F   B     F   B
 <G>       <G>       <G>
 E   C     E   C     E   C
 <D> (P)   <D> (P)   <D> (P)

 @param id
 Identifier of character's position on display.
 Accepted values are: 0, 1, 2.
 @param val
 Character to be represented on SSD at position being designated by id.
 Due to limited capabilities of SSD some characters are shown in a very
 schematic manner.
 Accepted values are: ANY.
 But only actual characters are defined. For the rest of values the
 '_' symbol is shown.
 @param dot
 Enable dot (decimal point) for the character.
 Accepted values true/false.

 */
static void setDigit(unsigned char id, unsigned char val, bool dot) {
	set_segments(displayData, id, val, dot, testMode);
}

static void setDigit2(unsigned char id, unsigned char val, bool dot) {
	set_segments(displayData2, id, val, dot, testMode);
}

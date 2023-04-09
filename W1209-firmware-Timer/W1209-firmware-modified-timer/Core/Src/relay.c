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
 - Apr/08/2023
 - W1209 as Timer

 References:
 - https://github.com/rtek1000/W1209-firmware-modified
 */

/**
 Control functions for relay.
 */

#include "relay.h"
#include "stm8s003/gpio.h"
#include "params.h"

#define RELAY_PORT              PA_ODR
#define RELAY_BIT               0x08
#define RELAY_TIMER_MULTIPLIER  4 // 240 // inc (@250ms): (x4)s (x60)min: 4x60=240 (@1min)

static unsigned int timer = 0;
static unsigned int timer_2 = 0;
static bool state_pin = false;
static bool state_waiting = false;
static bool state_toggle = false;
static bool incTimerEn = false;
static bool incTimerEn_2 = false;

extern int temp;

bool getRelayState(bool _blink) {
	return state_pin || (_blink && state_waiting);
}

void incRelayTimer() {
	timer += incTimerEn;
	timer_2 += incTimerEn_2;
}

/**
 @brief Configure appropriate bits for GPIO port A, reset local timer
 and reset state.
 */
void initRelay() {
	PA_DDR |= RELAY_BIT;
	PA_CR1 |= RELAY_BIT;
}

/**
 @brief Sets state of the relay.
 @param on - true, off - false
 */
void setRelay(bool _on) {
	state_pin = _on;

	if (_on) {
		RELAY_PORT |= RELAY_BIT;
	} else {
		RELAY_PORT &= ~RELAY_BIT;
	}

}

/**
 @brief This function is being called during timer's interrupt
 request so keep it extremely small and fast.
 */
void refreshRelay() {
	bool mode = 0;

	int _RELAY_MODE = getParamById(PARAM_RELAY_MODE);

	unsigned int _RELAY_DELAY = getParamById(
			PARAM_RELAY_DELAY);

	unsigned int _RELAY_DELAY_2 = getParamById(
			PARAM_RELAY_DELAY);

	if (_RELAY_MODE == RELAY_MODE_A1) {
		mode = true;
	} else if (_RELAY_MODE == RELAY_MODE_A2) {
		mode = false;
	}

	if (state_toggle == true) { // Relay state is enabled

		incTimerEn = true; // timer++;
		incTimerEn_2 = false; // timer++;

		temp = _RELAY_DELAY - (timer / RELAY_TIMER_MULTIPLIER);

		//if ((_RELAY_DELAY < timer) || (!mode)) {
		if (_RELAY_DELAY < (timer / RELAY_TIMER_MULTIPLIER)) {
			state_toggle = false;
			setRelay(mode);
			state_waiting = false;

			timer_2 = 0;
		}

	} else { // Relay state is disabled
		incTimerEn = false; // timer++;

		incTimerEn_2 = true; // timer++;

		temp = _RELAY_DELAY_2 - (timer_2 / RELAY_TIMER_MULTIPLIER);

		//temp = 0; //  _RELAY_DELAY_2 - (timer_2 / RELAY_TIMER_MULTIPLIER);

		// if ((_RELAY_DELAY_2 < timer_2) || (mode)) {
		if (_RELAY_DELAY_2 < (timer_2 / RELAY_TIMER_MULTIPLIER)) {
			timer = 0;

			state_toggle = true;
			setRelay(!mode);
			state_waiting = false;
		}
	}
}

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
#include "timer.h"

// PD.6
#define RELAY_PORT              PD_ODR
#define RELAY_BIT               0x40
#define RELAY_TIMER_MULTIPLIER  10 // 240 // inc (@250ms): (x4)s (x60)min: 4x60=240 (@1min)

static unsigned long timer_1 = 0;
static unsigned long timer_2 = 0;
static unsigned long relay_timer = 0;
static unsigned char relay_timer_unit = 0;
static bool state_pin = false;
static bool state_pin_old = false;
static bool backup_state_pin = false;
static bool state_waiting = false;
static bool state_toggle = false;
static bool incTimerEn_1 = false;
static bool incTimerEn_2 = false;

static bool is_T2_completed = false;

unsigned int relay_cycle_count = 0;

extern volatile int timer_millis;
extern volatile unsigned char timer_seconds;
extern volatile int timer_minutes;

void resetT2complete(void) {
	is_T2_completed = false;
}

void saveRelayState(void) {
	backup_state_pin = state_pin;
	setRelay(false);
}

void restoreRelayState(void) {
	setRelay(backup_state_pin);
}

bool getRelayStateWait(bool _blink) {
	return state_pin || (_blink && state_waiting);
}

void incRelayTimer(void) {
	timer_1 += incTimerEn_1;
	timer_2 += incTimerEn_2;
}

unsigned long getRelayTimer(void) {
	return relay_timer;
}

unsigned long getRelayTimerUnit(void) {
	return relay_timer_unit;
}

/**
 @brief Configure appropriate bits for GPIO port A, reset local timer
 and reset state.
 */
void initRelay() {
	PD_ODR &= ~RELAY_BIT;
	PD_DDR |= RELAY_BIT;
	PD_CR1 |= RELAY_BIT;

	(void) timer_millis;
	(void) timer_seconds;
	(void) timer_minutes;

	initRelayCycle();
}

void initRelayCycle(void) {
	state_toggle = true;

	initTimerCount();

	enableTimerCount();

	setRelay(!getRelayMode());

	unsigned char _RELAY_MODE = getParamById(PARAM_RELAY_MODE);

	if((_RELAY_MODE == RELAY_MODE_C4) || (_RELAY_MODE == RELAY_MODE_C5)) {
		relay_cycle_count = 0;
	}

	//relay_cycle_count++;
}

/**
 @brief Sets state of the relay.
 @param on - true, off - false
 */
void setRelay(bool _on) {
	state_pin = _on;

	if (_on) {
		RELAY_PORT |= RELAY_BIT;

		if(state_pin_old != state_pin) {
			state_pin_old = state_pin;

			relay_cycle_count++;
		}
	} else {
		state_pin_old = state_pin;

		RELAY_PORT &= ~RELAY_BIT;
	}

}

bool getRelayMode(void) {
	unsigned char _RELAY_MODE = getParamById(PARAM_RELAY_MODE);

	if ((_RELAY_MODE == RELAY_MODE_C1) || (_RELAY_MODE == RELAY_MODE_C2)
			|| (_RELAY_MODE == RELAY_MODE_C4)) {
		return true;
	} else {
		return false;
	}
}

unsigned char getRelayCycleMode(void) {
	unsigned char _RELAY_MODE = getParamById(PARAM_RELAY_MODE);

	if ((_RELAY_MODE == RELAY_MODE_C0) || (_RELAY_MODE == RELAY_MODE_C1)) {
		return RELAY_CYCLE_ONE_PULSE_T1;
	} else if ((_RELAY_MODE == RELAY_MODE_C2)
			|| (_RELAY_MODE == RELAY_MODE_C3)) {
		return RELAY_CYCLE_ONE_PULSE_T2;
	} else {
		return RELAY_CYCLE_LOOP;
	}
}

/**
 @brief This function is being called during timer's interrupt
 request so keep it extremely small and fast.
 */
void refreshRelay() {
	bool mode = getRelayMode();
	unsigned char cycle = getRelayCycleMode();

	if (state_toggle == true) { // Relay state is enabled
		if ((timer_minutes == 0) && (timer_seconds == 0)
				&& (timer_millis == 0)) {
			if (cycle != RELAY_CYCLE_ONE_PULSE_T1) {
//			if (getRelayCycleMode() == RELAY_CYCLE_LOOP) {
				timer_2 = 0;
				state_toggle = false;
				setRelay(mode);
				state_waiting = false;
				is_T2_completed = true;

				disableInterrupts();
				timer_millis = getParamById(PARAM_T2_MILLIS);
				timer_seconds = getParamById(PARAM_T2_SECONDS);
				timer_minutes = getParamById(PARAM_T2_MINUTES);
				enableInterrupts();
			} else { // if (getRelayCycleMode() == RELAY_CYCLE_ONE_PULSE_T1) { //  {
				setRelay(mode);
				disableTimerCount();
			}
		}
	} else { // Relay state is disabled
		if ((timer_minutes == 0) && (timer_seconds == 0)
				&& (timer_millis == 0)) {
			if ((getStateTimerCount() == true) &&
					(cycle == RELAY_CYCLE_LOOP)) {
//										&& (is_T2_completed != false)) {
				timer_1 = 0;
				state_toggle = true;
				setRelay(!mode);
				state_waiting = false;

				//relay_cycle_count++;

				disableInterrupts();
				timer_millis = getParamById(PARAM_T1_MILLIS);
				timer_seconds = getParamById(PARAM_T1_SECONDS);
				timer_minutes = getParamById(PARAM_T1_MINUTES);
				enableInterrupts();
			} else { // if (getRelayCycleMode() != RELAY_CYCLE_ONE_PULSE_T2) {
				setRelay(!mode);
				disableTimerCount();
			}
		}
	}
}

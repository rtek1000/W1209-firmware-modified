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
   - Apr/06/2023
   - Arduino sketch converted to Eclipse project
     --> To free up space in program memory (Flash)

   References:
   - https://github.com/rtek1000/NTC_Lookup_Table_Generator
   - https://github.com/rtek1000/W1209-firmware-modified
*/

/**
	Time base for millis() and Relay timer
*/

#include "timer.h"
#include "display.h"
#include "relay.h"

extern volatile unsigned long millis_counter;

volatile unsigned int counter_250ms = 0;

void initTimer() {
//	CLK_CKDIVR = 0x00;  // Set the frequency to 16 MHz
	TIM4_PSCR = 0x07;   // CLK / 128 = 125KHz
	TIM4_ARR = 0x7D;    // 125KHz /  125(0xFA) = 1000Hz
	TIM4_IER = 0x01;    // Enable interrupt on update event
	TIM4_CR1 = 0x05;    // Enable timer

	(void) millis_counter;
}

void TIM4_UPD_handler()
__interrupt (23)
{
	TIM4_SR &= ~TIMx_UIF; // Reset flag

	if(counter_250ms < 250) {
		counter_250ms++;
	} else {
		counter_250ms = 0;

		incRelayTimer();
	}

	millis_counter++;
}

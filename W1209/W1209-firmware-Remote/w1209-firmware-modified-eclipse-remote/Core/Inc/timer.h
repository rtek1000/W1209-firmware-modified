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

#ifndef TIMER_H_
#define TIMER_H_

void initTimer();
unsigned long millis(void);
void delay(unsigned long value);
void TIM1_UPD_handler() __interrupt (11);
void TIM2_UPD_handler() __interrupt (13);
void TIM4_UPD_handler() __interrupt (23);

#endif /* TIMER_H_ */

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

#ifndef RELAY_H
#define RELAY_H

#include "main.h"

// P0 options:
// 0: The relay opens after a delay of T1 time, and ends
// 1: The relay closes after a delay of T1 time and ends
// 2: The relay closes after a delay of T1 time, and then opens after a delay of T2, and ends
// 3: The relay opens after a delay of T1 time, then closes after a delay of T2 time, and ends
// 4: The relay closes after a delay of T1 time, and then opens after a delay of T2 time, loop
// 5: The relay opens after a delay of T1 time, and then closes after a delay of T2 time, and loops

enum relayMode_enum {
  RELAY_MODE_C0 = 0,               // 0
  RELAY_MODE_C1,                   // 1
  RELAY_MODE_C2,                   // 2
  RELAY_MODE_C3,                   // 3
  RELAY_MODE_C4,                   // 4
  RELAY_MODE_C5                    // 5
};

enum relayCycleMode_enum {
  RELAY_CYCLE_ONE_PULSE_T1 = 0,    // 0
  RELAY_CYCLE_ONE_PULSE_T2,        // 1
  RELAY_CYCLE_LOOP                 // 2
};

void resetT2complete(void);
void saveRelayState(void);
void restoreRelayState(void);

void initRelay(void);
void initRelayCycle(void);
void incRelayTimer(void);
unsigned long getRelayTimer(void);
unsigned long getRelayTimerUnit(void);
bool getRelayState(void);
bool getRelayStateWait(bool _blink);
bool getRelayMode(void);
unsigned char getRelayCycleMode(void);
void refreshRelay();
void setRelay (bool on);

#endif

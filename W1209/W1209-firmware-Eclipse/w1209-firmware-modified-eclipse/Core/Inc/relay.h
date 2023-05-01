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

enum relayMode_enum {
  RELAY_MODE_C1 = 0,                   // 0
  RELAY_MODE_C2,                   // 1
  RELAY_MODE_C3,                   // 2
  RELAY_MODE_H1,                   // 3
  RELAY_MODE_H2,                   // 4
  RELAY_MODE_H3,                   // 5
  RELAY_MODE_A1,                   // 6
  RELAY_MODE_A2                    // 7
};

void initRelay();
void incRelayTimer();
bool getRelayState(bool _blink);
void refreshRelay();
void setRelay (bool on);

#endif

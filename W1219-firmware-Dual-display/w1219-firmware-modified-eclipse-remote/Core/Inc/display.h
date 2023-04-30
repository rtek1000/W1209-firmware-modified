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

#ifndef DISPLAY_H
#define DISPLAY_H

#include "main.h"

enum brightness_enum {
  brightnessLow,
  brightnessHigh
};

void initDisplay();
void mainDisplay(void);
void controlDot(bool _state);
void dimmerBrightness(bool _state);
void refreshDisplay();
void setDisplayInt (int, bool sel_disp);
void setDisplayOff (bool val);
void setDisplayStr (const unsigned char*, bool sel_disp);
void setDisplayTestMode (bool); //, char* str);
void enableDigit (unsigned char id);
void enableDigit2(unsigned char id);

#endif

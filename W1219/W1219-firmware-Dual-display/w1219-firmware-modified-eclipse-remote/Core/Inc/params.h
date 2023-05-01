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

#ifndef PARAMS_H
#define PARAMS_H

#include "main.h"

/* Definition for parameter identifiers */
enum param_enum {
  PARAM_RELAY_MODE,                // 0
  PARAM_RELAY_HYSTERESIS,          // 1
  PARAM_MAX_TEMPERATURE,           // 2
  PARAM_MIN_TEMPERATURE,           // 3
  PARAM_TEMPERATURE_CORRECTION,    // 4
  PARAM_RELAY_DELAY,               // 5
  PARAM_OVERHEAT_INDICATION,       // 6
  PARAM_LOCK_BUTTONS,              // 7
  PARAM_AUTO_BRIGHT,               // 8
  PARAM_THRESHOLD                  // 9 (2 bytes)
};

int getParam();
void incParam();
void decParam();
void incParamId();
void decParamId();
void storeParams();
void initParamsEEPROM(void);
void resetParamsEEPROM();
void loadParamsEEPROM();
unsigned char getParamId();
int getParamById (unsigned char);
void setParam (int);
void setParamId (unsigned char);
int getMaxParamById(unsigned char id);
int getMinParamById(unsigned char id);
void setParamById (unsigned char, int);
void paramToString (unsigned char, unsigned char*);
void itofpa (int, unsigned char*, unsigned char);

#endif

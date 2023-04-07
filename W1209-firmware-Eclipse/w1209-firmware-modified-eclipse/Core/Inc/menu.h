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

#ifndef MENU_H
#define MENU_H

#include "main.h"

/* Menu sections */
enum menu_enum {
  MENU_ROOT,              // 0
  MENU_SET_THRESHOLD,     // 1
  MENU_SELECT_PARAM,      // 2
  MENU_CHANGE_PARAM,      // 3
  MENU_ALARM,             // 4
  MENU_ALARM_HIGH,        // 5
  MENU_ALARM_LOW,         // 6
  MENU_EEPROM_RESET,      // 7
  MENU_EEPROM_LOCKED,     // 8
  MENU_EEPROM_LOCKED2     // 9
};

/* Menu events */
#define MENU_EVENT_PUSH_BUTTON1     0
#define MENU_EVENT_PUSH_BUTTON2     1
#define MENU_EVENT_PUSH_BUTTON3     2
#define MENU_EVENT_RELEASE_BUTTON1  3
#define MENU_EVENT_RELEASE_BUTTON2  4
#define MENU_EVENT_RELEASE_BUTTON3  5
#define MENU_EVENT_CHECK_TIMER      6
#define MENU_EVENT_IDLE             7

void initMainControl(void);
void mainControl(void);

#endif

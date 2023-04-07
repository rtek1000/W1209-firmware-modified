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

#ifndef MAIN_H
#define MAIN_H

#include "stm8.h"

#define enableInterrupts()    __asm__("rim") //__asm rim __endasm;
#define disableInterrupts()   __asm__("sim") // __asm sim __endasm;
#define waitForInterrupt()  __asm__("wfi") // __asm wfi __endasm;
#define nop()                 __asm__("nop")    /* No Operation */

#ifndef bool
#define bool    _Bool
#define true    1
#define false   0
#define byte    unsigned char
#endif

#define OUTPUT 0
#define INPUT 1
#define INPUT_PULLUP 2

// void setMenuDisplay(unsigned char _menu);
unsigned long millis(void);
void delay(unsigned long value);

bool get_Button1(void);
bool get_Button2(void);
bool get_Button3(void);
void main(void);
void mainDisplay(void);
void mainControl(void);

#endif // #ifndef MAIN_H

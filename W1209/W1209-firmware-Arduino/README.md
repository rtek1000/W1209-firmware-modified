   # Do not use this W1209 board without solving the LED problem
   - The 12V voltage can bounce back across the LED and damage the microcontroller. See more details in the main description:
   - Here: https://github.com/rtek1000/W1209-firmware-modified

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

   - Modified by RTEK1000
   - Mar/27/2023
   - Code adaptation for Arduino IDE sketch.ino ([IDE v1.8.19](https://www.arduino.cc/en/software)) + ([Sduino STM8 Core](https://github.com/tenbaht/sduino))
   - Some bug fixes
   - Some functions added
   - - Parameter P0: C1/C2/C3/H1/H2/H3/A1/A2
   - - - C1: Cooler mode (hysteresis above Threshold)
   - - - C2: Cooler mode (hysteresis below Threshold)
   - - - C3: Cooler mode (hysteresis above and below Threshold)
   - - - H1: Heater mode (hysteresis below Threshold)
   - - - H2: Heater mode (hysteresis above Threshold)
   - - - H3: Heater mode (hysteresis above and below Threshold)
   - - - A1: Alarm mode (cause relay activation using the maximum "P2" and minimum parameters "P3")
   - - - - Temperature greater than the maximum value "P2": relay activated
   - - - - Temperature lower than the minimum value "P3": relay activated
   - - - A2: Alarm mode (cause relay activation using the maximum "P2" and minimum parameters "P3")
   - - - - Temperature greater than the maximum value "P2": relay disabled
   - - - - Temperature lower than the minimum value "P3": relay disabled
   - - Parameter P1: Hysteresis (Degree hysteresis (°C) to toggle relay)
   - - Parameter P2: Up limit
   - - - (Used in the alert indication; Activated in Parameter P6)
   - - - (Used in Alarm mode Parameter P0: A1 and A2)
   - - Parameter P3: Down limit
   - - - (Used in the alert indication; Activated in P6)
   - - - (Used in Alarm mode Parameter P0: A1 and A2)
   - - Parameter P4: Temperature sensor offset
   - - - (From -7.0 up to +7.0)
   - - Parameter P5: Delay time before activating the relay
   - - - (From 0 to 10 minutes)
   - - - (Does not affect relay deactivation, deactivation is immediate)
   - - Parameter P6: ON/OFF
   - - - (Alert mode; Need setup Parameter P2 and P3; The display flashes when the temperature is outside the configured range.)
   - - Parameter P7: ON/OFF
   - - - (Threshold value change access blocking)
   - - - (Factory reset lockout with Up "+" and Down "-" keys)
   - - Parameter P8: ON/OFF
   - - - (Automatic brightness reduction after 15 seconds)
   - Output status indication:
   - - Decimal point (DOT) right side off:
           Relay deactivated (contacts open)
   - - Decimal point (DOT) right side blinking:
           Relay deactivated (contacts open), but
           Waiting delay time programmed in Parameter P5
   - - Decimal point (DOT) right side on:
           Relay activated (contacts close)           
   - - Factory reset:
   - - - Set Parameter P7 in OFF
   - - - Turn power supply Off
   - - - Press and hold Up "+" and Down "-" keys
   - - - Turn power supply On
   - - - Wait for "rSt" to appear on the display
   - - - Release all keys
   - - - Wait for the current temperature to appear
   - Shows "HHH" or "LLL" on display if sensor fails, display flashing:
   - - If the sensor is disconnected, it shows "LLL"
   - - If the sensor is short circuited, it shows "HHH"
   
   - Troubleshoot:
   - - After updating the firmware, perform a Factory reset to adjust the variables within the range of values expected by the new firmware.
   - - Microcontroller resetting:
   - - - Try using a pull up resistor on the reset line
   
   - - Microcontroller no longer responds:
   - - - High voltage return may have occurred through the relay LED
   
   - - The temperature does not correspond to the real:
   - - - Try adjusting the offset Parameter P5
   - - - Try to replace the sensor
   - - - Test using a resistor of NTC equivalent value for 25°C (10k)
   - - - Try modifying the lookup table corresponding to the sensor
   
   - - Display flickering:
   - - - Disconnect STlink programmer from SWIM port (next to display)
           
   - Note for Arduino IDE and Sduino core:
     Track the size of the code when uploading,
     The maximum I got was 93%
   - - (Sketch uses 7589 bytes (92%))
   - - (Bytes written: 8136)
   - - (Maximum is 8192 bytes)
   - [Sduino core](https://github.com/tenbaht/sduino):
   - - Select STM8S Board / STM8S103F3 Breadout Board
   - - Programmer ST-link/V2
   - - Connect STlink: GND/SWIM/RST 

   - ST-Link V2 Programming Example on Linux (check Bin folder):
   - - stm8flash -c stlinkv2 -p stm8s003?3 -w W1209-firmware-Arduino-table_R2_5k1_NTC_10k_B3950.hex 
   - - - Determine FLASH area
   - - - STLink: v2, JTAG: v40, SWIM: v7, VID: 8304, PID: 4837
   - - - Due to its file extension (or lack thereof), "W1209-firmware-Arduino-table_R2_5k1_NTC_10k_B3950.hex" is considered as INTEL HEX format!
   - - - 8136 bytes at 0x8000... OK
   - - - Bytes written: 8136
   - Note: When flashing the microcontroller, the original firmware will be overwritten, and cannot be undone


   - References:
   - - https://github.com/rtek1000/NTC_Lookup_Table_Generator
   - - https://github.com/rtek1000/W1209-firmware-modified

# Note
- Eclipse project is the original forked code of the [original](https://github.com/mister-grumbler/w1209-firmware).

# Note: The code in this repository has been modified and is not an identical copy of the files.
- Bin folder is the compiled code to be used ST-Link V2

- I found some bugs related to menu navigation, I haven't found the cause yet.
- This repository is a fork of the [original](https://github.com/mister-grumbler/w1209-firmware).

# Code adaptation for Arduino IDE sketch.ino:
- (apparently all functions working): ckeck it [here](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W1209-firmware-Arduino).

# Modifications (W1209 Usage):
- Shows "HHH" or "LLL" on display if sensor fails, display flashing:
- - If the sensor is disconnected, it shows "LLL".
- - If the sensor is short circuited, it shows "HHH".
- - Note 1: in the "C" (Cooling) and "H" (Heating) modes of parameter "P0", the relay is deactivated when the sensor fails (open contacts "K0" and "K1").
- - Note 2: in mode "A1" (Alarm 1) of parameter "P0", the relay is activated when the sensor fails (closed contacts "K0" and "K1").
- - Note 3: in mode "A2" (Alarm 2) of parameter "P0", the relay is disabled when the sensor fails (open contacts "K0" and "K1").

- [P0: C/H/A1/A2] Operation mode for alarm:
- - When in "A1" mode (Alarm): cause relay activation using the maximum "P2" and minimum parameters "P3".
- - - Temperature greater than the maximum value "P2": relay activated.
- - - Temperature lower than the minimum value "P3": relay activated.
- - When in "A2" mode (Alarm): cause relay activation using the maximum "P2" and minimum parameters "P3".
- - - Temperature greater than the maximum value "P2": relay disabled.
- - - Temperature lower than the minimum value "P3": relay disabled.
- - When in "C" mode (Cooler): cause relay activation using the SETPOINT parameter (Threshold in the source code).
- - - Temperature greater than the SETPOINT: relay activated (closed contacts "K0" and "K1").
- - When in "H" mode (Heater): cause relay activation using the SETPOINT parameter (Threshold in the source code).
- - - Temperature greater than the SETPOINT: relay disabled (open contacts "K0" and "K1").

- [P1: 0.1/15] Degree hysteresis (°C) to toggle relay.
- [P2: -50/110] Maximum limit:
- - Used for Alert on the display (blinking) and Alarm mode ("P0" parameter in "A1" or "A2").
- [P3: -50/110] Minimum limit:
- - Used for Alert on the display (blinking) and Alarm mode ("P0" parameter in "A1" or "A2").
- [P4: -7.0/+7.0] Temperature offset.
- - Used to compensate for temperature deviations.
- [P5: 0/10] Delay before activating the relay:
- - Used for applications such as refrigerator compressor motor.

- [P6: ON/OFF] Alert parameter: When activated (ON) if the value is beyond the maximum and minimum range: the display flashes.
- - In the original code it shows HHH for higher value and shows LLL for lower value.

- [P7: ON/OFF] Lock parameter: When activated (ON):
- - The SETPOINT parameter (Threshold in the source code) cannot be modified.
- - - When trying to change the SETPIONT, the display shows: "LOC"
- - - When power is started, the display shows: "P7" and "LOC"
- - If parameter "P0" is "A1" (Alarm 1) or "A2" (Alarm 2), using the + or - keys it shows the minimum and maximum values. 
- - The RECOVERY parameter (data restoration to factory mode) cannot be performed.

- [P8: ON/OFF] Automatic brightness reduction: When activated (ON), after 15 seconds in IDLE, the brightness of the display is reduced.
- - Brightness returns to maximum when you press any key.
- - Note, the brightness of "LED1" (see board) cannot be controlled via software as it is the same control pin as the relay.

- Note:
- - To enter the main configuration parameters menu:
- - - Press the SET key for a long time (for more than 5 seconds).
- - - Press the "+" or "-" keys to toggle between parameters "P0" through "P8".
- - - Short press SET key to enter the parameter.
- - - - Press the "+" or "-" keys to change values.
- - Long press SET key or no press (for 10 seconds), confirm and return automatically.

- Note: Added delay for debounce, for fast increment hold key down.

- Table of adjustable parameters:
![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/Doc/Table_params_W1209_modified_6.png)

# W1209 hardware (variation):
There is an error in the electronic circuit that can kill the microcontroller, make the modification as soon as possible. Avoid using the board without modifying it. See [here](https://github.com/mister-grumbler/w1209-firmware/issues/22).
![image](https://user-images.githubusercontent.com/1465701/163829267-9fa689e8-70c2-4991-9749-82f886b1b8a6.jpg)

- Other details can be seen in this [post](https://github.com/TG9541/stm8ef/wiki/W1209-Identifying-'compliant'-boards).

- R2 is not the same for all boards:
![image](https://raw.githubusercontent.com/rtek1000/w1209-firmware/master/Doc/w1209.png)

- The generic schematic diagram shows the value of 20K ohms for R2:
![image](https://raw.githubusercontent.com/rtek1000/NTC_Lookup_Table_Generator/main/Img/image.jpg)

- R2 resistor: Some boards have a resistor value of 20k, others may have different values such as 5.1k, check the table in the adc.c file, if your board has a different value for R2 or for the sensor, it may be necessary to change the table rawADC[ ]:
![image](https://raw.githubusercontent.com/rtek1000/NTC_Lookup_Table_Generator/main/Img/Image2.png)

- To generate a custom lookup table for a different sensor, you can use this tool:
- - "[NTC Lookup Table Generator](https://github.com/rtek1000/NTC_Lookup_Table_Generator)":

- - ![image](https://github.com/rtek1000/NTC_Lookup_Table_Generator/blob/main/Img/Image_1.png)

- Note: This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

# Code usage:
- Build procedure (Run the "make" command inside the "Src" folder, using the command-line shell):
- - make

- Upload procedure:
- - Connect STlink to W1209 board, 3 wires are needed (GND/SWIM/RESET).
- - Power the W1209 board using a 12V power supply.
- - Run the command below inside the Build folder (Src/Build):
- - - stm8flash -c stlinkv2 -p stm8s003?3 -w thermostat.ihx

- Build tools:
- - Source control - Git is a free and open source distributed version control system.
- - - sudo apt-get install git-all
- - Build control - GNU Make is a tool which controls the generation of executables and other non-source files of a program.
- - - sudo apt install make
- - C Compiler - SDCC Small Device C Compiler
- - - sudo apt-get install sdcc
- - SWIM upload - stm8flash is a free and opensource tool that's able to communicate through the SWIM interface of ST-LINKs under Linux.
- - - sudo apt-get install pkg-config libusb-1.0-0-dev
- - - git clone https://github.com/vdudouyt/stm8flash.git
- - - cd stm8flash
- - - make
- - - sudo make install
- - Note: If you have errors in the code, when executing the make command, messages referring to the files and lines appear, similar to the warnings of the Arduino IDE. You can use different terminal windows (command-line shell) for compiling (make) and uploading (stm8flash).

- Upload tool:
- - STlink V2
- - Wires (At least 3 wires)
- - Single row pin bar 2.54mm pitch (At least 3 pins)
- Note: the STlink cable can interfere with the W1209 operation, if the display shows 888 or remains off, remove the cable from the W1209 board.

- Editing tool:
- - Any editor can be used to modify the files, as suggested in the original repository, you can use CodeLite, it is lightweight and has color and plugins that help in reading the code.
![image](https://github.com/rtek1000/W1209-firmware-modified/blob/master/Doc/CodeLite%20IDE.png)
- - CodeLite install:
- - - sudo apt-get install codelite
- - - sudo apt-get install codelite-plugins

# Original description:
- w1209-firmware
- - The functional equivalent to the original firmware of "Digital Thermostat Module Model XH-W1209".

- - The F.A.Q. page is available at https://github.com/mister-grumbler/w1209-firmware/wiki/FAQ

- - Look at the list of issues to have an idea of what needs to be done for the initial release.
https://github.com/mister-grumbler/w1209-firmware/issues

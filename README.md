# Note: The code in this repository has been modified and is not an identical copy of the files.


This repository is a fork of the ![original](https://github.com/mister-grumbler/w1209-firmware).

# Modifications:
- Shows FFF on display if sensor fails:
- - If the sensor is disconnected.
- - If the sensor is short circuited.

- Value outside the maximum or minimum range: display flashes.
- - In the original code it shows HHH for higher value and shows LLL for lower value.

- Added operation mode for alarm [P0: C/H/A]:
- - When in A mode (Alarm): cause relay activation using the maximum [P2] and minimum parameters [P3].
- - - Temperature greater than the maximum value [P2]: relay activated.
- - - Temperature lower than the minimum value [P3]: relay activated.
- - When in C mode (Cooler): cause relay activation using the SETPOINT parameter (Threshold in the source code).
- - - Temperature greater than the SETPOINT: relay activated (closed contacts).
- - When in H mode (Heater): cause relay activation using the SETPOINT parameter (Threshold in the source code).
- - - Temperature greater than the SETPOINT: relay disabled (open contacts).

- Added lock parameter [P7: ON/OFF]: When activated (ON) the SETPOINT parameter (Threshold in the source code) cannot be modified.

- Added automatic brightness reduction [P8: ON/OFF]: When activated (ON), after 15 seconds in IDLE, the brightness of the display is reduced.
- - Brightness returns to maximum when you press any key.

- Table of adjustable parameters:
![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/Doc/Table_params_W1209_modified_3.png)

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

# Usage:
- Build procedure (Run the 'make' command inside the Src folder, using the command-line shell):
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

- Upload tool:
- - STlink V2
- - Wires (At least 3 wires)
- - Single row pin bar 2.54mm pitch (At least 3 pins)
- Note: the STlink cable can interfere with the W1209 operation, if the display shows 888 or remains off, remove the cable from the W1209 board.

# Original description:
- w1209-firmware
- - The functional equivalent to the original firmware of "Digital Thermostat Module Model XH-W1209".

- - The F.A.Q. page is available at https://github.com/mister-grumbler/w1209-firmware/wiki/FAQ

- - Look at the list of issues to have an idea of what needs to be done for the initial release.
https://github.com/mister-grumbler/w1209-firmware/issues

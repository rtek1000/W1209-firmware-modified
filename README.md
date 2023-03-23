# Note: The code in this repository has been modified and is not an identical copy of the files.


This repository is a fork of the ![original](https://github.com/mister-grumbler/w1209-firmware).

# Modifications:
- Added sensor failure indicator (Value reading below position 0 of the table)
- Added alarm type operation mode [C/H/A] (Cause relay activation using the maximum [P2] and minimum parameters [P3].)
- Added lock parameter [P7]

- Table of original parameters:
![image](https://raw.githubusercontent.com/rtek1000/w1209-firmware/master/Doc/Table_params_W1209.png)

- R2 is not the same for all boards:
![image](https://raw.githubusercontent.com/rtek1000/w1209-firmware/master/Doc/w1209.png)

- R2 resistor: Some boards have a resistor value of 20k, others may have different values such as 5.1k, check the table in the adc.c file
![image](https://raw.githubusercontent.com/rtek1000/NTC_Lookup_Table_Generator/main/Img/image.jpg)

- To generate a custom lookup table for a different sensor, you can use this tool:
- - "[NTC Lookup Table Generator](https://github.com/rtek1000/NTC_Lookup_Table_Generator)":

- - ![image](https://github.com/rtek1000/NTC_Lookup_Table_Generator/blob/main/Img/Image_1.png)

- Note: This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

# Original description:
- w1209-firmware
- - The functional equivalent to the original firmware of "Digital Thermostat Module Model XH-W1209".

- - The F.A.Q. page is available at https://github.com/mister-grumbler/w1209-firmware/wiki/FAQ

- - Look at the list of issues to have an idea of what needs to be done for the initial release.
https://github.com/mister-grumbler/w1209-firmware/issues

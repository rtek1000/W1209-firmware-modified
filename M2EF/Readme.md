## M2EF - Similar board with IC SN74HC595

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/M2EF/M2EF-firmware-Timer/Doc/M2EF-Timer_SN74HC595_1.png)

----------

### Original firmware:

Basic description:

- Range selection:
- - 0.01 second,
- - 0.1 second,
- - 1 second,
- - 1 minute

- Timing range:
- - Minimum 0.01 second
- - Maximum 999 minutes

--------------------------
User's Guide:

There are two sets of time T1 and T2 for users to set.

Precautions
1. All parameters of the relay are automatically memorized in 5s,
2. If you need to stop during operation, press the stop button to stop the relay and reset the data. Press the stop button again to trigger again.
3. When the relay finishes normally, press the stop button to trigger the start again.

- T1 time setting:
Directly press the plus or minus button to set T1, the data will be automatically memorized 5s after setting, and the timing will start.
- T2 time setting:
Short press the setting button, the digital tube flashes, at this time, press the button to increase or decrease to set T2, 5 seconds after the setting is completed, the automatic memory starts to run.

Time range:
- Automatically switch the range.
- The default range is seconds.
- Decrease the number to 0, continue to press the button to decrease, the range will automatically switch to 99.9s;
- Increase the number to 999, continue to press the button to increase, the range will automatically switch to 0.0.0

- The number format is as follows
- - X.X X---time range 0.01s
- - X X.X---time range 0.1s
- - X X X---time range 1s
- - X.X.X---time range 1min

For example:
- Set T1=8.88, the controller counts down at 0.01s, T2=8.8.8, the controller counts down at 1 minute.
Working mode setting:
- Six working modes for users to set.

Long press the setting key to enter the P-0 parameter, and set the required working mode by pressing the key plus or minus on the current interface.

- P-0: The relay is turned off after a delay of T1, and ends
- P-1: The relay is closed after a delay of T1 time and ends
- P-2: The relay is closed after a delay of T1, and then opened after a delay of T2, and ends
- P-3: The relay opens after a delay of T1 time, then closes after a delay of T2 time, and ends
- P-4: The relay is closed after a delay of T1 time, and then opened after a delay of T2 time, loop
- P-5: The relay opens after a delay of T1 time, and then closes after a delay of T2 time, and loops

Typical application:
- First, let the relay open after a delay of 4.05s, then close after a delay of 10 minutes, and end
- - Firstly set the time, T1=4.05 T2=0.1.0
- - Secondly set the working mode P-3, it will be automatically memorized 5s after setting, and start to run.

Info sources:
- https://www.aliexpress.com/item/1005001830924875.html
- https://pt.aliexpress.com/item/1005001722532897.html
----------

### Hardware:

Internal board image:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Timer/Doc/Board_no_display.jpg)

Notes:
- For 110/220V board version, due to the diode only 4V3 reach the Relay, to correct this, replace the diode with a jumper.
- Cut the 3V3 track of the LED and connect the anode of the LED to the protection diode of the Relay, 5V arrives at this point (110/220V version).
- - For power versions other than 110v/220v, it may be necessary to change the LED resistor value.
- For external trigger (>3V3) you can populate the components: (connector, opto coupler, resistor).
- The board provides support for NTC temperature sensor. Need to populate the resistor R4 (and C4) also the connector.
- - Firmware can be adapted based on W1209 to operate NTC sensor.

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Timer/Doc/Board3.png)

IC pinout:
[STM8S003F3P6]
1. NC
2. NC (NTC)
3. Relay
4. Reset
5. HC595 pin 14
6. BTN Dn
7. GND
8. Vcap
9. VDD (3V3)
10. HC595 pin 11

11. BTN Up (10k Pull-Up)
12. BTN IO (On/Off) (10k Pull-Up)
13. NC (Opto OG1 - Input - Trigger)
14. BTN Set
15. Display pin 8 (Dig 3)
16. Display pin 9 (Dig 2)
17. Display pin 12 (Dig 1)
18. HC595 pin 12 (SWIM)
19. NC
20. NC

[SN74HC595]
1. Display pin 2 (Seg D) (220R) [QB]
2. Display pin 3 (Seg DP) (220R) [QC]
3. Display pin 4 (Seg C) (220R) [QD]
4. Display pin 11 (Seg A) (220R) [QE]
5. Display pin 10 (Seg F) (220R) [QF]
6. Display pin 5 (Seg G) (220R) [QG]
7. Display pin 7 (Seg B) (220R) [QH]
8. GND

9. NC [QH′]
10. VDD [/SRCLR]
11. STM8S pin 10 [SRCLK]
12. STM8S pin 18 [RCLK]
13. GND [/OE]
14. STM8S pin 5 [SER]
15. Display pin 1 (Seg E) (220R) [QA]
16. VDD (3V3)

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Timer/Doc/Sn74hc595.png)

[LED]
- Anode: 3V3 (STM8 VDD)
- Catode: (1k) to Relay coil (5V for 110-220Vac version)
- - For 12/24V version: do not use the board without modifying the LED circuit.  Relay voltage can bounce back across the LED and damage the STM8 microcontroller

--------------

If the STM8S003F3P6 is blocked when trying to program, this message should appear:

> target page is write protected (UBC) or read-out protection is enabled

[stm8flash (Linux)]:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Timer/Doc/MCU_write_protected.png)

[STVP (Windows)]:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Timer/Doc/Chip_protected.png)


It will be necessary to reset the OPTION_BYTE of the MCU:

>Option bytes
>
>Option bytes are located in the EEPROM and allow configuring device hardware features such as readout protection and alternate function mapping. Each option byte, except for read-out protection, has to be stored in a normal form (OPTx) and complementary form (NOPTx). The procedure for writing option bytes is the same as for writing EEPROM, except for the unlcok sequence: OPT bit has to be set in FLASH_CR2 and FLASH_NCR2 registers.

>If you mess things up, you can reset the option bytes via SWIM:

```$ echo -ne '\x00\x00\xff\x00\xff\x00\xff\x00\xff\x00\xff' > opt.bin```

```$ stm8flash -c stlinkv2 -p stm8s003f3 -s opt -w opt.bin```


Command result:
```
Determine OPT area
STLink: v2, JTAG: v41, SWIM: v7, VID: 8304, PID: 4837
Due to its file extension (or lack thereof), "opt.bin" is considered as RAW BINARY format!
11 bytes at 0x4800... OK
Bytes written: 11
```

Reference: [Bare metal programming: STM8 (Part 2) ](https://lujji.github.io/blog/bare-metal-programming-stm8-part2/)

[STVP (Windows)]:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Timer/Doc/Chip_unprotected.png)

--------------

### Alternative firmware for this board with IC SN74HC595:

Remote control (serial 9600 bauds):

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/M2EF/M2EF-firmware-Timer/Doc/M2EF-Board_display_remote.png)

- P0: Cycle mode [0, 1, 2, 3, 4, 5]
- P1: T1 minutes [0 ~ 999]
- P2: T1 seconds [0 ~ 59]
- P3: T1 milliseconds [0 ~ 999]

- P4: T2 minutes [0 ~ 999]
- P5: T2 seconds [0 ~ 59]
- P6: T2 milliseconds [0 ~ 999]
 
- P7: Lock Factory reset
- P8: Auto bright
- P9: Internal timer calibration (To allow more accurate timing)

Parameters table:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/M2EF/M2EF-firmware-Timer/Doc/Table_params_M2EF_timer.png)

Firmware usage

- There are 6 modes of operation (Looped or non-looped).
- Maximum time about 1000 minutes (about 16 hours and 40 minutes).
- Two-step timing (Times separated in minutes, seconds and milliseconds).
- Display automatically shows the most significant digits.
- Sensor input operating as a button.
- Remote Control (App (Windows) for tests).

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/M2EF/M2EF-firmware-Timer/App_Windows/Doc/W1209%20Timer%20Test%20App%20Windows.png)

Note: **The original firmware will be erased**.

To-do:

- Add P9 parameter in Windows App

---------

- More information about this alternative firmware [here](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W1209/W1209-firmware-Timer).
- - (This firmware is an adaptation of the firmware for the W1209 board)

---------

Note: This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

Adapted from W1209-firmware-remote

Parameters (Long press SET button):

- P0: Relay mode [0, 1, 2, 3, 4, 5]
- - 0: The relay opens after a delay of T1 time, and ends
- - 1: The relay closes after a delay of T1 time and ends
- - 2: The relay closes after a delay of T1 time, and then opens after a delay of T2, and ends
- - 3: The relay opens after a delay of T1 time, then closes after a delay of T2 time, and ends
- - 4: The relay closes after a delay of T1 time, and then opens after a delay of T2 time, loop
- - 5: The relay opens after a delay of T1 time, and then closes after a delay of T2 time, and loops

- P1: T1 minutes [0 ~ 999]
- P2: T1 seconds [0 ~ 59]
- P3: T1 milliseconds [0 ~ 999]

- P4: T1 minutes [0 ~ 999]
- P5: T1 seconds [0 ~ 59]
- P6: T1 milliseconds [0 ~ 999]
 
- P7: Lock Factory reset
- P8: Auto bright

To-Do:
- Add remote control

--------------------------

To-Do:

- Add Timer function to W1209

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

Board image:
![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Timer/Doc/Polish_20230403_120203288.jpg)

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
1. Display pin 2 (Seg D) (220R)
2. Display pin 3 (Seg DP) (220R)
3. Display pin 4 (Seg C) (220R)
4. Display pin 11 (Seg A) (220R)
5. Display pin 10 (Seg F) (220R)
6. Display pin 5 (Seg G) (220R)
7. Display pin 7 (Seg B) (220R)
8. GND

9. NC
10. VDD
11. STM8S pin 10
12. STM8S pin 18
13. GND
14. STM8S pin 5
15. Display pin 1 (Seg E) (220R)
16. VDD (3V3)

[LED]
- Anode: 3V3 (STM8 VDD)
- Catode: (1k) to Relay coil (5V for 110-220Vac version)
- - For 12/24V version: do not use the board without modifying the LED circuit.  Relay voltage can bounce back across the LED and damage the STM8 microcontroller

Source: https://www.aliexpress.com/item/1005001830924875.html

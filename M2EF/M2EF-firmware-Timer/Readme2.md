### Do not use this W1209 board without solving the LED problem
   - The 12V voltage can bounce back across the LED and damage the microcontroller. See more details in the main description:
   - Here: https://github.com/rtek1000/W1209-firmware-modified

### Firmware to use the W1209 board as a Programmable Timer

Adapted from [W1209-firmware-remote](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W1209-firmware-Remote) (Check communication information/Protocol)

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Remote/Doc/thermostat-w1209.jpg)

### Firmware usage

- There are 6 modes of operation (Looped or non-looped).
- Maximum time about 1000 minutes (about 16 hours and 40 minutes).
- Two-step timing (Times separated in minutes, seconds and milliseconds).
- Display automatically shows the most significant digits.
- Sensor input operating as a button.
- Remote Control (App Windows for tests).

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Timer/App_Windows/Doc/W1209%20Timer%20Test%20App%20Windows.png)

User's Guide:
- Button SET: Parameters adjust
- Buttons Up (+) and Down (-): Start/Restart timer
- NTC sensor input operating as a button: Start/Restart timer
- - (Same function of Buttons Up (+) and Down (-))
- - (Do not leave the NTC connected to the board)
- - (Leave disconnected if not using)

Parameters (Long press SET button):

- P0: Relay mode [0, 1, 2, 3, 4, 5]
- - Mode 0: The relay opens after a delay of T1 time, and ends
```
    ________
  _|   T1   |________________________________________________________
```

- - Mode 1: The relay closes after a delay of T1 time, and ends
```
             ________________________________________________________
  _____T1___|
```

- - Mode 2: The relay closes after a delay of T1 time, and then opens after a delay of T2, and ends
```
             ________
  _____T1___|   T2   |_______________________________________________
```

- - Mode 3: The relay opens after a delay of T1 time, then closes after a delay of T2 time, and ends
```
    ________          _______________________________________________
  _|   T1   |___T2___|
```

- - Mode 4: The relay closes after a delay of T1 time, and then opens after a delay of T2 time, loop
```
             ________          ________          ________          __
  _____T1___|   T2   |___T1___|   T2   |___T1___|   T2   |___T1___|
```

- - Mode 5: The relay opens after a delay of T1 time, and then closes after a delay of T2 time, and loops
```
    ________          ________          ________          ________
  _|   T1   |___T2___|   T1   |___T2___|   T1   |___T2___|   T1   |__
```


- P1: T1 minutes [0 ~ 999]
- P2: T1 seconds [0 ~ 59]
- P3: T1 milliseconds [0 ~ 999]

- P4: T1 minutes [0 ~ 999]
- P5: T1 seconds [0 ~ 59]
- P6: T1 milliseconds [0 ~ 999]
 
- P7: Lock Factory reset
- P8: Auto bright
- P9: Internal timer calibration (To allow more accurate timing)

-----------

### Similar board with IC SN74HC595:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Timer/Board_SN74HC595/Doc/Timer_SN74HC595.jpg)

More information: [here](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W1209-firmware-Timer/Board_SN74HC595)
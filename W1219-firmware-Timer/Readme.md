- Note: On this W1219 board, the LED is controlled independently of the relay.

- Note: This version of the board uses the SN74HC164D IC to drive the display segments.
- - Check pinout: [W1219-firmware-Dual-display](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W1219-firmware-Dual-display)

### Firmware to use the W1219 board as a Programmable Timer

Adapted from [W1209-firmware-Timer](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W1209-firmware-Timer)
- Check communication information/Protocol: [W1209-firmware-remote](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W1209-firmware-Remote) 

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1219-firmware-Timer/Doc/W1219_Displays.png)

### Firmware usage

- There are 6 modes of operation (Looped or non-looped).
- Maximum time about 1000 minutes (about 16 hours and 40 minutes).
- Two-step timing (Times separated in minutes, seconds and milliseconds).
- Display automatically shows the most significant digits.
- Remote Control (App (Windows) for tests).

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Timer/App_Windows/Doc/W1209%20Timer%20Test%20App%20Windows.png)

To-do:

- Add P9 parameter in Windows App
- Enable use of secondary display
- Test the remote communication

User's Guide:
- Button SET: Parameters adjust
- Buttons Up (+) and Down (-): Start/Restart timer

Parameters (Long press SET button):

- P0: Cycle mode [0, 1, 2, 3, 4, 5]
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

- P4: T2 minutes [0 ~ 999]
- P5: T2 seconds [0 ~ 59]
- P6: T2 milliseconds [0 ~ 999]
 
- P7: Lock Factory reset
- P8: Auto bright
- P9: Internal timer calibration (To allow more accurate timing)

Parameters table:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1219-firmware-Timer/Doc/Table_params_W1219_timer.png)

-----------

### M2EF - Similar board with IC SN74HC595:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/M2EF-firmware-Timer/Doc/M2EF-Timer_SN74HC595_1.png)

More information: [here](https://github.com/rtek1000/W1209-firmware-modified/tree/master/M2EF-firmware-Timer)

---------

Note: This library is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

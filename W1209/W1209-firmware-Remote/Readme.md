### Do not use this W1209 board without solving the LED problem
   - The 12V voltage can bounce back across the LED and damage the microcontroller. See more details in the main description:
   - Here: https://github.com/rtek1000/W1209-firmware-modified

### App Windows to test:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Remote/App_Windows/Doc/W1209_Remote_test.png)

- Added serial (9600 bauds) (normal hardware)
- RX: button (+) pin 14 (PC4) (supported by timer1)
- TX: button (-) pin 15 (PC5) (supported by timer2)
- Apparently functional

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Remote/Doc/thermostat-w1209.jpg)

------------------------

Communication protocol:
- 9600 bauds
- Serial TTL 5V
- RX: Button (+)
- TX: Button (-)

TX Data format: Pxddd.dccc
- P: start byte (always P)
- x: parameter reference (from A to J, plus T)
- d: parameter value (integer-dot-integer)
- c: checksum

RX Data format: Sxddd.dccc
- S: start byte (always S)
- x: parameter reference (from A to J, plus T)
- d: parameter value (integer-dot-integer)
- c: checksum

Automatic Data store (after 5 seconds)


Terminal monitor (putty):

```
PA000.0128 ---> P0: C1 (P A 000.0 128); C1: 000.0 (C2: 000.1; C3: 000.2; H1: 000.3); ccc: 128
PB000.0127 ---> P1: 0.0 (P B 000.0 127); 0.0: 000.0 (10.0: 010.0; -5.5: -05.5); ccc: 127
PC110.0124 ---> P2: 110.0 (P C 110.0 124); 0.0: 000.0 (1.2: 001.2; -5.5: -05.5); ccc: 124
PD109.7108 ---> P3
PE000.0124 ---> P4
PF000.0123 ---> P5
PG000.0122 ---> P6
PH000.0121 ---> P7: OFF (P H 000.0 121); OFF: 000.0 (ON: 000.1); ccc: 121
PI000.0120 ---> P8
PJ028.0109 ---> Threshold: 28.0 (P J 028.0 109); 28.0: 028.0; ccc: 109
PT024.4099 ---> Sensor: 24.4 (P T 024.4 099) 24.4: 024.4; ccc: 099 
```

- Checksum calculation:
- - Sum of ASCII character values (0 to 6).
- - Excludes bits above 8 bits (sum & 0xFF).
- - Invert bits using subtraction (0xFF - sum).
- - Separates hundreds (h), tens (t) and units (u) into 3 bytes (ccc: htu).
- - Add 48 to turn numerical values into ASCII.
- - The command can be done manually via the serial terminal, as long as the checksum matches the command.

(See source code: [remote.c](https://github.com/rtek1000/W1209-firmware-modified/blob/master/W1209/W1209-firmware-Remote/w1209-firmware-modified-eclipse-remote/Core/Src/remote.c) for W1209 Eclipse project)

```
	for (int i = 0; i <= 6; i++) {
		sum += buffer[i];
	}

	sum &= 0xFF;

	sum = 0xFF - sum;
```

- Check all info: [here](https://github.com/rtek1000/W1209-firmware-modified)
------------------------

Done:
- Add remote control using Serial port (Pins 14/15)
- - Emulated by EXTI and Timers
- - - More limited than using UART1

To-Do (to achieve higher communication speed):
- Add remote control using Serial port (Pins 5/6)
- - Need to change board tracks.
- - - UART1 RX and TX pins in use.
- Ckeck bug: initialization skips delay time to trigger relay for P0 parameter (H1/H2/H3)

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Remote/Doc/thermostat-w1209%20-%20Remote.jpg)

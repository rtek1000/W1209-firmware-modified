- App Windows to test:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Remote/App_Windows/Doc/W1209_Remote_test.png)

- Added serial (9600 bauds) (normal hardware)
- RX: button (+) pin 14 (PC4) (supported by timer1)
- TX: button (-) pin 15 (PC5) (supported by timer2)
- Apparently functional

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
PT024.4099
PA000.0128
PB000.0127
PC110.0124
PD109.7108
PE000.0124
PF000.0123
PG000.0122
PH000.0121
PI000.0120
PJ028.0109
PT024.4099
```

- Checksum calculation:
- - Sum of ASCII character values (0 to 6).
- - Excludes bits above 8 bits (sum & 0xFF).
- - Invert bits using subtraction (0xFF - sum).
- - Separates hundreds (h), tens (t) and units (u) into 3 bytes (ccc: htu).
- - Add 48 to turn numerical values into ASCII.
- - The command can be done manually via the serial terminal, as long as the checksum matches the command.

(See source code: [remote.c](https://github.com/rtek1000/W1209-firmware-modified/blob/master/W1209-firmware-Remote/w1209-firmware-modified-eclipse-remote/Core/Src/remote.c) for W1209 Eclipse project)

```
	for (int i = 0; i <= 6; i++) {
		sum += buffer[i];
	}

	sum &= 0xFF;

	sum = 0xFF - sum;
```


------------------------

To-Do (to achieve higher communication speed):
- Add remote control using Serial port (Pins 5/6)
- - Need to change board tracks.
- - - UART1 RX and TX pins in use.

- Add remote control using Serial port (Pins 14/15)
- - Emulated by EXTI and Timers
- - - More limited than using UART1


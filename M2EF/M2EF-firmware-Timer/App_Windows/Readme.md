![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209/W1209-firmware-Timer/App_Windows/Doc/W1209%20Timer%20Test%20App%20Windows.png)

- Added serial (9600 bauds) (normal hardware)
- RX: button (+) pin 14 (PC4) (supported by timer1)
- TX: button (-) pin 15 (PC5) (supported by timer2)
- Apparently functional

------------------------

To-Do (to achieve higher communication speed):
- Add remote control using Serial port (Pins 5/6)
- - Need to change board tracks.
- - - UART1 RX and TX pins in use.

- Add remote control using Serial port (Pins 14/15)
- - Emulated by EXTI and Timers
- - - More limited than using UART1


- Added serial (9600 bauds) (normal hardware)
- RX: button (+) pin 14 (PC4) (supported by timer1)
- TX: button (-) pin 15 (PC5) (supported by timer2)
- Not ready for use

To-Do:
- Add remote control using Serial port (Pins 5/6)
- - Need to change board tracks.
- - - UART1 RX and TX pins in use.

- Add remote control using Serial port (Pins 14/15)
- - Emulated by EXTI and Timers
- - - More limited than using UART1


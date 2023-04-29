### W1219 board:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1219-firmware-Dual-display/Doc/Dual_display.jpg)

Source: https://m.aliexpress.com/item/1005005223034816.html

Note: This version of the board uses the SN74HC164D IC to drive the display segments.

Pinout:

[SN74HC164D]
1. MCU pin 19 (Data A)
2. MCU pin 19 (Data B)
3. Disp pin 11 (Seg A)
4. Disp pin 3 (Seg DP)
5. Disp pin 2 (Seg D)
6. Disp pin 1 (Seg E)
7. GND

8. MCU pin 20 (Clock)
9. +5V
10. Disp pin 7 (Seg B)
11. Disp pin 5 (Seg G)
12. Disp pin 4 (Seg C)
13. Disp pin 10 (Seg F)
14. +5V


[STM8S003F3P6]
1. LED
2. NTC
3. Btn (-)
4. NRST
5. Btn (+)
6. Btn SET
7. GND
8. Vcap
9. +5V
10. Relay

11. NC
12. Disp 2 pin 8 (A3) (470R)
13. Disp 2 pin 9 (A2) (470R)
14. Disp 2 pin 12 (A1) (470R)
15. Disp 1 pin 8 (K3) (470R)
16. Disp 1 pin 9 (K2) (470R)
17. Disp 1 pin 12 (K1) (470R)
18. SWIM (ST-link)
19. HC164 pin 1 / pin 2
20. HC164 pin 8

----------

### W3230 - Alternative version (12V/24V/110V-220V):
![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W3230-firmware-Dual-display/Doc/W3230.png)

- P6: Maximum temperature [Off/-55~120]
- P7: Lock settings [On/Off]
- Button (-) long press: Factory reset
- Botton Restart long press: On/Off

More info [here](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W3230-firmware-Dual-display)


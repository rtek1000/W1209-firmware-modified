(W1219):

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Dual-display/Doc/Dual_display.jpg)

Source: https://m.aliexpress.com/item/1005005223034816.html

Alternative version W3230 (12V/24V/110V-220V):
![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Dual-display/Doc/Polish_20230403_122459081.jpg)

- P6: Maximum temperature [Off/-55~120]
- P7: Lock settings [On/Off]
- Button (-) long press: Factory reset
- Botton Restart long press: On/Off

Ref.: https://m.aliexpress.com/item/4001235406618.html

Display pin to MCU pin:

(Large display: common cathode)
1. 11 (220R)
2. 12 (220R)
3. 10 (220R)
4. 13 (220R)
5. 4 (220R)
6. NC
7. 8 (220R)
8. 19 (0R)
9. 9 (0R)
10. 18 (220R)
11. 5 (220R)
12. 1 (0R)

(Small display: common anode)
1. 11 (220R)
2. 12 (220R)
3. 10 (220R)
4. 13 (220R)
5. 4 (220R)
6. NC
7. 8 (220R)
8. 15 (0R)
9. 16 (0R)
10. 18 (220R)
11. 5 (220R)
12. 17 (0R)

Note: Display segment pins are connected together, using only one resistor for each segment.

Note: Pin 4 and pin 8 are used as GPIO so it's not a STM8S003F3P6.

Maybe it's an HC89S003A, see datasheet,
- Pin 4: SWD mode clock input
- Pin 18: SWD data input/output

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Dual-display/Doc/HC89S003A.png)

>Holychip is compatible with STM8S series of FLASH MCU products, with a complete product series, providing users with the best cost-effective solution. The full range of products have rich peripheral functions, integrate PWM, ADC, UART, SPI, I2C, LCD, support full mapping of peripheral function  pins, port four-level driver, online System Programming (ISP), and have high anti-interference ability (4KV ESD/ 4KV EFT) to meet the application needs of different markets. Users do not need to change the PCB and directly replace the STM8S105/103/005/003/001 series products. 

http://www.holychip.cn/en/product1.php?class_id=101101101

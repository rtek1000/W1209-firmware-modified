### W1219 board:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1219-firmware-Dual-display/Doc/Dual_display.jpg)

Source: https://www.aliexpress.com/item/1005005223034816.html

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

Note: The bottom (green) display is too bright, you may need to use 1k resistors instead of 470R (R1/R2/R3).
![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1219-firmware-Dual-display/Doc/W1219_Displays.png)

----------

If the STM8S003F3P6 is blocked when trying to program, this message should appear:

> target page is write protected (UBC) or read-out protection is enabled

[stm8flash (Linux)]:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Timer/Doc/MCU_write_protected.png)

[STVP (Windows)]:

![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W1209-firmware-Timer/Doc/Chip_protected.png)


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

----------

### W3230 - Alternative version (12V/24V/110V-220V):
![image](https://raw.githubusercontent.com/rtek1000/W1209-firmware-modified/master/W3230-firmware-Dual-display/Doc/W3230.png)

- P6: Maximum temperature [Off/-55~120]
- P7: Lock settings [On/Off]
- Button (-) long press: Factory reset
- Botton Restart long press: On/Off

More info [here](https://github.com/rtek1000/W1209-firmware-modified/tree/master/W3230-firmware-Dual-display)


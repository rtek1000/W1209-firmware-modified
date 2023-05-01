Note:
- The example codes are compiled with the Keil C51 IDE, but apparently the free version can generate a binary file only 2k in size.
- SDCC can compile Keil C51 projects, see these tips:
- - [Migrate from Keil to SDCC](https://charleeli.medium.com/migrate-from-keil-to-sdcc-dd3362c087a7)

> Migration
> 
> Then I tried to compile my source code. My Keil project has two C files: main.c and tm1638.c . According to the SDCC document, the supporting files should be compiled with -c option and then linked to the main program:
> 
> ```
> > sdcc -c tm1638.c
> > sdcc main.c tm1638.rel
> ```
> 
> I tried to run these two commands and fixed some incompatibilities between Keil and SDCC. The differences are:
> 
> - Customized header files must be included with double quotes. For example, my project has a tm1638.h in the same directory with the main.c . In Keil #include <tm1638.h> works, but in SDCC, it must be written as #include "tm1638.h" .
> 
> - The 8051 header file has a different name. In Keil we use #include <reg52.h> but in SDCC we use #include <8052.h>.
> 
> - The sbit, sfr in Keil correspond to the __sbit, __sfr in SDCC. In Keil we use sfr P0 = 0x80; sbit P0_1 = P0 ^ 1; while in SSDC we use __sfr __at (0x80) P0; __sbit __at (0x81) P0_1; . See the [document](http://sdcc.sourceforge.net/doc/sdccman.pdf) for details.
> 
> - Most of the time we don’t need to use __sfr to define the ports. 8052.h has already defined common ports for us, so we simply need to give them readable name using macro. For example: #define DIO P1_0
> 
> - The [code](https://www.keil.com/support/man/docs/c51/c51_le_pgmmem.htm) keyword in Keil correspons to the __code in SDCC. So what we’ve done in Keil unsiged char code sevenseg_hex[] = {...}; must be written as __code unsigend char sevenseg_hex[] = {...}; in SSDC.
> 
> - interrupt in Keil becomes __interrupt. So use the following code to define an interrupt handler: void timer0() __interrupt 1 { ... }
> 
> With these modifications my code compiled pretty well, and successfully generated main.ihx file. Then I only need to convert it to hex format with the following command:
> 
> `> packihx main.ihx > main.hex`
> 
> And this hex file can be downloaded and works correctly!

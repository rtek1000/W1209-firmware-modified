//WDT reset example

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

void Delay_ms(unsigned int fui_i);	 //delay function

unsigned char gui_i = 0;			 //LED flip count

/***************************************************************************************
  * @Function	WDT is set to watchdog mode, LED1 flashes 5 times after power-on, if not feeding the watchdog, the chip resets after 5.93s
***************************************************************************************/
void main()
{
/************************************system initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 

/************************************WDT initialization*****************************************/
    P0M0 = P0M0&0xF0|0x08;				//Set P00 as push-pull output
	WDTC = 0x57;						//Allow WDT reset, allow operation in power-down/idle mode, divide by 1024

	//Internal RC44K is used as WDT clock, WDT_CLOCK_1024 is divided by 1024, the initial value is 0xFF
	//Timing 	= 1024 * 0xFF / 44000
	//			    = 5.93s

	WDTCCR = 0xFF;						//When 00 is written, the WDT function will be disabled (but not the internal low-frequency RC),
										//which is equivalent to disabling WDT. When non-zero data is written, WDT will be started.
	for(gui_i=10;gui_i>0;gui_i--)
	{
			P0_0 =~ P0_0;   			        
			Delay_ms(250);
	}
	while(1)
	{
//			WDTC |= 0x10;              //Clear the watchdog
	}
}

/**
  * Delay function 
  * Fcpu = 16MHz,fui_i = 1,The delay time is about 1Ms
  */
void Delay_ms(unsigned int fui_i)
{
	unsigned int fui_j;
	for(;fui_i > 0;fui_i --)
	for(fui_j = 1596;fui_j > 0;fui_j --);
}
//Wake up from power down mode

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

void Delay_ms(unsigned int fui_i);//delay function

/***************************************************************************************
  * @Function	WDT is set to timing mode, the timing is 500Ms, P00 flips after entering the interrupt
***************************************************************************************/
void main()
{
/************************************system initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
	P0M0 = P0M0&0xF0|0x08;				//Set P00 as push-pull output
/***********************************WDT  initialization**************************************/
	FREQ_CLK = 0x10;					//This example involves low power consumption and needs to specify the system clock
	WDTC = 0x14;					    //Disable WDT reset, allow operation in power-down/idle mode, divide by 128
	Delay_ms(1);						//When using WDT to wake up from power-down mode,
                                     	//the interval between the clear the watchdog action and the power-down command is greater than or equal to 3 wdt_clk (about 70us)
	
	//Internal RC44K is used as WDT clock, WDT_CLOCK_1024 is divided by 1024, the initial value is 0xFF
	//Timing 	= 128 * (0xAB+1) / 44000
	//			= 500.36Ms

	WDTCCR = 0xAB;                      //When 00 is written, the WDT function will be disabled (but not the internal low-frequency RC),
										//which is equivalent to disabling WDT. When non-zero Data is written, WDT will be started.	
	IE |= 0x20;							//Turn on WDT Interrupt
	EA = 1;								//Open total Interrupt
	while(1)
	{
		PCON |= 0x02;					//Enter power down mode
	}
}

/***************************************************************************************
 WDT interrupt service function
***************************************************************************************/
void WDT_Rpt() interrupt WDT_VECTOR
{
	WDTC &=~ 0x20;						    //Clear flag Bit
	P0_0 =~ P0_0;
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
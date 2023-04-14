//RTC mode

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	T3 uses an external 32K crystal oscillator, wakes up in 1s at a time, LED1 flips after wake up
***************************************************************************************/
void main()
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
	P0M0 = P0M0&0xF0|0x08;              //Set P00 as push-pull output	
/**********************************TIM3 initialization**************************************/
	FREQ_CLK = 0x10;					//This routine involves the power-down mode, you need to specify the current system clock
    CLKCON |= 0x04;

	//T3 Timing 1s  = (65536 - 0x8000) * (1 / External input clock)
	//				= 32768 / (32768 / 1)
	//				= 1s

	//Timing 1s
	//Reverse initial value  = 65536 - (1 / (1 / External input clock))
	//			= 65536 - (1 / (1 / 32768))
	//          = 65536 - 32768
	//			= 0x8000

	TH3 = 0x80;
	TL3 = 0x00;	 						 //Timing time is calculated according to external clock
	T3CON = 0x46;						 //Allow operation in power-down mode, clock divided by 1
	IE1 |= 0x02;					  	 //Turn on T3 Interrupt
	EA = 1;								 //Open total Interrupt
	while(1)
	{
		 PCON |= 0x02;				     //Enter power down mode
	}
}

/***************************************************************************************
 T3 interrupt service function
***************************************************************************************/
void TIMER3_Rpt(void) interrupt T3_VECTOR
{
	 T3CON &=~ 0x80;					 //Clear T3-flag bit
	 P0_0 =~ P0_0;
}

//clock configuration


#define	ALLOCATE_EXTERN
#include "HC89S003F4.h"

void Delay_ms(unsigned int fui_i);		//delay function

/**************************************************************************************
  * @Function	Set FOSC to 16MHz and fcpu to 16MHz
**************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
	P0M0 = P0M0&0xF0|0x08;		//Set P00 as push-pull output

	while(1)
	{
		P0_0 =~ P0_0;
		Delay_ms(250);
	}
}

/**
  * Delay function 
  * Fcpu = 16MHz,fui_i = 1,The delay time is about 1ms
  */
void Delay_ms(unsigned int fui_i)
{
	unsigned int fui_j;
	for(;fui_i > 0;fui_i --)
	for(fui_j = 1596;fui_j > 0;fui_j --);
}
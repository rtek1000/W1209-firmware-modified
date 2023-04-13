//RST-Reset mode judgment

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

unsigned char guc_Count = 0;            //IO Count
void Delay_ms(unsigned int fui_i);		//Delay function

/***************************************************************************************
  * @Function	Determine whether the system is a POR reset or an external RST reset, if it is a POR reset, 
                LED1 flashes, if it is an external RXT reset LED2 flashes
  * @Note	    Need to set P27 port as reset pin in code option
***************************************************************************************/
void main()
{
/************************************System initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
	P0M0 = P0M0&0xF0|0x08;				//Set P00 as push-pull output
	P1M0 = P1M0&0xF0|0x08;				//Set P10 as push-pull output
/***********************************Reset flag judgment***************************************/
	if(RSTFR&0x80)						            //Determine whether it is POR reset
	{
		RSTFR = 0x00;					            //Clear reset flag
		for(guc_Count=0;guc_Count<10;guc_Count++)
		{
			P0_0 =~ P0_0;
			Delay_ms(250);
		}	
	}
	if(RSTFR&0x40)						            //Determine whether it is an external RST reset
	{
		RSTFR &=~ 0x40;					            //Clear the external RST reset flag
		for(guc_Count=0;guc_Count<10;guc_Count++)
		{
			P1_0 =~ P1_0;
			Delay_ms(250);
		}	
	}	
	while(1);
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
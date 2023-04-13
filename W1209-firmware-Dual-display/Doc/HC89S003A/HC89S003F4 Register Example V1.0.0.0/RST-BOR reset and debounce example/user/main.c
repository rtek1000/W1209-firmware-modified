//BOR reset and debounce

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

unsigned char guc_Count = 0;            //IO Count
void Delay_ms(unsigned int fui_i);	  	//Delay function

/***************************************************************************************
  * @Function	After the system is powered on, P00 flips 5 times, and it is detected that the system voltage is lower than 3.6V and the duration exceeds 127.625us,
                the system resets, and P00 flips again
***************************************************************************************/
void main()
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
	P0M0 = P0M0&0xF0|0x08;				//Set P00 as push-pull output
/***********************************BOR initialization**************************************/
	BORC = 0xC5;						            //BOR enable, BOR debounce enable, detection voltage point 3.6V
	//BOR debounce time calculation
	//Debounce time = BORDBC[7:0] * 8Tcpu + 2Tcpu
	//		   = 255 * 8 * 0.0625us + 2 * 0.0625us
	//		   = 127.625us

	BORDBC = 0xFF;						            //BOR voltage detection debounce time 127.625us
	for(guc_Count=0;guc_Count<10;guc_Count++)
	{
		P0_0 =~ P0_0;
		Delay_ms(250);
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
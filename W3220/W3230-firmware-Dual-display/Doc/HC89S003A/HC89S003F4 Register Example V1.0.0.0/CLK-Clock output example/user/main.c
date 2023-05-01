
//clock output

#define	ALLOCATE_EXTERN
#include "HC89S003F4.h"

/**************************************************************************************
  * @Function	Set FOSC to 16MHz and fcpu to 16MHz,then output the internal high frequency
            	RC/8 clock through port P00
**************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz  
/**************************************************************************************/
	P0M0 = P0M0&0xF0|0x08;		//Set P00 as push-pull output
	CLKO_MAP = 0x00;		     	//clock output,map to port P00
	CLKOUT = 0x17;						//Enable internal high frequency clock 8 frequency division output
	while(1);
}
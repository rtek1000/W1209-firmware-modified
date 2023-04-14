
//check port debounce

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	Set the debounce time of port p00£¬251.9375us < debounce time <255.9375us¡£
***************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz  
/**********************************port debounce initialization**************************************/
  P0M0 = P0M0&0xF0|0x02;    //Set P00 as push-pull output
	P00DBC = 0xFF;						//Set debounce time
	//Calculation of debounce time
	//PRESCALER*Tosc*P0xDBCT[5:0]-Tosc < debounce time < PRESCALER*Tosc*(P0xDBCT[5:0]+1)-Tosc
	//		  64*0.0625us*63-0.0625us < debounce time < 64*0.0625us*(63+1)-0.0625us
	//					   251.9375us < debounce time < 255.9375us

	while(1);
}
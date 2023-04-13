//PWR-Power down mode

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	After the system is initialized, the chip enters power-down mode
***************************************************************************************/
void main()
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz
/***********************************Enter power down mode***************************************/
	FREQ_CLK = 0x10;					//This routine involves the power-down mode, you need to specify the current system clock	
    BORC &=~ 0x80;                      //Turn off BOR to save power
	ADCC0 |= 0x03;
	PCON |= 0x02;						//Enter power down mode
	while(1);	
}
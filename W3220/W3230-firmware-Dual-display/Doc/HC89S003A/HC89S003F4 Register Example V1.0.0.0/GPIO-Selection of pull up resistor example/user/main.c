
//Selection of pull up resistor

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	Set the pull-up resistance of port P02 to 100k
***************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz  
/***********************************Set the pull-up resistor***************************************/
	P0M1 = P0M1&0xF0|0x02;		//Set P02 as pull-up input
	P0LPU |= 0x10;						//Set the pull-up resistance of port P02 to 100k
	while(1);
}
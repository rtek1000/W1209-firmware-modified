
//Set the working state of IO port 

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	Set the working state of each IO port
***************************************************************************************/
void main()
{
/************************************system initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
/***********************************IO port mode setting***************************************/
	P0M1 = P0M1&0xF0|0x00;				//Set P02 as input(non SMT)
	P0M0 = P0M0&0x0F|0x10;				//Set P01 as pull-down input(non SMT)
	P0M0 = P0M0&0xF0|0x02;				//Set P00 as pull-up input(non SMT)
	P1M0 = P1M0&0x0F|0x30;				//Set P11 as analog input
	P2M0 = P2M0&0xF0|0x04;				//Set P20 as input(SMT)
	P0M2 = P0M2&0x0F|0x50;				//Set P05 as pull-down input(SMT)
	P0M2 = P0M2&0xF0|0x06;				//Set P04 as pull-up input(SMT)
	P0M3 = P0M3&0x0F|0x80;				//Set P07 as push-pull output
	P0M3 = P0M3&0xF0|0x09;				//Set P06 as Open drain output
	P2M1 = P2M1&0xF0|0x0A;				//Set P22 as pull-up Open drain output
	while(1);
}
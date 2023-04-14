
//external interrupt 15

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	P27 is set to the falling edge interrupt, and LED1 status changes once 
	            after each interrupt
***************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz
/**********************************GPIO initialization**************************************/
	P0M0 = P0M0&0xF0|0x08;		//Set P00 as push-pull output
/***********************************INT15 initialization****************************************/
	P2M3 = P2M3&0x0F|0x40;		//Set P27 as pull-up input(SMT)
	PITS3 |= 0x40;						//INT15 Falling edge
	PINTE1 |= 0x80;						//enable INT15
	IE1 |= 0x80;						  //enable INT15 interrupt
	EA = 1;								    //enable all interrupt
	while(1);
}

/***************************************************************************************
   INT15 interrupt service function
***************************************************************************************/
void INT8_15_Rpt() interrupt INT8_15_VECTOR 
{
	if(PINTF1&0x80)
	{
		PINTF1 &=~ 0x80;				//Clear flag bit	
		P0_0 =~ P0_0;
	}
}
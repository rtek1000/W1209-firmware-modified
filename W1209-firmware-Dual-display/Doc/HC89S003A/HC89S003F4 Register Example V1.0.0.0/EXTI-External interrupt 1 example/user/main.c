
//external interrupt 1

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	P11 is set to the falling edge interrupt, and LED1 status changes once after each interrupt
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
/**********************************INT1 initialization**************************************/
	P1M0 = P1M0&0x0F|0x60;		//Set P11 as pull-up input(SMT)
	INT01_PINS |= 0x02;				//INT1 Select P11
	PITS0 |= 0x04;						//INT1 Falling edge
	IE |= 0x04;							  //enable INT1 interrupt
	EA = 1;								    //enable all interrupt
	while(1);
}

/***************************************************************************************
   INT1 interrupt service function
***************************************************************************************/
void INT1_Rpt() interrupt INT1_VECTOR 
{
	PINTF0 &=~ 0x02;					//Clear flag bit
	P0_0 =~ P0_0;				
}

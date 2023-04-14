
//external interrupt 1 ( debounce )

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	P01 is set to the falling edge interrupt, and the jitter elimination time 
	            is set.After each interrupt, LED1 status changes once
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
	P0M0 = P0M0&0x0F|0x60;		//Set P01 as pull-up input(SMT)
	P01DBC = 0xFF;						//Set debounce time
	//Calculation of debounce time
	//PRESCALER*Tosc*P0xDBCT[5:0]-Tosc < debounce time < PRESCALER*Tosc*(P0xDBCT[5:0]+1)-Tosc
	//		  64*0.0625us*63-0.0625us < debounce time < 64*0.0625us*(63+1)-0.0625us
	//					   251.9375us < debounce time < 255.9375us
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

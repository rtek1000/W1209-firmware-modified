//T0 Timer mode

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	T0 timing 1ms, every time an interrupt is entered, P00 flips once
***************************************************************************************/
void main()
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
	P0M0 = P0M0&0xF0|0x08;              //Set P00 as push-pull output
/**********************************TIM0 initialization**************************************/
	TCON1 = 0x00;						//The clock of Tx0 timer is Fosc
	TMOD = 0x00;						//16-bit reload timer/counter

	//T0 Timing 1ms = (65536 - 0xFACB) * (1 / (Fosc /Timer division factor))
	//				= 1333 / (16000000 / 12)
	//				= 1 ms

	//Timing 1ms
	//Reverse initial value	= 65536 - ((1/1000) / (1/(Fosc / Timer division factor)))
	//		   	= 65536 - ((1/1000) / (1/(16000000 / 12)))
	//			= 65536 - 1333
	//			= 0xFACB
	TH0 = 0xFA;
	TL0 = 0xCB;							  //T0 Timing 1ms
	IE |= 0x02;							  //Turn on T0 Interrupt
	TCON |= 0x10;						  //Start T0
    
	EA = 1;								  //Open total Interrupt
	while(1);
}

/***************************************************************************************
 T0 interrupt service function
***************************************************************************************/
void TIMER0_Rpt(void) interrupt TIMER0_VECTOR
{ 
	u16 count;
	count++;
	if(count>=100)
	{
		 count=0;
	   P0_0 =~ P0_0;
	}
}
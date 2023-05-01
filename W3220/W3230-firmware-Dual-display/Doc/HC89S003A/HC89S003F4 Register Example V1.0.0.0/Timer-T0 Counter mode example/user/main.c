//T0 Counter mode

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	Set T0 to counter mode, when P11 detects a falling edge, the count overflows and enters the interrupt, and P00 flips
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
    P1M0 = P1M0&0x0F|0x20;              //Set P11 as pull-up input     
	T0_MAP = 0x11;						//T0 mapping P11
	TCON1 |= 0x01;						//T0 clock , divided by 1
	TMOD |= 0x04;						//T0 counter mode
	TH0 = 0xFF;							
	TL0 = 0xFE;							//Pulse is 1
	IE |= 0x02;							//Turn on T0 Interrupt
	TCON |= 0x10;						//Start T0
    
	EA = 1;								//Open total Interrupt
	while(1);
}

/***************************************************************************************
 T0 interrupt service function
***************************************************************************************/
void TIMER0_Rpt(void) interrupt TIMER0_VECTOR
{
	P0_0 =~ P0_0;
}
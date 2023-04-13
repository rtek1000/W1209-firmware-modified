//T4 external trigger timing

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	P11 detects a falling edge, enters interrupt after timing 1s, P00 flips
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
/**********************************TIM4 initialization**************************************/
    P1M0 = P1M0&0x0F|0x20;              //Set P11 as pull-up input    
	T4_MAP = 0x11;	 					//External trigger port mapping P11

	//T4 Timing 1s 	= (65536 - 0x0BDC) * (1 / (Fosc /Timer division factor))
	//				= 62500 / (16000000 / 256)
	//				= 1s

	//Timing 1s
	//Reverse initial value = 65536 - (1 / (1/(Fosc / Timer division factor)))
	//		   	= 65536 - (1 / (1/(16000000 / 256)))
	//			= 65536 - 62500
	//			= 0x0BDC

	TH4 = 0x0B;
	TL4 = 0xDC; 						 //Timing 1s
	T4CON = 0x7E;						 //Falling edge trigger, divided by 256
	IE1 |= 0x04;						 //Turn on T4 Interrupt
	EA = 1;								 //Open total Interrupt
	while(1);
}

/***************************************************************************************
 T4 interrupt service function
***************************************************************************************/
void TIMER4_Rpt(void) interrupt T4_VECTOR
{
	T4CON &=~ 0x80;						 //Clear T4-flag bit
	P0_0 =~ P0_0;
}
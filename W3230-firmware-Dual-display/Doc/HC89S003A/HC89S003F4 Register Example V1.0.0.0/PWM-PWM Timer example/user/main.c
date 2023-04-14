//PWM Timer

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	Set PWM0 to timer mode, enter an interrupt every 32.76Ms, P00 level flips
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
/**********************************PWM initialization**************************************/
	PWM0C = 0x83;						//PWM clock divided by 128, open Interrupt

	//After the cycle count is completed, a PWM Interrupt will be generated, and the precise 
	//timing function can be realized by setting the cycle Register
	//Period calculation 	= 0x0FFF / (Fosc / PWM frequency division factor)
	//			= 0x0FFF /(16000000 / 128)
	// 			= 4095 	/125000
	//			= 32.76Ms	 (Timed time)
    
	PWM0PH = 0x0F;						//The upper 4 bits of the period Register are 0x0F
	PWM0PL = 0xFF;						//The lower 8 bits of the period Register are 0xFF
	PWM0EN = 0x0F;						//Enable PWM

	EA = 1;								//Open total Interrupt
	while(1);
}

/***************************************************************************************
 PWM interrupt service function
***************************************************************************************/
void PWM_Rpt(void) interrupt PWM_VECTOR
{
	P0_0 =~ P0_0;
	PWM0C &=~ 0x40;						//Clear flag Bit
}
//PWM-1 independent PWM output (8 bits)

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	P22 port output frequency is 15.69KHz, duty cycle is 34% square wave
***************************************************************************************/
void main()
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
/************************************PWM3 initialization****************************************/
	P2M1 = P2M1&0xF0|0x08;		        //Set P22 as push-pull output
	PWM3_MAP = 0x22;					//PWM3 channel mapping P22 port
	//Period calculation = 0xFF / (Fosc / PWM frequency division factor)
	//			= 0xFF /(16000000 / 4)			
	// 			= 255 /4000000
	//			= 63.75us £¨15.69KHZ£©		

	PWM3P = 0xFF;						//PWM period is 0xFF
	//Effective level time calculation£¨Duty cycle£© 	
	//			= 0x55 / (Fosc / PWM frequency division factor)	
	//			= 0x55 /(16000000 / 4)			
	// 			= 85 /4000000
	//			= 21.25us		duty cycle: 21.25 / 63.75 = 34%

	PWM3D = 0x55;						//PWM duty cycle
	PWM3C = 0x92; 						//Enable PWM3, disable Interrupt, allow PWM output, clock divided by 4
	
  while(1);
}
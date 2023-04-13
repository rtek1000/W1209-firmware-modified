//PWM-1 group 2 independent PWM outputs (12 bits) 

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	P22, P11 output frequency is 1.955KHz, duty cycle is 33.3% square wave
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
    P1M0 = P1M0&0xF0|0x08;              //Set P01 as push-pull output
	
	PWM0_MAP = 0x22;					//PWM0 channel mapping P22 port
	PWM01_MAP = 0x10;					//PWM01 channel mapping P10 port
    PWM0C = 0x01;					  	//Both PWM0 and PWM01 are active high, and the clock is divided by 8

	//In independent mode, PWM0 and PWM01 share a period register
	//PWM0 duty cycle adjustment			Duty Cycle Register of PWM0 Group
	//PWM01 duty cycle adjustment			Dead zone register of PWM0 group

	//Period calculation = 0x03ff / (Fosc / PWM frequency division factor)
	//			= 0x03ff / (16000000 / 8)			
	// 			= 1023   /2000000
	//			= 511.5us		  £¨1.955kHz£©

	PWM0PH = 0x03;						//The upper 4 bits of the period are set to 0x03
	PWM0PL = 0xFF;						//The lower 8 bits of the period are set to 0xFF

	//Duty cycle calculation = 0x0155 / (Fosc / PWM frequency division factor)
	//			= 0x0155 / (16000000 / 8)			
	// 			= 341 	 / 2000000
	//			= 170.5us		   Duty cycle£º 170.5/511.5 = 33.3%

	PWM0DH = 0x01;						//PWM0 high 4-bit duty cycle 0x01
	PWM0DL = 0x55;						//PWM0 low 8-bit duty cycle 0x55
	PWM0DTH = 0x01;						//PWM01 high 4-bit duty cycle 0x01
	PWM0DTL = 0x55;						//PWM01 low 8-bit duty cycle 0x55
	PWM0EN = 0x0F;						//Enable PWM0, work in independent mode
	
	while(1);
}
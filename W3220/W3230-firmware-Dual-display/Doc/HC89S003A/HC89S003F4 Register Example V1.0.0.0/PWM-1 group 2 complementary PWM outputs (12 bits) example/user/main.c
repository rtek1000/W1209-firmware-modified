//PWM-1 group 2 complementary PWM outputs (12 bits) 

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	The output frequency of P22 and P10 is 1.955KHz, the duty cycle is 33.4% square wave, 
                two complementary outputs, the dead time is 18.5us.
***************************************************************************************/
void main()
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
/************************************PWM initialization****************************************/
	P2M1 = P2M1&0xF0|0x08;	        	//Set P22 as push-pull output
	P0M0 = P0M0&0x0F|0x80;              //Set P01 as push-pull output

	PWM0_MAP = 0x22;					//PWM0 channel mapping P22 port
	PWM01_MAP = 0x01;					//PWM01 channel mapping P01 port	
    PWM0C = 0x01;						//Both PWM0 and PWM01 are active high, and the clock is divided by 8 

	//Complementary mode: In complementary mode, the valid period of PWM0 is the duty cycle period, 
	//and the valid period of PWM01 is the duty cycle complementary period

	//Period register of PWM0 group     	Adjust the period of the PWM group
	//Duty Cycle Register of PWM0 Group 	Adjust the duty cycle of the PWM group
	//Dead zone register of PWM0 group  	Adjust the dead time of the PWM group

	//Period calculation = 0x03ff / (Fosc / PWM frequency division factor)	
	//			= 0x03ff /(16000000 / 8)			
	// 			= 1023 	/2000000
	//			= 511.5us		(1.955KHZ)
	PWM0PH = 0x03;						//The upper 4 bits of the period are set to 0x03
	PWM0PL = 0xFF;						//The lower 8 bits of the period are set to 0xFF

	//Duty cycle calculation = 0x0155 / (Fosc / PWM frequency division factor)	
	//			= 0x0155 /(16000000 / 8)			
	// 			= 341 	 /2000000
	//			= 170.5us		   Duty cycle£º 170.5/511.5 = 33.4%
	PWM0DH = 0x01;						//PWM0, PWM01 high 4-bit duty cycle 0x01
	PWM0DL = 0x55;						//PWM0, PWM01 low 8-bit duty cycle 0x55

	//The dead zone adjusts the reduced time of PWM01 relative to PWM0.
	//Dead zone calculation	= 0x025  / (Fosc / PWM frequency division factor)
	//			= 0x025  /(16000000 / 8)			
	// 			= 37 	 /2000000
	//			= 18.5us		  
	
	PWM0DTH = 0x00;						//PWM01 high 4-bit dead time 0x00
    PWM0DTL = 0x25;					    //PWM01 low 8-bit dead time 0x25
	PWM0EN = 0x07;						//Enable PWM0, work in complementary mode
    
	while(1);
}
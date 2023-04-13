//PWM error detection

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	P22, P10 output a square wave with a frequency of 1.955KHz and a duty cycle of 33.4%. 
                If P02 inputs a low level, P22, P10 output a high level  
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
/*************************************PWM initialization****************************************/
	P2M1 = P2M1&0xF0|0x08;		        //Set P22 as push-pull output
	P1M0 = P1M0&0xF0|0x08;              //Set P10 as push-pull output
	P0M1 = P0M1&0xF0|0x02;              //Set P02 as pull-up input
	PWM2_MAP = 0x22;					//PWM2 channel mapping P22 port
	PWM21_MAP = 0x10;					//PWM21 channel mapping P10 port
	PWM2C = 0x01;						//PWM clock divided by 8

	//Period calculation = 0x03ff / (Fosc / PWM frequency division factor)
	//			= 0x03ff /(16000000 / 8)			
	// 			= 1023 	/2000000
	//			= 511.5us		      about 1.955KHZ
	PWM2PH = 0x03;						//The upper 4 bits of the period Register are 0x03
	PWM2PL = 0xFF;						//The lower 8 bits of the period Register are 0xFF

	//Duty cycle calculation = 0x0155 / (Fosc / PWM frequency division factor)	
	//			= 0x0155 /(16000000 / 8)			
	// 			= 341 	 /2000000
	//			= 170.5us		      duty cycle: 170.5/511.5 = 33.4%
	PWM2DH = 0x01;						//The upper 4 bits of the duty cycle Register are 0x01
	PWM2DL = 0x55;						//The lower 8 bits of the duty cycle Register are 0x55
	PWM2EN = 0x77;						//Work in complementary mode, output high level when fault occurs
    
	while(1);
}
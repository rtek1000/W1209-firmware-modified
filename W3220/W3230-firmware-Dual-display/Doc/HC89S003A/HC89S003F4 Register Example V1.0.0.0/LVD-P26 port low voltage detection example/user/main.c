
//P26 port low voltage detection

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

/***************************************************************************************
  * @Function	When the voltage is lower than 1.2V and the duration is more than 16.0625us,
            	LVD will be interrupted and LED1 will turn over.
  * @Operation This example cannot be simulated, and the simulator needs to be pulled out 
	            for testing.
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
/***********************************LVD initialization**************************************/
	P2M3 = P2M3&0xF0|0x03;		//Set P26 as analog input
	LVDC = 0xE8;						  //SET LVD
	//	debounce time = 	(0xFF + 2) * 1/Fcpu
	//			 =	(0xFF + 2) / 16000000	
	//			 =	16.0625us
	//	Now the program detects the voltage of p2.6 port, which is a fixed voltage point£¨1.2V£©
	LVDDBC = 0xFF;						//Set debounce time
    
	EA = 1;								    //enable all interrupt
	while(1);
}

/***************************************************************************************
   Lvd interrupt service function
***************************************************************************************/
void LVD_Rpt() interrupt LVD_VECTOR
{
	if(LVDC&0x08)
	{	
		 LVDC &=~ 0x08;			  //Clear LVD interrupt flag bit  
		 P0_0 =~ P0_0;
	}
}

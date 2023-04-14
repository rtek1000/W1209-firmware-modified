
//switching between internal high frequency clock and external high frequency clock

#define	ALLOCATE_EXTERN
#include "HC89S003F4.h"

void Delay_ms(unsigned int fui_i);		//delay function

unsigned char guc_i = 0;				      //Count the change times of P00

/***************************************************************************************
  * @Function	switching between internal high frequency clock and external high frequency 
	            clock,When fcpu is internal high frequency RC,LED flicker faster, When fcpu 
							is external high frequency RC,LED flicker slowly.			
***************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz   
	P0M0 = P0M0&0xF0|0x08;	  //Set P00 as push-pull output

	while(1)
	{
		for(guc_i=10;guc_i>0;guc_i--)
		{
			P0_0 =~ P0_0;
			Delay_ms(250);
		}
		CLKCON |= 0x04;				           	//enable external crystal oscillator
		XTALCFG |= 0x01;			           	//external crystal oscillator chooses high frequency crystal oscillator
		while((CLKCON&0x80)!=0x80);		    //wait for the external high frequency RC to start oscillation
		CLKSWR = 0xF0;					          //select external crystal oscillator as system clock
		while((CLKSWR&0xC0)!=0xC0);		    //Wait for the system clock to switch to external high frequency crystal oscillator
		CLKCON &=~ 0x02;				          //close internal high frequency RC
		for(guc_i=10;guc_i>0;guc_i--)
		{
			P0_0 =~ P0_0;
			Delay_ms(250);
		}
		CLKCON |= 0x02;					          //enable internal high frequency RC
		while((CLKCON&0x20)!=0x20);		    //Wait for the internal high frequency RC to start oscillation
		CLKSWR = 0x51;					          //Fosc/2£¬Fosc=16MHz
		while((CLKSWR&0xC0)!=0x40);		    //Wait for the system clock to switch to internal high frequency RC
		CLKDIV = 0x01;				          	//Fosc/1£¬Fcpu=16MHz  
	}
}

/**
  * Delay function 
  * Fcpu = 16MHz,fui_i = 1,The delay time is about 1ms
  */
void Delay_ms(unsigned int fui_i)
{
	unsigned int fui_j;
	for(;fui_i > 0;fui_i --)
 	for(fui_j = 1596;fui_j > 0;fui_j --);
}

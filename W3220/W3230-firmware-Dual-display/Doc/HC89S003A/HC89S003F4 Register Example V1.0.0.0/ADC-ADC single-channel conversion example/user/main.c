
//ADC single-channel conversion example

#define	ALLOCATE_EXTERN
#include "HC89S003F4.h"

void Delay_2us(unsigned int fui_i);		//delay function
			
unsigned int gui_AdcValue = 0;			  //Save the ADC value

/***************************************************************************************
  * @Function	ADC conversion for channel 0
***************************************************************************************/
void main()
{
/************************************system initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
	P0M0 = P0M0&0xF0|0x08;		//Set P00 as push-pull output
	
/************************************ADC initialization*****************************************/
	P0M0 = P0M0&0x0F|0x30;		//Set P01 as analog input
	ADCC0 = 0x80;						  //enable ADC power
	Delay_2us(10);					 	//delay 20us
	ADCC1 = 0x01;						  //Select external channel 1
	ADCC2 = 0x4D;						  //12bits, Right alignment of data, adc_clk frequency = Fosc/16 

	while(1)
	{
		ADCC0 |= 0x40;					//Start ADC
		while(!(ADCC0&0x20));		//Wait for the ADC conversion to complete
		ADCC0 &=~ 0x20;					//Clear flag bit
		gui_AdcValue = ADCR;		//Get the value of the ADC

		if(gui_AdcValue <= 0x10)
    {
		    P0_0 = 1;
		   }
		else
     {
		    P0_0 = 0;
		   }
	}
}

/**
  * Delay function 
  * Fcpu = 16MHz,fui_i = 1,The delay time is about 2us
  */
void Delay_2us(unsigned int fui_i)
{
	while(fui_i--);	
}
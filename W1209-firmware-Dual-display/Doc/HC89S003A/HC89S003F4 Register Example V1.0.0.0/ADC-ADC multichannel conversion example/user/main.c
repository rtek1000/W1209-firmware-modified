
//ADC multichannel conversion example

#define	ALLOCATE_EXTERN
#include "HC89S003F4.h"
			
void Delay_2us(unsigned int fui_i);		                  //delay function
			
unsigned int  gui_AdcValue_a[2] = {0x00};               //delay function
unsigned char guc_AdcChannel_a[2] = {0x01,0x02};        //ADC channel
unsigned char guc_Count = 0;			                      //Switch channel count

/***************************************************************************************
  * @Function	ADC conversion for AN1 and AN2
***************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 

	P0M0 = P0M0&0xF0|0x08;		//Set P00 as push-pull output
	P1M0 = P1M0&0xF0|0x08;		//Set P10 as push-pull output
/************************************ADC initialization*****************************************/
	P0M0 = P0M0&0x0F|0x30;		//Set P01 as analog inputSet P01 as analog input
	P0M1 = P0M1&0xF0|0x03;		//Set P02 as analog input
	ADCC0 = 0x80;						  //enable ADC power
	Delay_2us(10);						//delay 20us
	ADCC1 = 0x01;					  	//Select external channel 1
	ADCC2 = 0x4D;					  	//12bits, Right alignment of data, adc_clk frequency = Fosc/16 
	IE1 |= 0x20;					  	//enable ADC interrupt					
	EA = 1;							    	//enable all interrupt
	ADCC0 &=~ 0x20;						//Clear ADC interrupt flag bit 
	ADCC0 |= 0x40;						//Start ADC

	while(1)
	{
		if(gui_AdcValue_a[0] <= 0x10)
     {
		    P0_0 = 1;
		   }
		else
     {
		    P0_0 = 0;
		   }
		if(gui_AdcValue_a[1] <= 0x10)
     {
		    P1_0 = 1;
		   }
		else
     {
		    P1_0 = 0;
		   }
	}
}

/***************************************************************************************
   ADC interrupt service function
***************************************************************************************/
void ADC_Rpt() interrupt ADC_VECTOR
{
	ADCC0 &=~ 0x20;					          	                     //Clear flag bit
	gui_AdcValue_a[guc_Count++] = ADCR;	                     //Get the value of the ADC
	if(guc_Count==2)guc_Count=0;
	ADCC1 = (ADCC1&(~0x07))|(guc_AdcChannel_a[guc_Count]);   //Switching channel
	Delay_2us(10);						                               //delay 20us
	ADCC0 |= 0x40;						                               //Start ADC
} 

/**
  * Delay function 
  * Fcpu = 16MHz,fui_i = 1,The delay time is about 2us
  */
void Delay_2us(unsigned int fui_i)
{
	while(fui_i--);	
}
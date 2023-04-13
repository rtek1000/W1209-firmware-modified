
//ADC wake up from power saving mode

#define	ALLOCATE_EXTERN
#include "HC89S003F4.h"

void Delay_2us(unsigned int fui_i);		//delay function

unsigned long gul_VolValue = 0;			  //voltage value
unsigned long gul_AdcValue = 0;			  //Save the ADC value
unsigned int  gui_AdcTempVal = 0;		  //ADC temporary value
unsigned char guc_Count = 0;			    //ADC average value count

/***************************************************************************************
  * @Function	After initialization ,switch to power down mode,input low level of P02 port to wake up MCU£¬LED1 off.
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
/***********************************ADC initialization**************************************/
  FREQ_CLK = 0x10;          //This example relates to power down mode, and Fcpu need to be set
	ADCC0 &=~ 0x80;						//Close ADC
	ADCWC |= 0x80;						//Allow ADC wake up module
	P0M1 = P0M1&0xF0|0x03;		//Set P02 as analog input	
	P0LPU |= 0x10;					 	//Set pull-up resistance as 100k
	IE1 |= 0x20;						  //enable interrupt after AD conversion Open interrupt
	EA = 1;								    //enable all interrupt	
	while(1)
	{		
		PCON |= 0x02;					  //switch to power down mode
		gul_VolValue = gul_AdcValue*5000/4096;//Convert to voltage
		
		for(guc_Count=0;guc_Count<10;guc_Count++)
		{
			gui_AdcTempVal += gul_VolValue;		
		}
		gui_AdcTempVal = gui_AdcTempVal/10;
		if((gui_AdcTempVal<3500)&&(gui_AdcTempVal>2000))
		{
			P0_0=~P0_0;	
		}
		else if((gui_AdcTempVal<5000)&&(gui_AdcTempVal>3900))
		{
			P1_0=~P1_0;
		}
	}
}

/***************************************************************************************
   ADC interrupt service function
***************************************************************************************/
void ADC_Rpt(void) interrupt ADC_VECTOR
{
	ADCWC &=~ 0x40;						//Clear flag bit
	ADCC0 = 0x80;						  //enable ADC power
	Delay_2us(10);						//delay 20us
	ADCC1 = 0x02;						  //Select external channel 2
	ADCC2 = 0x4D;						  //12bits, Right alignment of data, adc_clk frequency = Fosc/16 	
	ADCC0 |= 0x40;					  //Start ADC
	while(!(ADCC0&0x20));			//Wait for the ADC conversion to complete
	ADCC0 &=~ 0x20;					  //Clear flag bit	
	gul_AdcValue = ADCR;			//Get the value of the ADC	
	ADCC0 &=~ 0x80;					  //close ADC	
}

/**
  * Delay function 
  * Fcpu = 16MHz,fui_i = 1,The delay time is about 2us
  */
void Delay_2us(unsigned int fui_i)
{
	while(fui_i--);	
}
//SPI-Master

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

unsigned char SPI_WriteReadData(unsigned char fuc_Data);  //SPI read and write Data
void Delay_ms(unsigned int fui_i);		                  //delay function

/***************************************************************************************
  * @Function	The master always sends data 0xAA to the slave, and the slave sends the received data to the host computer through the serial port
  * @Steps      IO connection:P0_0-->P0_0 P0_1-->P0_1 P2_0-->P2_0        
***************************************************************************************/
void main()
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz
/************************************SPI initialization*****************************************/
    P0M0 = P0M0&0x0F|0x40;         //Set P01 as SMT input
    P0M0 = P0M0&0xF0|0x08;         //Set P00 as push-pull output
    P2M0 = P2M0&0xF0|0x08;         //Set P20 as push-pull output
	MISO_MAP = 0x01;	           //SPI_MISO mapping P01¿Ú
	MOSI_MAP = 0x00;	           //SPI_MOSI mapping P00¿Ú
	SCK_MAP = 0x20;		           //SPI_SCK  mapping P20¿Ú
	SPDAT = 0x00;                  //Data Register write 0
	SPSTAT = 0x00;                 //Clear the status Register to 0          
	SPCTL = 0xD7;                  //Master mode, clock divided by 128
   
	while(1)
	{
		SPI_WriteReadData(0xAA);     //Send Data 0xAA
		Delay_ms(500);
	}   
}

/**
  * SPI write and read functions
  * SPI read and write data
  */
unsigned char SPI_WriteReadData(unsigned char fuc_Data)
{
	SPSTAT = 0xC0;
	SPDAT = fuc_Data;
	while(!(SPSTAT&0x80));
	SPSTAT = 0xC0;
	return SPDAT;
}

/**
  * Delay function 
  * Fcpu = 16MHz,fui_i = 1,The delay time is about 1Ms
  */
void Delay_ms(unsigned int fui_i)
{
	unsigned int fui_j;
	for(;fui_i > 0;fui_i --)
	for(fui_j = 1596;fui_j > 0;fui_j --);
}

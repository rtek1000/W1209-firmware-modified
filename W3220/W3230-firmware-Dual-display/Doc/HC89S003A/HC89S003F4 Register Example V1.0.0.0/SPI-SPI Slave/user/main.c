//ISP-Slave

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

unsigned char guc_ReceiveValue = 0;		//SPI Receive Data
unsigned char SPI_ReadData();			//SPI Read Data

/***************************************************************************************
  * @Function  The master always sends data 0xAA to the slave, and the slave sends the received data to the host computer through the serial port
  * @Steps     IO connection£ºP0_0-->P0_0 P0_1-->P0_1 P2_0-->P2_0        
***************************************************************************************/
void main()
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz
/**********************************UART initialization**************************************/
	P2M0 = P2M0&0x0F|0x80;			    //Set P21 as push-pull output
	P0M1 = P0M1&0x0F|0x20;				//Set P03 as pull-up input
	TXD_MAP = 0x21;						//TXD mapping P21
	RXD_MAP = 0x03;					    //RXD mapping P03		
	T4CON = 0x06;						//T4 working mode: UART1 baud rate generator
    TH4 = 0xFF; 
	TL4 = 0x98;						  	//Baud rate 9600
	SCON2 = 0x02;						//8-Bit UART, variable baud rate
	SCON = 0x10;					  	//Allow UART to receive
	IE |= 0x10;							//Turn on UART Interrupt
/************************************SPI initialization*****************************************/
    P0M0 = P0M0&0x0F|0x80;              //Set P01 as push-pull output
    P0M0 = P0M0&0xF0|0x04;              //Set P00 as SMT input
    P2M0 = P2M0&0xF0|0x04;              //Set P20 as SMT input
	MISO_MAP = 0x01;	            	//SPI_MISO mapping P01
	MOSI_MAP = 0x00;	            	//SPI_MOSI mapping P00
	SCK_MAP = 0x20;		                //SPI_SCK mapping P20
	SPDAT = 0x00;                       //Data Register write 0
	SPSTAT = 0x00;                      //Clear the status Register to 0         
	SPCTL = 0xC7;                       //Slave mode, clock divided by 128
    IE1 |= 0x01;					    //Open SPI Interrupt
    EA = 1;    
 
	while(1)
    {
		EA = 0;    
		SBUF = 0xBB;					          //Send 8-Bit serial Data
		while(!(SCON & 0x02));
		SCON &=~ 0x02;					          //Clear send-flag Bit
		SBUF = guc_ReceiveValue;		          //Send 8-Bit serial Data
		while(!(SCON & 0x02));
		SCON &=~ 0x02;					          //Clear send-flag Bit
		EA = 1;   
    }   
}

/***************************************************************************************
 SPI interrupt service function
***************************************************************************************/
void SPI_Rpt(void) interrupt SPI_VECTOR
{
	SPSTAT |= 0x80;						           //Clear flag Bit	
	guc_ReceiveValue = SPI_ReadData();	           //Read Data
}

/**
  * SPI read functions
  * SPI read data
  */
unsigned char SPI_ReadData()
{
	return SPDAT;						           //Return Data
}
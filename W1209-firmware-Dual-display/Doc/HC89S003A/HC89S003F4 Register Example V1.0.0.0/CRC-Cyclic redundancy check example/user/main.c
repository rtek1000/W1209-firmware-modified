
//cyclic redundancy check

#define	ALLOCATE_EXTERN
#include "HC89S003F4.h"
#include "string.h"

unsigned int CRC_CalcCRC(unsigned char *fucp_CheckArr,unsigned int fui_CheckLen);//write the data to be checked and return the check value

unsigned char guc_UARTFlag;				  //UART flag bit
unsigned char guc_UARTCnt;			  	//count the number of urat usage
unsigned char guc_UARTbuf_a[5];			//received data
unsigned char guc_i;					      //count the number of data sent	
unsigned int  gui_CrcResault;			  //CRC check value
unsigned char guc_CrcValue_a[2];		//CRC check send value
unsigned char guc_CrcCnt;				    //count the number of CRC data

/**************************************************************************************
  * @Function	  Five 8-bit data are sent to MCU through PC, and MCU returns CRC check value
  * @Operation  Connect RXD and TXD short-circuit caps, send 5 8-bit data to MCU, and MCU returns CRC check value
**************************************************************************************/
void main()
{
/************************************system initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz  
/*************************************************************************************************/
	P2M0 = P2M0&0x0F|0x80;			//Set P21 as push-pull output
	P0M1 = P0M1&0x0F|0x20;			//SEt P03 as pull-up input
	TXD_MAP = 0x21;						  //TXD mapping P21
	RXD_MAP = 0x03;						  //RXD mapping P03		
	T4CON = 0x06;						    //T4 mode£ºUART1 Baud rate generato
  TH4 = 0xFF; 
	TL4 = 0x98;							    //Baud = 9600
	SCON2 = 0x02;						    //8 bit UART£¬Baud rate is not fixed
	SCON = 0x10;						    //enable serial receive 
	IE |= 0X10;							    //enable serial port interrupt
/**********************************CRC initialization***************************************/
	CRCC = 0x07;					      //LSB first£¬The initial value after reset is 0xFFFF,Reset CRC calculator

	EA = 1;

	while(1)
	{
		if(guc_UARTFlag)
		{
			IE &=~ 0x10;				                     //Disable UART1 interrupt
			gui_CrcResault = CRC_CalcCRC(guc_UARTbuf_a,sizeof(guc_UARTbuf_a));	
										                           //write the data to be checked and return the check value
			memcpy(guc_CrcValue_a,&gui_CrcResault,2);//memory copy function
			for(guc_i = 0;guc_i< 2;guc_i++)
			{
				SBUF = guc_CrcValue_a[guc_i];          //Sending 8-bit serial data
				while(!(SCON & 0x02));
				SCON &=~ 0x02;			                   //Clear flag bit
			}
			CRCC = 0x07;				                     //LSB first£¬The initial value after reset is 0xFFFF,Reset CRC calculator
			IE |= 0x10;					                     //enable UART1 interrupt
			guc_UARTFlag = 0;			                   //Clear flag bit
			guc_UARTCnt = 0;			                   //Clear count
			SCON |= 0x10;				                     //enable UART1 receive
		}	
	}
}

/***************************************************************************************
   UART1 interrupt service function
***************************************************************************************/
void UART1_Rpt(void) interrupt UART1_VECTOR
{
	if(SCON&0x01)
	{	
		guc_UARTbuf_a[guc_UARTCnt++] = SBUF;  //8-bit data received by serial port
		if(guc_UARTCnt >= 5)
		{
			SCON &=~ 0x10;			               	//Disable UART1 receive
			guc_UARTFlag = 1;
		}
		SCON &=~ 0x01;			              		//Clear interrupt flag bit
	}									
}

/**
  * @Function  	write the data to be checked and return the check value
  * @Argument  	*fucp_CheckArr : CRC data first address
  * @Argument  	fui_CheckLen : CRC data length
  *             Value range 0 - 65535
  * @Return     CRC result
  			        LSB first , MSB last
  */
unsigned int CRC_CalcCRC(unsigned char *fucp_CheckArr,unsigned int fui_CheckLen)
{
	while(fui_CheckLen--)CRCL = *(fucp_CheckArr++);
	return CRCR;
}

//Read and write similar to EEPROM

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

void Flash_EraseBlock(unsigned int fui_Address);//erase block
void FLASH_WriteData(unsigned char fui_Address, unsigned int fuc_SaveData);//Write a byte of data
void Flash_WriteArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr);//Write any length of data
void Flash_ReadArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr);//Reading data of any length

unsigned char guc_Write_a[5] = {0x11,0x12,0x13,0x14,0x15};	//write data
unsigned char guc_Read_a[5] = {0x00};			//Store read data
unsigned char guc_Uartflag = 0;					  //Send count
unsigned char guc_Uartcnt = 0;					  //Count the number of data sent
unsigned char guc_Uartbuf_a[2] = {0x00};	//buffer array

/***************************************************************************************
  * @Function	 Five data are continuously written in the address of 0x3b00 to 0x3b04, and
               the corresponding data can be read by sending address through serial port 
               tool. When VDD voltage value is lower than LVD set voltage value, LED is
               on; when VDD voltage value is detected to be higher than LVD set voltage 
               value, LED is off.
  * @Operation Connect the RXD TXD short-circuit cap, send the data with the frame header
               of 0x2b to the single-chip microcomputer, and return the data corresponding 
               to the corresponding address. 
***************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
/*****************************************initialization******************************************/
	P0M0 = P0M0&0xF0|0x08;		//Set P00 as push-pull output	
	P2M0 = P2M0&0x0F|0x80;		//Set P21 as push-pull output
	P0M1 = P0M1&0x0F|0x20;		//Set P03 as pull-up output
	P0_0=1;
	TXD_MAP = 0x21;					  //TXD mapping P21
	RXD_MAP = 0x03;					  //RXD mapping P03		
	T4CON = 0x06;						  //T4 mode£ºUART1 Baud rate generator
  TH4 = 0xFF;
	TL4 = 0x98;							  //Baud = 9600
	SCON2 = 0x02;						  //8 bit UART£¬Baud rate is not fixed
	SCON = 0x10;						  //enable serial receive
	IE |= 0x10;							  //enable serial port interrupt
/**********************************Flash initialization*************************************/
	FREQ_CLK = 0x10;				  //Fcpu need to be set	
	LVDC = 0xAC;						  //Set LVD as3.0V,Disable interrupt
	//	Set debounce time = 	(0xFF + 2) * 1/Fcpu
	//			 =	(0xFF + 2) / 16000000
	//			 =	16.0625us
	LVDDBC = 0xFF;					  //Set debounce time
	LVDC &=~ 0x08;			      //Clear flag bit 

	Flash_EraseBlock(0x3B00);	//Erase the sector of address 0x2B00
	Flash_WriteArr(0x3B00,5,guc_Write_a);//Write the sector of address 0x2B00
	Flash_ReadArr(0x3B00,5,guc_Read_a);	//Read the sector of address 0x2B00
	EA = 1;								    //enable all interrupt
	while(1)
	{
		if(guc_Uartflag)
		{
			IE &=~ 0x10;				   //Disable UART1 receive
			if(guc_Uartbuf_a[0] == 0x3B)
			{
				switch(guc_Uartbuf_a[1])
				{
					case 0x00:	SBUF = guc_Read_a[0];//Sending 8-bit serial data
								break;
					case 0x01:	SBUF = guc_Read_a[1];//Sending 8-bit serial data
								break;
					case 0x02:	SBUF = guc_Read_a[2];//Sending 8-bit serial data
								break;
					case 0x03:	SBUF = guc_Read_a[3];//Sending 8-bit serial data
								break;
					case 0x04:	SBUF = guc_Read_a[4];//Sending 8-bit serial data
								break;
					default:break;
					while(!(SCON&0x02));	//Wait for sending to finish
					SCON &=~ 0x02;;			  //Clear flag bit
				}
				IE |= 0x10;						  //enable UART1 interrupt
				guc_Uartflag = 0;				//Clear flag bit
				guc_Uartcnt = 0;				//Clear flag bit
				SCON |= 0x10;					  //enable UART1 receive	
			}
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
		guc_Uartbuf_a[guc_Uartcnt++] = SBUF;//8-bit data received by serial port
		if(guc_Uartcnt >= 2)
		{
			SCON &=~ 0x10;					//Disable UART1 receive
			guc_Uartflag = 1;
		}
		SCON &=~ 0x01;						//Clear interrupt flag bit
	}
}
/**
  * @Function  	Erase block,it takes about 5ms
  *             This function needs absolute address compilation. Please refer to IAP 
                operation manual for details
  * @Argument  	fui_Address £ºAny address in the erased block
  * @Return     NULL
  */
void Flash_EraseBlock(unsigned int fui_Address)
{
	while(1)
	{
		LVDC &=~ 0x08;			  //Clear LVD interrupt flag bit
		P0_0=0;		
		if((LVDC&0x08)==0)		break;
	}
	P0_0=1;		
	EA=0;
	IAP_CMD = 0xF00F;				//Flash unlock
	IAP_ADDR = fui_Address;	//Write erase address
	IAP_CMD = 0xD22D;				//Select operation mode, sector erase
	IAP_CMD = 0xE11E; 			//After triggering,IAP_ADDRL&IAP_ADDRH points to 0xFF and locks automatically
	EA=1;
}

/**
  * @Function  	Write a byte of data to flash
  *             This function needs absolute address compilation. Please refer to IAP 
  *             operation manual for details
  * @Argument  	fui_Address £ºFLASH adderss
  *	@Argument	  fucp_SaveData£ºWrite data
  * @Return     NULL
  * @Notes	  	The operating block must be erased before writing
  */
void FLASH_WriteData(unsigned char fuc_SaveData, unsigned int fui_Address)
{
	while(1)
	{
		LVDC &=~ 0x08;			   //Clear LVD interrupt flag bit
		P0_0=0;		
		if((LVDC&0x08)==0)		break;
	}
	P0_0=1;	
	EA=0;
	IAP_DATA = fuc_SaveData;
	IAP_CMD=0xF00F;				   //Flash unlock
	IAP_ADDR = fui_Address;
	IAP_CMD=0xB44B;				   //Byte programming
	IAP_CMD=0xE11E;				   //Trigger operation
	EA=1;
}

/**
  * @Function  	Write any length of data to flash
  *             This function needs absolute address compilation. Please refer to IAP 
  *             operation manual for details
  * @Argument  	fui_Address £ºFLASH address
  *	@Argument 	fuc_Length £º Write data length
  *			        Value range£º0x00-0xFF
  *	@Argument	 *fucp_SaveArr£ºThe first address of the data storage area
  * @Return     NULL
  * @Notes		  The operating sector must be erased before writing
  */ 
void Flash_WriteArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr)
{
	unsigned char fui_i = 0;
	EA=0;
	for(fui_i=0;fui_i<fuc_Length;fui_i++)
	{
		FLASH_WriteData(*(fucp_SaveArr++), fui_Address++); 
	}
	EA=1;
}

/**
  * @Function  	Reading data of any length from flash
  * @Argument  	fui_Address £ºFLASH address
  *	@Argument	  fuc_Length £ºRead data length
  *			        alue range£º0x00-0xFF
  *	@Argument	 *fucp_SaveArr£ºThe first address of the data storage area
  * @Return     NULL
  */
void Flash_ReadArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr)
{
	while(fuc_Length--)
	*(fucp_SaveArr++)=*((unsigned char code *)(fui_Address++));//Read data
}

//CRC storing data

#define	ALLOCATE_EXTERN
#include "HC89S003F4.h"
#include "string.h"

unsigned int CRC_CalcCRC(unsigned char *fucp_CheckArr,unsigned int fui_CheckLen);                  //write the data to be checked and return the check value
void Flash_EraseBlock(unsigned int fui_Address);                                                   //erase block
void FLASH_WriteData(unsigned char fuc_SaveData, unsigned int fui_Address);                        //Write a byte of data to flash
void Flash_WriteArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr);//Write any length of data to flash
void Flash_ReadArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr); //Reading data of any length from flash
void Delay(unsigned int fui_i);			                                                               //delay function

unsigned char guc_StoredData_a[5] = {0x01,0x02,0x03,0x04,0x05};  //stored data
unsigned char guc_ReadData_a[5] = {0x00};                        //read data			
unsigned int  gui_CRCStoredValue = 0;	                           //CRC stored data
unsigned int  gui_CRCReadValue = 0;		                           //CRC read data

/**************************************************************************************
  * @Function     Write bytes to the address 0x2b00,CRC check.If the check value is correct, LED1 flashes, otherwise wait
  * @Operation     Write bytes to the address 0x2b00
**************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
/*************************************************************************************************/
	P0M0 = P0M0&0xF0|0x08;		//Set P21 as push-pull output
/**********************************CRC initialization***************************************/
	FREQ_CLK = 0x10;					//Fcpu need to be set
	
//	Flash_EraseBlock(0x2B00);			//Erase the block with the first address of 0x2B00
//	Flash_WriteArr(0x2B00,5,guc_StoredData_a);//Write data from 0x2B00
//  When the above two sentences are annotated, the CRC check value will be different and will always wait at while (1)
//  When the above two sentences are not annotated, the CRC check is the same and the LED flashes						
	
	Flash_ReadArr(0x2B00,5,guc_ReadData_a);	             //Read data from 0x2B00
	CRCC = 0x07;						                             //LSB first£¬The initial value after reset is 0xFFFF,Reset CRC calculator
	gui_CRCReadValue = CRC_CalcCRC(guc_ReadData_a,5);    //Calculate the CRC value read from the Block
	CRCC = 0x07;						                             //LSB first£¬The initial value after reset is 0xFFFF,Reset CRC calculator
	gui_CRCStoredValue = CRC_CalcCRC(guc_StoredData_a,5);//check stored CRC value
	if(gui_CRCStoredValue != gui_CRCReadValue)           //Compare CRC check value
	{
		while(1);
	}
	while(1)
	{
		P0_0 =~ P0_0;
		Delay(250);
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

/**
  * @Function  	Erase block,it takes about 5ms
  * @Argument  	fui_Address £ºAny address in the erased block
  * @Return     NULL
  */
#pragma disable							 //Ensure that the adjustment will not be interrupted, resulting in adjustment failure
void Flash_EraseBlock(unsigned int fui_Address)
{
	IAP_CMD = 0xF00F;				    //Flash unlock
	IAP_ADDR = fui_Address;			//Write erase address
	IAP_CMD = 0xD22D;				    //Select operation mode, sector erase
	IAP_CMD = 0xE11E; 				  //After triggering,IAP_ADDRL&IAP_ADDRH points to 0xFF and locks automatically
}

/**
  * @Function  	Write a byte of data to flash
  * @Argument  	fui_Address £ºFLASH address
  *	@Argument 	fucp_SaveData£ºThe first address of the data storage area
  * @Return     NULL
  * @Notes	  	The operating block must be erased before writing
  */
#pragma disable							//Ensure that the adjustment will not be interrupted, resulting in adjustment failure
void FLASH_WriteData(unsigned char fuc_SaveData, unsigned int fui_Address)
{
	IAP_DATA = fuc_SaveData;
	IAP_CMD=0xF00F;				    //Flash unlock
	IAP_ADDR = fui_Address;
	IAP_CMD=0xB44B;				    //Byte programming
	IAP_CMD=0xE11E;			     	//Trigger operation
}

/**
  * @Function  	Write any length of data to flash
  * @Argument  	fui_Address £ºFLASH address
  *	@Argument 	fuc_Length £º Write data length
  *			        Value range£º0x00-0xFF
  *	@Argument	 *fucp_SaveArr£ºThe first address of the data storage area
  * @Return     NULL
  * @Notes		  The operating sector must be erased before writing
  */ 
#pragma disable							//Ensure that the adjustment will not be interrupted, resulting in adjustment failure
void Flash_WriteArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr)
{
	unsigned char fui_i = 0;
	for(fui_i=0;fui_i<fuc_Length;fui_i++)
	{
		FLASH_WriteData(*(fucp_SaveArr++), fui_Address++); 
	}
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

/**
  * Delay function 
  * Fcpu = 16MHz,fui_i = 1,The delay time is about 1ms
  */
void Delay(unsigned int fui_i)
{
	unsigned int fui_j;
	for(;fui_i > 0;fui_i --)
	for(fui_j = 1596;fui_j > 0;fui_j --);
}

//Save data after power failure

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

unsigned char guc_Write_a= 0;	//write data
unsigned char guc_Read_a = 0; //Store read data

void Flash_EraseBlock(unsigned int fui_Address);//erase block
void FLASH_WriteData(unsigned int fui_Address, unsigned char fuc_SaveData);//Write a data
void Flash_ReadData(unsigned int fui_Address,unsigned char fuc_SaveArr);   //Read a data

/***************************************************************************************
  * @Function  Set the anti jitter time of LVD detection voltage of VDD to 16.0625us. When
               the voltage is lower than 4.2V and the duration is more than 16.0625us, LVD
			   will be interrupted and flash will be erased.
  * @Operation  This example can not be simulated, and it is necessary to unplug the 
	            emulator during the test, increase the external large capacitance, and 
				prolong the power down time. The time of LVD voltage falling to bor voltage
				is at least more than 6ms, the erasing time of one sector is 5ms, and the 
				writing time of one byte is 23us.
***************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz  
  FREQ_CLK = 0x10;					//Indicates the current system clock
/***********************************LVD configuration initialization*******************************/
	LVDC = 0xA7;						  //set LVD
	//	debounce time = 	(0xFF + 2) * 1/Fcpu
	//			 =	(0xFF + 2) / 16000000	
	//			 =	16.0625us
	//	Now the program detects the voltage of the VDD£¬4.2V
	LVDDBC = 0xFF;						//Set debounce time    
	EA = 1;								    //enable all interrupt
	while(1);
}

/***************************************************************************************
   LVD interrupt service function
***************************************************************************************/
void LVD_Rpt() interrupt LVD_VECTOR
{
	if(LVDC&0x08)
	{	
		LVDC &=~ 0x08;					            //Clear interrupt flag bit
		EA=0;
		Flash_ReadData(0x2B00,guc_Read_a);	//Read the sector of address 0x2B00	
		guc_Write_a=guc_Read_a++;		
		Flash_EraseBlock(0x2B00);
		FLASH_WriteData(0x2B00,guc_Write_a);//Write the sector of address 0x2B00	
		Flash_ReadData(0x2B00,guc_Read_a);	//Read the sector of address 0x2B00				
		EA=1;
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
	IAP_CMD = 0xF00F;				//Flash unlock
	IAP_ADDR = fui_Address;	//Write erase address
	IAP_CMD = 0xD22D;				//Select operation mode, sector erase
	IAP_CMD = 0xE11E; 			//After triggering,IAP_ADDRL&IAP_ADDRH points to 0xFF and locks automatically
}

/**
  * @Function  	Write a byte of data to flash
  * @Argument  	fui_Address £ºFLASH adderss
  *	@Argument	  fucp_SaveData£ºWrite data
  * @Return     NULL
  * @Notes	  	The operating block must be erased before writing
  */
void FLASH_WriteData(unsigned int fui_Address, unsigned char fuc_SaveData)
{
	IAP_DATA = fuc_SaveData;
	IAP_CMD=0xF00F;				  //Flash unlock
	IAP_ADDR = fui_Address;
	IAP_CMD=0xB44B;				  //Byte programming
	IAP_CMD=0xE11E;				  //Trigger operation
}

/**
  * @Function  	Read the specified address data from FLASH
  * @Argument  	fui_Address £ºFLASH adderss
  *	@Argument  	fuc_SaveArr £ºRaed data
  * @Return     NULL
  */
void Flash_ReadData(unsigned int fui_Address,unsigned char fuc_SaveArr)
{
	fuc_SaveArr=*((unsigned char code *)(fui_Address));//read data
}

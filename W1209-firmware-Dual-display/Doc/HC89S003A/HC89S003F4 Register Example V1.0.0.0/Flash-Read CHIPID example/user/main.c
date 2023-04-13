
//read CHIPID

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"
#include "string.h"

void Flash_ReadArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr);

unsigned char guc_Read_a[8] = {0x00};			     //Store read data
unsigned char guc_CompareBuf_a[] = "Read Chip ID\r";
unsigned char guc_CompareFlag = 1;             //Memory compare flag bit
unsigned char guc_Uartflag = 0;				       	 //Send flag bit 
unsigned char guc_Uartcnt = 0;					       //Send count
unsigned char guc_Uartbuf_a[13] = {0x00};		   //buffer array
unsigned char guc_i;					                 //Count the number of data sent	

/***************************************************************************************
  * @Function	  read CHIP ID¡£
  * @Operation   Connect the RXD TXD short-circuit cap, send the string read chip ID to 
                the MCU, and return the chip ID of MCU.
***************************************************************************************/
void main()
{
/************************************system initialization****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz  
/**********************************initialization**********&**************************************/
	P2M0 = P2M0&0x0F|0x80;				//Set P21 as push-pull output
	P0M1 = P0M1&0x0F|0x20;				//Set P03 as pull-up output
	TXD_MAP = 0x21;						    //TXD mapping P21
	RXD_MAP = 0x03;						    //RXD mapping P03		
	T4CON = 0x06;						      //T4 mode£ºUART1 Baud rate generator
  TH4 = 0xFF;
	TL4 = 0x98;							      //Baud = 9600
	SCON2 = 0x02;						      //8 bit UART£¬Baud rate is not fixed
	SCON = 0x10;						      //enable serial receive
	IE |= 0x10;							      //enable serial port interrupt
/**********************************Flash initialization*************************************/
  INSCON |= 0x10;                       //The data pointer points to the option area
	Flash_ReadArr(0x0100,8,guc_Read_a);	  //read CHIPID
  INSCON &=~ 0x10;                      //The data pointer points back to the flash area
	EA = 1;								                //enable all interrupt
	while(1) 
	{
		if(guc_Uartflag)
		{
			IE &=~ 0x10;				                //Disable UART1 interrupt
			guc_CompareFlag = memcmp(guc_Uartbuf_a,guc_CompareBuf_a,13);//Compare whether the received data is correct
			if(guc_CompareFlag == 0)
			{
				for(guc_i= 0;guc_i<8;guc_i++)
				{
					SBUF = guc_Read_a[guc_i];     //Sending 8-bit serial data
					while(!(SCON & 0x02));
					SCON &=~ 0x02;			          //Clear flag bit
				}             
			}
			IE |= 0x10;					                //enable UART1 interrupt
			guc_Uartflag = 0;
			guc_Uartcnt = 0;
			SCON |= 0x10;				                //enable UART1 receive
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
		guc_Uartbuf_a[guc_Uartcnt++] = SBUF;  //8-bit data received by serial port
		if(guc_Uartcnt >= 13)
		{
			SCON &=~ 0x10;					            //Disable UART1 receive
			guc_Uartflag = 1;
		}
		SCON &=~ 0x01;					            	//Clear interrupt flag bit
	}
}

/**
  * @Function  	Reading data of any length from FLASH
  * @Argument  	fui_Address £ºFLASH first address
  *			        Value range£º 0x0000-0x3FFF
  *	@Argument	  fuc_Length £º read data length
  *			        Value range£º 0x00-0xFF
  *	@Argument	 *fucp_SaveArr£ºRead the first address of the area where the data is stored
  * @Return     NULL
  */
void Flash_ReadArr(unsigned int fui_Address,unsigned char fuc_Length,unsigned char *fucp_SaveArr)
{
	while(fuc_Length--)
	*(fucp_SaveArr++)=*((unsigned char code *)(fui_Address++));//read data
}
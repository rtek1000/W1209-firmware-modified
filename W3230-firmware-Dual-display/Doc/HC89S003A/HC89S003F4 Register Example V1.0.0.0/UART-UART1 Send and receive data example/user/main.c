//UART1 Send and receive data

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

unsigned char guc_Uartflag = 0;			//UART2 judgment flag
unsigned char guc_Uartcnt = 0;		    //UART2 count
unsigned char guc_Uartbuf_a[5] = {0};	//Save the received value
unsigned char guc_i;                    //Send Data count

/***************************************************************************************
  * @Function	After UART2 receives the 5 8-bit data sent by the host computer, it sends the received 
                5 data to the host computer again
  * @Steps      Connect TXD, RXD short-circuit cap, and then send 5 8-bit data through the upper computer software
  * @Note		Baud rate 9600, 8-bit data, no parity bit		
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
	P2M0 = P2M0&0x0F|0x80;				//Set P21 as push-pull output
	P0M1 = P0M1&0x0F|0x20;				//Set P03 as pull-up input
	TXD2_MAP = 0x21;					//TXD mapping P21
	RXD2_MAP = 0x03;					//RXD mapping P03		
	T4CON = 0x06;						//T4 working mode: UART1 baud rate generator
	
	//Baud rate calculation
	//Baud rate = 1/16 * (T5 clock source frequency / Timer 5 prescaler ratio) / (65536 - 0xFF98)
	//          = 1/16 * ((16000000 / 1) / 104)
	//		    = 9615.38(error 0.16%)

	//Baud rate 9600
	//Reverse initial value = (65536 - ((T5 clock source frequency / Timer 5 prescaler ratio) * (1 / 16)) / Baud rate)
	//		                = (65536 - (16000000 * (1 / 16) / 9600))
	//		                = (65536 - 104.167)
	//                      = FF98
	
    TH4 = 0xFF;
	TL4 = 0x98;
	SCON2 = 0x02;						             //8-Bit UART, variable baud rate
	SCON = 0x10;					                 //Allow UART to receive
	IE |= 0X10;							             //Turn on UART Interrupt
	EA = 1;							              	 //Open total Interrupt
    
	while(1)
	{
		if(guc_Uartflag)
		{
			IE &=~ 0x10;				             //Disable UART1 Interrupt
			for(guc_i= 0;guc_i<guc_Uartcnt;guc_i++)
			{
				SBUF = guc_Uartbuf_a[guc_i];         //Send 8-Bit serial Data
				while(!(SCON & 0x02));
				SCON &=~ 0x02;			             //Clear send-flag Bit
			}
			IE |= 0x10;					             //UART1 Interrupt enable
			guc_Uartflag = 0;
			guc_Uartcnt = 0; 
			SCON |= 0x10;				             //UART1 receive enable
		}	
	}
}

/***************************************************************************************
 UART interrupt service function
***************************************************************************************/
void UART1_Rpt(void) interrupt UART1_VECTOR
{
	if(SCON & 0x01)						            //Determine the receive Interrupt flag Bit
	{
		guc_Uartbuf_a[guc_Uartcnt++] = SBUF;        //Transfer 8-Bit serial port to receive Data
		if(guc_Uartcnt >= 5)
		{
			SCON &=~ 0x10;				            //Disable UART1 receptionDisable UART2 reception
			guc_Uartflag = 1;
		}
		  SCON &=~ 0x01;					        //Clear receive-flag Bit
	}									
}
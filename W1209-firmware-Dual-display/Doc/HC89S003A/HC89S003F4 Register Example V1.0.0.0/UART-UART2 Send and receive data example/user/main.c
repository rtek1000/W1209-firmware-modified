//UART2 Send and receive data

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"

unsigned char guc_Uartflag = 0;			//UART2 judgment flag
unsigned char guc_Uartcnt = 0;		    //UART2 count
unsigned char guc_Uartbuf_a[5] = {0};	//Save the received value
unsigned char guc_i;                    //Send data count

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
	//Baud rate calculation
	//Baud rate = 1/16 * (T5 clock source frequency / Timer 5 prescaler ratio) / (65536 - 0xFF98)
	//          = 1/16 * ((16000000 / 1) / 104)
	//		    = 9615.38(error 0.16%)

	//Baud rate 9600
	//Reverse initial value = (65536 - ((T5 clock source frequency / Timer 5 prescaler ratio) * (1 / 16)) / Baud rate)
	//		                = (65536 - (16000000 * (1 / 16) / 9600))
	//		                = (65536 - 104.167)
	//                      = FF98

	RCAP5H = 0xFF;
	RCAP5L = 0x98;
	T5CON = 0x06;						    //T5 working mode: UART2 baud rate generator
	S2CON2 = 0x00;						    //8-bit UART, variable baud rate
	S2CON = 0x10;					      	//Allow UART to receive
	IE |= 0x40;						      	//Turn on UART Interrupt
	EA = 1;							        //Open total Interrupt
	while(1)
	{
		if(guc_Uartflag)
		{
			IE &=~ 0x40;				              //Disable UART2 interrupt
			for(guc_i=0;guc_i<guc_Uartcnt;guc_i++)
			{
				S2BUF = guc_Uartbuf_a[guc_i];		  //Send 8-bit serial data
				while(!(S2CON & 0x02));
				S2CON &=~ 0x02;			              //Clear send-flag bit
			}
			IE |= 0x40;					              //UART2 interrupt enable
			guc_Uartflag = 0;
			guc_Uartcnt = 0;
			S2CON |= 0x10;;			             	  //UART2 receive enable
		}
	}
}

/***************************************************************************************
 UART interrupt service function
***************************************************************************************/
void UART2_Rpt(void) interrupt UART2_VECTOR
{
	if(S2CON&0x01)					              //Determine the receive interrupt flag bit
	{
		guc_Uartbuf_a[guc_Uartcnt++] = S2BUF;     //Transfer 8-bit serial port to receive data
		if(guc_Uartcnt >= 5)
		{
			S2CON &=~ 0x10;				          //Disable UART2 reception
			guc_Uartflag = 1;
		}
		S2CON &=~ 0x01;				              //Clear receive-flag bit
	}									
}
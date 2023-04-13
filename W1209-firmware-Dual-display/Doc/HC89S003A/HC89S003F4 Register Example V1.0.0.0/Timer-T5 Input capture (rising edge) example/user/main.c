//Timer-T5 input capture (rising edge)

#define ALLOCATE_EXTERN
#include "HC89S003F4.h"
#include "stdio.h"

unsigned int gui_T5Value;             //T5 capture acquisition value
void Delay_ms(unsigned int fui_i);    //Delay function
/***************************************************************************************
  * @Function	  Set T5 to capture mode, capture the high and low pulse width of P01 port, and output from the serial port
  * @Steps        P01->P00 connection£¬TXD is P2_1
***************************************************************************************/
void main() 
{
/************************************System initialization ****************************************/
	WDTCCR = 0x00;						//Close watchdog
	                          //In this example, the watchdog is closed for the convenience of testing. 
	                          //In practical use, it is recommended to open the watchdog. See WDT Reset example for details
	
	CLKSWR = 0x51;						//Select internal RC32M as system clock, RC32M/2, Fosc=16MHz
	CLKDIV = 0x01;						//Fosc/1,Fcpu=16MHz 
	P0M0 = P0M0&0xF0|0x08;              //Set P00 as push-pull output	
/**********************************UART initialization**************************************/
	P2M0 = P2M0&0x0F|0x80;				//Set P21 as push-pull output
	TXD_MAP = 0x21;					    //TXD mapping P21		
	T4CON = 0x06;						//T4 working mode: UART1 baud rate generator

    TH4 = 0xFF;
	TL4 = 0x98;							//Baud rate 9600
	SCON2 = 0x02;						//8-bit UART, variable baud rate	
/**********************************TIM5 initialization**************************************/
    P0M0 = P0M0&0x0F|0x20;              //Set P01 as pull-up input
	T5_MAP = 0x01;						//T5 capture port mapping P01 port
	T5CON = 0x1F;						//Clock divided by 8, 16-bit falling edge capture
	T5CON1 = 0x00;						//T5 capture type selects the changing edge of T5 pin
	TH5 = 0x00;
	TL5 = 0x00;							//Clear count
	IE1 |= 0x10;					    //Turn on T5 Interrupt
	EA = 1;
	while(1)
	{  
	  P0_0 = ~P0_0;
	  Delay_ms(1);
	}
}

/***************************************************************************************
 T5 interrupt service function
***************************************************************************************/
void TIMER5_Rpt(void) interrupt T5_VECTOR
{
	if(T5CON&0x40)                       //Determine whether it is an external event
	{
		gui_T5Value = RCAP5/2;			        //Read the acquired data and convert the unit to 1 us
		printf("\nCapture time£º%d us\n",gui_T5Value);
		T5CON &=~ 0x40;						        //Clear pin external input event occurrence flag 	
		TH5 = 0x00;
		TL5 = 0x00;	
	}
	if(T5CON&0x80)
	{
		T5CON &=~ 0x80;						         //Clear T5-flag bit
	}
}

/**
  * Putc function 
  * Use printf function to print output from serial port 1
  */
char putchar(char guc_Uartbuf)
{
	SBUF = guc_Uartbuf;                   //Send 8-bit serial data
	while(!(SCON & 0x02));
	SCON &=~ 0x02;			              //Clear send-flag bit
	return guc_Uartbuf;
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

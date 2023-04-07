/*
 This file is part of the W1209 firmware replacement project
 (https://github.com/mister-grumbler/w1209-firmware).

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, version 3.

 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 - Modified by RTEK1000
 - Apr/06/2023
 - Arduino sketch converted to Eclipse project
 --> To free up space in program memory (Flash)
 - Mar/27/2023
 - Code adaptation for Arduino IDE sketch.ino
 - Some bug fixes
 - Some functions added
 --> Parameter P0: C1/C2/C3/H1/H2/H3/A1/A2
 - C1: Cooler mode (hysteresis above Threshold)
 - C2: Cooler mode (hysteresis below Threshold)
 - C3: Cooler mode (hysteresis above and below Threshold)
 - H1: Cooler mode (hysteresis below Threshold)
 - H2: Cooler mode (hysteresis above Threshold)
 - H3: Cooler mode (hysteresis above and below Threshold)
 --> Parameter P1: Hysteresis
 --> Parameter P2: Up limit
 (Used in the alert indication; Activated in Parameter P6)
 (Used in Alarm mode Parameter P0: A1 and A2; Activated in Parameter P6)
 --> Parameter P3: Down limit
 (Used in the alert indication; Activated in P6)
 (Used in Alarm mode Parameter P0: A1 and A2; Activated in Parameter P6)
 --> Parameter P4: Temperature sensor offset
 (From -7.0 up to +7.0)
 --> Parameter P5: Delay time before activating the relay
 (From 0 to 10 minutes)
 (Does not affect relay deactivation, deactivation is immediate)
 --> Parameter P6: ON/OFF
 (Alarm mode; Need setup Parameter P2 and P3)
 --> Parameter P7: ON/OFF
 (Threshold value change access blocking)
 (Factory reset lockout with Up "+" and Down "-" keys)
 --> Parameter P8: ON/OFF
 (Automatic brightness reduction after 15 seconds)
 --> Output status indication:
 - Decimal point (DOT) right side off:
 Relay deactivated (contacts open)
 - Decimal point (DOT) right side blinking:
 Relay deactivated (contacts open), but
 Waiting delay time programmed in Parameter P5
 --> Factory reset:
 - Set Parameter P7 in OFF
 - Turn power supply Off
 - Press and hold Up "+" and Down "-" keys
 - Turn power supply On
 - Wait for "rSt" to appear on the display
 - Release all keys
 - Wait for the current temperature to appear
 --> Troubleshoot:
 - Microcontroller resetting:
 Try using a pull up resistor on the reset line
 - Microcontroller no longer responds:
 High voltage return may have occurred through the relay LED
 - The temperature does not correspond to the real:
 Try adjusting the offset Parameter P5
 Try to replace the sensor
 Test using a resistor of NTC equivalent value for 25°C (10k)
 Try modifying the lookup table corresponding to the sensor
 - Display flickering:
 Disconnect STlink programmer from SWIM port (next to display)

 - Note for Arduino IDE and Sduino core:
 Track the size of the code when uploading,
 The maximum I got was 93%
 --> (Sketch uses 7589 bytes (92%))
 --> (Bytes written: 8136)
 --> (Maximum is 8192 bytes)
 - Sduino core:
 --> Select STM8S Board / STM8S103F3 Breadout Board
 --> Programmer ST-link/V2
 --> Connect STlink: GND/SWIM/RST

 References:
 - https://github.com/rtek1000/NTC_Lookup_Table_Generator
 - https://github.com/rtek1000/W1209-firmware-modified
 */

/**
 Control functions for main routines.
 - Menu (and Button) tree
 - Display tree
 - Timer tree (using millis() and micros())
 */

#include "stm8.h"
#include "remote.h"
#include "display.h"
#include "params.h"
#include "button.h"
#include "timer.h"

// 186(max)-169(min)=17; 17/2=8.5;169+8.5=177.5(med)
#define _delay_us_receiver 177

#define _delay_us 361 // 2400: 760/855; 9600: 205

volatile int data_received = 0;
volatile int data_buffer = 0;
volatile char data_counter = 0;
volatile bool start_bit = false;

volatile int data_buffer_send = 0;
volatile char data_counter_send = 0;
volatile bool empty_bit_send = true;
volatile bool start_bit_send = false;
volatile bool stop_bit_send = false;
volatile bool pause_bit_send = false;

char Msg[8];
char Msg_ref[2];
byte param_sender = 0;
byte sender_index = 0;
byte sender_start = 0;

extern int temp;

//extern volatile unsigned char tmr1_counter;

void initSerialReceiver(void) {
	disableInterrupts();

	PC_DDR &= ~BUTTON2_BIT;  // Pull-up with interrupt on pin PC3
	PC_CR2 |= BUTTON2_BIT;   // Pull-up with interrupt on pin PC3
	PC_CR1 |= BUTTON2_BIT;   // Pull-up with interrupt on pin PC3

	EXTI_CR1 |= 0x20;   // generate interrupt on falling edge.

	// https://github.com/tenbaht/sduino/issues/127
	// attachInterrupt(INT_PORTC & 0xFF, SR_INT_Handle, FALLING);

	enableInterrupts();

// https://sites.google.com/site/klaasdc/stm8s-projects/rpm-counter-1
// Pre_CLK: 16MHz: 62ns
// Goal: 500us
// Presc: 7
// TIM1_IN: 7x62ns = 434ns
// TIM1_PRELOAD: 65535 (MAX)
// TIM1_PERIOD: 1x434ns = 434ns

//  TIM1_DeInit();
//  TIM1_TimeBaseInit(1680, TIM1_COUNTERMODE_UP, 65535, 0); // 7: 0.5us
//  TIM1_Cmd(ENABLE);

// Goal: 104.167us
// Pre_CLK: 16MHz: 62ns
// Presc: = 104167 / 062 = 1680
// TIM1_IN: 1680x62ns = 104160ns
// TIM1_PRELOAD: 65535 (MAX)
// TIM1_PERIOD: 1x104160ns = 104160ns = 104.160us

//  TIM1_DeInit();
//  TIM1_TimeBaseInit(1680, TIM1_COUNTERMODE_UP, 65535, 0); // 7: 0.5us
//  TIM1_Cmd(ENABLE);

// Goal: 500ms
// Pre_CLK: 16MHz: 62ns
// Presc: = 500000000 / 62 = 8064516 (MAX: 65535 + 1) 8064516 / 65536 = 123
// TIM1_IN: 65535x62ns = 4063170ns
// TIM1_PRELOAD: 65535 (MAX) - 123 = 65412
// TIM1_PERIOD: 123x4063170ns = 499769910ns = 499769.910us = 499.769910ms

//CLK_PeripheralClockConfig (CLK_PERIPHERAL_TIMER1 , ENABLE);
//TIM1_DeInit();
//TIM1_TimeBaseInit(65535, TIM1_COUNTERMODE_DOWN, 123, 0); // 65535x123: 0.5s

//disableInterrupts();

//TIM1->SR1 &= ~0x01;
//TIM1->IER |= 0x01;
//TIM1_ITConfig(TIM1_IT_UPDATE, ENABLE);

//TIM1_Cmd(ENABLE);

// https://github.com/tenbaht/sduino/issues/127
// attachInterrupt(INT_TIM1_OVF, TIM1_int, 0);

//enableInterrupts();

}

void receiver_Handle(void) {
	//disableInterrupts();
	disableButton2interrupt();

	data_counter = 0;
	data_buffer = 0;
	start_bit = false;

//	setButton3stateLOW();
//
//	setButton3stateHIGH();

//	tmr1_counter = 0;

//	TIM1_CNTRH = 0xFC;
//	TIM1_CNTRL = 0xDB;

	TIM1_CNTRH = 0xFE;
	TIM1_CNTRL = 0x63;

	//TIM1_SR1 &= ~TIMx_UIF; // Reset flag

	TIM1_CR1 = 0x05;    // Enable timer

	//enableInterrupts();
	//setButton3stateLOW();

//	unsigned char _data = 0;
//
//	/* start bit */
//	//setButton3stateLOW();
//
//	bit_delay_receiver(_delay_us_receiver);
//
//	//setButton3stateHIGH();
//
//	if ((PC_IDR & BUTTON2_BIT) != BUTTON2_BIT) {
//		bit_delay_receiver(_delay_us_receiver);
//
//		for (unsigned char i = 0; i < 8; i++) {
//			//setButton3stateHIGH();
//			bit_delay_receiver(_delay_us_receiver);
//
//			//setButton3stateLOW();
//			_data |= (bool)((PC_IDR & BUTTON2_BIT) == BUTTON2_BIT) << i;
//
//			bit_delay_receiver(_delay_us_receiver);
//		}
//		// setButton3stateHIGH();
//	}
//	//setButton3stateHIGH();
//
//	bit_delay_receiver(_delay_us_receiver);
//
//	if ((PC_IDR & BUTTON2_BIT) == BUTTON2_BIT) {
//		data_received = _data;
//	}
//
//	bit_delay_receiver(_delay_us_receiver);
}

void set_serial_sender() {
	int param_tmp;

	if (param_sender < 10) {
		param_tmp = getParamById(param_sender);

		Msg_ref[0] = 'A' + param_sender;

	} else {
		param_tmp = temp;

		Msg_ref[0] = 'T';
	}

	itofpa(param_tmp, (char*) Msg, 0);

	if (param_sender <= 9) {
		param_sender++;
	} else {
		param_sender = 0;
	}
}

void serial_sender() {
	if ((sender_start == false) || (empty_bit_send == false)) {
		return;
	}

	char txt;

	if (sender_index <= ((sizeof Msg) + 3)) {
		if (sender_index == 0) {
			serial_sender_byte(Msg_ref[0]);

		} else if ((sender_index > 0) && (sender_index <= (sizeof Msg))) {
			txt = Msg[sender_index - 1];

			serial_sender_byte(txt);

		} else if (sender_index == ((sizeof Msg) + 2)) {
			serial_sender_byte(13);

		} else if (sender_index == ((sizeof Msg) + 3)) {
			serial_sender_byte(10);
		}

		sender_index++;

	} else {
		sender_start = false;

		sender_index = 0;
	}
}

void serial_sender_byte(unsigned char data) {
	empty_bit_send = false;

	start_bit_send = false;

	stop_bit_send = false;

	data_buffer_send = data;

	data_counter_send = 0;

	TIM2_CR1 = 0x05;    // Enable timer

//	setButton3stateLOW();
//	bit_delay_sender(_delay_us);                   // start bit
//
//	for (unsigned char i = 0; i < 8; i++) {
//		if (data & 0x01) {
//			setButton3stateHIGH();
//		} else {
//			setButton3stateLOW();
//		}
//
//		bit_delay_sender(_delay_us);
//
//		data >>= 1;  // get the next most significant bit
//	}
//
//	setButton3stateHIGH();
//	bit_delay_sender(_delay_us);
}

void bit_delay_sender(unsigned int value) {
	while (value--) {
		nop();
	}
}

void bit_delay_receiver(unsigned int value) {
	while (value--) {
		nop();
	}
}

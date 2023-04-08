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

bool remote_enabled = true;

//volatile int data_received = 0;
volatile int data_buffer = 0;
volatile char data_counter = 0;
volatile bool start_bit = false;

volatile int data_buffer_send = 0;
volatile char data_counter_send = 0;
volatile bool empty_bit_send = true;
volatile bool start_bit_send = false;
volatile bool stop_bit_send = false;
volatile bool pause_bit_send = false;

volatile unsigned char index_received;
volatile bool complete_received;
volatile unsigned char received_paramID;
volatile int received_param;

#define index_received_max 10
volatile unsigned char _data_buffer[index_received_max];

char Msg_send[index_received_max];
byte param_sender = 0;
byte sender_index = 0;
byte sender_start = 0;

extern int temp;

void initSerialReceiver(void) {
	disableInterrupts();

	PC_DDR &= ~BUTTON2_BIT;  // Pull-up with interrupt on pin PC3
	PC_CR2 |= BUTTON2_BIT;   // Pull-up with interrupt on pin PC3
	PC_CR1 |= BUTTON2_BIT;   // Pull-up with interrupt on pin PC3

	EXTI_CR1 |= 0x20;   // generate interrupt on falling edge.

	enableInterrupts();
}

void receiver_Handle(void) {
	if (remote_enabled == false) {
		return;
	}

	disableButton2interrupt();

	data_counter = 0;
	data_buffer = 0;
	start_bit = false;

	TIM1_CNTRH = 0xFE;
	TIM1_CNTRL = 0x63;

	TIM1_CR1 = 0x05;    // Enable timer
}

void receiver_data(unsigned char _data) {
	//	PA000.7121
	//	PB002.0125
	//	PC110.0124
	//	PD-50.0123
	//	PE000.3121
	//	PF000.2121
	//	PG000.1121
	//	PH000.1120
	//	PI000.1119
	//	PJ024.6107
	//	PT000.0109

	if (_data == 'S') { //  && (complete_received == false)
		_data_buffer[0] = _data;

		index_received = 1;

		complete_received = false;

		//temp = 1;

	} else if (index_received < index_received_max) {
		_data_buffer[index_received] = _data;

		index_received++;

		if (index_received == index_received_max) {
			if (calcCheckSum(_data_buffer, true) != -1) {
				received_paramID = _data_buffer[1] - 'A';
				if(received_paramID < 10) {
					received_param = (_data_buffer[3] - '0') * 100;
					received_param += (_data_buffer[4] - '0') * 10;
					received_param += (_data_buffer[6] - '0');

					if(_data_buffer[2] == '-') {
						received_param *= -1;

					} else {
						received_param += (_data_buffer[2] - '0') * 1000;
					}

					if(getParamById(received_paramID) != received_param){
						setParamById(received_paramID, received_param);
					}
//
//					temp = received_paramID;
				}
			}
		}
	}
}

void set_serial_sender() {
	int param_tmp;
	unsigned char dat1000 = 0;
	unsigned char dat100 = 0;
	unsigned char dat10 = 0;
	unsigned char dat1 = 0;
	bool isNegative = false;

//	PA000.7121
//	PB002.0125
//	PC110.0124
//	PD-50.0123
//	PE000.3121
//	PF000.2121
//	PG000.1121
//	PH000.1120
//	PI000.1119
//	PJ024.6107
//	PT000.0109

	Msg_send[0] = 'P';

	if (param_sender < 10) {
		param_tmp = getParamById(param_sender);

		Msg_send[1] = 'A' + param_sender;

	} else {
		param_tmp = temp;

		Msg_send[1] = 'T';
	}

	if (param_tmp < 0) {
		param_tmp *= -1;
		isNegative = true;
		Msg_send[2] = '-';
	}

	dat1000 = param_tmp / 1000;
	param_tmp -= dat1000 * 1000;
	dat100 = param_tmp / 100;
	param_tmp -= dat100 * 100;
	dat10 = param_tmp / 10;
	param_tmp -= dat10 * 10;
	dat1 = param_tmp;

	Msg_send[3] = dat100 + 48;
	Msg_send[4] = dat10 + 48;
	Msg_send[5] = '.';
	Msg_send[6] = dat1 + 48;
	Msg_send[7] = '-';
	Msg_send[8] = '-';
	Msg_send[9] = '-';

	if (isNegative == false) {
		Msg_send[2] = dat1000 + 48;
	}

	calcCheckSum(Msg_send, true);

	if (param_sender <= 9) {
		param_sender++;
	} else {
		param_sender = 0;
	}
}

void serial_sender() {
	if ((sender_start == false)
			|| (empty_bit_send == false)
			|| (remote_enabled == false)) {
		return;
	}

	if (sender_index < index_received_max) {
		serial_sender_byte(Msg_send[sender_index]);
	}

	sender_index++;

	if (sender_index == (index_received_max + 1)) {
		serial_sender_byte(13);

	} else if (sender_index == (index_received_max + 2)) {
		serial_sender_byte(10);
	} else if (sender_index == (index_received_max + 3)) {
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

int calcCheckSum(unsigned char *buffer, bool _set_buffer) {
	int result = 0;
	unsigned int sum = 0;
	unsigned char sum100 = 0;
	unsigned char sum10 = 0;
	unsigned char sum1 = 0;

	for (int i = 0; i <= 6; i++) {
		sum += buffer[i];
	}

	sum &= 0xFF;

	sum = 0xFF - sum;

	result = sum;

	if (_set_buffer == true) {
		sum100 = sum / 100;
		sum -= sum100 * 100;
		sum10 = sum / 10;
		sum -= sum10 * 10;
		sum1 = sum;

		sum100 += '0';
		sum10 += '0';
		sum1 += '0';

		if ((sum100 != buffer[7]) || (sum10 != buffer[8])
				|| (sum1 != buffer[9])) {
			result = -1;
		}

		buffer[7] = sum100;
		buffer[8] = sum10;
		buffer[9] = sum1;
	}

	return result;
}

/*
 * hc595.c
 *
 *  Created on: 13 de abr. de 2023
 *      Author: user
 */

#include "hc595.h"

#define HC595_data   0x02 // PA1
#define HC595_clock  0x08 // PA3
#define HC595_update 0x02 // PD1

#define HC595_data_port   PA_ODR // PA1/PA3
#define HC595_clock_port  PA_ODR // PA1/PA3
#define HC595_update_port PD_ODR // PD1

#define SSD_SEG_A_BIT  0x10 // 4
#define SSD_SEG_B_BIT  0x80 // 7
#define SSD_SEG_C_BIT  0x08 // 3
#define SSD_SEG_D_BIT  0x02 // 1
#define SSD_SEG_E_BIT  0x01 // 0
#define SSD_SEG_F_BIT  0x20 // 5
#define SSD_SEG_G_BIT  0x40 // 6
#define SSD_SEG_P_BIT  0x04 // 2

#define SSD_SEG_P_POS  2 // 2

void HC595_init(void) {
	PA_DDR |= HC595_data | HC595_clock;		// output
	PA_CR1 |= (HC595_data | HC595_clock);
//	PA_ODR &= ~(HC595_data | HC595_clock);

	PD_DDR |= HC595_update; 				// output
	PD_CR1 |= HC595_update;
//	PD_ODR &= ~HC595_update;

	set_hc595(0xFF, false);
}

void set_segment_dot(unsigned char *displayData, unsigned char id, bool val) {
	if (val) {
		displayData[id] |= SSD_SEG_P_BIT;
	} else {
		displayData[id] &= ~SSD_SEG_P_BIT;
	}
}

void set_segments(unsigned char *displayData, unsigned char id,
		unsigned char val, bool dot, bool testMode) {

	if (id > 2)
		return;

	switch (val) {
	case '-':
		displayData[id] = SSD_SEG_G_BIT;
		break;

	case ' ':
		displayData[id] = 0;
		break;

	case '0':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT
				| SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case '1':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
		break;

	case '2':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_G_BIT | SSD_SEG_A_BIT
				| SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case '3':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT
				| SSD_SEG_A_BIT | SSD_SEG_D_BIT;
		break;

	case '4':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT
				| SSD_SEG_G_BIT;
		break;

	case '5':
	case 'S':
		displayData[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT
				| SSD_SEG_A_BIT | SSD_SEG_D_BIT;
		break;

	case '6':
		displayData[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT
				| SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case '7':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_A_BIT;
		break;

	case '8':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT
				| SSD_SEG_G_BIT | SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case '9':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT
				| SSD_SEG_G_BIT | SSD_SEG_A_BIT | SSD_SEG_D_BIT;
		break;

	case 'A':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT
				| SSD_SEG_G_BIT | SSD_SEG_A_BIT | SSD_SEG_E_BIT;
		break;

	case 'B':
		displayData[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT
				| SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case 'C':
		displayData[id] = SSD_SEG_F_BIT | SSD_SEG_A_BIT | SSD_SEG_D_BIT
				| SSD_SEG_E_BIT;
		break;

	case 'D':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT
				| SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case 'E':
		displayData[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT | SSD_SEG_A_BIT
				| SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case 'F':
		displayData[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT | SSD_SEG_A_BIT
				| SSD_SEG_E_BIT;
		break;

	case 'H':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT
				| SSD_SEG_G_BIT | SSD_SEG_E_BIT;
		break;

	case 'L':
		displayData[id] = SSD_SEG_F_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case 'N':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT
				| SSD_SEG_A_BIT | SSD_SEG_E_BIT;
		break;

	case 'O':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT
				| SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
		break;

	case 'P':
		displayData[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT
				| SSD_SEG_A_BIT | SSD_SEG_E_BIT;
		break;

	case 'R':
		displayData[id] = SSD_SEG_G_BIT | SSD_SEG_E_BIT;
		break;

	case 'T':
		displayData[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT | SSD_SEG_D_BIT
				| SSD_SEG_E_BIT;
		break;

	default:
		displayData[id] = SSD_SEG_D_BIT;
	}

	if ((dot == true) && ((id != 0) || (testMode == true))) { // do not show DOT0 for Digit 0; only for test mode
		displayData[id] |= SSD_SEG_P_BIT;
	} else {
		displayData[id] &= ~SSD_SEG_P_BIT;
	}
}

void set_hc595(unsigned char data, bool ctrl_dot) {
	for (int i = 7; i >= 0; i--) {
		if ((ctrl_dot) && (i == SSD_SEG_P_POS)) {
			HC595_data_port |= HC595_data;
		} else {
			if ((data >> i) & 1) {
				HC595_data_port &= ~HC595_data;
			} else {
				HC595_data_port |= HC595_data;
			}
		}

		HC595_clock_port |= HC595_clock;  // HIGH
		HC595_clock_port &= ~HC595_clock; // LOW

	}

	HC595_update_port |= HC595_update;  // HIGH

	HC595_update_port &= ~HC595_update; // LOW
}


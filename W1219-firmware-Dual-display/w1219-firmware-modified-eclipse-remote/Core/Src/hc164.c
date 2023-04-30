/*
 * hc164.c
 *
 *  Created on: 29 de abr. de 2023
 *      Author: user
 */

#include "hc164.h"

#define HC164_data   0x04 // PD2
#define HC164_clock  0x08 // PD3

#define HC164_data_port   PD_ODR // PD2
#define HC164_clock_port  PD_ODR // PD3

#define SSD_SEG_A_BIT  0x01 // 0
#define SSD_SEG_B_BIT  0x10 // 4
#define SSD_SEG_C_BIT  0x40 // 6
#define SSD_SEG_D_BIT  0x04 // 2
#define SSD_SEG_E_BIT  0x08 // 3
#define SSD_SEG_F_BIT  0x80 // 7
#define SSD_SEG_G_BIT  0x20 // 5
#define SSD_SEG_P_BIT  0x02 // 1

#define SSD_SEG_P_POS  1

void HC164_init(void) {
	PD_DDR |= (HC164_data | HC164_clock);		// output
	PD_CR1 |= (HC164_data | HC164_clock);
	//PD_ODR &= ~(HC164_data | HC164_clock);

	set_hc164(0x00, false);
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

void set_hc164(unsigned char data, bool ctrl_dot) {
	for (int i = 7; i >= 0; i--) {
		if ((ctrl_dot) && (i == SSD_SEG_P_POS)) {
			HC164_data_port |= HC164_data;
		} else {
			if ((data >> i) & 1) {
				HC164_data_port |= HC164_data;
			} else {
				HC164_data_port &= ~HC164_data;
			}
		}

		HC164_clock_port |= HC164_clock;  // HIGH
		HC164_clock_port &= ~HC164_clock; // LOW

	}
}

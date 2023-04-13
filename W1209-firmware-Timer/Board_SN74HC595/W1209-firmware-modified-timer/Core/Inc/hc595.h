/*
 * hc595.h
 *
 *  Created on: 13 de abr. de 2023
 *      Author: user
 */

#ifndef HC595_H_
#define HC595_H_

#include "main.h"

void HC595_init(void);
void set_segment_dot(unsigned char *displayData, unsigned char id, bool val);
void set_segments(unsigned char *displayData, unsigned char id,
		unsigned char val, bool dot, bool testMode);
void set_hc595(unsigned char data, bool ctrl_dot);

#endif /* CORE_INC_HC595_H_ */

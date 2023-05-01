/*
 * hc164.h
 *
 *  Created on: 29 de abr. de 2023
 *      Author: user
 */

#ifndef HC164_H_
#define HC164_H_

#include "main.h"

void HC164_init(void);
void set_segment_dot(unsigned char *displayData, unsigned char id, bool val);
void set_segments(unsigned char *displayData, unsigned char id,
		unsigned char val, bool dot, bool testMode);
void set_hc164(unsigned char data, bool ctrl_dot);

#endif /* HC164_H_ */

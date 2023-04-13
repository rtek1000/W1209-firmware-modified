/*
 * iwdg.c
 *
 *  Created on: 13 de abr. de 2023
 *      Author: user
 */

#include "iwdg.h"

/* IWDG */
#define IWDG_KEY_ENABLE         0xCC
#define IWDG_KEY_REFRESH        0xAA
#define IWDG_KEY_ACCESS         0x55

/**
 * Initialize IWDG:
 * prescaler = /256, timeout = 1.02 s
 */

void IWDG_init(void) {
	IWDG_KR = IWDG_KEY_ENABLE;
	IWDG_KR = IWDG_KEY_ACCESS;
	IWDG_PR = 6;
	IWDG_KR = IWDG_KEY_REFRESH;
}

/**
 * Reset IWDG
 */
void IWDG_refresh(void) {
	IWDG_KR = IWDG_KEY_REFRESH;
}

;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module timer
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _refreshRelay
	.globl _refreshMenu
	.globl _refreshDisplay
	.globl _startADC
	.globl _initTimer
	.globl _resetUptime
	.globl _getUptime
	.globl _getUptimeTicks
	.globl _getUptimeSeconds
	.globl _getUptimeMinutes
	.globl _getUptimeHours
	.globl _getUptimeDays
	.globl _TIM4_UPD_handler
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_uptime:
	.ds 4
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	./timer.c: 54: void initTimer()
;	-----------------------------------------
;	 function initTimer
;	-----------------------------------------
_initTimer:
;	./timer.c: 56: CLK_CKDIVR = 0x00;  // Set the frequency to 16 MHz
	mov	0x50c6+0, #0x00
;	./timer.c: 57: TIM4_PSCR = 0x07;   // CLK / 128 = 125KHz
	mov	0x5347+0, #0x07
;	./timer.c: 58: TIM4_ARR = 0xFA;    // 125KHz /  250(0xFA) = 500
	mov	0x5348+0, #0xfa
;	./timer.c: 59: TIM4_IER = 0x01;    // Enable interrupt on update event
	mov	0x5343+0, #0x01
;	./timer.c: 60: TIM4_CR1 = 0x05;    // Enable timer
	mov	0x5340+0, #0x05
;	./timer.c: 61: resetUptime();
;	./timer.c: 62: }
	jp	_resetUptime
;	./timer.c: 67: void resetUptime()
;	-----------------------------------------
;	 function resetUptime
;	-----------------------------------------
_resetUptime:
;	./timer.c: 69: uptime = 0;
	clrw	x
	ldw	_uptime+2, x
	ldw	_uptime+0, x
;	./timer.c: 70: }
	ret
;	./timer.c: 78: unsigned long getUptime()
;	-----------------------------------------
;	 function getUptime
;	-----------------------------------------
_getUptime:
;	./timer.c: 80: return uptime;
	ldw	x, _uptime+2
	ldw	y, _uptime+0
;	./timer.c: 81: }
	ret
;	./timer.c: 87: unsigned int getUptimeTicks()
;	-----------------------------------------
;	 function getUptimeTicks
;	-----------------------------------------
_getUptimeTicks:
;	./timer.c: 89: return (unsigned int) (uptime & BITMASK (BITS_FOR_TICKS) );
	ldw	x, _uptime+2
	ld	a, xh
	and	a, #0x01
	ld	xh, a
;	./timer.c: 90: }
	ret
;	./timer.c: 96: unsigned char getUptimeSeconds()
;	-----------------------------------------
;	 function getUptimeSeconds
;	-----------------------------------------
_getUptimeSeconds:
	sub	sp, #4
;	./timer.c: 98: return (unsigned char) ( (uptime >> SECONDS_FIRST_BIT) & BITMASK (BITS_FOR_SECONDS) );
	ld	a, _uptime+2
	ldw	x, _uptime+0
	clr	(0x01, sp)
	srlw	x
	rrc	a
	srlw	x
	rrc	a
	and	a, #0x3f
;	./timer.c: 99: }
	addw	sp, #4
	ret
;	./timer.c: 105: unsigned char getUptimeMinutes()
;	-----------------------------------------
;	 function getUptimeMinutes
;	-----------------------------------------
_getUptimeMinutes:
;	./timer.c: 107: return (unsigned char) ( (uptime >> MINUTES_FIRST_BIT) & BITMASK (BITS_FOR_MINUTES) );
	ldw	x, _uptime+0
	ld	a, xl
	and	a, #0x3f
;	./timer.c: 108: }
	ret
;	./timer.c: 114: unsigned char getUptimeHours()
;	-----------------------------------------
;	 function getUptimeHours
;	-----------------------------------------
_getUptimeHours:
;	./timer.c: 116: return (unsigned char) ( (uptime >> HOURS_FIRST_BIT) & BITMASK (BITS_FOR_HOURS) );
	ldw	x, _uptime+0
	ld	a, #0x40
	div	x, a
	ld	a, xl
	and	a, #0x1f
;	./timer.c: 117: }
	ret
;	./timer.c: 123: unsigned char getUptimeDays()
;	-----------------------------------------
;	 function getUptimeDays
;	-----------------------------------------
_getUptimeDays:
	sub	sp, #4
;	./timer.c: 125: return (unsigned char) ( (uptime >> DAYS_FIRST_BIT) & BITMASK (BITS_FOR_DAYS) );
	ld	a, _uptime+0
	clr	(0x01, sp)
	srl	a
	srl	a
	srl	a
	and	a, #0x3f
;	./timer.c: 126: }
	addw	sp, #4
	ret
;	./timer.c: 132: void TIM4_UPD_handler() __interrupt (23)
;	-----------------------------------------
;	 function TIM4_UPD_handler
;	-----------------------------------------
_TIM4_UPD_handler:
	clr	a
	div	x, a
;	./timer.c: 134: TIM4_SR &= ~TIM_SR1_UIF; // Reset flag
	bres	21316, #0
;	./timer.c: 136: if ( ( (unsigned int) (uptime & BITMASK (BITS_FOR_TICKS) ) ) >= TICKS_IN_SECOND) {
	ldw	x, _uptime+2
	ld	a, xh
	and	a, #0x01
	ld	xh, a
	cpw	x, #0x01f4
	jrnc	00154$
	jp	00108$
00154$:
;	./timer.c: 137: uptime &= NBITMASK (SECONDS_FIRST_BIT);
	clr	a
	ld	xl, a
	ld	a, _uptime+2
	and	a, #0xfc
	ld	xh, a
	ldw	y, _uptime+0
	ldw	_uptime+2, x
	ldw	_uptime+0, y
;	./timer.c: 138: uptime += (unsigned long) 1 << SECONDS_FIRST_BIT;
	ldw	x, _uptime+2
	addw	x, #0x0400
	ldw	y, _uptime+0
	jrnc	00155$
	incw	y
00155$:
	ldw	_uptime+2, x
	ldw	_uptime+0, y
;	./timer.c: 141: if ( ( (unsigned char) (uptime >> SECONDS_FIRST_BIT) & BITMASK (BITS_FOR_SECONDS) ) == 60) {
	ld	a, _uptime+2
	ldw	x, _uptime+0
	srlw	x
	rrc	a
	srlw	x
	rrc	a
	and	a, #0x3f
	ld	xl, a
	clr	a
	clrw	y
	ld	xh, a
	cpw	x, #0x003c
	jrne	00102$
	tnzw	y
	jrne	00102$
;	./timer.c: 142: uptime &= NBITMASK (MINUTES_FIRST_BIT);
	clrw	x
	ldw	y, _uptime+0
	ldw	_uptime+2, x
	ldw	_uptime+0, y
;	./timer.c: 143: uptime += (unsigned long) 1 << MINUTES_FIRST_BIT;
	ldw	y, _uptime+2
	ldw	x, _uptime+0
	incw	x
	ldw	_uptime+2, y
	ldw	_uptime+0, x
00102$:
;	./timer.c: 147: if ( ( (unsigned char) (uptime >> MINUTES_FIRST_BIT) & BITMASK (BITS_FOR_MINUTES) ) == 60) {
	ldw	x, _uptime+0
	ld	a, xl
	and	a, #0x3f
	ld	xl, a
	clr	a
	clrw	y
	ld	xh, a
	cpw	x, #0x003c
	jrne	00104$
;	./timer.c: 148: uptime &= NBITMASK (HOURS_FIRST_BIT);
	tnzw	y
	jrne	00104$
	ld	a, _uptime+1
	and	a, #0xc0
	ld	xl, a
	ld	a, _uptime+0
	ld	xh, a
	ldw	_uptime+2, y
	ldw	_uptime+0, x
;	./timer.c: 149: uptime += (unsigned long) 1 << HOURS_FIRST_BIT;
	ldw	y, _uptime+2
	ldw	x, _uptime+0
	addw	x, #0x0040
	ldw	_uptime+2, y
	ldw	_uptime+0, x
00104$:
;	./timer.c: 153: if ( ( (unsigned char) (uptime >> HOURS_FIRST_BIT) & BITMASK (BITS_FOR_HOURS) ) == 24) {
	ldw	x, _uptime+0
	ld	a, #0x40
	div	x, a
	ld	a, xl
	and	a, #0x1f
	ld	xl, a
	clr	a
	clrw	y
	ld	xh, a
	cpw	x, #0x0018
	jrne	00108$
;	./timer.c: 154: uptime &= NBITMASK (DAYS_FIRST_BIT);
	tnzw	y
	jrne	00108$
	clr	a
	ld	xl, a
	ld	a, _uptime+0
	and	a, #0xf8
	ld	xh, a
	ldw	_uptime+2, y
	ldw	_uptime+0, x
;	./timer.c: 155: uptime += (unsigned long) 1 << DAYS_FIRST_BIT;
	ldw	y, _uptime+2
	ldw	x, _uptime+0
	addw	x, #0x0800
	ldw	_uptime+2, y
	ldw	_uptime+0, x
00108$:
;	./timer.c: 159: uptime++;
	ldw	x, _uptime+2
	addw	x, #0x0001
	ldw	y, _uptime+0
	jrnc	00165$
	incw	y
00165$:
	ldw	_uptime+2, x
	ldw	_uptime+0, y
;	./timer.c: 162: if ( ( (unsigned char) getUptimeTicks() & 0x0F) == 1) {
	call	_getUptimeTicks
	ld	a, xl
	and	a, #0x0f
	ld	xl, a
	clr	a
	ld	xh, a
	decw	x
	jrne	00115$
;	./timer.c: 163: refreshMenu();
	call	_refreshMenu
	jra	00116$
00115$:
;	./timer.c: 164: } else if ( ( (unsigned char) getUptimeTicks() & 0xFF) == 2) {
	call	_getUptimeTicks
	clr	a
	ld	xh, a
	cpw	x, #0x0002
	jrne	00112$
;	./timer.c: 165: startADC();
	call	_startADC
	jra	00116$
00112$:
;	./timer.c: 166: } else if ( ( (unsigned char) getUptimeTicks() & 0xFF) == 3) {
	call	_getUptimeTicks
	clr	a
	ld	xh, a
	cpw	x, #0x0003
	jrne	00116$
;	./timer.c: 167: refreshRelay();
	call	_refreshRelay
00116$:
;	./timer.c: 170: refreshDisplay();
	call	_refreshDisplay
;	./timer.c: 171: }
	iret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)

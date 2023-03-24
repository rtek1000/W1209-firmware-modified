;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module relay
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _getParamById
	.globl _getTemperature
	.globl _getSensorFail
	.globl _initRelay
	.globl _setRelay
	.globl _refreshRelay
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_timer:
	.ds 2
_state:
	.ds 1
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
;	./relay.c: 38: void initRelay()
;	-----------------------------------------
;	 function initRelay
;	-----------------------------------------
_initRelay:
;	./relay.c: 40: PA_DDR |= RELAY_BIT;
	bset	20482, #3
;	./relay.c: 41: PA_CR1 |= RELAY_BIT;
	bset	20483, #3
;	./relay.c: 42: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./relay.c: 43: state = false;
	clr	_state+0
;	./relay.c: 44: }
	ret
;	./relay.c: 50: void setRelay (bool on)
;	-----------------------------------------
;	 function setRelay
;	-----------------------------------------
_setRelay:
;	./relay.c: 53: RELAY_PORT |= RELAY_BIT;
	ld	a, 0x5000
;	./relay.c: 52: if (on) {
	tnz	(0x03, sp)
	jreq	00102$
;	./relay.c: 53: RELAY_PORT |= RELAY_BIT;
	or	a, #0x08
	ld	0x5000, a
	ret
00102$:
;	./relay.c: 55: RELAY_PORT &= ~RELAY_BIT;
	and	a, #0xf7
	ld	0x5000, a
;	./relay.c: 58: }
	ret
;	./relay.c: 64: void refreshRelay()
;	-----------------------------------------
;	 function refreshRelay
;	-----------------------------------------
_refreshRelay:
	sub	sp, #10
;	./relay.c: 68: int sensor_fail = getSensorFail();
	call	_getSensorFail
	ldw	(0x08, sp), x
;	./relay.c: 70: if (getParamById (PARAM_RELAY_MODE) == 2) {
	push	#0x00
	call	_getParamById
	pop	a
	cpw	x, #0x0002
	jrne	00105$
;	./relay.c: 71: alarm_mode = 1;
;	./relay.c: 72: mode = 1;
	ld	a, #0x01
	ld	(0x0a, sp), a
	ld	(0x01, sp), a
	jra	00106$
00105$:
;	./relay.c: 73: } else if (getParamById (PARAM_RELAY_MODE) == 3) {
	push	#0x00
	call	_getParamById
	pop	a
	cpw	x, #0x0003
	jrne	00102$
;	./relay.c: 74: alarm_mode = 1;
	ld	a, #0x01
	ld	(0x0a, sp), a
;	./relay.c: 75: mode = 0;
	clr	(0x01, sp)
	jra	00106$
00102$:
;	./relay.c: 77: alarm_mode = 0;
	clr	(0x0a, sp)
;	./relay.c: 78: mode = getParamById (PARAM_RELAY_MODE);
	push	#0x00
	call	_getParamById
	pop	a
	negw	x
	clr	a
	rlc	a
	ld	(0x01, sp), a
00106$:
;	./relay.c: 81: if(sensor_fail == 0) {
	ldw	x, (0x08, sp)
	jreq	00210$
	jp	00135$
00210$:
;	./relay.c: 86: setRelay (!mode);
	ld	a, (0x01, sp)
	xor	a, #0x01
	ld	(0x02, sp), a
;	./relay.c: 82: if (alarm_mode) {
	tnz	(0x0a, sp)
	jrne	00211$
	jp	00129$
00211$:
;	./relay.c: 83: if ((getTemperature() > (getParamById (PARAM_MIN_TEMPERATURE) * 10) ) &&
	call	_getTemperature
	ldw	(0x09, sp), x
	push	#0x03
	call	_getParamById
	pop	a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
	cpw	x, (0x09, sp)
	jrsge	00108$
;	./relay.c: 84: (getTemperature() < (getParamById (PARAM_MAX_TEMPERATURE) * 10) ) ) {
	call	_getTemperature
	ldw	(0x07, sp), x
	push	#0x02
	call	_getParamById
	pop	a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
	ldw	(0x09, sp), x
	ldw	x, (0x07, sp)
	cpw	x, (0x09, sp)
	jrsge	00108$
;	./relay.c: 85: state = false;
	clr	_state+0
;	./relay.c: 86: setRelay (!mode);
	ld	a, (0x02, sp)
	push	a
	call	_setRelay
	pop	a
00108$:
;	./relay.c: 89: if ((getTemperature() <= (getParamById (PARAM_MIN_TEMPERATURE) * 10) ) ||
	call	_getTemperature
	ldw	(0x09, sp), x
	push	#0x03
	call	_getParamById
	pop	a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
	cpw	x, (0x09, sp)
	jrsge	00110$
;	./relay.c: 90: (getTemperature() >= (getParamById (PARAM_MAX_TEMPERATURE) * 10) ) ) {
	call	_getTemperature
	ldw	(0x07, sp), x
	push	#0x02
	call	_getParamById
	pop	a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
	ldw	(0x09, sp), x
	ldw	x, (0x07, sp)
	cpw	x, (0x09, sp)
	jrsge	00215$
	jp	00137$
00215$:
00110$:
;	./relay.c: 91: state = true;
	mov	_state+0, #0x01
;	./relay.c: 92: setRelay (mode);
	ld	a, (0x01, sp)
	push	a
	call	_setRelay
	pop	a
	jp	00137$
00129$:
;	./relay.c: 95: if (state) { // Relay state is enabled
	btjt	_state+0, #0, 00216$
	jra	00126$
00216$:
;	./relay.c: 96: if (getTemperature() < (getParamById (PARAM_THRESHOLD)
	call	_getTemperature
	ldw	(0x03, sp), x
	push	#0x09
	call	_getParamById
	pop	a
	ldw	(0x05, sp), x
;	./relay.c: 97: - (getParamById (PARAM_RELAY_HYSTERESIS) >> 3) ) ) {
	push	#0x01
	call	_getParamById
	pop	a
	sraw	x
	sraw	x
	sraw	x
	ldw	(0x07, sp), x
	ldw	x, (0x05, sp)
	subw	x, (0x07, sp)
	ldw	(0x09, sp), x
	ldw	x, (0x03, sp)
	cpw	x, (0x09, sp)
	jrsge	00117$
;	./relay.c: 98: timer++;
	ldw	x, _timer+0
	incw	x
	ldw	_timer+0, x
;	./relay.c: 100: if ( (getParamById (PARAM_RELAY_DELAY) << RELAY_TIMER_MULTIPLIER) < timer) {
	push	#0x05
	call	_getParamById
	pop	a
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	cpw	x, _timer+0
	jrnc	00114$
;	./relay.c: 101: state = false;
	clr	_state+0
;	./relay.c: 102: setRelay (mode);
	ld	a, (0x01, sp)
	push	a
	call	_setRelay
	pop	a
	jp	00137$
00114$:
;	./relay.c: 104: setRelay (!mode);
	ld	a, (0x02, sp)
	push	a
	call	_setRelay
	pop	a
	jp	00137$
00117$:
;	./relay.c: 107: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./relay.c: 108: setRelay (!mode);
	ld	a, (0x02, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00137$
00126$:
;	./relay.c: 112: if (getTemperature() > (getParamById (PARAM_THRESHOLD)
	call	_getTemperature
	ldw	(0x07, sp), x
	push	#0x09
	call	_getParamById
	pop	a
	ldw	(0x09, sp), x
;	./relay.c: 113: + (getParamById (PARAM_RELAY_HYSTERESIS) >> 3) ) ) {
	push	#0x01
	call	_getParamById
	pop	a
	sraw	x
	sraw	x
	sraw	x
	addw	x, (0x09, sp)
	cpw	x, (0x07, sp)
	jrsge	00123$
;	./relay.c: 114: timer++;
	ldw	x, _timer+0
	incw	x
	ldw	_timer+0, x
;	./relay.c: 116: if ( (getParamById (PARAM_RELAY_DELAY) << RELAY_TIMER_MULTIPLIER) < timer) {
	push	#0x05
	call	_getParamById
	pop	a
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	cpw	x, _timer+0
	jrnc	00120$
;	./relay.c: 117: state = true;
	mov	_state+0, #0x01
;	./relay.c: 118: setRelay (!mode);
	ld	a, (0x02, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00137$
00120$:
;	./relay.c: 120: setRelay (mode);
	ld	a, (0x01, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00137$
00123$:
;	./relay.c: 123: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./relay.c: 124: setRelay (mode);
	ld	a, (0x01, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00137$
00135$:
;	./relay.c: 129: if (getParamById (PARAM_RELAY_MODE) == 2) {
	push	#0x00
	call	_getParamById
	pop	a
	cpw	x, #0x0002
	jrne	00132$
;	./relay.c: 130: state = true;
	mov	_state+0, #0x01
;	./relay.c: 131: setRelay (1);
	push	#0x01
	call	_setRelay
	pop	a
	jra	00137$
00132$:
;	./relay.c: 133: state = false;
	clr	_state+0
;	./relay.c: 134: setRelay (0);
	push	#0x00
	call	_setRelay
	pop	a
00137$:
;	./relay.c: 137: }
	addw	sp, #10
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)

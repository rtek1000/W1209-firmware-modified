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
;	./relay.c: 66: bool mode = getParamById (PARAM_RELAY_MODE);
	push	#0x00
	call	_getParamById
	pop	a
	negw	x
	clr	a
	rlc	a
;	./relay.c: 77: setRelay (!mode);
	ld	(0x01, sp), a
	xor	a, #0x01
	ld	(0x02, sp), a
;	./relay.c: 68: if (state) { // Relay state is enabled
	btjt	_state+0, #0, 00143$
	jra	00114$
00143$:
;	./relay.c: 69: if (getTemperature() < (getParamById (PARAM_THRESHOLD)
	call	_getTemperature
	ldw	(0x03, sp), x
	push	#0x09
	call	_getParamById
	pop	a
	ldw	(0x05, sp), x
;	./relay.c: 70: - (getParamById (PARAM_RELAY_HYSTERESIS) >> 3) ) ) {
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
	jrsge	00105$
;	./relay.c: 71: timer++;
	ldw	x, _timer+0
	incw	x
	ldw	_timer+0, x
;	./relay.c: 73: if ( (getParamById (PARAM_RELAY_DELAY) << RELAY_TIMER_MULTIPLIER) < timer) {
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
	jrnc	00102$
;	./relay.c: 74: state = false;
	clr	_state+0
;	./relay.c: 75: setRelay (mode);
	ld	a, (0x01, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00116$
00102$:
;	./relay.c: 77: setRelay (!mode);
	ld	a, (0x02, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00116$
00105$:
;	./relay.c: 80: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./relay.c: 81: setRelay (!mode);
	ld	a, (0x02, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00116$
00114$:
;	./relay.c: 84: if (getTemperature() > (getParamById (PARAM_THRESHOLD)
	call	_getTemperature
	ldw	(0x07, sp), x
	push	#0x09
	call	_getParamById
	pop	a
	ldw	(0x09, sp), x
;	./relay.c: 85: + (getParamById (PARAM_RELAY_HYSTERESIS) >> 3) ) ) {
	push	#0x01
	call	_getParamById
	pop	a
	sraw	x
	sraw	x
	sraw	x
	addw	x, (0x09, sp)
	cpw	x, (0x07, sp)
	jrsge	00111$
;	./relay.c: 86: timer++;
	ldw	x, _timer+0
	incw	x
	ldw	_timer+0, x
;	./relay.c: 88: if ( (getParamById (PARAM_RELAY_DELAY) << RELAY_TIMER_MULTIPLIER) < timer) {
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
	jrnc	00108$
;	./relay.c: 89: state = true;
	mov	_state+0, #0x01
;	./relay.c: 90: setRelay (!mode);
	ld	a, (0x02, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00116$
00108$:
;	./relay.c: 92: setRelay (mode);
	ld	a, (0x01, sp)
	push	a
	call	_setRelay
	pop	a
	jra	00116$
00111$:
;	./relay.c: 95: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./relay.c: 96: setRelay (mode);
	ld	a, (0x01, sp)
	push	a
	call	_setRelay
	pop	a
00116$:
;	./relay.c: 99: }
	addw	sp, #10
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)

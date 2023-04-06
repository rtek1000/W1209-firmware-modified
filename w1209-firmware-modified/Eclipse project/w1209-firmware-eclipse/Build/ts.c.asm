;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module ts
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _getUptimeSeconds
	.globl _getUptime
	.globl _initTimer
	.globl _initRelay
	.globl _itofpa
	.globl _paramToString
	.globl _getParamById
	.globl _getParamId
	.globl _initParamsEEPROM
	.globl _getMenuDisplay
	.globl _initMenu
	.globl _setDisplayTestMode
	.globl _setDisplayStr
	.globl _setDisplayOff
	.globl _initDisplay
	.globl _initButtons
	.globl _getTemperature
	.globl _initADC
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_main_stringBuffer_65536_13:
	.ds 14
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

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
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
	int 0x000000 ; trap
	int 0x000000 ; int0
	int 0x000000 ; int1
	int 0x000000 ; int2
	int 0x000000 ; int3
	int 0x000000 ; int4
	int _EXTI2_handler ; int5
	int 0x000000 ; int6
	int 0x000000 ; int7
	int 0x000000 ; int8
	int 0x000000 ; int9
	int 0x000000 ; int10
	int 0x000000 ; int11
	int 0x000000 ; int12
	int 0x000000 ; int13
	int 0x000000 ; int14
	int 0x000000 ; int15
	int 0x000000 ; int16
	int 0x000000 ; int17
	int 0x000000 ; int18
	int 0x000000 ; int19
	int 0x000000 ; int20
	int 0x000000 ; int21
	int _ADC1_EOC_handler ; int22
	int _TIM4_UPD_handler ; int23
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_gs_init_startup:
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	./ts.c: 33: int main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #11
;	./ts.c: 36: unsigned char paramMsg[] = {'P', '0', 0};
	ld	a, #0x50
	ld	(0x03, sp), a
	ldw	x, sp
	addw	x, #4
	ldw	(0x06, sp), x
	ld	a, #0x30
	ld	(x), a
	ldw	x, sp
	addw	x, #5
	clr	(x)
;	./ts.c: 38: initMenu();
	call	_initMenu
;	./ts.c: 39: initButtons();
	call	_initButtons
;	./ts.c: 40: initParamsEEPROM();
	call	_initParamsEEPROM
;	./ts.c: 41: initDisplay();
	call	_initDisplay
;	./ts.c: 42: initADC();
	call	_initADC
;	./ts.c: 43: initRelay();
	call	_initRelay
;	./ts.c: 44: initTimer();
	call	_initTimer
;	./ts.c: 46: INTERRUPT_ENABLE
	rim	
;	./ts.c: 49: while (true) {
00123$:
;	./ts.c: 50: if (getUptimeSeconds() > 0) {
	call	_getUptimeSeconds
	tnz	a
	jreq	00102$
;	./ts.c: 51: setDisplayTestMode (false, "");
	push	#<(___str_0 + 0)
	push	#((___str_0 + 0) >> 8)
	push	#0x00
	call	_setDisplayTestMode
	addw	sp, #3
00102$:
;	./ts.c: 54: if (getMenuDisplay() == MENU_ROOT) {
	call	_getMenuDisplay
	ld	(0x0b, sp), a
	jrne	00120$
;	./ts.c: 55: int temp = getTemperature();
	call	_getTemperature
	ldw	(0x08, sp), x
;	./ts.c: 56: itofpa (temp, (char*) stringBuffer, 0);
	ldw	x, #(_main_stringBuffer_65536_13 + 0)
	push	#0x00
	pushw	x
	ldw	x, (0x0b, sp)
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./ts.c: 57: setDisplayStr ( (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_13 + 0)
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
;	./ts.c: 59: if (getParamById (PARAM_OVERHEAT_INDICATION) ) {
	push	#0x06
	call	_getParamById
	pop	a
	tnzw	x
	jrne	00174$
	jp	00121$
00174$:
;	./ts.c: 60: if (temp < getParamById (PARAM_MIN_TEMPERATURE) ) {
	push	#0x03
	call	_getParamById
	pop	a
	ldw	(0x0a, sp), x
	ldw	x, (0x08, sp)
	cpw	x, (0x0a, sp)
	jrsge	00106$
;	./ts.c: 61: setDisplayStr ("LLL");
	push	#<(___str_1 + 0)
	push	#((___str_1 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jp	00121$
00106$:
;	./ts.c: 62: } else if (temp > getParamById (PARAM_MAX_TEMPERATURE) ) {
	push	#0x02
	call	_getParamById
	pop	a
	cpw	x, (0x08, sp)
	jrslt	00176$
	jp	00121$
00176$:
;	./ts.c: 63: setDisplayStr ("HHH");
	push	#<(___str_2 + 0)
	push	#((___str_2 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jp	00121$
00120$:
;	./ts.c: 66: } else if (getMenuDisplay() == MENU_SET_THRESHOLD) {
	call	_getMenuDisplay
	dec	a
	jrne	00117$
;	./ts.c: 67: paramToString (PARAM_THRESHOLD, (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_13 + 0)
	pushw	x
	push	#0x09
	call	_paramToString
	addw	sp, #3
;	./ts.c: 68: setDisplayStr ( (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_13 + 0)
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
	jra	00121$
00117$:
;	./ts.c: 69: } else if (getMenuDisplay() == MENU_SELECT_PARAM) {
	call	_getMenuDisplay
	cp	a, #0x02
	jrne	00114$
;	./ts.c: 70: paramMsg[1] = '0' + getParamId();
	call	_getParamId
	add	a, #0x30
	ldw	x, (0x06, sp)
	ld	(x), a
;	./ts.c: 71: setDisplayStr ( (unsigned char*) &paramMsg);
	ldw	x, sp
	addw	x, #3
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
	jra	00121$
00114$:
;	./ts.c: 72: } else if (getMenuDisplay() == MENU_CHANGE_PARAM) {
	call	_getMenuDisplay
	cp	a, #0x03
	jrne	00111$
;	./ts.c: 73: paramToString (getParamId(), (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_13 + 0)
	ldw	(0x01, sp), x
	ldw	y, x
	ldw	(0x09, sp), y
	call	_getParamId
	ld	(0x0b, sp), a
	ldw	x, (0x09, sp)
	pushw	x
	ld	a, (0x0d, sp)
	push	a
	call	_paramToString
	addw	sp, #3
;	./ts.c: 74: setDisplayStr ( (char *) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_13 + 0)
	ldw	(0x0a, sp), x
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
	jra	00121$
00111$:
;	./ts.c: 76: setDisplayStr ("ERR");
	push	#<(___str_3 + 0)
	push	#((___str_3 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
;	./ts.c: 77: setDisplayOff ( (bool) (getUptime() & 0x40) );
	call	_getUptime
	ldw	(0x0a, sp), x
	ldw	(0x08, sp), y
	ld	a, (0x0b, sp)
	sll	a
	sll	a
	clr	a
	rlc	a
	ld	(0x0b, sp), a
	push	a
	call	_setDisplayOff
	pop	a
00121$:
;	./ts.c: 80: WAIT_FOR_INTERRUPT
	wfi	
;	./ts.c: 82: }
	jp	00123$
	.area CODE
	.area CONST
	.area CONST
___str_0:
	.db 0x00
	.area CODE
	.area CONST
___str_1:
	.ascii "LLL"
	.db 0x00
	.area CODE
	.area CONST
___str_2:
	.ascii "HHH"
	.db 0x00
	.area CODE
	.area CONST
___str_3:
	.ascii "ERR"
	.db 0x00
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)

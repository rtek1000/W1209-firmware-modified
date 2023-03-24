;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module main
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _getUptimeSeconds
	.globl _getUptimeTicks
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
	.globl _getSensorFail
	.globl _initADC
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_main_stringBuffer_65536_16:
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
;	./main.c: 34: int main()
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #9
;	./main.c: 37: unsigned char paramMsg[] = {'P', '0', 0};
	ld	a, #0x50
	ld	(0x01, sp), a
	ldw	x, sp
	addw	x, #2
	ldw	(0x04, sp), x
	ld	a, #0x30
	ld	(x), a
	ldw	x, sp
	addw	x, #3
	clr	(x)
;	./main.c: 39: initMenu();
	call	_initMenu
;	./main.c: 40: initButtons();
	call	_initButtons
;	./main.c: 41: initParamsEEPROM();
	call	_initParamsEEPROM
;	./main.c: 42: initDisplay();
	call	_initDisplay
;	./main.c: 43: initADC();
	call	_initADC
;	./main.c: 44: initRelay();
	call	_initRelay
;	./main.c: 45: initTimer();
	call	_initTimer
;	./main.c: 47: INTERRUPT_ENABLE
	rim	
;	./main.c: 50: while (true) {
00150$:
;	./main.c: 51: if (getUptimeSeconds() > 0) {
	call	_getUptimeSeconds
	tnz	a
	jreq	00102$
;	./main.c: 52: setDisplayTestMode (false, "");
	push	#<(___str_0 + 0)
	push	#((___str_0 + 0) >> 8)
	push	#0x00
	call	_setDisplayTestMode
	addw	sp, #3
00102$:
;	./main.c: 55: if (getMenuDisplay() == MENU_ROOT) {
	call	_getMenuDisplay
	ld	(0x09, sp), a
	jreq	00245$
	jp	00147$
00245$:
;	./main.c: 56: int temp = getTemperature();
	call	_getTemperature
	ldw	(0x06, sp), x
;	./main.c: 57: int sensor_fail = getSensorFail();
	call	_getSensorFail
;	./main.c: 59: if(sensor_fail > 0) {
	cpw	x, #0x0000
	jrsle	00114$
;	./main.c: 60: bool blink = (bool) ( (unsigned char) getUptimeTicks() & 0x40);
	pushw	x
	call	_getUptimeTicks
	ldw	(0x0a, sp), x
	popw	x
	ld	a, (0x09, sp)
	sll	a
	sll	a
	clr	a
	rlc	a
	ld	(0x09, sp), a
;	./main.c: 62: if(sensor_fail == 1) {
	decw	x
	jrne	00104$
;	./main.c: 63: setDisplayStr ("HHH");
	push	#<(___str_1 + 0)
	push	#((___str_1 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jra	00105$
00104$:
;	./main.c: 65: setDisplayStr ("LLL");
	push	#<(___str_2 + 0)
	push	#((___str_2 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
00105$:
;	./main.c: 68: setDisplayOff (blink);
	ld	a, (0x09, sp)
	push	a
	call	_setDisplayOff
	pop	a
	jp	00148$
00114$:
;	./main.c: 70: itofpa (temp, (char*) stringBuffer, 0);
	ldw	x, #(_main_stringBuffer_65536_16 + 0)
	push	#0x00
	pushw	x
	ldw	x, (0x09, sp)
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./main.c: 71: setDisplayStr ( (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_16 + 0)
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
;	./main.c: 73: if (getParamById (PARAM_OVERHEAT_INDICATION) ) {
	push	#0x06
	call	_getParamById
	pop	a
	tnzw	x
	jrne	00250$
	jp	00148$
00250$:
;	./main.c: 74: bool blink = (bool) ( (unsigned char) getUptimeTicks() & 0x80);
	call	_getUptimeTicks
	ld	a, xl
	sll	a
	clr	a
	rlc	a
;	./main.c: 76: if (temp < (getParamById (PARAM_MIN_TEMPERATURE) * 10) ) {
	push	a
	push	#0x03
	call	_getParamById
	pop	a
	pop	a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
	ldw	(0x08, sp), x
	ldw	x, (0x06, sp)
	cpw	x, (0x08, sp)
	jrsge	00109$
;	./main.c: 77: setDisplayOff (blink);
	push	a
	call	_setDisplayOff
	pop	a
	jp	00148$
00109$:
;	./main.c: 78: } else if (temp >= (getParamById (PARAM_MAX_TEMPERATURE) * 10) ) {
	push	a
	push	#0x02
	call	_getParamById
	pop	a
	pop	a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
	ldw	(0x08, sp), x
	ldw	x, (0x06, sp)
	cpw	x, (0x08, sp)
	jrsge	00252$
	jp	00148$
00252$:
;	./main.c: 79: setDisplayOff (blink);
	push	a
	call	_setDisplayOff
	pop	a
	jp	00148$
00147$:
;	./main.c: 83: } else if (getMenuDisplay() == MENU_SET_THRESHOLD) {
	call	_getMenuDisplay
	dec	a
	jrne	00144$
;	./main.c: 84: paramToString (PARAM_THRESHOLD, (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_16 + 0)
	pushw	x
	push	#0x09
	call	_paramToString
	addw	sp, #3
;	./main.c: 85: setDisplayStr ( (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_16 + 0)
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
	jp	00148$
00144$:
;	./main.c: 86: } else if (getMenuDisplay() == MENU_SELECT_PARAM) {
	call	_getMenuDisplay
	cp	a, #0x02
	jrne	00141$
;	./main.c: 87: paramMsg[1] = '0' + getParamId();
	call	_getParamId
	add	a, #0x30
	ldw	x, (0x04, sp)
	ld	(x), a
;	./main.c: 88: setDisplayStr ( (unsigned char*) &paramMsg);
	ldw	x, sp
	incw	x
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
	jp	00148$
00141$:
;	./main.c: 89: } else if (getMenuDisplay() == MENU_CHANGE_PARAM) {
	call	_getMenuDisplay
	cp	a, #0x03
	jrne	00138$
;	./main.c: 90: paramToString (getParamId(), (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_16 + 0)
	pushw	x
	call	_getParamId
	push	a
	call	_paramToString
	addw	sp, #3
;	./main.c: 91: setDisplayStr ( (char *) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_16 + 0)
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
	jp	00148$
00138$:
;	./main.c: 92: } else if (getMenuDisplay() == MENU_ALARM) {
	call	_getMenuDisplay
	cp	a, #0x04
	jrne	00135$
;	./main.c: 93: if(getParamById(PARAM_RELAY_MODE) == 2) {
	push	#0x00
	call	_getParamById
	pop	a
	cpw	x, #0x0002
	jrne	00117$
;	./main.c: 94: setDisplayStr ("AL1");
	push	#<(___str_3 + 0)
	push	#((___str_3 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jra	00118$
00117$:
;	./main.c: 96: setDisplayStr ("AL2");
	push	#<(___str_4 + 0)
	push	#((___str_4 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
00118$:
;	./main.c: 98: setDisplayOff ( (bool) (getUptime() & 0x80) );
	call	_getUptime
	ld	a, xl
	sll	a
	clr	a
	rlc	a
	push	a
	call	_setDisplayOff
	pop	a
	jp	00148$
00135$:
;	./main.c: 99: } else if (getMenuDisplay() == MENU_ALARM_HIGH) {
	call	_getMenuDisplay
	cp	a, #0x05
	jrne	00132$
;	./main.c: 100: int temp = getParamById (PARAM_MAX_TEMPERATURE) * 10;
	push	#0x02
	call	_getParamById
	pop	a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
;	./main.c: 101: itofpa (temp, (char*) stringBuffer, 0);
	ldw	y, #(_main_stringBuffer_65536_16 + 0)
	push	#0x00
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./main.c: 102: setDisplayStr ( (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_16 + 0)
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
;	./main.c: 103: setDisplayOff ( (bool) (getUptime() & 0x80) );
	call	_getUptime
	ld	a, xl
	sll	a
	clr	a
	rlc	a
	push	a
	call	_setDisplayOff
	pop	a
	jp	00148$
00132$:
;	./main.c: 104: } else if (getMenuDisplay() == MENU_ALARM_LOW) {
	call	_getMenuDisplay
	cp	a, #0x06
	jrne	00129$
;	./main.c: 105: int temp = getParamById (PARAM_MIN_TEMPERATURE) * 10;
	push	#0x03
	call	_getParamById
	pop	a
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
;	./main.c: 106: itofpa (temp, (char*) stringBuffer, 0);
	ldw	y, #(_main_stringBuffer_65536_16 + 0)
	push	#0x00
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./main.c: 107: setDisplayStr ( (char*) stringBuffer);
	ldw	x, #(_main_stringBuffer_65536_16 + 0)
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
;	./main.c: 108: setDisplayOff ( (bool) (getUptime() & 0x80) );
	call	_getUptime
	ld	a, xl
	sll	a
	clr	a
	rlc	a
	push	a
	call	_setDisplayOff
	pop	a
	jra	00148$
00129$:
;	./main.c: 110: if(getMenuDisplay() == MENU_EEPROM_RESET) {
	call	_getMenuDisplay
	cp	a, #0x07
	jrne	00126$
;	./main.c: 111: setDisplayStr ("RST");
	push	#<(___str_5 + 0)
	push	#((___str_5 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jra	00148$
00126$:
;	./main.c: 112: } else if(getMenuDisplay() == MENU_EEPROM_LOCKED) {
	call	_getMenuDisplay
	cp	a, #0x08
	jrne	00123$
;	./main.c: 113: setDisplayStr (" P7");
	push	#<(___str_6 + 0)
	push	#((___str_6 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jra	00148$
00123$:
;	./main.c: 114: } else if(getMenuDisplay() == MENU_EEPROM_LOC_2) {
	call	_getMenuDisplay
	cp	a, #0x09
	jrne	00120$
;	./main.c: 115: setDisplayStr ("LOC");
	push	#<(___str_7 + 0)
	push	#((___str_7 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jra	00148$
00120$:
;	./main.c: 117: setDisplayStr ("ERR");
	push	#<(___str_8 + 0)
	push	#((___str_8 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
;	./main.c: 118: setDisplayOff ( (bool) (getUptime() & 0x40) );
	call	_getUptime
	ld	a, xl
	sll	a
	sll	a
	clr	a
	rlc	a
	push	a
	call	_setDisplayOff
	pop	a
00148$:
;	./main.c: 122: WAIT_FOR_INTERRUPT
	wfi	
;	./main.c: 124: }
	jp	00150$
	.area CODE
	.area CONST
	.area CONST
___str_0:
	.db 0x00
	.area CODE
	.area CONST
___str_1:
	.ascii "HHH"
	.db 0x00
	.area CODE
	.area CONST
___str_2:
	.ascii "LLL"
	.db 0x00
	.area CODE
	.area CONST
___str_3:
	.ascii "AL1"
	.db 0x00
	.area CODE
	.area CONST
___str_4:
	.ascii "AL2"
	.db 0x00
	.area CODE
	.area CONST
___str_5:
	.ascii "RST"
	.db 0x00
	.area CODE
	.area CONST
___str_6:
	.ascii " P7"
	.db 0x00
	.area CODE
	.area CONST
___str_7:
	.ascii "LOC"
	.db 0x00
	.area CODE
	.area CONST
___str_8:
	.ascii "ERR"
	.db 0x00
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)

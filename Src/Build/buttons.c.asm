;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module buttons
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _debounce
	.globl _getUptime
	.globl _feedMenu
	.globl _initButtons
	.globl _getButton
	.globl _getButtonDiff
	.globl _getButton1
	.globl _getButton2
	.globl _getButton3
	.globl _isButton1
	.globl _isButton2
	.globl _isButton3
	.globl _EXTI2_handler
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_status:
	.ds 1
_diff:
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
_debounce_buttons:
	.ds 4
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
;	./buttons.c: 48: void initButtons()
;	-----------------------------------------
;	 function initButtons
;	-----------------------------------------
_initButtons:
;	./buttons.c: 50: PC_CR1 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;
	ld	a, 0x500d
	or	a, #0x38
	ld	0x500d, a
;	./buttons.c: 51: PC_CR2 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;
	ld	a, 0x500e
	or	a, #0x38
	ld	0x500e, a
;	./buttons.c: 52: status = ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
	ld	a, 0x500b
	and	a, #0x38
	cpl	a
	ld	_status+0, a
;	./buttons.c: 53: diff = 0;
	clr	_diff+0
;	./buttons.c: 54: EXTI_CR1 |= 0x30;   // generate interrupt on falling and rising front.
	ld	a, 0x50a0
	or	a, #0x30
	ld	0x50a0, a
;	./buttons.c: 55: }
	ret
;	./buttons.c: 62: unsigned char getButton()
;	-----------------------------------------
;	 function getButton
;	-----------------------------------------
_getButton:
;	./buttons.c: 64: return status;
	ld	a, _status+0
;	./buttons.c: 65: }
	ret
;	./buttons.c: 71: unsigned char getButtonDiff()
;	-----------------------------------------
;	 function getButtonDiff
;	-----------------------------------------
_getButtonDiff:
;	./buttons.c: 73: return diff;
	ld	a, _diff+0
;	./buttons.c: 74: }
	ret
;	./buttons.c: 80: bool getButton1()
;	-----------------------------------------
;	 function getButton1
;	-----------------------------------------
_getButton1:
;	./buttons.c: 82: return status & BUTTON1_BIT;
	ld	a, _status+0
	swap	a
	sll	a
	clr	a
	rlc	a
;	./buttons.c: 83: }
	ret
;	./buttons.c: 89: bool getButton2()
;	-----------------------------------------
;	 function getButton2
;	-----------------------------------------
_getButton2:
;	./buttons.c: 91: return status & BUTTON2_BIT;
	ld	a, _status+0
	srl	a
	srl	a
	srl	a
	srl	a
	and	a, #0x01
;	./buttons.c: 92: }
	ret
;	./buttons.c: 98: bool getButton3()
;	-----------------------------------------
;	 function getButton3
;	-----------------------------------------
_getButton3:
;	./buttons.c: 100: return status & BUTTON3_BIT;
	ld	a, _status+0
	swap	a
	srl	a
	and	a, #0x01
;	./buttons.c: 101: }
	ret
;	./buttons.c: 107: bool isButton1()
;	-----------------------------------------
;	 function isButton1
;	-----------------------------------------
_isButton1:
;	./buttons.c: 109: if (diff & BUTTON1_BIT) {
	ld	a, _diff+0
	bcp	a, #0x08
	jreq	00102$
;	./buttons.c: 110: diff &= ~BUTTON1_BIT;
	bres	_diff+0, #3
;	./buttons.c: 111: return true;
	ld	a, #0x01
	ret
00102$:
;	./buttons.c: 114: return false;
	clr	a
;	./buttons.c: 115: }
	ret
;	./buttons.c: 121: bool isButton2()
;	-----------------------------------------
;	 function isButton2
;	-----------------------------------------
_isButton2:
;	./buttons.c: 123: if (diff & BUTTON2_BIT) {
	ld	a, _diff+0
	bcp	a, #0x10
	jreq	00102$
;	./buttons.c: 124: diff &= ~BUTTON2_BIT;
	bres	_diff+0, #4
;	./buttons.c: 125: return true;
	ld	a, #0x01
	ret
00102$:
;	./buttons.c: 128: return false;
	clr	a
;	./buttons.c: 129: }
	ret
;	./buttons.c: 135: bool isButton3()
;	-----------------------------------------
;	 function isButton3
;	-----------------------------------------
_isButton3:
;	./buttons.c: 137: if (diff & BUTTON3_BIT) {
	ld	a, _diff+0
	bcp	a, #0x20
	jreq	00102$
;	./buttons.c: 138: diff &= ~BUTTON3_BIT;
	bres	_diff+0, #5
;	./buttons.c: 139: return true;
	ld	a, #0x01
	ret
00102$:
;	./buttons.c: 142: return false;
	clr	a
;	./buttons.c: 143: }
	ret
;	./buttons.c: 145: bool debounce()
;	-----------------------------------------
;	 function debounce
;	-----------------------------------------
_debounce:
	sub	sp, #8
;	./buttons.c: 147: unsigned long _debounce = getUptime();
	call	_getUptime
	ldw	(0x03, sp), x
	ldw	(0x01, sp), y
;	./buttons.c: 149: if((_debounce - debounce_buttons) > 75) {
	ldw	x, (0x03, sp)
	subw	x, _debounce_buttons+2
	ldw	(0x07, sp), x
	ld	a, (0x02, sp)
	sbc	a, _debounce_buttons+1
	ld	(0x06, sp), a
	ld	a, (0x01, sp)
	sbc	a, _debounce_buttons+0
	ld	(0x05, sp), a
	ldw	x, #0x004b
	cpw	x, (0x07, sp)
	clr	a
	sbc	a, (0x06, sp)
	clr	a
	sbc	a, (0x05, sp)
	jrnc	00102$
;	./buttons.c: 150: debounce_buttons = _debounce;
	ldw	x, (0x03, sp)
	ldw	_debounce_buttons+2, x
	ldw	x, (0x01, sp)
	ldw	_debounce_buttons+0, x
;	./buttons.c: 151: return true;
	ld	a, #0x01
;	./buttons.c: 153: return false;
	.byte 0x21
00102$:
	clr	a
00104$:
;	./buttons.c: 155: }
	addw	sp, #8
	ret
;	./buttons.c: 161: void EXTI2_handler() __interrupt (5)
;	-----------------------------------------
;	 function EXTI2_handler
;	-----------------------------------------
_EXTI2_handler:
	clr	a
	div	x, a
;	./buttons.c: 164: diff = status ^ ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
	ld	a, 0x500b
	and	a, #0x38
	cpl	a
	xor	a, _status+0
	ld	_diff+0, a
;	./buttons.c: 165: status = ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
	ld	a, 0x500b
	and	a, #0x38
	cpl	a
	ld	_status+0, a
;	./buttons.c: 168: if (isButton1() ) {
	call	_isButton1
	tnz	a
	jreq	00126$
;	./buttons.c: 169: if(debounce()) {
	call	_debounce
	tnz	a
	jreq	00128$
;	./buttons.c: 170: if (getButton1() ) {
	call	_getButton1
	tnz	a
	jreq	00102$
;	./buttons.c: 171: event = MENU_EVENT_PUSH_BUTTON1;
	clr	a
	jra	00127$
00102$:
;	./buttons.c: 173: event = MENU_EVENT_RELEASE_BUTTON1;
	ld	a, #0x03
;	./buttons.c: 176: return;
	jra	00127$
00126$:
;	./buttons.c: 178: } else if (isButton2() ) {
	call	_isButton2
	tnz	a
	jreq	00123$
;	./buttons.c: 179: if(debounce()) {
	call	_debounce
	tnz	a
	jreq	00128$
;	./buttons.c: 180: if (getButton2() ) {
	call	_getButton2
	tnz	a
	jreq	00108$
;	./buttons.c: 181: event = MENU_EVENT_PUSH_BUTTON2;
	ld	a, #0x01
	jra	00127$
00108$:
;	./buttons.c: 183: event = MENU_EVENT_RELEASE_BUTTON2;
	ld	a, #0x04
;	./buttons.c: 186: return;
	jra	00127$
00123$:
;	./buttons.c: 188: } else if (isButton3() ) {
	call	_isButton3
	tnz	a
	jreq	00128$
;	./buttons.c: 189: if(debounce()) {
	call	_debounce
	tnz	a
	jreq	00128$
;	./buttons.c: 190: if (getButton3() ) {
	call	_getButton3
	tnz	a
	jreq	00114$
;	./buttons.c: 191: event = MENU_EVENT_PUSH_BUTTON3;
	ld	a, #0x02
;	./buttons.c: 193: event = MENU_EVENT_RELEASE_BUTTON3;
;	./buttons.c: 196: return;
;	./buttons.c: 199: return;
	.byte 0xc5
00114$:
	ld	a, #0x05
00127$:
;	./buttons.c: 202: feedMenu (event);
	push	a
	call	_feedMenu
	pop	a
00128$:
;	./buttons.c: 203: }
	iret
	.area CODE
	.area CONST
	.area INITIALIZER
__xinit__debounce_buttons:
	.byte #0x00, #0x00, #0x00, #0x00	; 0
	.area CABS (ABS)

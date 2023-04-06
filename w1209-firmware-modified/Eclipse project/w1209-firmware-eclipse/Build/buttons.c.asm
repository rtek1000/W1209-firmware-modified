;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module buttons
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
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
;	./buttons.c: 45: void initButtons()
;	-----------------------------------------
;	 function initButtons
;	-----------------------------------------
_initButtons:
;	./buttons.c: 47: PC_CR1 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;
	ld	a, 0x500d
	or	a, #0x38
	ld	0x500d, a
;	./buttons.c: 48: PC_CR2 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;
	ld	a, 0x500e
	or	a, #0x38
	ld	0x500e, a
;	./buttons.c: 49: status = ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
	ld	a, 0x500b
	and	a, #0x38
	cpl	a
	ld	_status+0, a
;	./buttons.c: 50: diff = 0;
	clr	_diff+0
;	./buttons.c: 51: EXTI_CR1 |= 0x30;   // generate interrupt on falling and rising front.
	ld	a, 0x50a0
	or	a, #0x30
	ld	0x50a0, a
;	./buttons.c: 52: }
	ret
;	./buttons.c: 59: unsigned char getButton()
;	-----------------------------------------
;	 function getButton
;	-----------------------------------------
_getButton:
;	./buttons.c: 61: return status;
	ld	a, _status+0
;	./buttons.c: 62: }
	ret
;	./buttons.c: 68: unsigned char getButtonDiff()
;	-----------------------------------------
;	 function getButtonDiff
;	-----------------------------------------
_getButtonDiff:
;	./buttons.c: 70: return diff;
	ld	a, _diff+0
;	./buttons.c: 71: }
	ret
;	./buttons.c: 77: bool getButton1()
;	-----------------------------------------
;	 function getButton1
;	-----------------------------------------
_getButton1:
;	./buttons.c: 79: return status & BUTTON1_BIT;
	ld	a, _status+0
	swap	a
	sll	a
	clr	a
	rlc	a
;	./buttons.c: 80: }
	ret
;	./buttons.c: 86: bool getButton2()
;	-----------------------------------------
;	 function getButton2
;	-----------------------------------------
_getButton2:
;	./buttons.c: 88: return status & BUTTON2_BIT;
	ld	a, _status+0
	srl	a
	srl	a
	srl	a
	srl	a
	and	a, #0x01
;	./buttons.c: 89: }
	ret
;	./buttons.c: 95: bool getButton3()
;	-----------------------------------------
;	 function getButton3
;	-----------------------------------------
_getButton3:
;	./buttons.c: 97: return status & BUTTON3_BIT;
	ld	a, _status+0
	swap	a
	srl	a
	and	a, #0x01
;	./buttons.c: 98: }
	ret
;	./buttons.c: 104: bool isButton1()
;	-----------------------------------------
;	 function isButton1
;	-----------------------------------------
_isButton1:
;	./buttons.c: 106: if (diff & BUTTON1_BIT) {
	ld	a, _diff+0
	bcp	a, #0x08
	jreq	00102$
;	./buttons.c: 107: diff &= ~BUTTON1_BIT;
	bres	_diff+0, #3
;	./buttons.c: 108: return true;
	ld	a, #0x01
	ret
00102$:
;	./buttons.c: 111: return false;
	clr	a
;	./buttons.c: 112: }
	ret
;	./buttons.c: 118: bool isButton2()
;	-----------------------------------------
;	 function isButton2
;	-----------------------------------------
_isButton2:
;	./buttons.c: 120: if (diff & BUTTON2_BIT) {
	ld	a, _diff+0
	bcp	a, #0x10
	jreq	00102$
;	./buttons.c: 121: diff &= ~BUTTON2_BIT;
	bres	_diff+0, #4
;	./buttons.c: 122: return true;
	ld	a, #0x01
	ret
00102$:
;	./buttons.c: 125: return false;
	clr	a
;	./buttons.c: 126: }
	ret
;	./buttons.c: 132: bool isButton3()
;	-----------------------------------------
;	 function isButton3
;	-----------------------------------------
_isButton3:
;	./buttons.c: 134: if (diff & BUTTON3_BIT) {
	ld	a, _diff+0
	bcp	a, #0x20
	jreq	00102$
;	./buttons.c: 135: diff &= ~BUTTON3_BIT;
	bres	_diff+0, #5
;	./buttons.c: 136: return true;
	ld	a, #0x01
	ret
00102$:
;	./buttons.c: 139: return false;
	clr	a
;	./buttons.c: 140: }
	ret
;	./buttons.c: 146: void EXTI2_handler() __interrupt (5)
;	-----------------------------------------
;	 function EXTI2_handler
;	-----------------------------------------
_EXTI2_handler:
	clr	a
	div	x, a
;	./buttons.c: 149: diff = status ^ ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
	ld	a, 0x500b
	and	a, #0x38
	cpl	a
	xor	a, _status+0
	ld	_diff+0, a
;	./buttons.c: 150: status = ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
	ld	a, 0x500b
	and	a, #0x38
	cpl	a
	ld	_status+0, a
;	./buttons.c: 153: if (isButton1() ) {
	call	_isButton1
	tnz	a
	jreq	00117$
;	./buttons.c: 154: if (getButton1() ) {
	call	_getButton1
	tnz	a
	jreq	00102$
;	./buttons.c: 155: event = MENU_EVENT_PUSH_BUTTON1;
	clr	a
	jra	00118$
00102$:
;	./buttons.c: 157: event = MENU_EVENT_RELEASE_BUTTON1;
	ld	a, #0x03
	jra	00118$
00117$:
;	./buttons.c: 159: } else if (isButton2() ) {
	call	_isButton2
	tnz	a
	jreq	00114$
;	./buttons.c: 160: if (getButton2() ) {
	call	_getButton2
	tnz	a
	jreq	00105$
;	./buttons.c: 161: event = MENU_EVENT_PUSH_BUTTON2;
	ld	a, #0x01
	jra	00118$
00105$:
;	./buttons.c: 163: event = MENU_EVENT_RELEASE_BUTTON2;
	ld	a, #0x04
	jra	00118$
00114$:
;	./buttons.c: 165: } else if (isButton3() ) {
	call	_isButton3
	tnz	a
	jreq	00119$
;	./buttons.c: 166: if (getButton3() ) {
	call	_getButton3
	tnz	a
	jreq	00108$
;	./buttons.c: 167: event = MENU_EVENT_PUSH_BUTTON3;
	ld	a, #0x02
;	./buttons.c: 169: event = MENU_EVENT_RELEASE_BUTTON3;
;	./buttons.c: 172: return;
	.byte 0xc5
00108$:
	ld	a, #0x05
00118$:
;	./buttons.c: 175: feedMenu (event);
	push	a
	call	_feedMenu
	pop	a
00119$:
;	./buttons.c: 176: }
	iret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)

;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module menu
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _getUptimeTicks
	.globl _setParamId
	.globl _storeParams
	.globl _decParamId
	.globl _incParamId
	.globl _decParam
	.globl _incParam
	.globl _setDisplayOff
	.globl _getButton3
	.globl _getButton2
	.globl _getButton1
	.globl _initMenu
	.globl _getMenuDisplay
	.globl _feedMenu
	.globl _refreshMenu
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_menuDisplay:
	.ds 1
_menuState:
	.ds 1
_timer:
	.ds 2
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
;	./menu.c: 40: void initMenu()
;	-----------------------------------------
;	 function initMenu
;	-----------------------------------------
_initMenu:
;	./menu.c: 42: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 43: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 44: }
	ret
;	./menu.c: 50: unsigned char getMenuDisplay()
;	-----------------------------------------
;	 function getMenuDisplay
;	-----------------------------------------
_getMenuDisplay:
;	./menu.c: 52: return menuDisplay;
	ld	a, _menuDisplay+0
;	./menu.c: 53: }
	ret
;	./menu.c: 72: void feedMenu (unsigned char event)
;	-----------------------------------------
;	 function feedMenu
;	-----------------------------------------
_feedMenu:
	sub	sp, #3
;	./menu.c: 84: if (timer < MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	clr	a
	rlc	a
	ld	(0x01, sp), a
;	./menu.c: 76: if (menuState == MENU_ROOT) {
	tnz	_menuState+0
	jrne	00188$
;	./menu.c: 77: switch (event) {
	ld	a, (0x06, sp)
	cp	a, #0x00
	jreq	00101$
	ld	a, (0x06, sp)
	cp	a, #0x03
	jreq	00102$
	ld	a, (0x06, sp)
	cp	a, #0x06
	jreq	00105$
	jra	00110$
;	./menu.c: 78: case MENU_EVENT_PUSH_BUTTON1:
00101$:
;	./menu.c: 79: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 80: menuDisplay = MENU_SET_THRESHOLD;
	mov	_menuDisplay+0, #0x01
;	./menu.c: 81: break;
	jp	00190$
;	./menu.c: 83: case MENU_EVENT_RELEASE_BUTTON1:
00102$:
;	./menu.c: 84: if (timer < MENU_5_SEC_PASSED) {
	tnz	(0x01, sp)
	jreq	00104$
;	./menu.c: 85: menuState = MENU_SET_THRESHOLD;
	mov	_menuState+0, #0x01
00104$:
;	./menu.c: 88: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 89: break;
	jp	00190$
;	./menu.c: 91: case MENU_EVENT_CHECK_TIMER:
00105$:
;	./menu.c: 92: if (getButton1() ) {
	call	_getButton1
	tnz	a
	jrne	00358$
	jp	00190$
00358$:
;	./menu.c: 93: if (timer > MENU_3_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x0060
	jrugt	00359$
	jp	00190$
00359$:
;	./menu.c: 94: setParamId (0);
	push	#0x00
	call	_setParamId
	pop	a
;	./menu.c: 95: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 96: menuState = menuDisplay = MENU_SELECT_PARAM;
	mov	_menuDisplay+0, #0x02
	mov	_menuState+0, #0x02
;	./menu.c: 100: break;
	jp	00190$
;	./menu.c: 102: default:
00110$:
;	./menu.c: 103: if (timer > MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	jrugt	00360$
	jp	00190$
00360$:
;	./menu.c: 104: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 105: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 109: }
	jp	00190$
00188$:
;	./menu.c: 111: switch (event) {
	ld	a, (0x06, sp)
	cp	a, #0x06
	jrugt	00361$
	clr	(0x02, sp)
	jra	00362$
00361$:
	ld	a, #0x01
	ld	(0x02, sp), a
00362$:
;	./menu.c: 134: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
	ldw	x, _timer+0
	cpw	x, #0x0024
	jrugt	00363$
	clr	(0x03, sp)
	jra	00364$
00363$:
	ld	a, #0x01
	ld	(0x03, sp), a
00364$:
;	./menu.c: 110: } else if (menuState == MENU_SELECT_PARAM) {
	ld	a, _menuState+0
	cp	a, #0x02
	jreq	00367$
	jp	00185$
00367$:
;	./menu.c: 111: switch (event) {
	tnz	(0x02, sp)
	jreq	00368$
	jp	00190$
00368$:
	clrw	x
	ld	a, (0x06, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00369$, x)
	jp	(x)
00369$:
	.dw	#00114$
	.dw	#00116$
	.dw	#00118$
	.dw	#00115$
	.dw	#00117$
	.dw	#00119$
	.dw	#00120$
;	./menu.c: 112: case MENU_EVENT_PUSH_BUTTON1:
00114$:
;	./menu.c: 113: menuState = menuDisplay = MENU_CHANGE_PARAM;
	mov	_menuDisplay+0, #0x03
	mov	_menuState+0, #0x03
;	./menu.c: 115: case MENU_EVENT_RELEASE_BUTTON1:
00115$:
;	./menu.c: 116: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 117: break;
	jp	00190$
;	./menu.c: 119: case MENU_EVENT_PUSH_BUTTON2:
00116$:
;	./menu.c: 120: incParamId();
	call	_incParamId
;	./menu.c: 122: case MENU_EVENT_RELEASE_BUTTON2:
00117$:
;	./menu.c: 123: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 124: break;
	jp	00190$
;	./menu.c: 126: case MENU_EVENT_PUSH_BUTTON3:
00118$:
;	./menu.c: 127: decParamId();
	call	_decParamId
;	./menu.c: 129: case MENU_EVENT_RELEASE_BUTTON3:
00119$:
;	./menu.c: 130: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 131: break;
	jp	00190$
;	./menu.c: 133: case MENU_EVENT_CHECK_TIMER:
00120$:
;	./menu.c: 134: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
	tnz	(0x03, sp)
	jreq	00127$
;	./menu.c: 135: if (getButton2() ) {
	call	_getButton2
	tnz	a
	jreq	00124$
;	./menu.c: 136: incParamId();
	call	_incParamId
;	./menu.c: 137: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
	jra	00127$
00124$:
;	./menu.c: 138: } else if (getButton3() ) {
	call	_getButton3
	tnz	a
	jreq	00127$
;	./menu.c: 139: decParamId();
	call	_decParamId
;	./menu.c: 140: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
00127$:
;	./menu.c: 144: if (timer > MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	jrugt	00373$
	jp	00190$
00373$:
;	./menu.c: 145: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 146: setParamId (0);
	push	#0x00
	call	_setParamId
	pop	a
;	./menu.c: 147: storeParams();
	call	_storeParams
;	./menu.c: 148: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 151: break;
	jp	00190$
;	./menu.c: 155: }
00185$:
;	./menu.c: 156: } else if (menuState == MENU_CHANGE_PARAM) {
	ld	a, _menuState+0
	cp	a, #0x03
	jreq	00376$
	jp	00182$
00376$:
;	./menu.c: 157: switch (event) {
	tnz	(0x02, sp)
	jreq	00377$
	jp	00190$
00377$:
	clrw	x
	ld	a, (0x06, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00378$, x)
	jp	(x)
00378$:
	.dw	#00132$
	.dw	#00134$
	.dw	#00136$
	.dw	#00133$
	.dw	#00135$
	.dw	#00137$
	.dw	#00138$
;	./menu.c: 158: case MENU_EVENT_PUSH_BUTTON1:
00132$:
;	./menu.c: 159: menuState = menuDisplay = MENU_SELECT_PARAM;
	mov	_menuDisplay+0, #0x02
	mov	_menuState+0, #0x02
;	./menu.c: 161: case MENU_EVENT_RELEASE_BUTTON1:
00133$:
;	./menu.c: 162: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 163: break;
	jp	00190$
;	./menu.c: 165: case MENU_EVENT_PUSH_BUTTON2:
00134$:
;	./menu.c: 166: incParam();
	call	_incParam
;	./menu.c: 168: case MENU_EVENT_RELEASE_BUTTON2:
00135$:
;	./menu.c: 169: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 170: break;
	jp	00190$
;	./menu.c: 172: case MENU_EVENT_PUSH_BUTTON3:
00136$:
;	./menu.c: 173: decParam();
	call	_decParam
;	./menu.c: 175: case MENU_EVENT_RELEASE_BUTTON3:
00137$:
;	./menu.c: 176: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 177: break;
	jp	00190$
;	./menu.c: 179: case MENU_EVENT_CHECK_TIMER:
00138$:
;	./menu.c: 180: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
	tnz	(0x03, sp)
	jreq	00145$
;	./menu.c: 181: if (getButton2() ) {
	call	_getButton2
	tnz	a
	jreq	00142$
;	./menu.c: 182: incParam();
	call	_incParam
;	./menu.c: 183: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
	jra	00145$
00142$:
;	./menu.c: 184: } else if (getButton3() ) {
	call	_getButton3
	tnz	a
	jreq	00145$
;	./menu.c: 185: decParam();
	call	_decParam
;	./menu.c: 186: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
00145$:
;	./menu.c: 190: if (getButton1() && timer > MENU_3_SEC_PASSED) {
	call	_getButton1
	tnz	a
	jreq	00147$
	ldw	x, _timer+0
	cpw	x, #0x0060
	jrule	00147$
;	./menu.c: 191: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 192: menuState = menuDisplay = MENU_SELECT_PARAM;
	mov	_menuDisplay+0, #0x02
	mov	_menuState+0, #0x02
;	./menu.c: 193: break;
	jp	00190$
00147$:
;	./menu.c: 196: if (timer > MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	jrugt	00384$
	jp	00190$
00384$:
;	./menu.c: 197: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 198: storeParams();
	call	_storeParams
;	./menu.c: 199: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 202: break;
	jp	00190$
;	./menu.c: 206: }
00182$:
;	./menu.c: 207: } else if (menuState == MENU_SET_THRESHOLD) {
	ld	a, _menuState+0
	dec	a
	jreq	00387$
	jp	00190$
00387$:
;	./menu.c: 208: switch (event) {
	tnz	(0x02, sp)
	jreq	00388$
	jp	00190$
00388$:
	clrw	x
	ld	a, (0x06, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00389$, x)
	jp	(x)
00389$:
	.dw	#00153$
	.dw	#00157$
	.dw	#00159$
	.dw	#00154$
	.dw	#00158$
	.dw	#00160$
	.dw	#00161$
;	./menu.c: 209: case MENU_EVENT_PUSH_BUTTON1:
00153$:
;	./menu.c: 210: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 211: menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
;	./menu.c: 212: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 213: break;
	jp	00190$
;	./menu.c: 215: case MENU_EVENT_RELEASE_BUTTON1:
00154$:
;	./menu.c: 216: if (timer < MENU_5_SEC_PASSED) {
	tnz	(0x01, sp)
	jreq	00156$
;	./menu.c: 217: storeParams();
	call	_storeParams
;	./menu.c: 218: menuState = MENU_ROOT;
	clr	_menuState+0
;	./menu.c: 219: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
00156$:
;	./menu.c: 222: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 223: break;
	jp	00190$
;	./menu.c: 225: case MENU_EVENT_PUSH_BUTTON2:
00157$:
;	./menu.c: 226: setParamId (PARAM_THRESHOLD);
	push	#0x09
	call	_setParamId
	pop	a
;	./menu.c: 227: incParam();
	call	_incParam
;	./menu.c: 229: case MENU_EVENT_RELEASE_BUTTON2:
00158$:
;	./menu.c: 230: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 231: break;
	jp	00190$
;	./menu.c: 233: case MENU_EVENT_PUSH_BUTTON3:
00159$:
;	./menu.c: 234: setParamId (PARAM_THRESHOLD);
	push	#0x09
	call	_setParamId
	pop	a
;	./menu.c: 235: decParam();
	call	_decParam
;	./menu.c: 237: case MENU_EVENT_RELEASE_BUTTON3:
00160$:
;	./menu.c: 238: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 239: break;
	jp	00190$
;	./menu.c: 241: case MENU_EVENT_CHECK_TIMER:
00161$:
;	./menu.c: 242: if (getButton2() || getButton3() ) {
	call	_getButton2
	tnz	a
	jrne	00162$
	call	_getButton3
	tnz	a
	jreq	00163$
00162$:
;	./menu.c: 243: blink = false;
	clr	(0x03, sp)
	jra	00164$
00163$:
;	./menu.c: 245: blink = (bool) ( (unsigned char) getUptimeTicks() & 0x80);
	call	_getUptimeTicks
	ld	a, xl
	sll	a
	clr	a
	rlc	a
	ld	(0x03, sp), a
00164$:
;	./menu.c: 248: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
	ldw	x, _timer+0
	cpw	x, #0x0024
	jrule	00172$
;	./menu.c: 249: setParamId (PARAM_THRESHOLD);
	push	#0x09
	call	_setParamId
	pop	a
;	./menu.c: 251: if (getButton2() ) {
	call	_getButton2
	tnz	a
	jreq	00169$
;	./menu.c: 252: incParam();
	call	_incParam
;	./menu.c: 253: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
	jra	00172$
00169$:
;	./menu.c: 254: } else if (getButton3() ) {
	call	_getButton3
	tnz	a
	jreq	00172$
;	./menu.c: 255: decParam();
	call	_decParam
;	./menu.c: 256: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
00172$:
;	./menu.c: 260: setDisplayOff (blink);
	ld	a, (0x03, sp)
	push	a
	call	_setDisplayOff
	pop	a
;	./menu.c: 262: if (timer > MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	jrule	00190$
;	./menu.c: 263: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 265: if (getButton1() ) {
	call	_getButton1
	tnz	a
	jreq	00174$
;	./menu.c: 266: menuState = menuDisplay = MENU_SELECT_PARAM;
	mov	_menuDisplay+0, #0x02
	mov	_menuState+0, #0x02
;	./menu.c: 267: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 268: break;
	jra	00190$
00174$:
;	./menu.c: 271: storeParams();
	call	_storeParams
;	./menu.c: 272: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 273: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 280: }
00190$:
;	./menu.c: 282: }
	addw	sp, #3
	ret
;	./menu.c: 292: void refreshMenu()
;	-----------------------------------------
;	 function refreshMenu
;	-----------------------------------------
_refreshMenu:
;	./menu.c: 294: timer++;
	ldw	x, _timer+0
	incw	x
	ldw	_timer+0, x
;	./menu.c: 295: feedMenu (MENU_EVENT_CHECK_TIMER);
	push	#0x06
	call	_feedMenu
	pop	a
;	./menu.c: 296: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)

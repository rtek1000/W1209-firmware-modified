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
	.globl _getParamById
	.globl _storeParams
	.globl _decParamId
	.globl _incParamId
	.globl _decParam
	.globl _incParam
	.globl _setDisplayOff
	.globl _dimmerBrightness
	.globl _getButton3
	.globl _getButton2
	.globl _getButton1
	.globl _getSensorFail
	.globl _initMenu
	.globl _getMenuDisplay
	.globl _setMenuDisplay
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
_autoBrightness:
	.ds 1
_lowBrightness:
	.ds 1
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
;	./menu.c: 44: void initMenu()
;	-----------------------------------------
;	 function initMenu
;	-----------------------------------------
_initMenu:
;	./menu.c: 46: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 47: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 48: }
	ret
;	./menu.c: 54: unsigned char getMenuDisplay()
;	-----------------------------------------
;	 function getMenuDisplay
;	-----------------------------------------
_getMenuDisplay:
;	./menu.c: 56: return menuDisplay;
	ld	a, _menuDisplay+0
;	./menu.c: 57: }
	ret
;	./menu.c: 59: void setMenuDisplay(unsigned char _menu)
;	-----------------------------------------
;	 function setMenuDisplay
;	-----------------------------------------
_setMenuDisplay:
;	./menu.c: 61: menuDisplay = _menu;
	ld	a, (0x03, sp)
	ld	_menuDisplay+0, a
;	./menu.c: 62: }
	ret
;	./menu.c: 81: void feedMenu (unsigned char event)
;	-----------------------------------------
;	 function feedMenu
;	-----------------------------------------
_feedMenu:
	sub	sp, #4
;	./menu.c: 86: switch (event) {
	ld	a, (0x07, sp)
	cp	a, #0x06
	jrugt	00502$
	clr	(0x01, sp)
	jra	00503$
00502$:
	ld	a, #0x01
	ld	(0x01, sp), a
00503$:
;	./menu.c: 104: if (timer < MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	clr	a
	rlc	a
	ld	(0x02, sp), a
;	./menu.c: 174: if (timer > MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	jrugt	00504$
	clr	(0x03, sp)
	jra	00505$
00504$:
	ld	a, #0x01
	ld	(0x03, sp), a
00505$:
;	./menu.c: 85: if (menuState == MENU_ROOT) {
	tnz	_menuState+0
	jreq	00506$
	jp	00248$
00506$:
;	./menu.c: 86: switch (event) {
	tnz	(0x01, sp)
	jreq	00507$
	jp	00147$
00507$:
	clrw	x
	ld	a, (0x07, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00508$, x)
	jp	(x)
00508$:
	.dw	#00101$
	.dw	#00115$
	.dw	#00119$
	.dw	#00108$
	.dw	#00118$
	.dw	#00122$
	.dw	#00123$
;	./menu.c: 87: case MENU_EVENT_PUSH_BUTTON1:
00101$:
;	./menu.c: 88: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 89: if ((getParamById (PARAM_RELAY_MODE) == 2) || (getParamById (PARAM_RELAY_MODE) == 3)) {
	push	#0x00
	call	_getParamById
	pop	a
	cpw	x, #0x0002
	jreq	00102$
	push	#0x00
	call	_getParamById
	pop	a
	cpw	x, #0x0003
	jrne	00103$
00102$:
;	./menu.c: 90: menuDisplay = MENU_ALARM;
	mov	_menuDisplay+0, #0x04
	jra	00104$
00103$:
;	./menu.c: 92: menuDisplay = MENU_SET_THRESHOLD;
	mov	_menuDisplay+0, #0x01
00104$:
;	./menu.c: 94: setDisplayOff (0);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 96: if(getParamById (PARAM_AUTO_BRIGHT) ) {
	push	#0x08
	call	_getParamById
	pop	a
	tnzw	x
	jrne	00515$
	jp	00250$
00515$:
;	./menu.c: 97: lowBrightness = false;
	clr	_lowBrightness+0
;	./menu.c: 98: dimmerBrightness(lowBrightness);
	push	#0x00
	call	_dimmerBrightness
	pop	a
;	./menu.c: 101: break;
	jp	00250$
;	./menu.c: 103: case MENU_EVENT_RELEASE_BUTTON1:
00108$:
;	./menu.c: 104: if (timer < MENU_5_SEC_PASSED) {
	tnz	(0x02, sp)
	jreq	00114$
;	./menu.c: 105: if ((getParamById (PARAM_RELAY_MODE) == 2) || (getParamById (PARAM_RELAY_MODE) == 3)) {
	push	#0x00
	call	_getParamById
	pop	a
	cpw	x, #0x0002
	jreq	00109$
	push	#0x00
	call	_getParamById
	pop	a
	cpw	x, #0x0003
	jrne	00110$
00109$:
;	./menu.c: 106: menuState = MENU_ALARM;
	mov	_menuState+0, #0x04
	jra	00114$
00110$:
;	./menu.c: 108: menuState = MENU_SET_THRESHOLD;
	mov	_menuState+0, #0x01
00114$:
;	./menu.c: 112: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 113: break;
	jp	00250$
;	./menu.c: 115: case MENU_EVENT_PUSH_BUTTON2:
00115$:
;	./menu.c: 116: if(getParamById (PARAM_AUTO_BRIGHT) ) {
	push	#0x08
	call	_getParamById
	pop	a
	tnzw	x
	jreq	00118$
;	./menu.c: 117: lowBrightness = false;
	clr	_lowBrightness+0
;	./menu.c: 118: dimmerBrightness(lowBrightness);
	push	#0x00
	call	_dimmerBrightness
	pop	a
;	./menu.c: 120: case MENU_EVENT_RELEASE_BUTTON2:
00118$:
;	./menu.c: 121: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 122: break;
	jp	00250$
;	./menu.c: 124: case MENU_EVENT_PUSH_BUTTON3:
00119$:
;	./menu.c: 125: if(getParamById (PARAM_AUTO_BRIGHT) ) {
	push	#0x08
	call	_getParamById
	pop	a
	tnzw	x
	jreq	00122$
;	./menu.c: 126: lowBrightness = false;
	clr	_lowBrightness+0
;	./menu.c: 127: dimmerBrightness(lowBrightness);
	push	#0x00
	call	_dimmerBrightness
	pop	a
;	./menu.c: 130: case MENU_EVENT_RELEASE_BUTTON3:
00122$:
;	./menu.c: 131: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 132: break;
	jp	00250$
;	./menu.c: 134: case MENU_EVENT_CHECK_TIMER:
00123$:
;	./menu.c: 135: if (getButton1() ) {
	call	_getButton1
	tnz	a
	jreq	00127$
;	./menu.c: 136: if (timer > MENU_3_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x0060
	jrule	00127$
;	./menu.c: 137: setParamId (0);
	push	#0x00
	call	_setParamId
	pop	a
;	./menu.c: 138: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 139: setDisplayOff (0);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 140: menuState = menuDisplay = MENU_SELECT_PARAM;
	mov	_menuDisplay+0, #0x02
	mov	_menuState+0, #0x02
00127$:
;	./menu.c: 144: if (timer > MENU_3_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x0060
	jrule	00135$
;	./menu.c: 145: if (menuDisplay == MENU_EEPROM_LOCKED) {
	ld	a, _menuDisplay+0
	cp	a, #0x08
	jrne	00132$
;	./menu.c: 146: menuDisplay = MENU_EEPROM_LOC_2;
	mov	_menuDisplay+0, #0x09
;	./menu.c: 147: timer = 0;
	clrw	x
	ldw	_timer+0, x
	jra	00135$
00132$:
;	./menu.c: 148: } else if ((menuDisplay == MENU_EEPROM_LOC_2) || (menuDisplay == MENU_EEPROM_RESET)) {
	ld	a, _menuDisplay+0
	cp	a, #0x09
	jreq	00128$
	ld	a, _menuDisplay+0
	cp	a, #0x07
	jrne	00135$
00128$:
;	./menu.c: 149: menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
;	./menu.c: 150: timer = 0;
	clrw	x
	ldw	_timer+0, x
00135$:
;	./menu.c: 154: if(timer > MENU_15_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x01e0
	jrule	00142$
;	./menu.c: 155: if(getParamById (PARAM_AUTO_BRIGHT) ) {
	push	#0x08
	call	_getParamById
	pop	a
	tnzw	x
	jreq	00142$
;	./menu.c: 156: if ((autoBrightness) && (!lowBrightness)) {
	btjt	_autoBrightness+0, #0, 00539$
	jra	00142$
00539$:
	btjf	_lowBrightness+0, #0, 00540$
	jra	00142$
00540$:
;	./menu.c: 157: lowBrightness = true;
	mov	_lowBrightness+0, #0x01
;	./menu.c: 158: dimmerBrightness(lowBrightness);
	push	#0x01
	call	_dimmerBrightness
	pop	a
00142$:
;	./menu.c: 163: if(lowBrightness) {
	btjt	_lowBrightness+0, #0, 00541$
	jp	00250$
00541$:
;	./menu.c: 164: if(getSensorFail() > 0) {
	call	_getSensorFail
	cpw	x, #0x0000
	jrsgt	00542$
	jp	00250$
00542$:
;	./menu.c: 165: lowBrightness = false;
	clr	_lowBrightness+0
;	./menu.c: 166: dimmerBrightness(lowBrightness);
	push	#0x00
	call	_dimmerBrightness
	pop	a
;	./menu.c: 167: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 171: break;
	jp	00250$
;	./menu.c: 173: default:
00147$:
;	./menu.c: 174: if (timer > MENU_5_SEC_PASSED) {
	tnz	(0x03, sp)
	jrne	00543$
	jp	00250$
00543$:
;	./menu.c: 175: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 176: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 180: }
	jp	00250$
00248$:
;	./menu.c: 205: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
	ldw	x, _timer+0
	cpw	x, #0x0024
	jrugt	00544$
	clr	(0x04, sp)
	jra	00545$
00544$:
	ld	a, #0x01
	ld	(0x04, sp), a
00545$:
;	./menu.c: 181: } else if (menuState == MENU_SELECT_PARAM) {
	ld	a, _menuState+0
	cp	a, #0x02
	jreq	00548$
	jp	00245$
00548$:
;	./menu.c: 182: switch (event) {
	tnz	(0x01, sp)
	jreq	00549$
	jp	00250$
00549$:
	clrw	x
	ld	a, (0x07, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00550$, x)
	jp	(x)
00550$:
	.dw	#00151$
	.dw	#00153$
	.dw	#00155$
	.dw	#00152$
	.dw	#00154$
	.dw	#00156$
	.dw	#00157$
;	./menu.c: 183: case MENU_EVENT_PUSH_BUTTON1:
00151$:
;	./menu.c: 184: menuState = menuDisplay = MENU_CHANGE_PARAM;
	mov	_menuDisplay+0, #0x03
	mov	_menuState+0, #0x03
;	./menu.c: 186: case MENU_EVENT_RELEASE_BUTTON1:
00152$:
;	./menu.c: 187: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 188: break;
	jp	00250$
;	./menu.c: 190: case MENU_EVENT_PUSH_BUTTON2:
00153$:
;	./menu.c: 191: incParamId();
	call	_incParamId
;	./menu.c: 193: case MENU_EVENT_RELEASE_BUTTON2:
00154$:
;	./menu.c: 194: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 195: break;
	jp	00250$
;	./menu.c: 197: case MENU_EVENT_PUSH_BUTTON3:
00155$:
;	./menu.c: 198: decParamId();
	call	_decParamId
;	./menu.c: 200: case MENU_EVENT_RELEASE_BUTTON3:
00156$:
;	./menu.c: 201: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 202: break;
	jp	00250$
;	./menu.c: 204: case MENU_EVENT_CHECK_TIMER:
00157$:
;	./menu.c: 205: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
	tnz	(0x04, sp)
	jreq	00164$
;	./menu.c: 206: if (getButton2() ) {
	call	_getButton2
	tnz	a
	jreq	00161$
;	./menu.c: 207: incParamId();
	call	_incParamId
;	./menu.c: 208: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
	jra	00164$
00161$:
;	./menu.c: 209: } else if (getButton3() ) {
	call	_getButton3
	tnz	a
	jreq	00164$
;	./menu.c: 210: decParamId();
	call	_decParamId
;	./menu.c: 211: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
00164$:
;	./menu.c: 215: if (timer > MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	jrugt	00554$
	jp	00250$
00554$:
;	./menu.c: 216: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 217: setParamId (0);
	push	#0x00
	call	_setParamId
	pop	a
;	./menu.c: 218: storeParams();
	call	_storeParams
;	./menu.c: 219: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 222: break;
	jp	00250$
;	./menu.c: 226: }
00245$:
;	./menu.c: 227: } else if (menuState == MENU_CHANGE_PARAM) {
	ld	a, _menuState+0
	cp	a, #0x03
	jreq	00557$
	jp	00242$
00557$:
;	./menu.c: 228: switch (event) {
	tnz	(0x01, sp)
	jreq	00558$
	jp	00250$
00558$:
	clrw	x
	ld	a, (0x07, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00559$, x)
	jp	(x)
00559$:
	.dw	#00169$
	.dw	#00171$
	.dw	#00173$
	.dw	#00170$
	.dw	#00172$
	.dw	#00174$
	.dw	#00175$
;	./menu.c: 229: case MENU_EVENT_PUSH_BUTTON1:
00169$:
;	./menu.c: 230: menuState = menuDisplay = MENU_SELECT_PARAM;
	mov	_menuDisplay+0, #0x02
	mov	_menuState+0, #0x02
;	./menu.c: 232: case MENU_EVENT_RELEASE_BUTTON1:
00170$:
;	./menu.c: 233: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 234: break;
	jp	00250$
;	./menu.c: 236: case MENU_EVENT_PUSH_BUTTON2:
00171$:
;	./menu.c: 237: incParam();
	call	_incParam
;	./menu.c: 239: case MENU_EVENT_RELEASE_BUTTON2:
00172$:
;	./menu.c: 240: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 241: break;
	jp	00250$
;	./menu.c: 243: case MENU_EVENT_PUSH_BUTTON3:
00173$:
;	./menu.c: 244: decParam();
	call	_decParam
;	./menu.c: 246: case MENU_EVENT_RELEASE_BUTTON3:
00174$:
;	./menu.c: 247: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 248: break;
	jp	00250$
;	./menu.c: 250: case MENU_EVENT_CHECK_TIMER:
00175$:
;	./menu.c: 251: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
	tnz	(0x04, sp)
	jreq	00182$
;	./menu.c: 252: if (getButton2() ) {
	call	_getButton2
	tnz	a
	jreq	00179$
;	./menu.c: 253: incParam();
	call	_incParam
;	./menu.c: 254: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
	jra	00182$
00179$:
;	./menu.c: 255: } else if (getButton3() ) {
	call	_getButton3
	tnz	a
	jreq	00182$
;	./menu.c: 256: decParam();
	call	_decParam
;	./menu.c: 257: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
00182$:
;	./menu.c: 261: if (getButton1() && timer > MENU_3_SEC_PASSED) {
	call	_getButton1
	tnz	a
	jreq	00184$
	ldw	x, _timer+0
	cpw	x, #0x0060
	jrule	00184$
;	./menu.c: 262: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 263: menuState = menuDisplay = MENU_SELECT_PARAM;
	mov	_menuDisplay+0, #0x02
	mov	_menuState+0, #0x02
;	./menu.c: 264: break;
	jp	00250$
00184$:
;	./menu.c: 267: if (timer > MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	jrugt	00565$
	jp	00250$
00565$:
;	./menu.c: 268: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 269: storeParams();
	call	_storeParams
;	./menu.c: 270: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 273: break;
	jp	00250$
;	./menu.c: 277: }
00242$:
;	./menu.c: 278: } else if (menuState == MENU_SET_THRESHOLD) {
	ld	a, _menuState+0
	dec	a
	jreq	00568$
	jp	00239$
00568$:
;	./menu.c: 279: switch (event) {
	tnz	(0x01, sp)
	jreq	00569$
	jp	00250$
00569$:
	clrw	x
	ld	a, (0x07, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00570$, x)
	jp	(x)
00570$:
	.dw	#00190$
	.dw	#00194$
	.dw	#00199$
	.dw	#00191$
	.dw	#00198$
	.dw	#00203$
	.dw	#00204$
;	./menu.c: 280: case MENU_EVENT_PUSH_BUTTON1:
00190$:
;	./menu.c: 281: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 282: menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
;	./menu.c: 283: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 284: break;
	jp	00250$
;	./menu.c: 286: case MENU_EVENT_RELEASE_BUTTON1:
00191$:
;	./menu.c: 287: if (timer < MENU_5_SEC_PASSED) {
	tnz	(0x02, sp)
	jreq	00193$
;	./menu.c: 288: storeParams();
	call	_storeParams
;	./menu.c: 289: menuState = MENU_ROOT;
	clr	_menuState+0
;	./menu.c: 290: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
00193$:
;	./menu.c: 293: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 294: break;
	jp	00250$
;	./menu.c: 296: case MENU_EVENT_PUSH_BUTTON2:
00194$:
;	./menu.c: 297: setParamId (PARAM_THRESHOLD);
	push	#0x09
	call	_setParamId
	pop	a
;	./menu.c: 298: if (!getParamById (PARAM_LOCK_BUTTONS) ) {
	push	#0x07
	call	_getParamById
	pop	a
	tnzw	x
	jrne	00196$
;	./menu.c: 299: incParam();
	call	_incParam
	jra	00198$
00196$:
;	./menu.c: 301: menuDisplay = MENU_EEPROM_LOC_2;
	mov	_menuDisplay+0, #0x09
;	./menu.c: 304: case MENU_EVENT_RELEASE_BUTTON2:
00198$:
;	./menu.c: 305: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 306: break;
	jp	00250$
;	./menu.c: 308: case MENU_EVENT_PUSH_BUTTON3:
00199$:
;	./menu.c: 309: setParamId (PARAM_THRESHOLD);
	push	#0x09
	call	_setParamId
	pop	a
;	./menu.c: 310: if (!getParamById (PARAM_LOCK_BUTTONS) ) {
	push	#0x07
	call	_getParamById
	pop	a
	tnzw	x
	jrne	00201$
;	./menu.c: 311: decParam();
	call	_decParam
	jra	00203$
00201$:
;	./menu.c: 313: menuDisplay = MENU_EEPROM_LOC_2;
	mov	_menuDisplay+0, #0x09
;	./menu.c: 316: case MENU_EVENT_RELEASE_BUTTON3:
00203$:
;	./menu.c: 317: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 318: break;
	jp	00250$
;	./menu.c: 320: case MENU_EVENT_CHECK_TIMER:
00204$:
;	./menu.c: 321: if (getButton2() || getButton3() ) {
	call	_getButton2
	tnz	a
	jrne	00205$
	call	_getButton3
	tnz	a
	jreq	00206$
00205$:
;	./menu.c: 322: blink = false;
	clr	(0x04, sp)
	jra	00207$
00206$:
;	./menu.c: 324: blink = (bool) ( (unsigned char) getUptimeTicks() & 0x80);
	call	_getUptimeTicks
	ld	a, xl
	sll	a
	clr	a
	rlc	a
	ld	(0x04, sp), a
00207$:
;	./menu.c: 327: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
	ldw	x, _timer+0
	cpw	x, #0x0024
	jrule	00215$
;	./menu.c: 328: setParamId (PARAM_THRESHOLD);
	push	#0x09
	call	_setParamId
	pop	a
;	./menu.c: 330: if (getButton2() ) {
	call	_getButton2
	tnz	a
	jreq	00212$
;	./menu.c: 331: incParam();
	call	_incParam
;	./menu.c: 332: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
	jra	00215$
00212$:
;	./menu.c: 333: } else if (getButton3() ) {
	call	_getButton3
	tnz	a
	jreq	00215$
;	./menu.c: 334: decParam();
	call	_decParam
;	./menu.c: 335: timer = MENU_1_SEC_PASSED;
	ldw	x, #0x0020
	ldw	_timer+0, x
00215$:
;	./menu.c: 339: setDisplayOff (blink);
	ld	a, (0x04, sp)
	push	a
	call	_setDisplayOff
	pop	a
;	./menu.c: 341: if (timer > MENU_5_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x00a0
	jrugt	00579$
	jp	00250$
00579$:
;	./menu.c: 342: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 344: if (getButton1() ) {
	call	_getButton1
	tnz	a
	jreq	00217$
;	./menu.c: 345: menuState = menuDisplay = MENU_SELECT_PARAM;
	mov	_menuDisplay+0, #0x02
	mov	_menuState+0, #0x02
;	./menu.c: 346: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 347: break;
	jp	00250$
00217$:
;	./menu.c: 350: storeParams();
	call	_storeParams
;	./menu.c: 351: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 352: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 355: break;
	jra	00250$
;	./menu.c: 359: }
00239$:
;	./menu.c: 360: } else if (menuState == MENU_ALARM) {
	ld	a, _menuState+0
	cp	a, #0x04
	jrne	00250$
;	./menu.c: 361: switch (event) {
	ld	a, (0x07, sp)
	cp	a, #0x05
	jrugt	00230$
	clrw	x
	ld	a, (0x07, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00585$, x)
	jp	(x)
00585$:
	.dw	#00222$
	.dw	#00226$
	.dw	#00228$
	.dw	#00223$
	.dw	#00227$
	.dw	#00229$
;	./menu.c: 362: case MENU_EVENT_PUSH_BUTTON1:
00222$:
;	./menu.c: 363: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 364: menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
;	./menu.c: 365: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
;	./menu.c: 366: break;
	jra	00250$
;	./menu.c: 368: case MENU_EVENT_RELEASE_BUTTON1:
00223$:
;	./menu.c: 369: if (timer < MENU_5_SEC_PASSED) {
	tnz	(0x02, sp)
	jreq	00225$
;	./menu.c: 370: menuState = MENU_ROOT;
	clr	_menuState+0
;	./menu.c: 371: setDisplayOff (false);
	push	#0x00
	call	_setDisplayOff
	pop	a
00225$:
;	./menu.c: 374: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 375: break;
	jra	00250$
;	./menu.c: 377: case MENU_EVENT_PUSH_BUTTON2:
00226$:
;	./menu.c: 378: menuDisplay = MENU_ALARM_HIGH;
	mov	_menuDisplay+0, #0x05
;	./menu.c: 380: case MENU_EVENT_RELEASE_BUTTON2:
00227$:
;	./menu.c: 381: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 382: break;
	jra	00250$
;	./menu.c: 384: case MENU_EVENT_PUSH_BUTTON3:
00228$:
;	./menu.c: 385: menuDisplay = MENU_ALARM_LOW;
	mov	_menuDisplay+0, #0x06
;	./menu.c: 387: case MENU_EVENT_RELEASE_BUTTON3:
00229$:
;	./menu.c: 388: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 389: break;
	jra	00250$
;	./menu.c: 391: default:
00230$:
;	./menu.c: 392: if (timer > MENU_3_SEC_PASSED) {
	ldw	x, _timer+0
	cpw	x, #0x0060
	jrule	00232$
;	./menu.c: 393: menuDisplay = MENU_ALARM;
	mov	_menuDisplay+0, #0x04
00232$:
;	./menu.c: 396: if (timer > MENU_5_SEC_PASSED) {
	tnz	(0x03, sp)
	jreq	00250$
;	./menu.c: 397: timer = 0;
	clrw	x
	ldw	_timer+0, x
;	./menu.c: 398: menuState = menuDisplay = MENU_ROOT;
	clr	_menuDisplay+0
	clr	_menuState+0
;	./menu.c: 402: }
00250$:
;	./menu.c: 404: }
	addw	sp, #4
	ret
;	./menu.c: 414: void refreshMenu()
;	-----------------------------------------
;	 function refreshMenu
;	-----------------------------------------
_refreshMenu:
;	./menu.c: 416: timer++;
	ldw	x, _timer+0
	incw	x
	ldw	_timer+0, x
;	./menu.c: 417: feedMenu (MENU_EVENT_CHECK_TIMER);
	push	#0x06
	call	_feedMenu
	pop	a
;	./menu.c: 418: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
__xinit__autoBrightness:
	.db #0x01	;  1
__xinit__lowBrightness:
	.db #0x00	;  0
	.area CABS (ABS)

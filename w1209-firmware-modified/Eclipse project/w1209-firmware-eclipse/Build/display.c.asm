;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module display
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _Hex2CharMap
	.globl _setDisplayDot
	.globl _initDisplay
	.globl _refreshDisplay
	.globl _setDisplayTestMode
	.globl _setDisplayOff
	.globl _setDisplayStr
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_activeDigitId:
	.ds 1
_displayAC:
	.ds 3
_displayD:
	.ds 3
_displayOff:
	.ds 1
_testMode:
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
;	./display.c: 86: void initDisplay()
;	-----------------------------------------
;	 function initDisplay
;	-----------------------------------------
_initDisplay:
;	./display.c: 88: PA_DDR |= SSD_SEG_B_BIT | SSD_SEG_F_BIT;
	ld	a, 0x5002
	or	a, #0x06
	ld	0x5002, a
;	./display.c: 89: PA_CR1 |= SSD_SEG_B_BIT | SSD_SEG_F_BIT;
	ld	a, 0x5003
	or	a, #0x06
	ld	0x5003, a
;	./display.c: 90: PB_DDR |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
	ld	a, 0x5007
	or	a, #0x30
	ld	0x5007, a
;	./display.c: 91: PB_CR1 |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
	ld	a, 0x5008
	or	a, #0x30
	ld	0x5008, a
;	./display.c: 92: PC_DDR |= SSD_SEG_C_BIT | SSD_SEG_G_BIT;
	ld	a, 0x500c
	or	a, #0xc0
	ld	0x500c, a
;	./display.c: 93: PC_CR1 |= SSD_SEG_C_BIT | SSD_SEG_G_BIT;
	ld	a, 0x500d
	or	a, #0xc0
	ld	0x500d, a
;	./display.c: 94: PD_DDR |= SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT | SSD_SEG_P_BIT | SSD_DIGIT_3_BIT;
	ld	a, 0x5011
	or	a, #0x3e
	ld	0x5011, a
;	./display.c: 95: PD_CR1 |= SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT | SSD_SEG_P_BIT | SSD_DIGIT_3_BIT;
	ld	a, 0x5012
	or	a, #0x3e
	ld	0x5012, a
;	./display.c: 96: displayOff = false;
	clr	_displayOff+0
;	./display.c: 97: activeDigitId = 0;
	clr	_activeDigitId+0
;	./display.c: 98: setDisplayTestMode (true, "");
	push	#<(___str_0 + 0)
	push	#((___str_0 + 0) >> 8)
	push	#0x01
	call	_setDisplayTestMode
	addw	sp, #3
;	./display.c: 99: }
	ret
;	./display.c: 107: void refreshDisplay()
;	-----------------------------------------
;	 function refreshDisplay
;	-----------------------------------------
_refreshDisplay:
	push	a
;	./display.c: 109: enableDigit (3);
	push	#0x03
	call	_enableDigit
	pop	a
;	./display.c: 111: if (displayOff) {
	btjt	_displayOff+0, #0, 00118$
	jra	00102$
00118$:
;	./display.c: 112: return;
	jra	00106$
00102$:
;	./display.c: 115: SSD_SEG_BF_PORT &= ~SSD_BF_PORT_MASK;
	ld	a, 0x5000
	and	a, #0xf9
;	./display.c: 116: SSD_SEG_BF_PORT |= displayAC[activeDigitId] & SSD_BF_PORT_MASK;
	ld	0x5000, a
	ld	(0x01, sp), a
	clrw	x
	ld	a, _activeDigitId+0
	ld	xl, a
	addw	x, #(_displayAC + 0)
	ld	a, (x)
	and	a, #0x06
	or	a, (0x01, sp)
	ld	0x5000, a
;	./display.c: 117: SSD_SEG_CG_PORT &= ~SSD_CG_PORT_MASK;
	ld	a, 0x500a
	and	a, #0x3f
;	./display.c: 118: SSD_SEG_CG_PORT |= displayAC[activeDigitId] & SSD_CG_PORT_MASK;
	ld	0x500a, a
	ld	(0x01, sp), a
	clrw	x
	ld	a, _activeDigitId+0
	ld	xl, a
	addw	x, #(_displayAC + 0)
	ld	a, (x)
	and	a, #0xc0
	or	a, (0x01, sp)
	ld	0x500a, a
;	./display.c: 119: SSD_SEG_AEDP_PORT &= ~SSD_AEDP_PORT_MASK;
	ld	a, 0x500f
	and	a, #0xd1
;	./display.c: 120: SSD_SEG_AEDP_PORT |= displayD[activeDigitId];
	ld	0x500f, a
	ld	(0x01, sp), a
	clrw	x
	ld	a, _activeDigitId+0
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	or	a, (0x01, sp)
	ld	0x500f, a
;	./display.c: 121: enableDigit (activeDigitId);
	push	_activeDigitId+0
	call	_enableDigit
	pop	a
;	./display.c: 123: if (activeDigitId > 1) {
	ld	a, _activeDigitId+0
	cp	a, #0x01
	jrule	00104$
;	./display.c: 124: activeDigitId = 0;
	clr	_activeDigitId+0
	jra	00106$
00104$:
;	./display.c: 126: activeDigitId++;
	inc	_activeDigitId+0
00106$:
;	./display.c: 128: }
	pop	a
	ret
;	./display.c: 137: void setDisplayTestMode (bool val, char* str)
;	-----------------------------------------
;	 function setDisplayTestMode
;	-----------------------------------------
_setDisplayTestMode:
;	./display.c: 139: if (!testMode && val) {
	btjf	_testMode+0, #0, 00124$
	jra	00105$
00124$:
	tnz	(0x03, sp)
	jreq	00105$
;	./display.c: 140: if (*str == 0) {
	ldw	x, (0x04, sp)
	ld	a, (x)
	jrne	00102$
;	./display.c: 141: setDisplayStr ("888");
	push	#<(___str_1 + 0)
	push	#((___str_1 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jra	00105$
00102$:
;	./display.c: 143: setDisplayStr (str);
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
00105$:
;	./display.c: 147: testMode = val;
	ld	a, (0x03, sp)
	ld	_testMode+0, a
;	./display.c: 148: }
	ret
;	./display.c: 155: void setDisplayOff (bool val)
;	-----------------------------------------
;	 function setDisplayOff
;	-----------------------------------------
_setDisplayOff:
;	./display.c: 157: displayOff = val;
	ld	a, (0x03, sp)
	ld	_displayOff+0, a
;	./display.c: 158: }
	ret
;	./display.c: 168: void setDisplayDot (unsigned char id, bool val)
;	-----------------------------------------
;	 function setDisplayDot
;	-----------------------------------------
_setDisplayDot:
;	./display.c: 170: if (val) {
	tnz	(0x04, sp)
	jreq	00102$
;	./display.c: 171: displayD[id] |= SSD_SEG_P_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ret
00102$:
;	./display.c: 173: displayD[id] &= ~SSD_SEG_P_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
;	./display.c: 175: }
	ret
;	./display.c: 182: void setDisplayStr (const unsigned char* val)
;	-----------------------------------------
;	 function setDisplayStr
;	-----------------------------------------
_setDisplayStr:
	sub	sp, #6
;	./display.c: 187: for (i = 0, d = 0; * (val + i) != 0; i++, d++) {
	clr	(0x06, sp)
	clr	(0x05, sp)
00114$:
	clrw	x
	ld	a, (0x05, sp)
	ld	xl, a
	addw	x, (0x09, sp)
	ld	a, (x)
	jreq	00105$
;	./display.c: 188: if (* (val + i) == '.' && i > 0 && * (val + i - 1) != '.') d--;
	cp	a, #0x2e
	jrne	00115$
	tnz	(0x05, sp)
	jreq	00115$
	addw	x, #0xffff
	ld	a, (x)
	cp	a, #0x2e
	jreq	00115$
	dec	(0x06, sp)
00115$:
;	./display.c: 187: for (i = 0, d = 0; * (val + i) != 0; i++, d++) {
	inc	(0x05, sp)
	inc	(0x06, sp)
	jra	00114$
00105$:
;	./display.c: 193: if (d > 3) {
	ld	a, (0x06, sp)
	cp	a, #0x03
	jrule	00107$
;	./display.c: 194: d = 3;
	ld	a, #0x03
	ld	(0x06, sp), a
00107$:
;	./display.c: 198: for (i = 3 - d; i > 0; i--) {
	ld	a, (0x06, sp)
	ld	(0x05, sp), a
	ld	a, #0x03
	sub	a, (0x05, sp)
	ld	(0x05, sp), a
00117$:
	tnz	(0x05, sp)
	jreq	00108$
;	./display.c: 199: setDigit (3 - i, ' ', false);
	ld	a, (0x05, sp)
	ld	(0x04, sp), a
	ld	a, #0x03
	sub	a, (0x04, sp)
	push	#0x00
	push	#0x20
	push	a
	call	_setDigit
	addw	sp, #3
;	./display.c: 198: for (i = 3 - d; i > 0; i--) {
	dec	(0x05, sp)
	jra	00117$
00108$:
;	./display.c: 203: for (i = 0; d != 0 && *val + i != 0; i++, d--) {
	clr	(0x05, sp)
00121$:
	tnz	(0x06, sp)
	jreq	00123$
	ldw	y, (0x09, sp)
	ldw	(0x01, sp), y
	ldw	x, y
	ld	a, (x)
	ld	(0x04, sp), a
	clr	(0x03, sp)
	ld	a, (0x05, sp)
	clrw	x
	ld	xl, a
	addw	x, (0x03, sp)
	tnzw	x
	jreq	00123$
;	./display.c: 204: if (* (val + i + 1) == '.') {
	clrw	x
	ld	a, (0x05, sp)
	ld	xl, a
	addw	x, (0x01, sp)
	ldw	y, x
	ld	a, (0x1, y)
	ld	(0x04, sp), a
;	./display.c: 205: setDigit (d - 1, * (val + i), true);
	ld	a, (x)
	ld	xl, a
	ld	a, (0x06, sp)
	dec	a
	ld	xh, a
;	./display.c: 204: if (* (val + i + 1) == '.') {
	ld	a, (0x04, sp)
	cp	a, #0x2e
	jrne	00110$
;	./display.c: 205: setDigit (d - 1, * (val + i), true);
	push	#0x01
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_setDigit
	addw	sp, #3
;	./display.c: 206: i++;
	inc	(0x05, sp)
	jra	00122$
00110$:
;	./display.c: 208: setDigit (d - 1, * (val + i), false);
	push	#0x00
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_setDigit
	addw	sp, #3
00122$:
;	./display.c: 203: for (i = 0; d != 0 && *val + i != 0; i++, d--) {
	inc	(0x05, sp)
	dec	(0x06, sp)
	jra	00121$
00123$:
;	./display.c: 211: }
	addw	sp, #6
	ret
;	./display.c: 221: static void enableDigit (unsigned char id)
;	-----------------------------------------
;	 function enableDigit
;	-----------------------------------------
_enableDigit:
;	./display.c: 223: switch (id) {
	ld	a, (0x03, sp)
	cp	a, #0x00
	jreq	00101$
	ld	a, (0x03, sp)
	dec	a
	jreq	00102$
	ld	a, (0x03, sp)
	cp	a, #0x02
	jreq	00103$
	jra	00104$
;	./display.c: 224: case 0:
00101$:
;	./display.c: 225: SSD_DIGIT_12_PORT &= ~SSD_DIGIT_1_BIT;
	ld	a, 0x5005
	and	a, #0xef
;	./display.c: 226: SSD_DIGIT_12_PORT |= SSD_DIGIT_2_BIT;
	ld	0x5005, a
	or	a, #0x20
	ld	0x5005, a
;	./display.c: 227: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
	bset	20495, #4
;	./display.c: 228: break;
	ret
;	./display.c: 230: case 1:
00102$:
;	./display.c: 231: SSD_DIGIT_12_PORT &= ~SSD_DIGIT_2_BIT;
	ld	a, 0x5005
	and	a, #0xdf
;	./display.c: 232: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT;
	ld	0x5005, a
	or	a, #0x10
	ld	0x5005, a
;	./display.c: 233: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
	bset	20495, #4
;	./display.c: 234: break;
	ret
;	./display.c: 236: case 2:
00103$:
;	./display.c: 237: SSD_DIGIT_3_PORT &= ~SSD_DIGIT_3_BIT;
	bres	20495, #4
;	./display.c: 238: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
	ld	a, 0x5005
	or	a, #0x30
	ld	0x5005, a
;	./display.c: 239: break;
	ret
;	./display.c: 241: default:
00104$:
;	./display.c: 242: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
	ld	a, 0x5005
	or	a, #0x30
	ld	0x5005, a
;	./display.c: 243: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
	bset	20495, #4
;	./display.c: 245: }
;	./display.c: 246: }
	ret
;	./display.c: 276: static void setDigit (unsigned char id, unsigned char val, bool dot)
;	-----------------------------------------
;	 function setDigit
;	-----------------------------------------
_setDigit:
;	./display.c: 279: if (id > 2) return;
	ld	a, (0x03, sp)
	cp	a, #0x02
	jrule	00102$
	ret
00102$:
;	./display.c: 281: if (testMode) return;
	btjt	_testMode+0, #0, 00272$
	jra	00104$
00272$:
	ret
00104$:
;	./display.c: 283: switch (val) {
	ld	a, (0x04, sp)
	cp	a, #0x20
	jrne	00274$
	jp	00106$
00274$:
	ld	a, (0x04, sp)
	cp	a, #0x2d
	jrne	00277$
	jp	00105$
00277$:
	ld	a, (0x04, sp)
	cp	a, #0x30
	jrne	00280$
	jp	00107$
00280$:
	ld	a, (0x04, sp)
	cp	a, #0x31
	jrne	00283$
	jp	00108$
00283$:
	ld	a, (0x04, sp)
	cp	a, #0x32
	jrne	00286$
	jp	00109$
00286$:
	ld	a, (0x04, sp)
	cp	a, #0x33
	jrne	00289$
	jp	00110$
00289$:
	ld	a, (0x04, sp)
	cp	a, #0x34
	jrne	00292$
	jp	00111$
00292$:
	ld	a, (0x04, sp)
	cp	a, #0x35
	jrne	00295$
	jp	00112$
00295$:
	ld	a, (0x04, sp)
	cp	a, #0x36
	jrne	00298$
	jp	00113$
00298$:
	ld	a, (0x04, sp)
	cp	a, #0x37
	jrne	00301$
	jp	00114$
00301$:
	ld	a, (0x04, sp)
	cp	a, #0x38
	jrne	00304$
	jp	00115$
00304$:
	ld	a, (0x04, sp)
	cp	a, #0x39
	jrne	00307$
	jp	00116$
00307$:
	ld	a, (0x04, sp)
	cp	a, #0x41
	jrne	00310$
	jp	00117$
00310$:
	ld	a, (0x04, sp)
	cp	a, #0x42
	jrne	00313$
	jp	00118$
00313$:
	ld	a, (0x04, sp)
	cp	a, #0x43
	jrne	00316$
	jp	00119$
00316$:
	ld	a, (0x04, sp)
	cp	a, #0x44
	jrne	00319$
	jp	00120$
00319$:
	ld	a, (0x04, sp)
	cp	a, #0x45
	jrne	00322$
	jp	00121$
00322$:
	ld	a, (0x04, sp)
	cp	a, #0x46
	jrne	00325$
	jp	00122$
00325$:
	ld	a, (0x04, sp)
	cp	a, #0x48
	jrne	00328$
	jp	00123$
00328$:
	ld	a, (0x04, sp)
	cp	a, #0x4c
	jrne	00331$
	jp	00124$
00331$:
	ld	a, (0x04, sp)
	cp	a, #0x4e
	jrne	00334$
	jp	00125$
00334$:
	ld	a, (0x04, sp)
	cp	a, #0x4f
	jrne	00337$
	jp	00126$
00337$:
	ld	a, (0x04, sp)
	cp	a, #0x50
	jrne	00340$
	jp	00127$
00340$:
	ld	a, (0x04, sp)
	cp	a, #0x52
	jrne	00343$
	jp	00128$
00343$:
	jp	00129$
;	./display.c: 284: case '-':
00105$:
;	./display.c: 285: displayAC[id] = SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x40
	ld	((_displayAC + 0), x), a
;	./display.c: 286: displayD[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayD + 0), x)
;	./display.c: 287: break;
	jp	00130$
;	./display.c: 289: case ' ':
00106$:
;	./display.c: 290: displayAC[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayAC + 0), x)
;	./display.c: 291: displayD[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayD + 0), x)
;	./display.c: 292: break;
	jp	00130$
;	./display.c: 294: case '0':
00107$:
;	./display.c: 295: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x86
	ld	((_displayAC + 0), x), a
;	./display.c: 296: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 297: break;
	jp	00130$
;	./display.c: 299: case '1':
00108$:
;	./display.c: 300: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x84
	ld	((_displayAC + 0), x), a
;	./display.c: 301: displayD[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayD + 0), x)
;	./display.c: 302: break;
	jp	00130$
;	./display.c: 304: case '2':
00109$:
;	./display.c: 305: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x44
	ld	((_displayAC + 0), x), a
;	./display.c: 306: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 307: break;
	jp	00130$
;	./display.c: 309: case '3':
00110$:
;	./display.c: 310: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc4
	ld	((_displayAC + 0), x), a
;	./display.c: 311: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x28
	ld	((_displayD + 0), x), a
;	./display.c: 312: break;
	jp	00130$
;	./display.c: 314: case '4':
00111$:
;	./display.c: 315: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 316: displayD[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayD + 0), x)
;	./display.c: 317: break;
	jp	00130$
;	./display.c: 319: case '5':
00112$:
;	./display.c: 320: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc2
	ld	((_displayAC + 0), x), a
;	./display.c: 321: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x28
	ld	((_displayD + 0), x), a
;	./display.c: 322: break;
	jp	00130$
;	./display.c: 324: case '6':
00113$:
;	./display.c: 325: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc2
	ld	((_displayAC + 0), x), a
;	./display.c: 326: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 327: break;
	jp	00130$
;	./display.c: 329: case '7':
00114$:
;	./display.c: 330: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x84
	ld	((_displayAC + 0), x), a
;	./display.c: 331: displayD[id] = SSD_SEG_A_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x20
	ld	((_displayD + 0), x), a
;	./display.c: 332: break;
	jp	00130$
;	./display.c: 334: case '8':
00115$:
;	./display.c: 335: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 336: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 337: break;
	jp	00130$
;	./display.c: 339: case '9':
00116$:
;	./display.c: 340: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 341: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x28
	ld	((_displayD + 0), x), a
;	./display.c: 342: break;
	jp	00130$
;	./display.c: 344: case 'A':
00117$:
;	./display.c: 345: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 346: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 347: break;
	jp	00130$
;	./display.c: 349: case 'B':
00118$:
;	./display.c: 350: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc2
	ld	((_displayAC + 0), x), a
;	./display.c: 351: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x0a
	ld	((_displayD + 0), x), a
;	./display.c: 352: break;
	jp	00130$
;	./display.c: 354: case 'C':
00119$:
;	./display.c: 355: displayAC[id] = SSD_SEG_F_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x02
	ld	((_displayAC + 0), x), a
;	./display.c: 356: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 357: break;
	jp	00130$
;	./display.c: 359: case 'D':
00120$:
;	./display.c: 360: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc4
	ld	((_displayAC + 0), x), a
;	./display.c: 361: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x0a
	ld	((_displayD + 0), x), a
;	./display.c: 362: break;
	jp	00130$
;	./display.c: 364: case 'E':
00121$:
;	./display.c: 365: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x42
	ld	((_displayAC + 0), x), a
;	./display.c: 366: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 367: break;
	jp	00130$
;	./display.c: 369: case 'F':
00122$:
;	./display.c: 370: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x42
	ld	((_displayAC + 0), x), a
;	./display.c: 371: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 372: break;
	jp	00130$
;	./display.c: 374: case 'H':
00123$:
;	./display.c: 375: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 376: displayD[id] = SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x02
	ld	((_displayD + 0), x), a
;	./display.c: 377: break;
	jp	00130$
;	./display.c: 379: case 'L':
00124$:
;	./display.c: 380: displayAC[id] = SSD_SEG_F_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x02
	ld	((_displayAC + 0), x), a
;	./display.c: 381: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x0a
	ld	((_displayD + 0), x), a
;	./display.c: 382: break;
	jra	00130$
;	./display.c: 384: case 'N':
00125$:
;	./display.c: 385: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x86
	ld	((_displayAC + 0), x), a
;	./display.c: 386: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 387: break;
	jra	00130$
;	./display.c: 389: case 'O':
00126$:
;	./display.c: 390: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x86
	ld	((_displayAC + 0), x), a
;	./display.c: 391: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 392: break;
	jra	00130$
;	./display.c: 394: case 'P':
00127$:
;	./display.c: 395: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x46
	ld	((_displayAC + 0), x), a
;	./display.c: 396: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 397: break;
	jra	00130$
;	./display.c: 399: case 'R':
00128$:
;	./display.c: 400: displayAC[id] = SSD_SEG_F_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x02
	ld	((_displayAC + 0), x), a
;	./display.c: 401: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 402: break;
	jra	00130$
;	./display.c: 404: default:
00129$:
;	./display.c: 405: displayAC[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayAC + 0), x)
;	./display.c: 406: displayD[id] = SSD_SEG_D_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x08
	ld	((_displayD + 0), x), a
;	./display.c: 407: }
00130$:
;	./display.c: 409: if (dot) {
	tnz	(0x05, sp)
	jreq	00132$
;	./display.c: 410: displayD[id] |= SSD_SEG_P_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ret
00132$:
;	./display.c: 412: displayD[id] &= ~SSD_SEG_P_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
;	./display.c: 415: return;
;	./display.c: 416: }
	ret
	.area CODE
	.area CONST
_Hex2CharMap:
	.db #0x30	; 48	'0'
	.db #0x31	; 49	'1'
	.db #0x32	; 50	'2'
	.db #0x33	; 51	'3'
	.db #0x34	; 52	'4'
	.db #0x35	; 53	'5'
	.db #0x36	; 54	'6'
	.db #0x37	; 55	'7'
	.db #0x38	; 56	'8'
	.db #0x39	; 57	'9'
	.db #0x41	; 65	'A'
	.db #0x42	; 66	'B'
	.db #0x43	; 67	'C'
	.db #0x44	; 68	'D'
	.db #0x45	; 69	'E'
	.db #0x46	; 70	'F'
	.area CONST
___str_0:
	.db 0x00
	.area CODE
	.area CONST
___str_1:
	.ascii "888"
	.db 0x00
	.area CODE
	.area INITIALIZER
	.area CABS (ABS)

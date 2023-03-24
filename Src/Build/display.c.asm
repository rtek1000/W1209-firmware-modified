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
	.globl _dimmerBrightness
	.globl _initDisplay
	.globl _refreshDisplay
	.globl _setDisplayTestMode
	.globl _setDisplayOff
	.globl _setDisplayStr
	.globl _enableDigit
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
;	./display.c: 83: void dimmerBrightness(bool _state)
;	-----------------------------------------
;	 function dimmerBrightness
;	-----------------------------------------
_dimmerBrightness:
;	./display.c: 85: lowBrightness = _state;
	ld	a, (0x03, sp)
	ld	_lowBrightness+0, a
;	./display.c: 86: }
	ret
;	./display.c: 92: void initDisplay()
;	-----------------------------------------
;	 function initDisplay
;	-----------------------------------------
_initDisplay:
;	./display.c: 94: PA_DDR |= SSD_SEG_B_BIT | SSD_SEG_F_BIT;
	ld	a, 0x5002
	or	a, #0x06
	ld	0x5002, a
;	./display.c: 95: PA_CR1 |= SSD_SEG_B_BIT | SSD_SEG_F_BIT;
	ld	a, 0x5003
	or	a, #0x06
	ld	0x5003, a
;	./display.c: 96: PB_DDR |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
	ld	a, 0x5007
	or	a, #0x30
	ld	0x5007, a
;	./display.c: 97: PB_CR1 |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
	ld	a, 0x5008
	or	a, #0x30
	ld	0x5008, a
;	./display.c: 98: PC_DDR |= SSD_SEG_C_BIT | SSD_SEG_G_BIT;
	ld	a, 0x500c
	or	a, #0xc0
	ld	0x500c, a
;	./display.c: 99: PC_CR1 |= SSD_SEG_C_BIT | SSD_SEG_G_BIT;
	ld	a, 0x500d
	or	a, #0xc0
	ld	0x500d, a
;	./display.c: 100: PD_DDR |= SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT | SSD_SEG_P_BIT | SSD_DIGIT_3_BIT;
	ld	a, 0x5011
	or	a, #0x3e
	ld	0x5011, a
;	./display.c: 101: PD_CR1 |= SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT | SSD_SEG_P_BIT | SSD_DIGIT_3_BIT;
	ld	a, 0x5012
	or	a, #0x3e
	ld	0x5012, a
;	./display.c: 102: displayOff = false;
	clr	_displayOff+0
;	./display.c: 103: activeDigitId = 0;
	clr	_activeDigitId+0
;	./display.c: 104: setDisplayTestMode (true, "");
	push	#<(___str_0 + 0)
	push	#((___str_0 + 0) >> 8)
	push	#0x01
	call	_setDisplayTestMode
	addw	sp, #3
;	./display.c: 105: }
	ret
;	./display.c: 113: void refreshDisplay()
;	-----------------------------------------
;	 function refreshDisplay
;	-----------------------------------------
_refreshDisplay:
	push	a
;	./display.c: 115: enableDigit (3);
	push	#0x03
	call	_enableDigit
	pop	a
;	./display.c: 117: if (displayOff) {
	btjt	_displayOff+0, #0, 00139$
	jra	00102$
00139$:
;	./display.c: 118: return;
	jra	00111$
00102$:
;	./display.c: 121: SSD_SEG_BF_PORT &= ~SSD_BF_PORT_MASK;
	ld	a, 0x5000
	and	a, #0xf9
;	./display.c: 122: SSD_SEG_BF_PORT |= displayAC[activeDigitId] & SSD_BF_PORT_MASK;
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
;	./display.c: 123: SSD_SEG_CG_PORT &= ~SSD_CG_PORT_MASK;
	ld	a, 0x500a
	and	a, #0x3f
;	./display.c: 124: SSD_SEG_CG_PORT |= displayAC[activeDigitId] & SSD_CG_PORT_MASK;
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
;	./display.c: 125: SSD_SEG_AEDP_PORT &= ~SSD_AEDP_PORT_MASK;
	ld	a, 0x500f
	and	a, #0xd1
;	./display.c: 126: SSD_SEG_AEDP_PORT |= displayD[activeDigitId];
	ld	0x500f, a
	ld	(0x01, sp), a
	clrw	x
	ld	a, _activeDigitId+0
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	or	a, (0x01, sp)
	ld	0x500f, a
;	./display.c: 127: enableDigit (activeDigitId);
	push	_activeDigitId+0
	call	_enableDigit
	pop	a
;	./display.c: 129: if (activeDigitId > 1) {
	ld	a, _activeDigitId+0
	cp	a, #0x01
	jrule	00104$
;	./display.c: 130: activeDigitId = 0;
	clr	_activeDigitId+0
	jra	00105$
00104$:
;	./display.c: 132: activeDigitId++;
	inc	_activeDigitId+0
00105$:
;	./display.c: 135: if(lowBrightness) {
	btjt	_lowBrightness+0, #0, 00141$
	jra	00111$
00141$:
;	./display.c: 138: while(i--);
	ldw	x, #0x03e8
00106$:
	ldw	y, x
	decw	x
	tnzw	y
	jrne	00106$
;	./display.c: 140: enableDigit (3);
	push	#0x03
	call	_enableDigit
	pop	a
00111$:
;	./display.c: 142: }
	pop	a
	ret
;	./display.c: 151: void setDisplayTestMode (bool val, char* str)
;	-----------------------------------------
;	 function setDisplayTestMode
;	-----------------------------------------
_setDisplayTestMode:
;	./display.c: 153: if (!testMode && val) {
	btjf	_testMode+0, #0, 00124$
	jra	00105$
00124$:
	tnz	(0x03, sp)
	jreq	00105$
;	./display.c: 154: if (*str == 0) {
	ldw	x, (0x04, sp)
	ld	a, (x)
	jrne	00102$
;	./display.c: 155: setDisplayStr ("888");
	push	#<(___str_1 + 0)
	push	#((___str_1 + 0) >> 8)
	call	_setDisplayStr
	addw	sp, #2
	jra	00105$
00102$:
;	./display.c: 157: setDisplayStr (str);
	pushw	x
	call	_setDisplayStr
	addw	sp, #2
00105$:
;	./display.c: 161: testMode = val;
	ld	a, (0x03, sp)
	ld	_testMode+0, a
;	./display.c: 162: }
	ret
;	./display.c: 169: void setDisplayOff (bool val)
;	-----------------------------------------
;	 function setDisplayOff
;	-----------------------------------------
_setDisplayOff:
;	./display.c: 171: displayOff = val;
	ld	a, (0x03, sp)
	ld	_displayOff+0, a
;	./display.c: 172: }
	ret
;	./display.c: 182: void setDisplayDot (unsigned char id, bool val)
;	-----------------------------------------
;	 function setDisplayDot
;	-----------------------------------------
_setDisplayDot:
;	./display.c: 184: if (val) {
	tnz	(0x04, sp)
	jreq	00102$
;	./display.c: 185: displayD[id] |= SSD_SEG_P_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ret
00102$:
;	./display.c: 187: displayD[id] &= ~SSD_SEG_P_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
;	./display.c: 189: }
	ret
;	./display.c: 196: void setDisplayStr (const unsigned char* val)
;	-----------------------------------------
;	 function setDisplayStr
;	-----------------------------------------
_setDisplayStr:
	sub	sp, #6
;	./display.c: 201: for (i = 0, d = 0; * (val + i) != 0; i++, d++) {
	clr	(0x06, sp)
	clr	(0x05, sp)
00114$:
	clrw	x
	ld	a, (0x05, sp)
	ld	xl, a
	addw	x, (0x09, sp)
	ld	a, (x)
	jreq	00105$
;	./display.c: 202: if (* (val + i) == '.' && i > 0 && * (val + i - 1) != '.') d--;
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
;	./display.c: 201: for (i = 0, d = 0; * (val + i) != 0; i++, d++) {
	inc	(0x05, sp)
	inc	(0x06, sp)
	jra	00114$
00105$:
;	./display.c: 207: if (d > 3) {
	ld	a, (0x06, sp)
	cp	a, #0x03
	jrule	00107$
;	./display.c: 208: d = 3;
	ld	a, #0x03
	ld	(0x06, sp), a
00107$:
;	./display.c: 212: for (i = 3 - d; i > 0; i--) {
	ld	a, (0x06, sp)
	ld	(0x05, sp), a
	ld	a, #0x03
	sub	a, (0x05, sp)
	ld	(0x05, sp), a
00117$:
	tnz	(0x05, sp)
	jreq	00108$
;	./display.c: 213: setDigit (3 - i, ' ', false);
	ld	a, (0x05, sp)
	ld	(0x04, sp), a
	ld	a, #0x03
	sub	a, (0x04, sp)
	push	#0x00
	push	#0x20
	push	a
	call	_setDigit
	addw	sp, #3
;	./display.c: 212: for (i = 3 - d; i > 0; i--) {
	dec	(0x05, sp)
	jra	00117$
00108$:
;	./display.c: 217: for (i = 0; d != 0 && *val + i != 0; i++, d--) {
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
;	./display.c: 218: if (* (val + i + 1) == '.') {
	clrw	x
	ld	a, (0x05, sp)
	ld	xl, a
	addw	x, (0x01, sp)
	ldw	y, x
	ld	a, (0x1, y)
	ld	(0x04, sp), a
;	./display.c: 219: setDigit (d - 1, * (val + i), true);
	ld	a, (x)
	ld	xl, a
	ld	a, (0x06, sp)
	dec	a
	ld	xh, a
;	./display.c: 218: if (* (val + i + 1) == '.') {
	ld	a, (0x04, sp)
	cp	a, #0x2e
	jrne	00110$
;	./display.c: 219: setDigit (d - 1, * (val + i), true);
	push	#0x01
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_setDigit
	addw	sp, #3
;	./display.c: 220: i++;
	inc	(0x05, sp)
	jra	00122$
00110$:
;	./display.c: 222: setDigit (d - 1, * (val + i), false);
	push	#0x00
	ld	a, xl
	push	a
	ld	a, xh
	push	a
	call	_setDigit
	addw	sp, #3
00122$:
;	./display.c: 217: for (i = 0; d != 0 && *val + i != 0; i++, d--) {
	inc	(0x05, sp)
	dec	(0x06, sp)
	jra	00121$
00123$:
;	./display.c: 225: }
	addw	sp, #6
	ret
;	./display.c: 235: void enableDigit (unsigned char id)
;	-----------------------------------------
;	 function enableDigit
;	-----------------------------------------
_enableDigit:
;	./display.c: 237: switch (id) {
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
;	./display.c: 238: case 0:
00101$:
;	./display.c: 239: SSD_DIGIT_12_PORT &= ~SSD_DIGIT_1_BIT;
	ld	a, 0x5005
	and	a, #0xef
;	./display.c: 240: SSD_DIGIT_12_PORT |= SSD_DIGIT_2_BIT;
	ld	0x5005, a
	or	a, #0x20
	ld	0x5005, a
;	./display.c: 241: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
	bset	20495, #4
;	./display.c: 242: break;
	ret
;	./display.c: 244: case 1:
00102$:
;	./display.c: 245: SSD_DIGIT_12_PORT &= ~SSD_DIGIT_2_BIT;
	ld	a, 0x5005
	and	a, #0xdf
;	./display.c: 246: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT;
	ld	0x5005, a
	or	a, #0x10
	ld	0x5005, a
;	./display.c: 247: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
	bset	20495, #4
;	./display.c: 248: break;
	ret
;	./display.c: 250: case 2:
00103$:
;	./display.c: 251: SSD_DIGIT_3_PORT &= ~SSD_DIGIT_3_BIT;
	bres	20495, #4
;	./display.c: 252: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
	ld	a, 0x5005
	or	a, #0x30
	ld	0x5005, a
;	./display.c: 253: break;
	ret
;	./display.c: 255: default:
00104$:
;	./display.c: 256: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
	ld	a, 0x5005
	or	a, #0x30
	ld	0x5005, a
;	./display.c: 257: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
	bset	20495, #4
;	./display.c: 259: }
;	./display.c: 260: }
	ret
;	./display.c: 290: static void setDigit (unsigned char id, unsigned char val, bool dot)
;	-----------------------------------------
;	 function setDigit
;	-----------------------------------------
_setDigit:
;	./display.c: 293: if (id > 2) return;
	ld	a, (0x03, sp)
	cp	a, #0x02
	jrule	00102$
	ret
00102$:
;	./display.c: 295: if (testMode) return;
	btjt	_testMode+0, #0, 00284$
	jra	00104$
00284$:
	ret
00104$:
;	./display.c: 297: switch (val) {
	ld	a, (0x04, sp)
	cp	a, #0x20
	jrne	00286$
	jp	00106$
00286$:
	ld	a, (0x04, sp)
	cp	a, #0x2d
	jrne	00289$
	jp	00105$
00289$:
	ld	a, (0x04, sp)
	cp	a, #0x30
	jrne	00292$
	jp	00107$
00292$:
	ld	a, (0x04, sp)
	cp	a, #0x31
	jrne	00295$
	jp	00108$
00295$:
	ld	a, (0x04, sp)
	cp	a, #0x32
	jrne	00298$
	jp	00109$
00298$:
	ld	a, (0x04, sp)
	cp	a, #0x33
	jrne	00301$
	jp	00110$
00301$:
	ld	a, (0x04, sp)
	cp	a, #0x34
	jrne	00304$
	jp	00111$
00304$:
	ld	a, (0x04, sp)
	cp	a, #0x35
	jrne	00307$
	jp	00113$
00307$:
	ld	a, (0x04, sp)
	cp	a, #0x36
	jrne	00310$
	jp	00114$
00310$:
	ld	a, (0x04, sp)
	cp	a, #0x37
	jrne	00313$
	jp	00115$
00313$:
	ld	a, (0x04, sp)
	cp	a, #0x38
	jrne	00316$
	jp	00116$
00316$:
	ld	a, (0x04, sp)
	cp	a, #0x39
	jrne	00319$
	jp	00117$
00319$:
	ld	a, (0x04, sp)
	cp	a, #0x41
	jrne	00322$
	jp	00118$
00322$:
	ld	a, (0x04, sp)
	cp	a, #0x42
	jrne	00325$
	jp	00119$
00325$:
	ld	a, (0x04, sp)
	cp	a, #0x43
	jrne	00328$
	jp	00120$
00328$:
	ld	a, (0x04, sp)
	cp	a, #0x44
	jrne	00331$
	jp	00121$
00331$:
	ld	a, (0x04, sp)
	cp	a, #0x45
	jrne	00334$
	jp	00122$
00334$:
	ld	a, (0x04, sp)
	cp	a, #0x46
	jrne	00337$
	jp	00123$
00337$:
	ld	a, (0x04, sp)
	cp	a, #0x48
	jrne	00340$
	jp	00124$
00340$:
	ld	a, (0x04, sp)
	cp	a, #0x4c
	jrne	00343$
	jp	00125$
00343$:
	ld	a, (0x04, sp)
	cp	a, #0x4e
	jrne	00346$
	jp	00126$
00346$:
	ld	a, (0x04, sp)
	cp	a, #0x4f
	jrne	00349$
	jp	00127$
00349$:
	ld	a, (0x04, sp)
	cp	a, #0x50
	jrne	00352$
	jp	00128$
00352$:
	ld	a, (0x04, sp)
	cp	a, #0x52
	jrne	00355$
	jp	00129$
00355$:
	ld	a, (0x04, sp)
	cp	a, #0x53
	jrne	00358$
	jp	00113$
00358$:
	ld	a, (0x04, sp)
	cp	a, #0x54
	jrne	00361$
	jp	00130$
00361$:
	jp	00131$
;	./display.c: 298: case '-':
00105$:
;	./display.c: 299: displayAC[id] = SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x40
	ld	((_displayAC + 0), x), a
;	./display.c: 300: displayD[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayD + 0), x)
;	./display.c: 301: break;
	jp	00132$
;	./display.c: 303: case ' ':
00106$:
;	./display.c: 304: displayAC[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayAC + 0), x)
;	./display.c: 305: displayD[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayD + 0), x)
;	./display.c: 306: break;
	jp	00132$
;	./display.c: 308: case '0':
00107$:
;	./display.c: 309: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x86
	ld	((_displayAC + 0), x), a
;	./display.c: 310: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 311: break;
	jp	00132$
;	./display.c: 313: case '1':
00108$:
;	./display.c: 314: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x84
	ld	((_displayAC + 0), x), a
;	./display.c: 315: displayD[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayD + 0), x)
;	./display.c: 316: break;
	jp	00132$
;	./display.c: 318: case '2':
00109$:
;	./display.c: 319: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x44
	ld	((_displayAC + 0), x), a
;	./display.c: 320: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 321: break;
	jp	00132$
;	./display.c: 323: case '3':
00110$:
;	./display.c: 324: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc4
	ld	((_displayAC + 0), x), a
;	./display.c: 325: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x28
	ld	((_displayD + 0), x), a
;	./display.c: 326: break;
	jp	00132$
;	./display.c: 328: case '4':
00111$:
;	./display.c: 329: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 330: displayD[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayD + 0), x)
;	./display.c: 331: break;
	jp	00132$
;	./display.c: 334: case 'S':
00113$:
;	./display.c: 335: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc2
	ld	((_displayAC + 0), x), a
;	./display.c: 336: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x28
	ld	((_displayD + 0), x), a
;	./display.c: 337: break;
	jp	00132$
;	./display.c: 339: case '6':
00114$:
;	./display.c: 340: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc2
	ld	((_displayAC + 0), x), a
;	./display.c: 341: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 342: break;
	jp	00132$
;	./display.c: 344: case '7':
00115$:
;	./display.c: 345: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x84
	ld	((_displayAC + 0), x), a
;	./display.c: 346: displayD[id] = SSD_SEG_A_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x20
	ld	((_displayD + 0), x), a
;	./display.c: 347: break;
	jp	00132$
;	./display.c: 349: case '8':
00116$:
;	./display.c: 350: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 351: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 352: break;
	jp	00132$
;	./display.c: 354: case '9':
00117$:
;	./display.c: 355: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 356: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x28
	ld	((_displayD + 0), x), a
;	./display.c: 357: break;
	jp	00132$
;	./display.c: 359: case 'A':
00118$:
;	./display.c: 360: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 361: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 362: break;
	jp	00132$
;	./display.c: 364: case 'B':
00119$:
;	./display.c: 365: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc2
	ld	((_displayAC + 0), x), a
;	./display.c: 366: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x0a
	ld	((_displayD + 0), x), a
;	./display.c: 367: break;
	jp	00132$
;	./display.c: 369: case 'C':
00120$:
;	./display.c: 370: displayAC[id] = SSD_SEG_F_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x02
	ld	((_displayAC + 0), x), a
;	./display.c: 371: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 372: break;
	jp	00132$
;	./display.c: 374: case 'D':
00121$:
;	./display.c: 375: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc4
	ld	((_displayAC + 0), x), a
;	./display.c: 376: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x0a
	ld	((_displayD + 0), x), a
;	./display.c: 377: break;
	jp	00132$
;	./display.c: 379: case 'E':
00122$:
;	./display.c: 380: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x42
	ld	((_displayAC + 0), x), a
;	./display.c: 381: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 382: break;
	jp	00132$
;	./display.c: 384: case 'F':
00123$:
;	./display.c: 385: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x42
	ld	((_displayAC + 0), x), a
;	./display.c: 386: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 387: break;
	jp	00132$
;	./display.c: 389: case 'H':
00124$:
;	./display.c: 390: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0xc6
	ld	((_displayAC + 0), x), a
;	./display.c: 391: displayD[id] = SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x02
	ld	((_displayD + 0), x), a
;	./display.c: 392: break;
	jp	00132$
;	./display.c: 394: case 'L':
00125$:
;	./display.c: 395: displayAC[id] = SSD_SEG_F_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x02
	ld	((_displayAC + 0), x), a
;	./display.c: 396: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x0a
	ld	((_displayD + 0), x), a
;	./display.c: 397: break;
	jp	00132$
;	./display.c: 399: case 'N':
00126$:
;	./display.c: 400: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x86
	ld	((_displayAC + 0), x), a
;	./display.c: 401: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 402: break;
	jra	00132$
;	./display.c: 404: case 'O':
00127$:
;	./display.c: 405: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x86
	ld	((_displayAC + 0), x), a
;	./display.c: 406: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x2a
	ld	((_displayD + 0), x), a
;	./display.c: 407: break;
	jra	00132$
;	./display.c: 409: case 'P':
00128$:
;	./display.c: 410: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x46
	ld	((_displayAC + 0), x), a
;	./display.c: 411: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x22
	ld	((_displayD + 0), x), a
;	./display.c: 412: break;
	jra	00132$
;	./display.c: 414: case 'R':
00129$:
;	./display.c: 415: displayAC[id] = SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x40
	ld	((_displayAC + 0), x), a
;	./display.c: 416: displayD[id] = SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x02
	ld	((_displayD + 0), x), a
;	./display.c: 417: break;
	jra	00132$
;	./display.c: 419: case 'T':
00130$:
;	./display.c: 420: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x42
	ld	((_displayAC + 0), x), a
;	./display.c: 421: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x0a
	ld	((_displayD + 0), x), a
;	./display.c: 422: break;
	jra	00132$
;	./display.c: 424: default:
00131$:
;	./display.c: 425: displayAC[id] = 0;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	clr	((_displayAC + 0), x)
;	./display.c: 426: displayD[id] = SSD_SEG_D_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	ld	a, #0x08
	ld	((_displayD + 0), x), a
;	./display.c: 427: }
00132$:
;	./display.c: 429: if (dot) {
	tnz	(0x05, sp)
	jreq	00134$
;	./display.c: 430: displayD[id] |= SSD_SEG_P_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	or	a, #0x04
	ld	(x), a
	ret
00134$:
;	./display.c: 432: displayD[id] &= ~SSD_SEG_P_BIT;
	clrw	x
	ld	a, (0x03, sp)
	ld	xl, a
	addw	x, #(_displayD + 0)
	ld	a, (x)
	and	a, #0xfb
	ld	(x), a
;	./display.c: 435: return;
;	./display.c: 436: }
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
__xinit__lowBrightness:
	.db #0x00	;  0
	.area CABS (ABS)

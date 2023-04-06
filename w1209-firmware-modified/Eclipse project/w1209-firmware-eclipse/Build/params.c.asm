;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module params
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _paramDefault
	.globl _paramMax
	.globl _paramMin
	.globl _getButton3
	.globl _getButton2
	.globl _initParamsEEPROM
	.globl _getParamById
	.globl _setParamById
	.globl _getParam
	.globl _setParam
	.globl _incParam
	.globl _decParam
	.globl _getParamId
	.globl _setParamId
	.globl _incParamId
	.globl _decParamId
	.globl _paramToString
	.globl _storeParams
	.globl _itofpa
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_paramId:
	.ds 1
_paramCache:
	.ds 20
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
;	./params.c: 53: void initParamsEEPROM()
;	-----------------------------------------
;	 function initParamsEEPROM
;	-----------------------------------------
_initParamsEEPROM:
;	./params.c: 55: if (getButton2() && getButton3() ) {
	call	_getButton2
	tnz	a
	jreq	00104$
	call	_getButton3
	tnz	a
	jreq	00104$
;	./params.c: 57: for (paramId = 0; paramId < 10; paramId++) {
	clr	_paramId+0
00107$:
;	./params.c: 58: paramCache[paramId] = paramDefault[paramId];
	ld	a, _paramId+0
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, x
	addw	y, #(_paramCache + 0)
	addw	x, #(_paramDefault + 0)
	ldw	x, (x)
	ldw	(y), x
;	./params.c: 57: for (paramId = 0; paramId < 10; paramId++) {
	inc	_paramId+0
	ld	a, _paramId+0
	cp	a, #0x0a
	jrc	00107$
;	./params.c: 61: storeParams();
	call	_storeParams
	jra	00105$
00104$:
;	./params.c: 64: for (paramId = 0; paramId < 10; paramId++) {
	clr	_paramId+0
00109$:
;	./params.c: 65: paramCache[paramId] = * (int*) (EEPROM_BASE_ADDR + EEPROM_PARAMS_OFFSET
	ld	a, _paramId+0
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, x
	addw	y, #(_paramCache + 0)
;	./params.c: 66: + (paramId * sizeof paramCache[0]) );
	addw	x, #0x4064
	ldw	x, (x)
	ldw	(y), x
;	./params.c: 64: for (paramId = 0; paramId < 10; paramId++) {
	inc	_paramId+0
	ld	a, _paramId+0
	cp	a, #0x0a
	jrc	00109$
00105$:
;	./params.c: 70: paramId = 0;
	clr	_paramId+0
;	./params.c: 71: }
	ret
;	./params.c: 78: int getParamById (unsigned char id)
;	-----------------------------------------
;	 function getParamById
;	-----------------------------------------
_getParamById:
;	./params.c: 80: if (id < 10) {
	ld	a, (0x03, sp)
	cp	a, #0x0a
	jrnc	00102$
;	./params.c: 81: return paramCache[id];
	ld	a, (0x03, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	ret
00102$:
;	./params.c: 84: return -1;
	clrw	x
	decw	x
;	./params.c: 85: }
	ret
;	./params.c: 92: void setParamById (unsigned char id, int val)
;	-----------------------------------------
;	 function setParamById
;	-----------------------------------------
_setParamById:
;	./params.c: 94: if (id < 10) {
	ld	a, (0x03, sp)
	cp	a, #0x0a
	jrc	00110$
	ret
00110$:
;	./params.c: 95: paramCache[id] = val;
	ld	a, (0x03, sp)
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, (0x04, sp)
	ldw	((_paramCache + 0), x), y
;	./params.c: 97: }
	ret
;	./params.c: 103: int getParam()
;	-----------------------------------------
;	 function getParam
;	-----------------------------------------
_getParam:
;	./params.c: 105: return paramCache[paramId];
	ld	a, _paramId+0
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
;	./params.c: 106: }
	ret
;	./params.c: 112: void setParam (int val)
;	-----------------------------------------
;	 function setParam
;	-----------------------------------------
_setParam:
;	./params.c: 114: paramCache[paramId] = val;
	ld	a, _paramId+0
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, (0x03, sp)
	ldw	((_paramCache + 0), x), y
;	./params.c: 115: }
	ret
;	./params.c: 120: void incParam()
;	-----------------------------------------
;	 function incParam
;	-----------------------------------------
_incParam:
	sub	sp, #4
;	./params.c: 123: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
	clrw	x
	ld	a, _paramId+0
	ld	xl, a
	sllw	x
	exgw	x, y
;	./params.c: 122: if (paramId == PARAM_RELAY_MODE || paramId == PARAM_OVERHEAT_INDICATION) {
	tnz	_paramId+0
	jreq	00103$
	ld	a, _paramId+0
	cp	a, #0x06
	jrne	00104$
00103$:
;	./params.c: 123: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
	addw	y, #(_paramCache + 0)
	ldw	x, y
	ldw	x, (x)
	cplw	x
	ld	a, xl
	and	a, #0x01
	ld	xl, a
	clr	a
	ld	xh, a
	ldw	(y), x
	jra	00107$
00104$:
;	./params.c: 124: } else if (paramCache[paramId] < paramMax[paramId]) {
	ldw	x, y
	addw	x, #(_paramCache + 0)
	ldw	(0x01, sp), x
	ldw	x, (x)
	addw	y, #(_paramMax + 0)
	ldw	y, (y)
	ldw	(0x03, sp), y
	cpw	x, (0x03, sp)
	jrsge	00107$
;	./params.c: 125: paramCache[paramId]++;
	incw	x
	ldw	y, (0x01, sp)
	ldw	(y), x
00107$:
;	./params.c: 127: }
	addw	sp, #4
	ret
;	./params.c: 132: void decParam()
;	-----------------------------------------
;	 function decParam
;	-----------------------------------------
_decParam:
	sub	sp, #4
;	./params.c: 135: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
	clrw	x
	ld	a, _paramId+0
	ld	xl, a
	sllw	x
	exgw	x, y
;	./params.c: 134: if (paramId == PARAM_RELAY_MODE || paramId == PARAM_OVERHEAT_INDICATION) {
	tnz	_paramId+0
	jreq	00103$
	ld	a, _paramId+0
	cp	a, #0x06
	jrne	00104$
00103$:
;	./params.c: 135: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
	addw	y, #(_paramCache + 0)
	ldw	x, y
	ldw	x, (x)
	cplw	x
	ld	a, xl
	and	a, #0x01
	ld	xl, a
	clr	a
	ld	xh, a
	ldw	(y), x
	jra	00107$
00104$:
;	./params.c: 136: } else if (paramCache[paramId] > paramMin[paramId]) {
	ldw	x, y
	addw	x, #(_paramCache + 0)
	ldw	(0x01, sp), x
	ldw	x, (x)
	addw	y, #(_paramMin + 0)
	ldw	y, (y)
	ldw	(0x03, sp), y
	cpw	x, (0x03, sp)
	jrsle	00107$
;	./params.c: 137: paramCache[paramId]--;
	decw	x
	ldw	y, (0x01, sp)
	ldw	(y), x
00107$:
;	./params.c: 139: }
	addw	sp, #4
	ret
;	./params.c: 145: unsigned char getParamId()
;	-----------------------------------------
;	 function getParamId
;	-----------------------------------------
_getParamId:
;	./params.c: 147: return paramId;
	ld	a, _paramId+0
;	./params.c: 148: }
	ret
;	./params.c: 154: void setParamId (unsigned char val)
;	-----------------------------------------
;	 function setParamId
;	-----------------------------------------
_setParamId:
;	./params.c: 156: if (val < 10) {
	ld	a, (0x03, sp)
	cp	a, #0x0a
	jrc	00110$
	ret
00110$:
;	./params.c: 157: paramId = val;
	ld	a, (0x03, sp)
	ld	_paramId+0, a
;	./params.c: 159: }
	ret
;	./params.c: 164: void incParamId()
;	-----------------------------------------
;	 function incParamId
;	-----------------------------------------
_incParamId:
;	./params.c: 166: if (paramId < 6) {
	ld	a, _paramId+0
	cp	a, #0x06
	jrnc	00102$
;	./params.c: 167: paramId++;
	inc	_paramId+0
	ret
00102$:
;	./params.c: 169: paramId = 0;
	clr	_paramId+0
;	./params.c: 171: }
	ret
;	./params.c: 176: void decParamId()
;	-----------------------------------------
;	 function decParamId
;	-----------------------------------------
_decParamId:
;	./params.c: 178: if (paramId > 0) {
	tnz	_paramId+0
	jreq	00102$
;	./params.c: 179: paramId--;
	dec	_paramId+0
	ret
00102$:
;	./params.c: 181: paramId = 6;
	mov	_paramId+0, #0x06
;	./params.c: 183: }
	ret
;	./params.c: 192: void paramToString (unsigned char id, unsigned char* strBuff)
;	-----------------------------------------
;	 function paramToString
;	-----------------------------------------
_paramToString:
	sub	sp, #10
;	./params.c: 197: ( (unsigned char*) strBuff) [0] = 'H';
	ldw	y, (0x0e, sp)
;	./params.c: 229: ( (unsigned char*) strBuff) [1] = 'N';
	ldw	(0x01, sp), y
	ldw	x, y
	incw	x
	ldw	(0x03, sp), x
;	./params.c: 230: ( (unsigned char*) strBuff) [2] = ' ';
	ldw	x, (0x01, sp)
	incw	x
	incw	x
	ldw	(0x05, sp), x
;	./params.c: 236: ( (unsigned char*) strBuff) [3] = 0;
	ldw	x, (0x01, sp)
	addw	x, #0x0003
	ldw	(0x07, sp), x
;	./params.c: 194: switch (id) {
	ld	a, (0x0d, sp)
	cp	a, #0x09
	jrule	00134$
	jp	00115$
00134$:
;	./params.c: 196: if (paramCache[id]) {
	clrw	x
	ld	a, (0x0d, sp)
	ld	xl, a
	sllw	x
	ldw	(0x09, sp), x
;	./params.c: 194: switch (id) {
	clrw	x
	ld	a, (0x0d, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00135$, x)
	jp	(x)
00135$:
	.dw	#00101$
	.dw	#00105$
	.dw	#00106$
	.dw	#00107$
	.dw	#00108$
	.dw	#00109$
	.dw	#00110$
	.dw	#00115$
	.dw	#00115$
	.dw	#00114$
;	./params.c: 195: case PARAM_RELAY_MODE:
00101$:
;	./params.c: 196: if (paramCache[id]) {
	ldw	x, (0x09, sp)
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	ldw	(0x09, sp), x
	jreq	00103$
;	./params.c: 197: ( (unsigned char*) strBuff) [0] = 'H';
	ldw	x, (0x01, sp)
	ld	a, #0x48
	ld	(x), a
	jra	00104$
00103$:
;	./params.c: 199: ( (unsigned char*) strBuff) [0] = 'C';
	ldw	x, (0x01, sp)
	ld	a, #0x43
	ld	(x), a
00104$:
;	./params.c: 202: ( (unsigned char*) strBuff) [1] = 0;
	ldw	x, (0x0e, sp)
	incw	x
	clr	(x)
;	./params.c: 203: break;
	jp	00117$
;	./params.c: 205: case PARAM_RELAY_HYSTERESIS:
00105$:
;	./params.c: 206: itofpa (paramCache[id], strBuff, 0);
	ldw	x, (0x09, sp)
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x00
	ldw	y, (0x0f, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 207: break;
	jp	00117$
;	./params.c: 209: case PARAM_MAX_TEMPERATURE:
00106$:
;	./params.c: 210: itofpa (paramCache[id], strBuff, 6);
	ldw	x, (0x09, sp)
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x06
	ldw	y, (0x0f, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 211: break;
	jp	00117$
;	./params.c: 213: case PARAM_MIN_TEMPERATURE:
00107$:
;	./params.c: 214: itofpa (paramCache[id], strBuff, 6);
	ldw	x, (0x09, sp)
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x06
	ldw	y, (0x0f, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 215: break;
	jra	00117$
;	./params.c: 217: case PARAM_TEMPERATURE_CORRECTION:
00108$:
;	./params.c: 218: itofpa (paramCache[id], strBuff, 0);
	ldw	x, (0x09, sp)
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x00
	ldw	y, (0x0f, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 219: break;
	jra	00117$
;	./params.c: 221: case PARAM_RELAY_DELAY:
00109$:
;	./params.c: 222: itofpa (paramCache[id], strBuff, 6);
	ldw	x, (0x09, sp)
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x06
	ldw	y, (0x0f, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 223: break;
	jra	00117$
;	./params.c: 225: case PARAM_OVERHEAT_INDICATION:
00110$:
;	./params.c: 226: ( (unsigned char*) strBuff) [0] = 'O';
	ldw	x, (0x01, sp)
	ld	a, #0x4f
	ld	(x), a
;	./params.c: 228: if (paramCache[id]) {
	ldw	x, (0x09, sp)
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	ldw	(0x09, sp), x
	jreq	00112$
;	./params.c: 229: ( (unsigned char*) strBuff) [1] = 'N';
	ldw	x, (0x03, sp)
	ld	a, #0x4e
	ld	(x), a
;	./params.c: 230: ( (unsigned char*) strBuff) [2] = ' ';
	ldw	x, (0x05, sp)
	ld	a, #0x20
	ld	(x), a
	jra	00113$
00112$:
;	./params.c: 232: ( (unsigned char*) strBuff) [1] = 'F';
	ldw	x, (0x03, sp)
	ld	a, #0x46
	ld	(x), a
;	./params.c: 233: ( (unsigned char*) strBuff) [2] = 'F';
	ldw	x, (0x05, sp)
	ld	a, #0x46
	ld	(x), a
00113$:
;	./params.c: 236: ( (unsigned char*) strBuff) [3] = 0;
	ldw	x, (0x07, sp)
	clr	(x)
;	./params.c: 237: break;
	jra	00117$
;	./params.c: 239: case PARAM_THRESHOLD:
00114$:
;	./params.c: 240: itofpa (paramCache[id], strBuff, 0);
	ldw	x, (0x09, sp)
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x00
	ldw	y, (0x0f, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 241: break;
	jra	00117$
;	./params.c: 243: default: // Display "OFF" to all unknown ID
00115$:
;	./params.c: 244: ( (unsigned char*) strBuff) [0] = 'O';
	ldw	x, (0x01, sp)
	ld	a, #0x4f
	ld	(x), a
;	./params.c: 245: ( (unsigned char*) strBuff) [1] = 'F';
	ldw	x, (0x03, sp)
	ld	a, #0x46
	ld	(x), a
;	./params.c: 246: ( (unsigned char*) strBuff) [2] = 'F';
	ldw	x, (0x05, sp)
	ld	a, #0x46
	ld	(x), a
;	./params.c: 247: ( (unsigned char*) strBuff) [3] = 0;
	ldw	x, (0x07, sp)
	clr	(x)
;	./params.c: 248: }
00117$:
;	./params.c: 249: }
	addw	sp, #10
	ret
;	./params.c: 254: void storeParams()
;	-----------------------------------------
;	 function storeParams
;	-----------------------------------------
_storeParams:
	sub	sp, #2
;	./params.c: 259: if ( (FLASH_IAPSR & 0x08) == 0) {
	ld	a, 0x505f
	bcp	a, #0x08
	jrne	00112$
;	./params.c: 260: FLASH_DUKR = 0xAE;
	mov	0x5064+0, #0xae
;	./params.c: 261: FLASH_DUKR = 0x56;
	mov	0x5064+0, #0x56
;	./params.c: 265: for (i = 0; i < 10; i++) {
00112$:
	clr	a
00106$:
;	./params.c: 266: if (paramCache[i] != (* (int*) (EEPROM_BASE_ADDR + EEPROM_PARAMS_OFFSET
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	ldw	(0x01, sp), x
;	./params.c: 267: + (i * sizeof paramCache[0]) ) ) ) {
	addw	y, #0x4064
	ldw	x, y
	ldw	x, (x)
	cpw	x, (0x01, sp)
	jreq	00107$
;	./params.c: 269: + (i * sizeof paramCache[0]) ) = paramCache[i];
	ldw	x, y
	ldw	y, (0x01, sp)
	ldw	(x), y
00107$:
;	./params.c: 265: for (i = 0; i < 10; i++) {
	inc	a
	cp	a, #0x0a
	jrc	00106$
;	./params.c: 274: FLASH_IAPSR &= ~0x08;
	bres	20575, #3
;	./params.c: 275: }
	addw	sp, #2
	ret
;	./params.c: 281: static void writeEEPROM (unsigned char val, unsigned char offset)
;	-----------------------------------------
;	 function writeEEPROM
;	-----------------------------------------
_writeEEPROM:
;	./params.c: 284: if ( (FLASH_IAPSR & 0x08) == 0) {
	ld	a, 0x505f
	bcp	a, #0x08
	jrne	00102$
;	./params.c: 285: FLASH_DUKR = 0xAE;
	mov	0x5064+0, #0xae
;	./params.c: 286: FLASH_DUKR = 0x56;
	mov	0x5064+0, #0x56
00102$:
;	./params.c: 290: (* (unsigned char*) (EEPROM_BASE_ADDR + offset) ) = val;
	ld	a, (0x04, sp)
	clrw	x
	addw	x, #16384
	ld	xl, a
	ld	a, (0x03, sp)
	ld	(x), a
;	./params.c: 293: FLASH_IAPSR &= ~0x08;
	bres	20575, #3
;	./params.c: 294: }
	ret
;	./params.c: 308: void itofpa (int val, unsigned char* str, unsigned char pointPosition)
;	-----------------------------------------
;	 function itofpa
;	-----------------------------------------
_itofpa:
	sub	sp, #13
;	./params.c: 310: unsigned char i, l, buffer[] = {0, 0, 0, 0, 0, 0};
	clr	(0x01, sp)
	ldw	x, sp
	clr	(2, x)
	ldw	x, sp
	clr	(3, x)
	ldw	x, sp
	clr	(4, x)
	ldw	x, sp
	clr	(5, x)
	ldw	x, sp
	clr	(6, x)
;	./params.c: 311: bool minus = false;
	clr	(0x07, sp)
;	./params.c: 314: if (val == 0) {
	ldw	x, (0x10, sp)
	jrne	00102$
;	./params.c: 315: ( (unsigned char*) str) [0] = '0';
	ldw	x, (0x12, sp)
	ld	a, #0x30
	ld	(x), a
;	./params.c: 316: ( (unsigned char*) str) [1] = 0;
	incw	x
	clr	(x)
;	./params.c: 317: return;
	jp	00119$
00102$:
;	./params.c: 321: if (val < 0) {
	tnz	(0x10, sp)
	jrpl	00104$
;	./params.c: 322: minus = true;
	ld	a, #0x01
	ld	(0x07, sp), a
;	./params.c: 323: val = -val;
	ldw	x, (0x10, sp)
	negw	x
	ldw	(0x10, sp), x
00104$:
;	./params.c: 327: for (i = 0; val != 0; i++) {
	clr	(0x0d, sp)
00114$:
;	./params.c: 328: buffer[i] = '0' + (val % 10);
	clrw	x
	ld	a, (0x0d, sp)
	ld	xl, a
	pushw	x
	ldw	x, sp
	addw	x, #3
	addw	x, (1, sp)
	ldw	(0x0a, sp), x
	addw	sp, #2
;	./params.c: 331: i++;
	ld	a, (0x0d, sp)
	inc	a
	ld	(0x0a, sp), a
;	./params.c: 327: for (i = 0; val != 0; i++) {
	ldw	x, (0x10, sp)
	jreq	00107$
;	./params.c: 328: buffer[i] = '0' + (val % 10);
	push	#0x0a
	push	#0x00
	ldw	x, (0x12, sp)
	pushw	x
	call	__modsint
	addw	sp, #4
	ld	a, xl
	add	a, #0x30
	ldw	x, (0x08, sp)
	ld	(x), a
;	./params.c: 330: if (i == pointPosition) {
	ld	a, (0x0d, sp)
	cp	a, (0x14, sp)
	jrne	00106$
;	./params.c: 331: i++;
	ld	a, (0x0a, sp)
	ld	(0x0d, sp), a
;	./params.c: 332: buffer[i] = '.';
	clrw	x
	ld	a, (0x0d, sp)
	ld	xl, a
	pushw	x
	ldw	x, sp
	addw	x, #3
	addw	x, (1, sp)
	ldw	(0x0d, sp), x
	addw	sp, #2
	ldw	x, (0x0b, sp)
	ld	a, #0x2e
	ld	(x), a
00106$:
;	./params.c: 335: val /= 10;
	push	#0x0a
	push	#0x00
	ldw	x, (0x12, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	ldw	(0x10, sp), x
;	./params.c: 327: for (i = 0; val != 0; i++) {
	inc	(0x0d, sp)
	jra	00114$
00107$:
;	./params.c: 339: if (buffer[i - 1] == '.') {
	ld	a, (0x0d, sp)
	dec	a
	ld	(0x0c, sp), a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x0b, sp), a
	ldw	x, sp
	addw	x, #1
	addw	x, (0x0b, sp)
	ld	a, (x)
	cp	a, #0x2e
	jrne	00109$
;	./params.c: 340: buffer[i] = '0';
	ldw	x, (0x08, sp)
	ld	a, #0x30
	ld	(x), a
;	./params.c: 341: i++;
	ld	a, (0x0a, sp)
	ld	(0x0d, sp), a
00109$:
;	./params.c: 345: if (minus) {
	tnz	(0x07, sp)
	jreq	00111$
;	./params.c: 346: buffer[i] = '-';
	clrw	x
	ld	a, (0x0d, sp)
	ld	xl, a
	pushw	x
	ldw	x, sp
	addw	x, #3
	addw	x, (1, sp)
	addw	sp, #2
	ld	a, #0x2d
	ld	(x), a
;	./params.c: 347: i++;
	inc	(0x0d, sp)
00111$:
;	./params.c: 351: for (l = i; i > 0; i--) {
	ld	a, (0x0d, sp)
	ld	(0x0c, sp), a
00117$:
	tnz	(0x0d, sp)
	jreq	00112$
;	./params.c: 352: ( (unsigned char*) str) [l - i] = buffer[i - 1];
	clrw	x
	ld	a, (0x0c, sp)
	ld	xl, a
	ld	a, (0x0d, sp)
	ld	(0x0b, sp), a
	clr	(0x0a, sp)
	subw	x, (0x0a, sp)
	addw	x, (0x12, sp)
	exgw	x, y
	ld	a, (0x0d, sp)
	dec	a
	ld	(0x0b, sp), a
	rlc	a
	clr	a
	sbc	a, #0x00
	ld	(0x0a, sp), a
	ldw	x, sp
	addw	x, #1
	addw	x, (0x0a, sp)
	ld	a, (x)
	ld	(y), a
;	./params.c: 351: for (l = i; i > 0; i--) {
	dec	(0x0d, sp)
	jra	00117$
00112$:
;	./params.c: 356: ( (unsigned char*) str) [l] = 0;
	clrw	x
	ld	a, (0x0c, sp)
	ld	xl, a
	addw	x, (0x12, sp)
	clr	(x)
00119$:
;	./params.c: 357: }
	addw	sp, #13
	ret
	.area CODE
	.area CONST
_paramMin:
	.dw #0x0000
	.dw #0x0001
	.dw #0xffd3
	.dw #0xffce
	.dw #0xffba
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0xfe0c
_paramMax:
	.dw #0x0001
	.dw #0x0096
	.dw #0x006e
	.dw #0x0069
	.dw #0x0046
	.dw #0x000a
	.dw #0x0001
	.dw #0x0000
	.dw #0x0000
	.dw #0x044c
_paramDefault:
	.dw #0x0000
	.dw #0x0014
	.dw #0x006e
	.dw #0xffce
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0118
	.area INITIALIZER
	.area CABS (ABS)

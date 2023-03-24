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
	.globl _setMenuDisplay
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
;	./params.c: 62: void initParamsEEPROM()
;	-----------------------------------------
;	 function initParamsEEPROM
;	-----------------------------------------
_initParamsEEPROM:
;	./params.c: 64: if (getButton2() && getButton3() ) {
	call	_getButton2
	tnz	a
	jreq	00104$
	call	_getButton3
	tnz	a
	jreq	00104$
;	./params.c: 65: if (getParamById (PARAM_LOCK_BUTTONS)) {
	push	#0x07
	call	_getParamById
	pop	a
	tnzw	x
	jreq	00104$
;	./params.c: 66: resetParamsEEPROM();
	call	_resetParamsEEPROM
;	./params.c: 67: setMenuDisplay(MENU_EEPROM_RESET);
	push	#0x07
	call	_setMenuDisplay
	pop	a
00104$:
;	./params.c: 71: loadParamsEEPROM();
	call	_loadParamsEEPROM
;	./params.c: 73: if (getParamById (PARAM_LOCK_BUTTONS)) {
	push	#0x07
	call	_getParamById
	pop	a
	tnzw	x
	jreq	00107$
;	./params.c: 74: setMenuDisplay(MENU_EEPROM_LOCKED);
	push	#0x08
	call	_setMenuDisplay
	pop	a
00107$:
;	./params.c: 77: paramId = 0;
	clr	_paramId+0
;	./params.c: 78: }
	ret
;	./params.c: 80: static void resetParamsEEPROM()
;	-----------------------------------------
;	 function resetParamsEEPROM
;	-----------------------------------------
_resetParamsEEPROM:
;	./params.c: 83: for (paramId = 0; paramId < paramLen; paramId++) {
	clr	_paramId+0
00102$:
;	./params.c: 84: paramCache[paramId] = paramDefault[paramId];
	ld	a, _paramId+0
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, x
	addw	y, #(_paramCache + 0)
	addw	x, #(_paramDefault + 0)
	ldw	x, (x)
	ldw	(y), x
;	./params.c: 83: for (paramId = 0; paramId < paramLen; paramId++) {
	inc	_paramId+0
	ld	a, _paramId+0
	cp	a, #0x0a
	jrc	00102$
;	./params.c: 87: storeParams();
;	./params.c: 88: }
	jp	_storeParams
;	./params.c: 90: static void loadParamsEEPROM()
;	-----------------------------------------
;	 function loadParamsEEPROM
;	-----------------------------------------
_loadParamsEEPROM:
;	./params.c: 93: for (paramId = 0; paramId < paramLen; paramId++) {
	clr	_paramId+0
00102$:
;	./params.c: 94: paramCache[paramId] = * (int*) (EEPROM_BASE_ADDR + EEPROM_PARAMS_OFFSET
	ld	a, _paramId+0
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, x
	addw	y, #(_paramCache + 0)
;	./params.c: 95: + (paramId * sizeof paramCache[0]) );
	addw	x, #0x4064
	ldw	x, (x)
	ldw	(y), x
;	./params.c: 93: for (paramId = 0; paramId < paramLen; paramId++) {
	inc	_paramId+0
	ld	a, _paramId+0
	cp	a, #0x0a
	jrc	00102$
;	./params.c: 97: }
	ret
;	./params.c: 104: int getParamById (unsigned char id)
;	-----------------------------------------
;	 function getParamById
;	-----------------------------------------
_getParamById:
;	./params.c: 106: if (id < paramLen) {
	ld	a, (0x03, sp)
	cp	a, #0x0a
	jrnc	00102$
;	./params.c: 107: return paramCache[id];
	ld	a, (0x03, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	ret
00102$:
;	./params.c: 110: return -1;
	clrw	x
	decw	x
;	./params.c: 111: }
	ret
;	./params.c: 118: void setParamById (unsigned char id, int val)
;	-----------------------------------------
;	 function setParamById
;	-----------------------------------------
_setParamById:
;	./params.c: 120: if (id < paramLen) {
	ld	a, (0x03, sp)
	cp	a, #0x0a
	jrc	00110$
	ret
00110$:
;	./params.c: 121: paramCache[id] = val;
	ld	a, (0x03, sp)
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, (0x04, sp)
	ldw	((_paramCache + 0), x), y
;	./params.c: 123: }
	ret
;	./params.c: 129: int getParam()
;	-----------------------------------------
;	 function getParam
;	-----------------------------------------
_getParam:
;	./params.c: 131: return paramCache[paramId];
	ld	a, _paramId+0
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
;	./params.c: 132: }
	ret
;	./params.c: 138: void setParam (int val)
;	-----------------------------------------
;	 function setParam
;	-----------------------------------------
_setParam:
;	./params.c: 140: paramCache[paramId] = val;
	ld	a, _paramId+0
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, (0x03, sp)
	ldw	((_paramCache + 0), x), y
;	./params.c: 141: }
	ret
;	./params.c: 146: void incParam()
;	-----------------------------------------
;	 function incParam
;	-----------------------------------------
_incParam:
	sub	sp, #4
;	./params.c: 151: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
	clrw	x
	ld	a, _paramId+0
	ld	xl, a
	sllw	x
	exgw	x, y
;	./params.c: 149: if (paramId == PARAM_OVERHEAT_INDICATION ||
	ld	a, _paramId+0
	cp	a, #0x06
	jreq	00103$
;	./params.c: 150: paramId == PARAM_LOCK_BUTTONS || paramId == PARAM_AUTO_BRIGHT) {
	ld	a, _paramId+0
	cp	a, #0x07
	jreq	00103$
	ld	a, _paramId+0
	cp	a, #0x08
	jrne	00104$
00103$:
;	./params.c: 151: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
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
	jra	00108$
00104$:
;	./params.c: 152: } else if (paramCache[paramId] < paramMax[paramId]) {
	ldw	x, y
	addw	x, #(_paramCache + 0)
	ldw	(0x01, sp), x
	ldw	x, (x)
	addw	y, #(_paramMax + 0)
	ldw	y, (y)
	ldw	(0x03, sp), y
	cpw	x, (0x03, sp)
	jrsge	00108$
;	./params.c: 153: paramCache[paramId]++;
	incw	x
	ldw	y, (0x01, sp)
	ldw	(y), x
00108$:
;	./params.c: 155: }
	addw	sp, #4
	ret
;	./params.c: 160: void decParam()
;	-----------------------------------------
;	 function decParam
;	-----------------------------------------
_decParam:
	sub	sp, #4
;	./params.c: 165: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
	clrw	x
	ld	a, _paramId+0
	ld	xl, a
	sllw	x
	exgw	x, y
;	./params.c: 163: if (paramId == PARAM_OVERHEAT_INDICATION ||
	ld	a, _paramId+0
	cp	a, #0x06
	jreq	00103$
;	./params.c: 164: paramId == PARAM_LOCK_BUTTONS || paramId == PARAM_AUTO_BRIGHT) {
	ld	a, _paramId+0
	cp	a, #0x07
	jreq	00103$
	ld	a, _paramId+0
	cp	a, #0x08
	jrne	00104$
00103$:
;	./params.c: 165: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
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
	jra	00108$
00104$:
;	./params.c: 166: } else if (paramCache[paramId] > paramMin[paramId]) {
	ldw	x, y
	addw	x, #(_paramCache + 0)
	ldw	(0x01, sp), x
	ldw	x, (x)
	addw	y, #(_paramMin + 0)
	ldw	y, (y)
	ldw	(0x03, sp), y
	cpw	x, (0x03, sp)
	jrsle	00108$
;	./params.c: 167: paramCache[paramId]--;
	decw	x
	ldw	y, (0x01, sp)
	ldw	(y), x
00108$:
;	./params.c: 169: }
	addw	sp, #4
	ret
;	./params.c: 175: unsigned char getParamId()
;	-----------------------------------------
;	 function getParamId
;	-----------------------------------------
_getParamId:
;	./params.c: 177: return paramId;
	ld	a, _paramId+0
;	./params.c: 178: }
	ret
;	./params.c: 184: void setParamId (unsigned char val)
;	-----------------------------------------
;	 function setParamId
;	-----------------------------------------
_setParamId:
;	./params.c: 186: if (val < paramLen) {
	ld	a, (0x03, sp)
	cp	a, #0x0a
	jrc	00110$
	ret
00110$:
;	./params.c: 187: paramId = val;
	ld	a, (0x03, sp)
	ld	_paramId+0, a
;	./params.c: 189: }
	ret
;	./params.c: 194: void incParamId()
;	-----------------------------------------
;	 function incParamId
;	-----------------------------------------
_incParamId:
;	./params.c: 196: if (paramId < paramIdMax) {
	ld	a, _paramId+0
	cp	a, #0x08
	jrnc	00102$
;	./params.c: 197: paramId++;
	inc	_paramId+0
	ret
00102$:
;	./params.c: 199: paramId = 0;
	clr	_paramId+0
;	./params.c: 201: }
	ret
;	./params.c: 206: void decParamId()
;	-----------------------------------------
;	 function decParamId
;	-----------------------------------------
_decParamId:
;	./params.c: 208: if (paramId > 0) {
	tnz	_paramId+0
	jreq	00102$
;	./params.c: 209: paramId--;
	dec	_paramId+0
	ret
00102$:
;	./params.c: 211: paramId = paramIdMax;
	mov	_paramId+0, #0x08
;	./params.c: 213: }
	ret
;	./params.c: 222: void paramToString (unsigned char id, unsigned char* strBuff)
;	-----------------------------------------
;	 function paramToString
;	-----------------------------------------
_paramToString:
	sub	sp, #4
;	./params.c: 224: switch (id) {
	ld	a, (0x07, sp)
	cp	a, #0x09
	jrule	00159$
	jp	00125$
00159$:
	clrw	x
	ld	a, (0x07, sp)
	ld	xl, a
	sllw	x
	ldw	x, (#00160$, x)
	jp	(x)
00160$:
	.dw	#00101$
	.dw	#00113$
	.dw	#00114$
	.dw	#00115$
	.dw	#00116$
	.dw	#00117$
	.dw	#00120$
	.dw	#00120$
	.dw	#00120$
	.dw	#00124$
;	./params.c: 225: case PARAM_RELAY_MODE:
00101$:
;	./params.c: 226: ( (unsigned char*) strBuff) [1] = 0;
	ldw	y, (0x08, sp)
	incw	y
	clr	(y)
;	./params.c: 227: if (paramCache[id] == 1) {
	ld	a, (0x07, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	cpw	x, #0x0001
	jrne	00111$
;	./params.c: 228: ( (unsigned char*) strBuff) [0] = 'H';
	ldw	x, (0x08, sp)
	ld	a, #0x48
	ld	(x), a
	jp	00127$
00111$:
;	./params.c: 229: } else if (paramCache[id] == 0) {
	tnzw	x
	jrne	00108$
;	./params.c: 230: ( (unsigned char*) strBuff) [0] = 'C';
	ldw	x, (0x08, sp)
	ld	a, #0x43
	ld	(x), a
	jp	00127$
00108$:
;	./params.c: 231: } else if (paramCache[id] == 2) {
	cpw	x, #0x0002
	jrne	00105$
;	./params.c: 232: ( (unsigned char*) strBuff) [2] = 0;
	ldw	x, (0x08, sp)
	incw	x
	incw	x
	clr	(x)
;	./params.c: 233: ( (unsigned char*) strBuff) [1] = '1';
	ld	a, #0x31
	ld	(y), a
;	./params.c: 234: ( (unsigned char*) strBuff) [0] = 'A';
	ldw	x, (0x08, sp)
	ld	a, #0x41
	ld	(x), a
	jp	00127$
00105$:
;	./params.c: 235: } else if (paramCache[id] == 3) {
	cpw	x, #0x0003
	jreq	00170$
	jp	00127$
00170$:
;	./params.c: 236: ( (unsigned char*) strBuff) [2] = 0;
	ldw	x, (0x08, sp)
	incw	x
	incw	x
	clr	(x)
;	./params.c: 237: ( (unsigned char*) strBuff) [1] = '2';
	ld	a, #0x32
	ld	(y), a
;	./params.c: 238: ( (unsigned char*) strBuff) [0] = 'A';
	ldw	x, (0x08, sp)
	ld	a, #0x41
	ld	(x), a
;	./params.c: 241: break;
	jp	00127$
;	./params.c: 243: case PARAM_RELAY_HYSTERESIS:
00113$:
;	./params.c: 244: itofpa (paramCache[id], strBuff, 0);
	ld	a, (0x07, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x00
	ldw	y, (0x09, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 245: break;
	jp	00127$
;	./params.c: 247: case PARAM_MAX_TEMPERATURE:
00114$:
;	./params.c: 248: itofpa (paramCache[id], strBuff, 6);
	ld	a, (0x07, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x06
	ldw	y, (0x09, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 249: break;
	jp	00127$
;	./params.c: 251: case PARAM_MIN_TEMPERATURE:
00115$:
;	./params.c: 252: itofpa (paramCache[id], strBuff, 6);
	ld	a, (0x07, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x06
	ldw	y, (0x09, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 253: break;
	jp	00127$
;	./params.c: 255: case PARAM_TEMPERATURE_CORRECTION:
00116$:
;	./params.c: 256: itofpa (paramCache[id], strBuff, 0);
	ld	a, (0x07, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x00
	ldw	y, (0x09, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 257: break;
	jra	00127$
;	./params.c: 259: case PARAM_RELAY_DELAY:
00117$:
;	./params.c: 260: itofpa (paramCache[id], strBuff, 6);
	ld	a, (0x07, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x06
	ldw	y, (0x09, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 261: break;
	jra	00127$
;	./params.c: 265: case PARAM_AUTO_BRIGHT:
00120$:
;	./params.c: 266: ( (unsigned char*) strBuff) [0] = 'O';
	ldw	y, (0x08, sp)
	ldw	(0x01, sp), y
	ldw	x, y
	ld	a, #0x4f
	ld	(x), a
;	./params.c: 268: if (paramCache[id]) {
	ld	a, (0x07, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	ldw	(0x03, sp), x
	jreq	00122$
;	./params.c: 269: ( (unsigned char*) strBuff) [1] = 'N';
	ldw	x, (0x01, sp)
	incw	x
	ld	a, #0x4e
	ld	(x), a
;	./params.c: 270: ( (unsigned char*) strBuff) [2] = ' ';
	ldw	x, (0x01, sp)
	incw	x
	incw	x
	ld	a, #0x20
	ld	(x), a
	jra	00123$
00122$:
;	./params.c: 272: ( (unsigned char*) strBuff) [1] = 'F';
	ldw	x, (0x01, sp)
	incw	x
	ld	a, #0x46
	ld	(x), a
;	./params.c: 273: ( (unsigned char*) strBuff) [2] = 'F';
	ldw	x, (0x01, sp)
	incw	x
	incw	x
	ld	a, #0x46
	ld	(x), a
00123$:
;	./params.c: 276: ( (unsigned char*) strBuff) [3] = 0;
	ldw	x, (0x01, sp)
	clr	(0x0003, x)
;	./params.c: 277: break;
	jra	00127$
;	./params.c: 279: case PARAM_THRESHOLD:
00124$:
;	./params.c: 280: itofpa (paramCache[id], strBuff, 0);
	ld	a, (0x07, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	push	#0x00
	ldw	y, (0x09, sp)
	pushw	y
	pushw	x
	call	_itofpa
	addw	sp, #5
;	./params.c: 281: break;
	jra	00127$
;	./params.c: 283: default: // Display "OFF" to all unknown ID
00125$:
;	./params.c: 284: ( (unsigned char*) strBuff) [0] = 'O';
	ldw	y, (0x08, sp)
	ld	a, #0x4f
	ld	(y), a
;	./params.c: 285: ( (unsigned char*) strBuff) [1] = 'F';
	ldw	x, y
	incw	x
	ld	a, #0x46
	ld	(x), a
;	./params.c: 286: ( (unsigned char*) strBuff) [2] = 'F';
	ldw	x, y
	incw	x
	incw	x
	ld	a, #0x46
	ld	(x), a
;	./params.c: 287: ( (unsigned char*) strBuff) [3] = 0;
	ldw	x, y
	clr	(0x0003, x)
;	./params.c: 288: }
00127$:
;	./params.c: 289: }
	addw	sp, #4
	ret
;	./params.c: 294: void storeParams()
;	-----------------------------------------
;	 function storeParams
;	-----------------------------------------
_storeParams:
	sub	sp, #2
;	./params.c: 299: if ( (FLASH_IAPSR & 0x08) == 0) {
	ld	a, 0x505f
	bcp	a, #0x08
	jrne	00112$
;	./params.c: 300: FLASH_DUKR = 0xAE;
	mov	0x5064+0, #0xae
;	./params.c: 301: FLASH_DUKR = 0x56;
	mov	0x5064+0, #0x56
;	./params.c: 305: for (i = 0; i < paramLen; i++) {
00112$:
	clr	a
00106$:
;	./params.c: 306: if (paramCache[i] != (* (int*) (EEPROM_BASE_ADDR + EEPROM_PARAMS_OFFSET
	clrw	x
	ld	xl, a
	sllw	x
	ldw	y, x
	addw	x, #(_paramCache + 0)
	ldw	x, (x)
	ldw	(0x01, sp), x
;	./params.c: 307: + (i * sizeof paramCache[0]) ) ) ) {
	addw	y, #0x4064
	ldw	x, y
	ldw	x, (x)
	cpw	x, (0x01, sp)
	jreq	00107$
;	./params.c: 309: + (i * sizeof paramCache[0]) ) = paramCache[i];
	ldw	x, y
	ldw	y, (0x01, sp)
	ldw	(x), y
00107$:
;	./params.c: 305: for (i = 0; i < paramLen; i++) {
	inc	a
	cp	a, #0x0a
	jrc	00106$
;	./params.c: 314: FLASH_IAPSR &= ~0x08;
	bres	20575, #3
;	./params.c: 315: }
	addw	sp, #2
	ret
;	./params.c: 321: static void writeEEPROM (unsigned char val, unsigned char offset)
;	-----------------------------------------
;	 function writeEEPROM
;	-----------------------------------------
_writeEEPROM:
;	./params.c: 324: if ( (FLASH_IAPSR & 0x08) == 0) {
	ld	a, 0x505f
	bcp	a, #0x08
	jrne	00102$
;	./params.c: 325: FLASH_DUKR = 0xAE;
	mov	0x5064+0, #0xae
;	./params.c: 326: FLASH_DUKR = 0x56;
	mov	0x5064+0, #0x56
00102$:
;	./params.c: 330: (* (unsigned char*) (EEPROM_BASE_ADDR + offset) ) = val;
	ld	a, (0x04, sp)
	clrw	x
	addw	x, #16384
	ld	xl, a
	ld	a, (0x03, sp)
	ld	(x), a
;	./params.c: 333: FLASH_IAPSR &= ~0x08;
	bres	20575, #3
;	./params.c: 334: }
	ret
;	./params.c: 348: void itofpa (int val, unsigned char* str, unsigned char pointPosition)
;	-----------------------------------------
;	 function itofpa
;	-----------------------------------------
_itofpa:
	sub	sp, #13
;	./params.c: 350: unsigned char i, l, buffer[] = {0, 0, 0, 0, 0, 0};
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
;	./params.c: 351: bool minus = false;
	clr	(0x07, sp)
;	./params.c: 354: if (val == 0) {
	ldw	x, (0x10, sp)
	jrne	00102$
;	./params.c: 355: ( (unsigned char*) str) [0] = '0';
	ldw	x, (0x12, sp)
	ld	a, #0x30
	ld	(x), a
;	./params.c: 356: ( (unsigned char*) str) [1] = 0;
	incw	x
	clr	(x)
;	./params.c: 357: return;
	jp	00119$
00102$:
;	./params.c: 361: if (val < 0) {
	tnz	(0x10, sp)
	jrpl	00104$
;	./params.c: 362: minus = true;
	ld	a, #0x01
	ld	(0x07, sp), a
;	./params.c: 363: val = -val;
	ldw	x, (0x10, sp)
	negw	x
	ldw	(0x10, sp), x
00104$:
;	./params.c: 367: for (i = 0; val != 0; i++) {
	clr	(0x0d, sp)
00114$:
;	./params.c: 368: buffer[i] = '0' + (val % 10);
	clrw	x
	ld	a, (0x0d, sp)
	ld	xl, a
	pushw	x
	ldw	x, sp
	addw	x, #3
	addw	x, (1, sp)
	ldw	(0x0a, sp), x
	addw	sp, #2
;	./params.c: 371: i++;
	ld	a, (0x0d, sp)
	inc	a
	ld	(0x0a, sp), a
;	./params.c: 367: for (i = 0; val != 0; i++) {
	ldw	x, (0x10, sp)
	jreq	00107$
;	./params.c: 368: buffer[i] = '0' + (val % 10);
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
;	./params.c: 370: if (i == pointPosition) {
	ld	a, (0x0d, sp)
	cp	a, (0x14, sp)
	jrne	00106$
;	./params.c: 371: i++;
	ld	a, (0x0a, sp)
	ld	(0x0d, sp), a
;	./params.c: 372: buffer[i] = '.';
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
;	./params.c: 375: val /= 10;
	push	#0x0a
	push	#0x00
	ldw	x, (0x12, sp)
	pushw	x
	call	__divsint
	addw	sp, #4
	ldw	(0x10, sp), x
;	./params.c: 367: for (i = 0; val != 0; i++) {
	inc	(0x0d, sp)
	jra	00114$
00107$:
;	./params.c: 379: if (buffer[i - 1] == '.') {
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
;	./params.c: 380: buffer[i] = '0';
	ldw	x, (0x08, sp)
	ld	a, #0x30
	ld	(x), a
;	./params.c: 381: i++;
	ld	a, (0x0a, sp)
	ld	(0x0d, sp), a
00109$:
;	./params.c: 385: if (minus) {
	tnz	(0x07, sp)
	jreq	00111$
;	./params.c: 386: buffer[i] = '-';
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
;	./params.c: 387: i++;
	inc	(0x0d, sp)
00111$:
;	./params.c: 391: for (l = i; i > 0; i--) {
	ld	a, (0x0d, sp)
	ld	(0x0c, sp), a
00117$:
	tnz	(0x0d, sp)
	jreq	00112$
;	./params.c: 392: ( (unsigned char*) str) [l - i] = buffer[i - 1];
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
;	./params.c: 391: for (l = i; i > 0; i--) {
	dec	(0x0d, sp)
	jra	00117$
00112$:
;	./params.c: 396: ( (unsigned char*) str) [l] = 0;
	clrw	x
	ld	a, (0x0c, sp)
	ld	xl, a
	addw	x, (0x12, sp)
	clr	(x)
00119$:
;	./params.c: 397: }
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
	.dw #0x0003
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

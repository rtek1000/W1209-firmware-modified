;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module adc
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _rawAdc
	.globl _getParamById
	.globl _initADC
	.globl _startADC
	.globl _getAdcResult
	.globl _getAdcAveraged
	.globl _getTemperature
	.globl _ADC1_EOC_handler
	.globl _getSensorFail
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_result:
	.ds 2
_result_fail:
	.ds 4
_averaged:
	.ds 4
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
;	./adc.c: 174: void initADC()
;	-----------------------------------------
;	 function initADC
;	-----------------------------------------
_initADC:
;	./adc.c: 176: ADC_CR1 |= 0x70;    // Prescaler f/18 (SPSEL)
	ld	a, 0x5401
	or	a, #0x70
	ld	0x5401, a
;	./adc.c: 177: ADC_CSR |= 0x06;    // select AIN6
	ld	a, 0x5400
	or	a, #0x06
;	./adc.c: 178: ADC_CSR |= 0x20;    // Interrupt enable (EOCIE)
	ld	0x5400, a
	or	a, #0x20
	ld	0x5400, a
;	./adc.c: 179: ADC_CR1 |= 0x01;    // Power up ADC
	bset	21505, #0
;	./adc.c: 180: result = 0;
	clrw	x
	ldw	_result+0, x
;	./adc.c: 181: averaged = 0;
	clrw	x
	ldw	_averaged+2, x
	ldw	_averaged+0, x
;	./adc.c: 182: }
	ret
;	./adc.c: 187: void startADC()
;	-----------------------------------------
;	 function startADC
;	-----------------------------------------
_startADC:
;	./adc.c: 189: ADC_CR1 |= 0x01;
	bset	21505, #0
;	./adc.c: 190: }
	ret
;	./adc.c: 196: unsigned int getAdcResult()
;	-----------------------------------------
;	 function getAdcResult
;	-----------------------------------------
_getAdcResult:
;	./adc.c: 198: return result;
	ldw	x, _result+0
;	./adc.c: 199: }
	ret
;	./adc.c: 206: unsigned int getAdcAveraged()
;	-----------------------------------------
;	 function getAdcAveraged
;	-----------------------------------------
_getAdcAveraged:
;	./adc.c: 208: return (unsigned int) (averaged >> ADC_AVERAGING_BITS);
	ldw	x, _averaged+2
	ldw	y, _averaged+0
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
;	./adc.c: 209: }
	ret
;	./adc.c: 216: int getTemperature()
;	-----------------------------------------
;	 function getTemperature
;	-----------------------------------------
_getTemperature:
	sub	sp, #8
;	./adc.c: 218: unsigned int val = averaged >> ADC_AVERAGING_BITS;
	ldw	x, _averaged+2
	ldw	y, _averaged+0
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
	srlw	y
	rrcw	x
	ldw	(0x01, sp), x
;	./adc.c: 219: unsigned char rightBound = ADC_RAW_TABLE_SIZE;
	ld	a, #0xa5
	ld	(0x03, sp), a
;	./adc.c: 220: unsigned char leftBound = 0;
	clr	(0x04, sp)
;	./adc.c: 223: while ( (rightBound - leftBound) > 1) {
00104$:
	ld	a, (0x03, sp)
	ld	(0x06, sp), a
	clr	(0x05, sp)
	ld	a, (0x04, sp)
	ld	(0x08, sp), a
	clr	(0x07, sp)
	ldw	x, (0x05, sp)
	subw	x, (0x07, sp)
	cpw	x, #0x0001
	jrsle	00106$
;	./adc.c: 224: unsigned char midId = (leftBound + rightBound) >> 1;
	ldw	x, (0x07, sp)
	addw	x, (0x05, sp)
	sraw	x
	exg	a, xl
	ld	(0x08, sp), a
	exg	a, xl
;	./adc.c: 226: if (val > rawAdc[midId]) {
	ld	a, (0x08, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_rawAdc + 0)
	ldw	x, (x)
	cpw	x, (0x01, sp)
	jrnc	00102$
;	./adc.c: 227: rightBound = midId;
	ld	a, (0x08, sp)
	ld	(0x03, sp), a
	jra	00104$
00102$:
;	./adc.c: 229: leftBound = midId;
	ld	a, (0x08, sp)
	ld	(0x04, sp), a
	jra	00104$
00106$:
;	./adc.c: 234: if (val >= rawAdc[leftBound]) {
	ldw	x, (0x07, sp)
	sllw	x
	addw	x, #(_rawAdc + 0)
	ldw	x, (x)
	ldw	(0x03, sp), x
	ldw	x, (0x01, sp)
	cpw	x, (0x03, sp)
	jrc	00108$
;	./adc.c: 235: val = leftBound * 10;
	ldw	x, (0x07, sp)
	sllw	x
	sllw	x
	addw	x, (0x07, sp)
	sllw	x
	jra	00109$
00108$:
;	./adc.c: 237: val = (rightBound * 10) - ( (val - rawAdc[rightBound]) * 10)
	ldw	x, (0x05, sp)
	sllw	x
	sllw	x
	addw	x, (0x05, sp)
	sllw	x
	ldw	(0x07, sp), x
	ldw	x, (0x05, sp)
	sllw	x
	addw	x, #(_rawAdc + 0)
	ldw	x, (x)
	ldw	(0x05, sp), x
	ldw	x, (0x01, sp)
	subw	x, (0x05, sp)
	pushw	x
	sllw	x
	sllw	x
	addw	x, (1, sp)
	sllw	x
	addw	sp, #2
;	./adc.c: 238: / (rawAdc[leftBound] - rawAdc[rightBound]);
	ldw	y, (0x03, sp)
	subw	y, (0x05, sp)
	divw	x, y
	ldw	(0x05, sp), x
	ldw	x, (0x07, sp)
	subw	x, (0x05, sp)
	ldw	(0x07, sp), x
00109$:
;	./adc.c: 242: return ADC_RAW_TABLE_BASE_TEMP + val + getParamById (PARAM_TEMPERATURE_CORRECTION);
	addw	x, #0xfdf8
	ldw	(0x07, sp), x
	push	#0x04
	call	_getParamById
	pop	a
	addw	x, (0x07, sp)
;	./adc.c: 243: }
	addw	sp, #8
	ret
;	./adc.c: 249: void ADC1_EOC_handler() __interrupt (22)
;	-----------------------------------------
;	 function ADC1_EOC_handler
;	-----------------------------------------
_ADC1_EOC_handler:
	clr	a
	div	x, a
	sub	sp, #12
;	./adc.c: 251: result = ADC_DRH << 2;
	ld	a, 0x5404
	clrw	x
	ld	xl, a
	sllw	x
	sllw	x
	ldw	_result+0, x
;	./adc.c: 252: result |= ADC_DRL;
	ld	a, 0x5405
	clrw	x
	or	a, _result+1
	rlwa	x
	or	a, _result+0
	ld	xh, a
	ldw	_result+0, x
;	./adc.c: 253: ADC_CSR &= ~0x80;   // reset EOC
	bres	21504, #7
;	./adc.c: 259: averaged += result - (averaged >> ADC_AVERAGING_BITS);
	ldw	x, _result+0
	ldw	(0x03, sp), x
	clr	(0x02, sp)
	clr	(0x01, sp)
;	./adc.c: 256: if (averaged == 0) {
	ldw	x, _averaged+2
	jrne	00102$
	ldw	x, _averaged+0
	jrne	00102$
;	./adc.c: 257: averaged = result << ADC_AVERAGING_BITS;
	ldw	x, _result+0
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	clrw	y
	ldw	_averaged+2, x
	ldw	_averaged+0, y
	jra	00103$
00102$:
;	./adc.c: 259: averaged += result - (averaged >> ADC_AVERAGING_BITS);
	ldw	x, _averaged+2
	ldw	(0x0b, sp), x
	ldw	x, _averaged+0
	ldw	(0x09, sp), x
	srl	(0x09, sp)
	rrc	(0x0a, sp)
	rrc	(0x0b, sp)
	rrc	(0x0c, sp)
	srl	(0x09, sp)
	rrc	(0x0a, sp)
	rrc	(0x0b, sp)
	rrc	(0x0c, sp)
	srl	(0x09, sp)
	rrc	(0x0a, sp)
	rrc	(0x0b, sp)
	rrc	(0x0c, sp)
	srl	(0x09, sp)
	rrc	(0x0a, sp)
	rrc	(0x0b, sp)
	rrc	(0x0c, sp)
	ldw	x, (0x03, sp)
	subw	x, (0x0b, sp)
	ldw	(0x07, sp), x
	ld	a, (0x02, sp)
	sbc	a, (0x0a, sp)
	ld	(0x06, sp), a
	ld	a, (0x01, sp)
	sbc	a, (0x09, sp)
	ld	(0x05, sp), a
	ldw	x, _averaged+2
	addw	x, (0x07, sp)
	ldw	(0x0b, sp), x
	ld	a, _averaged+1
	adc	a, (0x06, sp)
	ld	(0x0a, sp), a
	ld	a, _averaged+0
	adc	a, (0x05, sp)
	ld	(0x09, sp), a
	ldw	x, (0x0b, sp)
	ldw	_averaged+2, x
	ldw	x, (0x09, sp)
	ldw	_averaged+0, x
00103$:
;	./adc.c: 263: if (result_fail == 0) {
	ldw	x, _result_fail+2
	jrne	00105$
	ldw	x, _result_fail+0
	jrne	00105$
;	./adc.c: 264: result_fail = result << ADC_AVERAGING_FAIL_BITS;
	ldw	x, _result+0
	sllw	x
	clrw	y
	ldw	_result_fail+2, x
	ldw	_result_fail+0, y
	jra	00107$
00105$:
;	./adc.c: 266: result_fail += result - (result_fail >> ADC_AVERAGING_FAIL_BITS);
	ldw	x, _result_fail+2
	ldw	(0x07, sp), x
	ldw	x, _result_fail+0
	ldw	(0x05, sp), x
	srl	(0x05, sp)
	rrc	(0x06, sp)
	rrc	(0x07, sp)
	rrc	(0x08, sp)
	ldw	x, (0x03, sp)
	subw	x, (0x07, sp)
	ld	a, (0x02, sp)
	sbc	a, (0x06, sp)
	push	a
	ld	a, (0x02, sp)
	sbc	a, (0x06, sp)
	ld	(0x0a, sp), a
	pop	a
	addw	x, _result_fail+2
	adc	a, _result_fail+1
	ld	(0x06, sp), a
	ld	a, (0x09, sp)
	adc	a, _result_fail+0
	ld	(0x05, sp), a
	ldw	_result_fail+2, x
	ldw	x, (0x05, sp)
	ldw	_result_fail+0, x
00107$:
;	./adc.c: 268: }
	addw	sp, #12
	iret
;	./adc.c: 270: int getSensorFail()
;	-----------------------------------------
;	 function getSensorFail
;	-----------------------------------------
_getSensorFail:
	sub	sp, #8
;	./adc.c: 272: if((result_fail >> ADC_AVERAGING_FAIL_BITS) > rawAdc[0]) {
	ldw	x, _result_fail+2
	ldw	(0x03, sp), x
	ldw	x, _result_fail+0
	ldw	(0x01, sp), x
	srl	(0x01, sp)
	rrc	(0x02, sp)
	rrc	(0x03, sp)
	rrc	(0x04, sp)
	ldw	x, _rawAdc+0
	clrw	y
	cpw	x, (0x03, sp)
	ld	a, yl
	sbc	a, (0x02, sp)
	ld	a, yh
	sbc	a, (0x01, sp)
	jrnc	00105$
;	./adc.c: 273: return 2;
	ldw	x, #0x0002
	jra	00107$
00105$:
;	./adc.c: 274: } else if((result_fail >> ADC_AVERAGING_FAIL_BITS) < rawAdc[ADC_RAW_TABLE_SIZE - 1]) {
	ldw	x, _rawAdc+328
	ldw	(0x07, sp), x
	clr	(0x06, sp)
	clr	(0x05, sp)
	ldw	x, (0x03, sp)
	cpw	x, (0x07, sp)
	ld	a, (0x02, sp)
	sbc	a, (0x06, sp)
	ld	a, (0x01, sp)
	sbc	a, (0x05, sp)
	jrnc	00102$
;	./adc.c: 275: return 1;
	clrw	x
	incw	x
;	./adc.c: 277: return 0;
	.byte 0x21
00102$:
	clrw	x
00107$:
;	./adc.c: 279: }
	addw	sp, #8
	ret
	.area CODE
	.area CONST
_rawAdc:
	.dw #0x03fb
	.dw #0x03fa
	.dw #0x03fa
	.dw #0x03f9
	.dw #0x03f9
	.dw #0x03f8
	.dw #0x03f8
	.dw #0x03f7
	.dw #0x03f6
	.dw #0x03f6
	.dw #0x03f5
	.dw #0x03f4
	.dw #0x03f3
	.dw #0x03f2
	.dw #0x03f1
	.dw #0x03f0
	.dw #0x03ef
	.dw #0x03ee
	.dw #0x03ec
	.dw #0x03eb
	.dw #0x03ea
	.dw #0x03e8
	.dw #0x03e7
	.dw #0x03e5
	.dw #0x03e3
	.dw #0x03e1
	.dw #0x03df
	.dw #0x03dd
	.dw #0x03db
	.dw #0x03d8
	.dw #0x03d6
	.dw #0x03d3
	.dw #0x03d1
	.dw #0x03ce
	.dw #0x03cb
	.dw #0x03c8
	.dw #0x03c5
	.dw #0x03c1
	.dw #0x03bd
	.dw #0x03ba
	.dw #0x03b6
	.dw #0x03b2
	.dw #0x03ae
	.dw #0x03a9
	.dw #0x03a5
	.dw #0x03a0
	.dw #0x039b
	.dw #0x0396
	.dw #0x0390
	.dw #0x038b
	.dw #0x0385
	.dw #0x037f
	.dw #0x0379
	.dw #0x0373
	.dw #0x036c
	.dw #0x0366
	.dw #0x035f
	.dw #0x0358
	.dw #0x0350
	.dw #0x0349
	.dw #0x0341
	.dw #0x0339
	.dw #0x0331
	.dw #0x0329
	.dw #0x0321
	.dw #0x0318
	.dw #0x030f
	.dw #0x0307
	.dw #0x02fe
	.dw #0x02f4
	.dw #0x02eb
	.dw #0x02e1
	.dw #0x02d8
	.dw #0x02ce
	.dw #0x02c4
	.dw #0x02ba
	.dw #0x02b0
	.dw #0x02a6
	.dw #0x029c
	.dw #0x0292
	.dw #0x0287
	.dw #0x027d
	.dw #0x0272
	.dw #0x0268
	.dw #0x025e
	.dw #0x0253
	.dw #0x0249
	.dw #0x023e
	.dw #0x0234
	.dw #0x0229
	.dw #0x021f
	.dw #0x0214
	.dw #0x020a
	.dw #0x0200
	.dw #0x01f5
	.dw #0x01eb
	.dw #0x01e1
	.dw #0x01d7
	.dw #0x01cd
	.dw #0x01c4
	.dw #0x01ba
	.dw #0x01b0
	.dw #0x01a7
	.dw #0x019e
	.dw #0x0194
	.dw #0x018b
	.dw #0x0182
	.dw #0x017a
	.dw #0x0171
	.dw #0x0168
	.dw #0x0160
	.dw #0x0158
	.dw #0x0150
	.dw #0x0148
	.dw #0x0140
	.dw #0x0138
	.dw #0x0131
	.dw #0x0129
	.dw #0x0122
	.dw #0x011b
	.dw #0x0114
	.dw #0x010d
	.dw #0x0107
	.dw #0x0100
	.dw #0x00fa
	.dw #0x00f4
	.dw #0x00ee
	.dw #0x00e8
	.dw #0x00e2
	.dw #0x00dc
	.dw #0x00d7
	.dw #0x00d1
	.dw #0x00cc
	.dw #0x00c7
	.dw #0x00c2
	.dw #0x00bd
	.dw #0x00b8
	.dw #0x00b4
	.dw #0x00af
	.dw #0x00ab
	.dw #0x00a7
	.dw #0x00a3
	.dw #0x009e
	.dw #0x009a
	.dw #0x0097
	.dw #0x0093
	.dw #0x008f
	.dw #0x008c
	.dw #0x0088
	.dw #0x0085
	.dw #0x0082
	.dw #0x007e
	.dw #0x007b
	.dw #0x0078
	.dw #0x0075
	.dw #0x0072
	.dw #0x0070
	.dw #0x006d
	.dw #0x006a
	.dw #0x0068
	.dw #0x0065
	.dw #0x0063
	.dw #0x0060
	.dw #0x005e
	.dw #0x005c
	.area INITIALIZER
	.area CABS (ABS)

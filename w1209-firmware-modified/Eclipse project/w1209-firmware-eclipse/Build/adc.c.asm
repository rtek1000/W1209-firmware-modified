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
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
_result:
	.ds 2
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
;	./adc.c: 63: void initADC()
;	-----------------------------------------
;	 function initADC
;	-----------------------------------------
_initADC:
;	./adc.c: 65: ADC_CR1 |= 0x70;    // Prescaler f/18 (SPSEL)
	ld	a, 0x5401
	or	a, #0x70
	ld	0x5401, a
;	./adc.c: 66: ADC_CSR |= 0x06;    // select AIN6
	ld	a, 0x5400
	or	a, #0x06
;	./adc.c: 67: ADC_CSR |= 0x20;    // Interrupt enable (EOCIE)
	ld	0x5400, a
	or	a, #0x20
	ld	0x5400, a
;	./adc.c: 68: ADC_CR1 |= 0x01;    // Power up ADC
	bset	21505, #0
;	./adc.c: 69: result = 0;
	clrw	x
	ldw	_result+0, x
;	./adc.c: 70: averaged = 0;
	clrw	x
	ldw	_averaged+2, x
	ldw	_averaged+0, x
;	./adc.c: 71: }
	ret
;	./adc.c: 76: void startADC()
;	-----------------------------------------
;	 function startADC
;	-----------------------------------------
_startADC:
;	./adc.c: 78: ADC_CR1 |= 0x01;
	bset	21505, #0
;	./adc.c: 79: }
	ret
;	./adc.c: 85: unsigned int getAdcResult()
;	-----------------------------------------
;	 function getAdcResult
;	-----------------------------------------
_getAdcResult:
;	./adc.c: 87: return result;
	ldw	x, _result+0
;	./adc.c: 88: }
	ret
;	./adc.c: 95: unsigned int getAdcAveraged()
;	-----------------------------------------
;	 function getAdcAveraged
;	-----------------------------------------
_getAdcAveraged:
;	./adc.c: 97: return (unsigned int) (averaged >> ADC_AVERAGING_BITS);
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
;	./adc.c: 98: }
	ret
;	./adc.c: 105: int getTemperature()
;	-----------------------------------------
;	 function getTemperature
;	-----------------------------------------
_getTemperature:
	sub	sp, #8
;	./adc.c: 107: unsigned int val = averaged >> ADC_AVERAGING_BITS;
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
;	./adc.c: 108: unsigned char rightBound = ADC_RAW_TABLE_SIZE;
	ld	a, #0xa5
	ld	(0x03, sp), a
;	./adc.c: 109: unsigned char leftBound = 0;
	clr	(0x04, sp)
;	./adc.c: 112: while ( (rightBound - leftBound) > 1) {
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
;	./adc.c: 113: unsigned char midId = (leftBound + rightBound) >> 1;
	ldw	x, (0x07, sp)
	addw	x, (0x05, sp)
	sraw	x
	exg	a, xl
	ld	(0x08, sp), a
	exg	a, xl
;	./adc.c: 115: if (val > rawAdc[midId]) {
	ld	a, (0x08, sp)
	clrw	x
	ld	xl, a
	sllw	x
	addw	x, #(_rawAdc + 0)
	ldw	x, (x)
	cpw	x, (0x01, sp)
	jrnc	00102$
;	./adc.c: 116: rightBound = midId;
	ld	a, (0x08, sp)
	ld	(0x03, sp), a
	jra	00104$
00102$:
;	./adc.c: 118: leftBound = midId;
	ld	a, (0x08, sp)
	ld	(0x04, sp), a
	jra	00104$
00106$:
;	./adc.c: 123: if (val >= rawAdc[leftBound]) {
	ldw	x, (0x07, sp)
	sllw	x
	addw	x, #(_rawAdc + 0)
	ldw	x, (x)
	ldw	(0x03, sp), x
	ldw	x, (0x01, sp)
	cpw	x, (0x03, sp)
	jrc	00108$
;	./adc.c: 124: val = leftBound * 10;
	ldw	x, (0x07, sp)
	sllw	x
	sllw	x
	addw	x, (0x07, sp)
	sllw	x
	jra	00109$
00108$:
;	./adc.c: 126: val = (rightBound * 10) - ( (val - rawAdc[rightBound]) * 10)
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
;	./adc.c: 127: / (rawAdc[leftBound] - rawAdc[rightBound]);
	ldw	y, (0x03, sp)
	subw	y, (0x05, sp)
	divw	x, y
	ldw	(0x05, sp), x
	ldw	x, (0x07, sp)
	subw	x, (0x05, sp)
	ldw	(0x07, sp), x
00109$:
;	./adc.c: 131: return ADC_RAW_TABLE_BASE_TEMP + val + getParamById (PARAM_TEMPERATURE_CORRECTION);
	addw	x, #0xfdf8
	ldw	(0x07, sp), x
	push	#0x04
	call	_getParamById
	pop	a
	addw	x, (0x07, sp)
;	./adc.c: 132: }
	addw	sp, #8
	ret
;	./adc.c: 138: void ADC1_EOC_handler() __interrupt (22)
;	-----------------------------------------
;	 function ADC1_EOC_handler
;	-----------------------------------------
_ADC1_EOC_handler:
	clr	a
	div	x, a
	sub	sp, #12
;	./adc.c: 140: result = ADC_DRH << 2;
	ld	a, 0x5404
	clrw	x
	ld	xl, a
	sllw	x
	sllw	x
	ldw	_result+0, x
;	./adc.c: 141: result |= ADC_DRL;
	ld	a, 0x5405
	clrw	x
	or	a, _result+1
	rlwa	x
	or	a, _result+0
	ld	xh, a
	ldw	_result+0, x
;	./adc.c: 142: ADC_CSR &= ~0x80;   // reset EOC
	bres	21504, #7
;	./adc.c: 145: if (averaged == 0) {
	ldw	x, _averaged+2
	jrne	00102$
	ldw	x, _averaged+0
	jrne	00102$
;	./adc.c: 146: averaged = result << ADC_AVERAGING_BITS;
	ldw	x, _result+0
	sllw	x
	sllw	x
	sllw	x
	sllw	x
	clrw	y
	ldw	_averaged+2, x
	ldw	_averaged+0, y
	jra	00104$
00102$:
;	./adc.c: 148: averaged += result - (averaged >> ADC_AVERAGING_BITS);
	ldw	x, _averaged+2
	ldw	(0x03, sp), x
	ldw	x, _averaged+0
	srlw	x
	rrc	(0x03, sp)
	rrc	(0x04, sp)
	srlw	x
	rrc	(0x03, sp)
	rrc	(0x04, sp)
	srlw	x
	rrc	(0x03, sp)
	rrc	(0x04, sp)
	srlw	x
	rrc	(0x03, sp)
	rrc	(0x04, sp)
	ldw	y, _result+0
	clr	a
	clr	(0x05, sp)
	subw	y, (0x03, sp)
	pushw	x
	sbc	a, (2, sp)
	popw	x
	ld	(0x0a, sp), a
	ld	a, (0x05, sp)
	pushw	x
	sbc	a, (1, sp)
	popw	x
	ld	(0x09, sp), a
	ld	a, _averaged+3
	pushw	y
	add	a, (2, sp)
	popw	y
	ld	xl, a
	ld	a, _averaged+2
	pushw	y
	adc	a, (1, sp)
	popw	y
	ld	xh, a
	ldw	y, _averaged+0
	jrnc	00113$
	incw	y
00113$:
	addw	y, (0x09, sp)
	ldw	_averaged+2, x
	ldw	_averaged+0, y
00104$:
;	./adc.c: 150: }
	addw	sp, #12
	iret
	.area CODE
	.area CONST
_rawAdc:
	.dw #0x03ce
	.dw #0x03cb
	.dw #0x03c7
	.dw #0x03c4
	.dw #0x03c0
	.dw #0x03bc
	.dw #0x03b9
	.dw #0x03b4
	.dw #0x03b0
	.dw #0x03ac
	.dw #0x03a7
	.dw #0x03a2
	.dw #0x039d
	.dw #0x0398
	.dw #0x0392
	.dw #0x038d
	.dw #0x0387
	.dw #0x0381
	.dw #0x037b
	.dw #0x0374
	.dw #0x036d
	.dw #0x0367
	.dw #0x0360
	.dw #0x0358
	.dw #0x0351
	.dw #0x0349
	.dw #0x0341
	.dw #0x0339
	.dw #0x0331
	.dw #0x0329
	.dw #0x0320
	.dw #0x0317
	.dw #0x030e
	.dw #0x0305
	.dw #0x02fc
	.dw #0x02f2
	.dw #0x02e9
	.dw #0x02df
	.dw #0x02d5
	.dw #0x02cb
	.dw #0x02c1
	.dw #0x02b7
	.dw #0x02ad
	.dw #0x02a3
	.dw #0x0298
	.dw #0x028e
	.dw #0x0284
	.dw #0x0279
	.dw #0x026f
	.dw #0x0264
	.dw #0x0259
	.dw #0x024f
	.dw #0x0244
	.dw #0x023a
	.dw #0x022f
	.dw #0x0225
	.dw #0x021a
	.dw #0x0210
	.dw #0x0206
	.dw #0x01fb
	.dw #0x01f1
	.dw #0x01e7
	.dw #0x01dd
	.dw #0x01d3
	.dw #0x01c9
	.dw #0x01c0
	.dw #0x01b6
	.dw #0x01ad
	.dw #0x01a3
	.dw #0x019a
	.dw #0x0191
	.dw #0x0188
	.dw #0x017f
	.dw #0x0177
	.dw #0x016e
	.dw #0x0166
	.dw #0x015d
	.dw #0x0155
	.dw #0x014d
	.dw #0x0146
	.dw #0x013e
	.dw #0x0136
	.dw #0x012f
	.dw #0x0128
	.dw #0x0121
	.dw #0x011a
	.dw #0x0113
	.dw #0x010d
	.dw #0x0106
	.dw #0x0100
	.dw #0x00fa
	.dw #0x00f4
	.dw #0x00ee
	.dw #0x00e8
	.dw #0x00e2
	.dw #0x00dd
	.dw #0x00d7
	.dw #0x00d2
	.dw #0x00cd
	.dw #0x00c8
	.dw #0x00c3
	.dw #0x00bf
	.dw #0x00ba
	.dw #0x00b5
	.dw #0x00b1
	.dw #0x00ad
	.dw #0x00a9
	.dw #0x00a5
	.dw #0x00a1
	.dw #0x009d
	.dw #0x0099
	.dw #0x0095
	.dw #0x0092
	.dw #0x008e
	.dw #0x008b
	.dw #0x0088
	.dw #0x0084
	.dw #0x0081
	.dw #0x007e
	.dw #0x007b
	.dw #0x0078
	.dw #0x0075
	.dw #0x0073
	.dw #0x0070
	.dw #0x006d
	.dw #0x006b
	.dw #0x0068
	.dw #0x0066
	.dw #0x0064
	.dw #0x0061
	.dw #0x005f
	.dw #0x005d
	.dw #0x005b
	.dw #0x0059
	.dw #0x0057
	.dw #0x0055
	.dw #0x0053
	.dw #0x0051
	.dw #0x004f
	.dw #0x004e
	.dw #0x004c
	.dw #0x004a
	.dw #0x0049
	.dw #0x0047
	.dw #0x0045
	.dw #0x0044
	.dw #0x0043
	.dw #0x0041
	.dw #0x0040
	.dw #0x003e
	.dw #0x003d
	.dw #0x003c
	.dw #0x003a
	.dw #0x0039
	.dw #0x0038
	.dw #0x0037
	.dw #0x0036
	.dw #0x0035
	.dw #0x0034
	.dw #0x0033
	.dw #0x0031
	.dw #0x0030
	.dw #0x002f
	.dw #0x002f
	.dw #0x002e
	.area INITIALIZER
	.area CABS (ABS)

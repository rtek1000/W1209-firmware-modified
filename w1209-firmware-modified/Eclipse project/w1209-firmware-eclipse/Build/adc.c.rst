                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module adc
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _rawAdc
                                     12 	.globl _getParamById
                                     13 	.globl _initADC
                                     14 	.globl _startADC
                                     15 	.globl _getAdcResult
                                     16 	.globl _getAdcAveraged
                                     17 	.globl _getTemperature
                                     18 	.globl _ADC1_EOC_handler
                                     19 ;--------------------------------------------------------
                                     20 ; ram data
                                     21 ;--------------------------------------------------------
                                     22 	.area DATA
      00001E                         23 _result:
      00001E                         24 	.ds 2
      000020                         25 _averaged:
      000020                         26 	.ds 4
                                     27 ;--------------------------------------------------------
                                     28 ; ram data
                                     29 ;--------------------------------------------------------
                                     30 	.area INITIALIZED
                                     31 ;--------------------------------------------------------
                                     32 ; absolute external ram data
                                     33 ;--------------------------------------------------------
                                     34 	.area DABS (ABS)
                                     35 
                                     36 ; default segment ordering for linker
                                     37 	.area HOME
                                     38 	.area GSINIT
                                     39 	.area GSFINAL
                                     40 	.area CONST
                                     41 	.area INITIALIZER
                                     42 	.area CODE
                                     43 
                                     44 ;--------------------------------------------------------
                                     45 ; global & static initialisations
                                     46 ;--------------------------------------------------------
                                     47 	.area HOME
                                     48 	.area GSINIT
                                     49 	.area GSFINAL
                                     50 	.area GSINIT
                                     51 ;--------------------------------------------------------
                                     52 ; Home
                                     53 ;--------------------------------------------------------
                                     54 	.area HOME
                                     55 	.area HOME
                                     56 ;--------------------------------------------------------
                                     57 ; code
                                     58 ;--------------------------------------------------------
                                     59 	.area CODE
                                     60 ;	./adc.c: 63: void initADC()
                                     61 ;	-----------------------------------------
                                     62 ;	 function initADC
                                     63 ;	-----------------------------------------
      008ABC                         64 _initADC:
                                     65 ;	./adc.c: 65: ADC_CR1 |= 0x70;    // Prescaler f/18 (SPSEL)
      008ABC C6 54 01         [ 1]   66 	ld	a, 0x5401
      008ABF AA 70            [ 1]   67 	or	a, #0x70
      008AC1 C7 54 01         [ 1]   68 	ld	0x5401, a
                                     69 ;	./adc.c: 66: ADC_CSR |= 0x06;    // select AIN6
      008AC4 C6 54 00         [ 1]   70 	ld	a, 0x5400
      008AC7 AA 06            [ 1]   71 	or	a, #0x06
                                     72 ;	./adc.c: 67: ADC_CSR |= 0x20;    // Interrupt enable (EOCIE)
      008AC9 C7 54 00         [ 1]   73 	ld	0x5400, a
      008ACC AA 20            [ 1]   74 	or	a, #0x20
      008ACE C7 54 00         [ 1]   75 	ld	0x5400, a
                                     76 ;	./adc.c: 68: ADC_CR1 |= 0x01;    // Power up ADC
      008AD1 72 10 54 01      [ 1]   77 	bset	21505, #0
                                     78 ;	./adc.c: 69: result = 0;
      008AD5 5F               [ 1]   79 	clrw	x
      008AD6 CF 00 1E         [ 2]   80 	ldw	_result+0, x
                                     81 ;	./adc.c: 70: averaged = 0;
      008AD9 5F               [ 1]   82 	clrw	x
      008ADA CF 00 22         [ 2]   83 	ldw	_averaged+2, x
      008ADD CF 00 20         [ 2]   84 	ldw	_averaged+0, x
                                     85 ;	./adc.c: 71: }
      008AE0 81               [ 4]   86 	ret
                                     87 ;	./adc.c: 76: void startADC()
                                     88 ;	-----------------------------------------
                                     89 ;	 function startADC
                                     90 ;	-----------------------------------------
      008AE1                         91 _startADC:
                                     92 ;	./adc.c: 78: ADC_CR1 |= 0x01;
      008AE1 72 10 54 01      [ 1]   93 	bset	21505, #0
                                     94 ;	./adc.c: 79: }
      008AE5 81               [ 4]   95 	ret
                                     96 ;	./adc.c: 85: unsigned int getAdcResult()
                                     97 ;	-----------------------------------------
                                     98 ;	 function getAdcResult
                                     99 ;	-----------------------------------------
      008AE6                        100 _getAdcResult:
                                    101 ;	./adc.c: 87: return result;
      008AE6 CE 00 1E         [ 2]  102 	ldw	x, _result+0
                                    103 ;	./adc.c: 88: }
      008AE9 81               [ 4]  104 	ret
                                    105 ;	./adc.c: 95: unsigned int getAdcAveraged()
                                    106 ;	-----------------------------------------
                                    107 ;	 function getAdcAveraged
                                    108 ;	-----------------------------------------
      008AEA                        109 _getAdcAveraged:
                                    110 ;	./adc.c: 97: return (unsigned int) (averaged >> ADC_AVERAGING_BITS);
      008AEA CE 00 22         [ 2]  111 	ldw	x, _averaged+2
      008AED 90 CE 00 20      [ 2]  112 	ldw	y, _averaged+0
      008AF1 90 54            [ 2]  113 	srlw	y
      008AF3 56               [ 2]  114 	rrcw	x
      008AF4 90 54            [ 2]  115 	srlw	y
      008AF6 56               [ 2]  116 	rrcw	x
      008AF7 90 54            [ 2]  117 	srlw	y
      008AF9 56               [ 2]  118 	rrcw	x
      008AFA 90 54            [ 2]  119 	srlw	y
      008AFC 56               [ 2]  120 	rrcw	x
                                    121 ;	./adc.c: 98: }
      008AFD 81               [ 4]  122 	ret
                                    123 ;	./adc.c: 105: int getTemperature()
                                    124 ;	-----------------------------------------
                                    125 ;	 function getTemperature
                                    126 ;	-----------------------------------------
      008AFE                        127 _getTemperature:
      008AFE 52 08            [ 2]  128 	sub	sp, #8
                                    129 ;	./adc.c: 107: unsigned int val = averaged >> ADC_AVERAGING_BITS;
      008B00 CE 00 22         [ 2]  130 	ldw	x, _averaged+2
      008B03 90 CE 00 20      [ 2]  131 	ldw	y, _averaged+0
      008B07 90 54            [ 2]  132 	srlw	y
      008B09 56               [ 2]  133 	rrcw	x
      008B0A 90 54            [ 2]  134 	srlw	y
      008B0C 56               [ 2]  135 	rrcw	x
      008B0D 90 54            [ 2]  136 	srlw	y
      008B0F 56               [ 2]  137 	rrcw	x
      008B10 90 54            [ 2]  138 	srlw	y
      008B12 56               [ 2]  139 	rrcw	x
      008B13 1F 01            [ 2]  140 	ldw	(0x01, sp), x
                                    141 ;	./adc.c: 108: unsigned char rightBound = ADC_RAW_TABLE_SIZE;
      008B15 A6 A5            [ 1]  142 	ld	a, #0xa5
      008B17 6B 03            [ 1]  143 	ld	(0x03, sp), a
                                    144 ;	./adc.c: 109: unsigned char leftBound = 0;
      008B19 0F 04            [ 1]  145 	clr	(0x04, sp)
                                    146 ;	./adc.c: 112: while ( (rightBound - leftBound) > 1) {
      008B1B                        147 00104$:
      008B1B 7B 03            [ 1]  148 	ld	a, (0x03, sp)
      008B1D 6B 06            [ 1]  149 	ld	(0x06, sp), a
      008B1F 0F 05            [ 1]  150 	clr	(0x05, sp)
      008B21 7B 04            [ 1]  151 	ld	a, (0x04, sp)
      008B23 6B 08            [ 1]  152 	ld	(0x08, sp), a
      008B25 0F 07            [ 1]  153 	clr	(0x07, sp)
      008B27 1E 05            [ 2]  154 	ldw	x, (0x05, sp)
      008B29 72 F0 07         [ 2]  155 	subw	x, (0x07, sp)
      008B2C A3 00 01         [ 2]  156 	cpw	x, #0x0001
      008B2F 2D 23            [ 1]  157 	jrsle	00106$
                                    158 ;	./adc.c: 113: unsigned char midId = (leftBound + rightBound) >> 1;
      008B31 1E 07            [ 2]  159 	ldw	x, (0x07, sp)
      008B33 72 FB 05         [ 2]  160 	addw	x, (0x05, sp)
      008B36 57               [ 2]  161 	sraw	x
      008B37 41               [ 1]  162 	exg	a, xl
      008B38 6B 08            [ 1]  163 	ld	(0x08, sp), a
      008B3A 41               [ 1]  164 	exg	a, xl
                                    165 ;	./adc.c: 115: if (val > rawAdc[midId]) {
      008B3B 7B 08            [ 1]  166 	ld	a, (0x08, sp)
      008B3D 5F               [ 1]  167 	clrw	x
      008B3E 97               [ 1]  168 	ld	xl, a
      008B3F 58               [ 2]  169 	sllw	x
      008B40 1C 80 AA         [ 2]  170 	addw	x, #(_rawAdc + 0)
      008B43 FE               [ 2]  171 	ldw	x, (x)
      008B44 13 01            [ 2]  172 	cpw	x, (0x01, sp)
      008B46 24 06            [ 1]  173 	jrnc	00102$
                                    174 ;	./adc.c: 116: rightBound = midId;
      008B48 7B 08            [ 1]  175 	ld	a, (0x08, sp)
      008B4A 6B 03            [ 1]  176 	ld	(0x03, sp), a
      008B4C 20 CD            [ 2]  177 	jra	00104$
      008B4E                        178 00102$:
                                    179 ;	./adc.c: 118: leftBound = midId;
      008B4E 7B 08            [ 1]  180 	ld	a, (0x08, sp)
      008B50 6B 04            [ 1]  181 	ld	(0x04, sp), a
      008B52 20 C7            [ 2]  182 	jra	00104$
      008B54                        183 00106$:
                                    184 ;	./adc.c: 123: if (val >= rawAdc[leftBound]) {
      008B54 1E 07            [ 2]  185 	ldw	x, (0x07, sp)
      008B56 58               [ 2]  186 	sllw	x
      008B57 1C 80 AA         [ 2]  187 	addw	x, #(_rawAdc + 0)
      008B5A FE               [ 2]  188 	ldw	x, (x)
      008B5B 1F 03            [ 2]  189 	ldw	(0x03, sp), x
      008B5D 1E 01            [ 2]  190 	ldw	x, (0x01, sp)
      008B5F 13 03            [ 2]  191 	cpw	x, (0x03, sp)
      008B61 25 0A            [ 1]  192 	jrc	00108$
                                    193 ;	./adc.c: 124: val = leftBound * 10;
      008B63 1E 07            [ 2]  194 	ldw	x, (0x07, sp)
      008B65 58               [ 2]  195 	sllw	x
      008B66 58               [ 2]  196 	sllw	x
      008B67 72 FB 07         [ 2]  197 	addw	x, (0x07, sp)
      008B6A 58               [ 2]  198 	sllw	x
      008B6B 20 30            [ 2]  199 	jra	00109$
      008B6D                        200 00108$:
                                    201 ;	./adc.c: 126: val = (rightBound * 10) - ( (val - rawAdc[rightBound]) * 10)
      008B6D 1E 05            [ 2]  202 	ldw	x, (0x05, sp)
      008B6F 58               [ 2]  203 	sllw	x
      008B70 58               [ 2]  204 	sllw	x
      008B71 72 FB 05         [ 2]  205 	addw	x, (0x05, sp)
      008B74 58               [ 2]  206 	sllw	x
      008B75 1F 07            [ 2]  207 	ldw	(0x07, sp), x
      008B77 1E 05            [ 2]  208 	ldw	x, (0x05, sp)
      008B79 58               [ 2]  209 	sllw	x
      008B7A 1C 80 AA         [ 2]  210 	addw	x, #(_rawAdc + 0)
      008B7D FE               [ 2]  211 	ldw	x, (x)
      008B7E 1F 05            [ 2]  212 	ldw	(0x05, sp), x
      008B80 1E 01            [ 2]  213 	ldw	x, (0x01, sp)
      008B82 72 F0 05         [ 2]  214 	subw	x, (0x05, sp)
      008B85 89               [ 2]  215 	pushw	x
      008B86 58               [ 2]  216 	sllw	x
      008B87 58               [ 2]  217 	sllw	x
      008B88 72 FB 01         [ 2]  218 	addw	x, (1, sp)
      008B8B 58               [ 2]  219 	sllw	x
      008B8C 5B 02            [ 2]  220 	addw	sp, #2
                                    221 ;	./adc.c: 127: / (rawAdc[leftBound] - rawAdc[rightBound]);
      008B8E 16 03            [ 2]  222 	ldw	y, (0x03, sp)
      008B90 72 F2 05         [ 2]  223 	subw	y, (0x05, sp)
      008B93 65               [ 2]  224 	divw	x, y
      008B94 1F 05            [ 2]  225 	ldw	(0x05, sp), x
      008B96 1E 07            [ 2]  226 	ldw	x, (0x07, sp)
      008B98 72 F0 05         [ 2]  227 	subw	x, (0x05, sp)
      008B9B 1F 07            [ 2]  228 	ldw	(0x07, sp), x
      008B9D                        229 00109$:
                                    230 ;	./adc.c: 131: return ADC_RAW_TABLE_BASE_TEMP + val + getParamById (PARAM_TEMPERATURE_CORRECTION);
      008B9D 1C FD F8         [ 2]  231 	addw	x, #0xfdf8
      008BA0 1F 07            [ 2]  232 	ldw	(0x07, sp), x
      008BA2 4B 04            [ 1]  233 	push	#0x04
      008BA4 CD 8F 8F         [ 4]  234 	call	_getParamById
      008BA7 84               [ 1]  235 	pop	a
      008BA8 72 FB 07         [ 2]  236 	addw	x, (0x07, sp)
                                    237 ;	./adc.c: 132: }
      008BAB 5B 08            [ 2]  238 	addw	sp, #8
      008BAD 81               [ 4]  239 	ret
                                    240 ;	./adc.c: 138: void ADC1_EOC_handler() __interrupt (22)
                                    241 ;	-----------------------------------------
                                    242 ;	 function ADC1_EOC_handler
                                    243 ;	-----------------------------------------
      008BAE                        244 _ADC1_EOC_handler:
      008BAE 4F               [ 1]  245 	clr	a
      008BAF 62               [ 2]  246 	div	x, a
      008BB0 52 0C            [ 2]  247 	sub	sp, #12
                                    248 ;	./adc.c: 140: result = ADC_DRH << 2;
      008BB2 C6 54 04         [ 1]  249 	ld	a, 0x5404
      008BB5 5F               [ 1]  250 	clrw	x
      008BB6 97               [ 1]  251 	ld	xl, a
      008BB7 58               [ 2]  252 	sllw	x
      008BB8 58               [ 2]  253 	sllw	x
      008BB9 CF 00 1E         [ 2]  254 	ldw	_result+0, x
                                    255 ;	./adc.c: 141: result |= ADC_DRL;
      008BBC C6 54 05         [ 1]  256 	ld	a, 0x5405
      008BBF 5F               [ 1]  257 	clrw	x
      008BC0 CA 00 1F         [ 1]  258 	or	a, _result+1
      008BC3 02               [ 1]  259 	rlwa	x
      008BC4 CA 00 1E         [ 1]  260 	or	a, _result+0
      008BC7 95               [ 1]  261 	ld	xh, a
      008BC8 CF 00 1E         [ 2]  262 	ldw	_result+0, x
                                    263 ;	./adc.c: 142: ADC_CSR &= ~0x80;   // reset EOC
      008BCB 72 1F 54 00      [ 1]  264 	bres	21504, #7
                                    265 ;	./adc.c: 145: if (averaged == 0) {
      008BCF CE 00 22         [ 2]  266 	ldw	x, _averaged+2
      008BD2 26 17            [ 1]  267 	jrne	00102$
      008BD4 CE 00 20         [ 2]  268 	ldw	x, _averaged+0
      008BD7 26 12            [ 1]  269 	jrne	00102$
                                    270 ;	./adc.c: 146: averaged = result << ADC_AVERAGING_BITS;
      008BD9 CE 00 1E         [ 2]  271 	ldw	x, _result+0
      008BDC 58               [ 2]  272 	sllw	x
      008BDD 58               [ 2]  273 	sllw	x
      008BDE 58               [ 2]  274 	sllw	x
      008BDF 58               [ 2]  275 	sllw	x
      008BE0 90 5F            [ 1]  276 	clrw	y
      008BE2 CF 00 22         [ 2]  277 	ldw	_averaged+2, x
      008BE5 90 CF 00 20      [ 2]  278 	ldw	_averaged+0, y
      008BE9 20 5A            [ 2]  279 	jra	00104$
      008BEB                        280 00102$:
                                    281 ;	./adc.c: 148: averaged += result - (averaged >> ADC_AVERAGING_BITS);
      008BEB CE 00 22         [ 2]  282 	ldw	x, _averaged+2
      008BEE 1F 03            [ 2]  283 	ldw	(0x03, sp), x
      008BF0 CE 00 20         [ 2]  284 	ldw	x, _averaged+0
      008BF3 54               [ 2]  285 	srlw	x
      008BF4 06 03            [ 1]  286 	rrc	(0x03, sp)
      008BF6 06 04            [ 1]  287 	rrc	(0x04, sp)
      008BF8 54               [ 2]  288 	srlw	x
      008BF9 06 03            [ 1]  289 	rrc	(0x03, sp)
      008BFB 06 04            [ 1]  290 	rrc	(0x04, sp)
      008BFD 54               [ 2]  291 	srlw	x
      008BFE 06 03            [ 1]  292 	rrc	(0x03, sp)
      008C00 06 04            [ 1]  293 	rrc	(0x04, sp)
      008C02 54               [ 2]  294 	srlw	x
      008C03 06 03            [ 1]  295 	rrc	(0x03, sp)
      008C05 06 04            [ 1]  296 	rrc	(0x04, sp)
      008C07 90 CE 00 1E      [ 2]  297 	ldw	y, _result+0
      008C0B 4F               [ 1]  298 	clr	a
      008C0C 0F 05            [ 1]  299 	clr	(0x05, sp)
      008C0E 72 F2 03         [ 2]  300 	subw	y, (0x03, sp)
      008C11 89               [ 2]  301 	pushw	x
      008C12 12 02            [ 1]  302 	sbc	a, (2, sp)
      008C14 85               [ 2]  303 	popw	x
      008C15 6B 0A            [ 1]  304 	ld	(0x0a, sp), a
      008C17 7B 05            [ 1]  305 	ld	a, (0x05, sp)
      008C19 89               [ 2]  306 	pushw	x
      008C1A 12 01            [ 1]  307 	sbc	a, (1, sp)
      008C1C 85               [ 2]  308 	popw	x
      008C1D 6B 09            [ 1]  309 	ld	(0x09, sp), a
      008C1F C6 00 23         [ 1]  310 	ld	a, _averaged+3
      008C22 90 89            [ 2]  311 	pushw	y
      008C24 1B 02            [ 1]  312 	add	a, (2, sp)
      008C26 90 85            [ 2]  313 	popw	y
      008C28 97               [ 1]  314 	ld	xl, a
      008C29 C6 00 22         [ 1]  315 	ld	a, _averaged+2
      008C2C 90 89            [ 2]  316 	pushw	y
      008C2E 19 01            [ 1]  317 	adc	a, (1, sp)
      008C30 90 85            [ 2]  318 	popw	y
      008C32 95               [ 1]  319 	ld	xh, a
      008C33 90 CE 00 20      [ 2]  320 	ldw	y, _averaged+0
      008C37 24 02            [ 1]  321 	jrnc	00113$
      008C39 90 5C            [ 1]  322 	incw	y
      008C3B                        323 00113$:
      008C3B 72 F9 09         [ 2]  324 	addw	y, (0x09, sp)
      008C3E CF 00 22         [ 2]  325 	ldw	_averaged+2, x
      008C41 90 CF 00 20      [ 2]  326 	ldw	_averaged+0, y
      008C45                        327 00104$:
                                    328 ;	./adc.c: 150: }
      008C45 5B 0C            [ 2]  329 	addw	sp, #12
      008C47 80               [11]  330 	iret
                                    331 	.area CODE
                                    332 	.area CONST
      0080AA                        333 _rawAdc:
      0080AA 03 CE                  334 	.dw #0x03ce
      0080AC 03 CB                  335 	.dw #0x03cb
      0080AE 03 C7                  336 	.dw #0x03c7
      0080B0 03 C4                  337 	.dw #0x03c4
      0080B2 03 C0                  338 	.dw #0x03c0
      0080B4 03 BC                  339 	.dw #0x03bc
      0080B6 03 B9                  340 	.dw #0x03b9
      0080B8 03 B4                  341 	.dw #0x03b4
      0080BA 03 B0                  342 	.dw #0x03b0
      0080BC 03 AC                  343 	.dw #0x03ac
      0080BE 03 A7                  344 	.dw #0x03a7
      0080C0 03 A2                  345 	.dw #0x03a2
      0080C2 03 9D                  346 	.dw #0x039d
      0080C4 03 98                  347 	.dw #0x0398
      0080C6 03 92                  348 	.dw #0x0392
      0080C8 03 8D                  349 	.dw #0x038d
      0080CA 03 87                  350 	.dw #0x0387
      0080CC 03 81                  351 	.dw #0x0381
      0080CE 03 7B                  352 	.dw #0x037b
      0080D0 03 74                  353 	.dw #0x0374
      0080D2 03 6D                  354 	.dw #0x036d
      0080D4 03 67                  355 	.dw #0x0367
      0080D6 03 60                  356 	.dw #0x0360
      0080D8 03 58                  357 	.dw #0x0358
      0080DA 03 51                  358 	.dw #0x0351
      0080DC 03 49                  359 	.dw #0x0349
      0080DE 03 41                  360 	.dw #0x0341
      0080E0 03 39                  361 	.dw #0x0339
      0080E2 03 31                  362 	.dw #0x0331
      0080E4 03 29                  363 	.dw #0x0329
      0080E6 03 20                  364 	.dw #0x0320
      0080E8 03 17                  365 	.dw #0x0317
      0080EA 03 0E                  366 	.dw #0x030e
      0080EC 03 05                  367 	.dw #0x0305
      0080EE 02 FC                  368 	.dw #0x02fc
      0080F0 02 F2                  369 	.dw #0x02f2
      0080F2 02 E9                  370 	.dw #0x02e9
      0080F4 02 DF                  371 	.dw #0x02df
      0080F6 02 D5                  372 	.dw #0x02d5
      0080F8 02 CB                  373 	.dw #0x02cb
      0080FA 02 C1                  374 	.dw #0x02c1
      0080FC 02 B7                  375 	.dw #0x02b7
      0080FE 02 AD                  376 	.dw #0x02ad
      008100 02 A3                  377 	.dw #0x02a3
      008102 02 98                  378 	.dw #0x0298
      008104 02 8E                  379 	.dw #0x028e
      008106 02 84                  380 	.dw #0x0284
      008108 02 79                  381 	.dw #0x0279
      00810A 02 6F                  382 	.dw #0x026f
      00810C 02 64                  383 	.dw #0x0264
      00810E 02 59                  384 	.dw #0x0259
      008110 02 4F                  385 	.dw #0x024f
      008112 02 44                  386 	.dw #0x0244
      008114 02 3A                  387 	.dw #0x023a
      008116 02 2F                  388 	.dw #0x022f
      008118 02 25                  389 	.dw #0x0225
      00811A 02 1A                  390 	.dw #0x021a
      00811C 02 10                  391 	.dw #0x0210
      00811E 02 06                  392 	.dw #0x0206
      008120 01 FB                  393 	.dw #0x01fb
      008122 01 F1                  394 	.dw #0x01f1
      008124 01 E7                  395 	.dw #0x01e7
      008126 01 DD                  396 	.dw #0x01dd
      008128 01 D3                  397 	.dw #0x01d3
      00812A 01 C9                  398 	.dw #0x01c9
      00812C 01 C0                  399 	.dw #0x01c0
      00812E 01 B6                  400 	.dw #0x01b6
      008130 01 AD                  401 	.dw #0x01ad
      008132 01 A3                  402 	.dw #0x01a3
      008134 01 9A                  403 	.dw #0x019a
      008136 01 91                  404 	.dw #0x0191
      008138 01 88                  405 	.dw #0x0188
      00813A 01 7F                  406 	.dw #0x017f
      00813C 01 77                  407 	.dw #0x0177
      00813E 01 6E                  408 	.dw #0x016e
      008140 01 66                  409 	.dw #0x0166
      008142 01 5D                  410 	.dw #0x015d
      008144 01 55                  411 	.dw #0x0155
      008146 01 4D                  412 	.dw #0x014d
      008148 01 46                  413 	.dw #0x0146
      00814A 01 3E                  414 	.dw #0x013e
      00814C 01 36                  415 	.dw #0x0136
      00814E 01 2F                  416 	.dw #0x012f
      008150 01 28                  417 	.dw #0x0128
      008152 01 21                  418 	.dw #0x0121
      008154 01 1A                  419 	.dw #0x011a
      008156 01 13                  420 	.dw #0x0113
      008158 01 0D                  421 	.dw #0x010d
      00815A 01 06                  422 	.dw #0x0106
      00815C 01 00                  423 	.dw #0x0100
      00815E 00 FA                  424 	.dw #0x00fa
      008160 00 F4                  425 	.dw #0x00f4
      008162 00 EE                  426 	.dw #0x00ee
      008164 00 E8                  427 	.dw #0x00e8
      008166 00 E2                  428 	.dw #0x00e2
      008168 00 DD                  429 	.dw #0x00dd
      00816A 00 D7                  430 	.dw #0x00d7
      00816C 00 D2                  431 	.dw #0x00d2
      00816E 00 CD                  432 	.dw #0x00cd
      008170 00 C8                  433 	.dw #0x00c8
      008172 00 C3                  434 	.dw #0x00c3
      008174 00 BF                  435 	.dw #0x00bf
      008176 00 BA                  436 	.dw #0x00ba
      008178 00 B5                  437 	.dw #0x00b5
      00817A 00 B1                  438 	.dw #0x00b1
      00817C 00 AD                  439 	.dw #0x00ad
      00817E 00 A9                  440 	.dw #0x00a9
      008180 00 A5                  441 	.dw #0x00a5
      008182 00 A1                  442 	.dw #0x00a1
      008184 00 9D                  443 	.dw #0x009d
      008186 00 99                  444 	.dw #0x0099
      008188 00 95                  445 	.dw #0x0095
      00818A 00 92                  446 	.dw #0x0092
      00818C 00 8E                  447 	.dw #0x008e
      00818E 00 8B                  448 	.dw #0x008b
      008190 00 88                  449 	.dw #0x0088
      008192 00 84                  450 	.dw #0x0084
      008194 00 81                  451 	.dw #0x0081
      008196 00 7E                  452 	.dw #0x007e
      008198 00 7B                  453 	.dw #0x007b
      00819A 00 78                  454 	.dw #0x0078
      00819C 00 75                  455 	.dw #0x0075
      00819E 00 73                  456 	.dw #0x0073
      0081A0 00 70                  457 	.dw #0x0070
      0081A2 00 6D                  458 	.dw #0x006d
      0081A4 00 6B                  459 	.dw #0x006b
      0081A6 00 68                  460 	.dw #0x0068
      0081A8 00 66                  461 	.dw #0x0066
      0081AA 00 64                  462 	.dw #0x0064
      0081AC 00 61                  463 	.dw #0x0061
      0081AE 00 5F                  464 	.dw #0x005f
      0081B0 00 5D                  465 	.dw #0x005d
      0081B2 00 5B                  466 	.dw #0x005b
      0081B4 00 59                  467 	.dw #0x0059
      0081B6 00 57                  468 	.dw #0x0057
      0081B8 00 55                  469 	.dw #0x0055
      0081BA 00 53                  470 	.dw #0x0053
      0081BC 00 51                  471 	.dw #0x0051
      0081BE 00 4F                  472 	.dw #0x004f
      0081C0 00 4E                  473 	.dw #0x004e
      0081C2 00 4C                  474 	.dw #0x004c
      0081C4 00 4A                  475 	.dw #0x004a
      0081C6 00 49                  476 	.dw #0x0049
      0081C8 00 47                  477 	.dw #0x0047
      0081CA 00 45                  478 	.dw #0x0045
      0081CC 00 44                  479 	.dw #0x0044
      0081CE 00 43                  480 	.dw #0x0043
      0081D0 00 41                  481 	.dw #0x0041
      0081D2 00 40                  482 	.dw #0x0040
      0081D4 00 3E                  483 	.dw #0x003e
      0081D6 00 3D                  484 	.dw #0x003d
      0081D8 00 3C                  485 	.dw #0x003c
      0081DA 00 3A                  486 	.dw #0x003a
      0081DC 00 39                  487 	.dw #0x0039
      0081DE 00 38                  488 	.dw #0x0038
      0081E0 00 37                  489 	.dw #0x0037
      0081E2 00 36                  490 	.dw #0x0036
      0081E4 00 35                  491 	.dw #0x0035
      0081E6 00 34                  492 	.dw #0x0034
      0081E8 00 33                  493 	.dw #0x0033
      0081EA 00 31                  494 	.dw #0x0031
      0081EC 00 30                  495 	.dw #0x0030
      0081EE 00 2F                  496 	.dw #0x002f
      0081F0 00 2F                  497 	.dw #0x002f
      0081F2 00 2E                  498 	.dw #0x002e
                                    499 	.area INITIALIZER
                                    500 	.area CABS (ABS)

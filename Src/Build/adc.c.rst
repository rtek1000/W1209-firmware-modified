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
                                     19 	.globl _getSensorFail
                                     20 ;--------------------------------------------------------
                                     21 ; ram data
                                     22 ;--------------------------------------------------------
                                     23 	.area DATA
      00001E                         24 _result:
      00001E                         25 	.ds 2
      000020                         26 _result_fail:
      000020                         27 	.ds 4
      000024                         28 _averaged:
      000024                         29 	.ds 4
                                     30 ;--------------------------------------------------------
                                     31 ; ram data
                                     32 ;--------------------------------------------------------
                                     33 	.area INITIALIZED
                                     34 ;--------------------------------------------------------
                                     35 ; absolute external ram data
                                     36 ;--------------------------------------------------------
                                     37 	.area DABS (ABS)
                                     38 
                                     39 ; default segment ordering for linker
                                     40 	.area HOME
                                     41 	.area GSINIT
                                     42 	.area GSFINAL
                                     43 	.area CONST
                                     44 	.area INITIALIZER
                                     45 	.area CODE
                                     46 
                                     47 ;--------------------------------------------------------
                                     48 ; global & static initialisations
                                     49 ;--------------------------------------------------------
                                     50 	.area HOME
                                     51 	.area GSINIT
                                     52 	.area GSFINAL
                                     53 	.area GSINIT
                                     54 ;--------------------------------------------------------
                                     55 ; Home
                                     56 ;--------------------------------------------------------
                                     57 	.area HOME
                                     58 	.area HOME
                                     59 ;--------------------------------------------------------
                                     60 ; code
                                     61 ;--------------------------------------------------------
                                     62 	.area CODE
                                     63 ;	./adc.c: 174: void initADC()
                                     64 ;	-----------------------------------------
                                     65 ;	 function initADC
                                     66 ;	-----------------------------------------
      008C8C                         67 _initADC:
                                     68 ;	./adc.c: 176: ADC_CR1 |= 0x70;    // Prescaler f/18 (SPSEL)
      008C8C C6 54 01         [ 1]   69 	ld	a, 0x5401
      008C8F AA 70            [ 1]   70 	or	a, #0x70
      008C91 C7 54 01         [ 1]   71 	ld	0x5401, a
                                     72 ;	./adc.c: 177: ADC_CSR |= 0x06;    // select AIN6
      008C94 C6 54 00         [ 1]   73 	ld	a, 0x5400
      008C97 AA 06            [ 1]   74 	or	a, #0x06
                                     75 ;	./adc.c: 178: ADC_CSR |= 0x20;    // Interrupt enable (EOCIE)
      008C99 C7 54 00         [ 1]   76 	ld	0x5400, a
      008C9C AA 20            [ 1]   77 	or	a, #0x20
      008C9E C7 54 00         [ 1]   78 	ld	0x5400, a
                                     79 ;	./adc.c: 179: ADC_CR1 |= 0x01;    // Power up ADC
      008CA1 72 10 54 01      [ 1]   80 	bset	21505, #0
                                     81 ;	./adc.c: 180: result = 0;
      008CA5 5F               [ 1]   82 	clrw	x
      008CA6 CF 00 1E         [ 2]   83 	ldw	_result+0, x
                                     84 ;	./adc.c: 181: averaged = 0;
      008CA9 5F               [ 1]   85 	clrw	x
      008CAA CF 00 26         [ 2]   86 	ldw	_averaged+2, x
      008CAD CF 00 24         [ 2]   87 	ldw	_averaged+0, x
                                     88 ;	./adc.c: 182: }
      008CB0 81               [ 4]   89 	ret
                                     90 ;	./adc.c: 187: void startADC()
                                     91 ;	-----------------------------------------
                                     92 ;	 function startADC
                                     93 ;	-----------------------------------------
      008CB1                         94 _startADC:
                                     95 ;	./adc.c: 189: ADC_CR1 |= 0x01;
      008CB1 72 10 54 01      [ 1]   96 	bset	21505, #0
                                     97 ;	./adc.c: 190: }
      008CB5 81               [ 4]   98 	ret
                                     99 ;	./adc.c: 196: unsigned int getAdcResult()
                                    100 ;	-----------------------------------------
                                    101 ;	 function getAdcResult
                                    102 ;	-----------------------------------------
      008CB6                        103 _getAdcResult:
                                    104 ;	./adc.c: 198: return result;
      008CB6 CE 00 1E         [ 2]  105 	ldw	x, _result+0
                                    106 ;	./adc.c: 199: }
      008CB9 81               [ 4]  107 	ret
                                    108 ;	./adc.c: 206: unsigned int getAdcAveraged()
                                    109 ;	-----------------------------------------
                                    110 ;	 function getAdcAveraged
                                    111 ;	-----------------------------------------
      008CBA                        112 _getAdcAveraged:
                                    113 ;	./adc.c: 208: return (unsigned int) (averaged >> ADC_AVERAGING_BITS);
      008CBA CE 00 26         [ 2]  114 	ldw	x, _averaged+2
      008CBD 90 CE 00 24      [ 2]  115 	ldw	y, _averaged+0
      008CC1 90 54            [ 2]  116 	srlw	y
      008CC3 56               [ 2]  117 	rrcw	x
      008CC4 90 54            [ 2]  118 	srlw	y
      008CC6 56               [ 2]  119 	rrcw	x
      008CC7 90 54            [ 2]  120 	srlw	y
      008CC9 56               [ 2]  121 	rrcw	x
      008CCA 90 54            [ 2]  122 	srlw	y
      008CCC 56               [ 2]  123 	rrcw	x
                                    124 ;	./adc.c: 209: }
      008CCD 81               [ 4]  125 	ret
                                    126 ;	./adc.c: 216: int getTemperature()
                                    127 ;	-----------------------------------------
                                    128 ;	 function getTemperature
                                    129 ;	-----------------------------------------
      008CCE                        130 _getTemperature:
      008CCE 52 08            [ 2]  131 	sub	sp, #8
                                    132 ;	./adc.c: 218: unsigned int val = averaged >> ADC_AVERAGING_BITS;
      008CD0 CE 00 26         [ 2]  133 	ldw	x, _averaged+2
      008CD3 90 CE 00 24      [ 2]  134 	ldw	y, _averaged+0
      008CD7 90 54            [ 2]  135 	srlw	y
      008CD9 56               [ 2]  136 	rrcw	x
      008CDA 90 54            [ 2]  137 	srlw	y
      008CDC 56               [ 2]  138 	rrcw	x
      008CDD 90 54            [ 2]  139 	srlw	y
      008CDF 56               [ 2]  140 	rrcw	x
      008CE0 90 54            [ 2]  141 	srlw	y
      008CE2 56               [ 2]  142 	rrcw	x
      008CE3 1F 01            [ 2]  143 	ldw	(0x01, sp), x
                                    144 ;	./adc.c: 219: unsigned char rightBound = ADC_RAW_TABLE_SIZE;
      008CE5 A6 A5            [ 1]  145 	ld	a, #0xa5
      008CE7 6B 03            [ 1]  146 	ld	(0x03, sp), a
                                    147 ;	./adc.c: 220: unsigned char leftBound = 0;
      008CE9 0F 04            [ 1]  148 	clr	(0x04, sp)
                                    149 ;	./adc.c: 223: while ( (rightBound - leftBound) > 1) {
      008CEB                        150 00104$:
      008CEB 7B 03            [ 1]  151 	ld	a, (0x03, sp)
      008CED 6B 06            [ 1]  152 	ld	(0x06, sp), a
      008CEF 0F 05            [ 1]  153 	clr	(0x05, sp)
      008CF1 7B 04            [ 1]  154 	ld	a, (0x04, sp)
      008CF3 6B 08            [ 1]  155 	ld	(0x08, sp), a
      008CF5 0F 07            [ 1]  156 	clr	(0x07, sp)
      008CF7 1E 05            [ 2]  157 	ldw	x, (0x05, sp)
      008CF9 72 F0 07         [ 2]  158 	subw	x, (0x07, sp)
      008CFC A3 00 01         [ 2]  159 	cpw	x, #0x0001
      008CFF 2D 23            [ 1]  160 	jrsle	00106$
                                    161 ;	./adc.c: 224: unsigned char midId = (leftBound + rightBound) >> 1;
      008D01 1E 07            [ 2]  162 	ldw	x, (0x07, sp)
      008D03 72 FB 05         [ 2]  163 	addw	x, (0x05, sp)
      008D06 57               [ 2]  164 	sraw	x
      008D07 41               [ 1]  165 	exg	a, xl
      008D08 6B 08            [ 1]  166 	ld	(0x08, sp), a
      008D0A 41               [ 1]  167 	exg	a, xl
                                    168 ;	./adc.c: 226: if (val > rawAdc[midId]) {
      008D0B 7B 08            [ 1]  169 	ld	a, (0x08, sp)
      008D0D 5F               [ 1]  170 	clrw	x
      008D0E 97               [ 1]  171 	ld	xl, a
      008D0F 58               [ 2]  172 	sllw	x
      008D10 1C 80 BE         [ 2]  173 	addw	x, #(_rawAdc + 0)
      008D13 FE               [ 2]  174 	ldw	x, (x)
      008D14 13 01            [ 2]  175 	cpw	x, (0x01, sp)
      008D16 24 06            [ 1]  176 	jrnc	00102$
                                    177 ;	./adc.c: 227: rightBound = midId;
      008D18 7B 08            [ 1]  178 	ld	a, (0x08, sp)
      008D1A 6B 03            [ 1]  179 	ld	(0x03, sp), a
      008D1C 20 CD            [ 2]  180 	jra	00104$
      008D1E                        181 00102$:
                                    182 ;	./adc.c: 229: leftBound = midId;
      008D1E 7B 08            [ 1]  183 	ld	a, (0x08, sp)
      008D20 6B 04            [ 1]  184 	ld	(0x04, sp), a
      008D22 20 C7            [ 2]  185 	jra	00104$
      008D24                        186 00106$:
                                    187 ;	./adc.c: 234: if (val >= rawAdc[leftBound]) {
      008D24 1E 07            [ 2]  188 	ldw	x, (0x07, sp)
      008D26 58               [ 2]  189 	sllw	x
      008D27 1C 80 BE         [ 2]  190 	addw	x, #(_rawAdc + 0)
      008D2A FE               [ 2]  191 	ldw	x, (x)
      008D2B 1F 03            [ 2]  192 	ldw	(0x03, sp), x
      008D2D 1E 01            [ 2]  193 	ldw	x, (0x01, sp)
      008D2F 13 03            [ 2]  194 	cpw	x, (0x03, sp)
      008D31 25 0A            [ 1]  195 	jrc	00108$
                                    196 ;	./adc.c: 235: val = leftBound * 10;
      008D33 1E 07            [ 2]  197 	ldw	x, (0x07, sp)
      008D35 58               [ 2]  198 	sllw	x
      008D36 58               [ 2]  199 	sllw	x
      008D37 72 FB 07         [ 2]  200 	addw	x, (0x07, sp)
      008D3A 58               [ 2]  201 	sllw	x
      008D3B 20 30            [ 2]  202 	jra	00109$
      008D3D                        203 00108$:
                                    204 ;	./adc.c: 237: val = (rightBound * 10) - ( (val - rawAdc[rightBound]) * 10)
      008D3D 1E 05            [ 2]  205 	ldw	x, (0x05, sp)
      008D3F 58               [ 2]  206 	sllw	x
      008D40 58               [ 2]  207 	sllw	x
      008D41 72 FB 05         [ 2]  208 	addw	x, (0x05, sp)
      008D44 58               [ 2]  209 	sllw	x
      008D45 1F 07            [ 2]  210 	ldw	(0x07, sp), x
      008D47 1E 05            [ 2]  211 	ldw	x, (0x05, sp)
      008D49 58               [ 2]  212 	sllw	x
      008D4A 1C 80 BE         [ 2]  213 	addw	x, #(_rawAdc + 0)
      008D4D FE               [ 2]  214 	ldw	x, (x)
      008D4E 1F 05            [ 2]  215 	ldw	(0x05, sp), x
      008D50 1E 01            [ 2]  216 	ldw	x, (0x01, sp)
      008D52 72 F0 05         [ 2]  217 	subw	x, (0x05, sp)
      008D55 89               [ 2]  218 	pushw	x
      008D56 58               [ 2]  219 	sllw	x
      008D57 58               [ 2]  220 	sllw	x
      008D58 72 FB 01         [ 2]  221 	addw	x, (1, sp)
      008D5B 58               [ 2]  222 	sllw	x
      008D5C 5B 02            [ 2]  223 	addw	sp, #2
                                    224 ;	./adc.c: 238: / (rawAdc[leftBound] - rawAdc[rightBound]);
      008D5E 16 03            [ 2]  225 	ldw	y, (0x03, sp)
      008D60 72 F2 05         [ 2]  226 	subw	y, (0x05, sp)
      008D63 65               [ 2]  227 	divw	x, y
      008D64 1F 05            [ 2]  228 	ldw	(0x05, sp), x
      008D66 1E 07            [ 2]  229 	ldw	x, (0x07, sp)
      008D68 72 F0 05         [ 2]  230 	subw	x, (0x05, sp)
      008D6B 1F 07            [ 2]  231 	ldw	(0x07, sp), x
      008D6D                        232 00109$:
                                    233 ;	./adc.c: 242: return ADC_RAW_TABLE_BASE_TEMP + val + getParamById (PARAM_TEMPERATURE_CORRECTION);
      008D6D 1C FD F8         [ 2]  234 	addw	x, #0xfdf8
      008D70 1F 07            [ 2]  235 	ldw	(0x07, sp), x
      008D72 4B 04            [ 1]  236 	push	#0x04
      008D74 CD 93 E4         [ 4]  237 	call	_getParamById
      008D77 84               [ 1]  238 	pop	a
      008D78 72 FB 07         [ 2]  239 	addw	x, (0x07, sp)
                                    240 ;	./adc.c: 243: }
      008D7B 5B 08            [ 2]  241 	addw	sp, #8
      008D7D 81               [ 4]  242 	ret
                                    243 ;	./adc.c: 249: void ADC1_EOC_handler() __interrupt (22)
                                    244 ;	-----------------------------------------
                                    245 ;	 function ADC1_EOC_handler
                                    246 ;	-----------------------------------------
      008D7E                        247 _ADC1_EOC_handler:
      008D7E 4F               [ 1]  248 	clr	a
      008D7F 62               [ 2]  249 	div	x, a
      008D80 52 0C            [ 2]  250 	sub	sp, #12
                                    251 ;	./adc.c: 251: result = ADC_DRH << 2;
      008D82 C6 54 04         [ 1]  252 	ld	a, 0x5404
      008D85 5F               [ 1]  253 	clrw	x
      008D86 97               [ 1]  254 	ld	xl, a
      008D87 58               [ 2]  255 	sllw	x
      008D88 58               [ 2]  256 	sllw	x
      008D89 CF 00 1E         [ 2]  257 	ldw	_result+0, x
                                    258 ;	./adc.c: 252: result |= ADC_DRL;
      008D8C C6 54 05         [ 1]  259 	ld	a, 0x5405
      008D8F 5F               [ 1]  260 	clrw	x
      008D90 CA 00 1F         [ 1]  261 	or	a, _result+1
      008D93 02               [ 1]  262 	rlwa	x
      008D94 CA 00 1E         [ 1]  263 	or	a, _result+0
      008D97 95               [ 1]  264 	ld	xh, a
      008D98 CF 00 1E         [ 2]  265 	ldw	_result+0, x
                                    266 ;	./adc.c: 253: ADC_CSR &= ~0x80;   // reset EOC
      008D9B 72 1F 54 00      [ 1]  267 	bres	21504, #7
                                    268 ;	./adc.c: 259: averaged += result - (averaged >> ADC_AVERAGING_BITS);
      008D9F CE 00 1E         [ 2]  269 	ldw	x, _result+0
      008DA2 1F 03            [ 2]  270 	ldw	(0x03, sp), x
      008DA4 0F 02            [ 1]  271 	clr	(0x02, sp)
      008DA6 0F 01            [ 1]  272 	clr	(0x01, sp)
                                    273 ;	./adc.c: 256: if (averaged == 0) {
      008DA8 CE 00 26         [ 2]  274 	ldw	x, _averaged+2
      008DAB 26 17            [ 1]  275 	jrne	00102$
      008DAD CE 00 24         [ 2]  276 	ldw	x, _averaged+0
      008DB0 26 12            [ 1]  277 	jrne	00102$
                                    278 ;	./adc.c: 257: averaged = result << ADC_AVERAGING_BITS;
      008DB2 CE 00 1E         [ 2]  279 	ldw	x, _result+0
      008DB5 58               [ 2]  280 	sllw	x
      008DB6 58               [ 2]  281 	sllw	x
      008DB7 58               [ 2]  282 	sllw	x
      008DB8 58               [ 2]  283 	sllw	x
      008DB9 90 5F            [ 1]  284 	clrw	y
      008DBB CF 00 26         [ 2]  285 	ldw	_averaged+2, x
      008DBE 90 CF 00 24      [ 2]  286 	ldw	_averaged+0, y
      008DC2 20 5D            [ 2]  287 	jra	00103$
      008DC4                        288 00102$:
                                    289 ;	./adc.c: 259: averaged += result - (averaged >> ADC_AVERAGING_BITS);
      008DC4 CE 00 26         [ 2]  290 	ldw	x, _averaged+2
      008DC7 1F 0B            [ 2]  291 	ldw	(0x0b, sp), x
      008DC9 CE 00 24         [ 2]  292 	ldw	x, _averaged+0
      008DCC 1F 09            [ 2]  293 	ldw	(0x09, sp), x
      008DCE 04 09            [ 1]  294 	srl	(0x09, sp)
      008DD0 06 0A            [ 1]  295 	rrc	(0x0a, sp)
      008DD2 06 0B            [ 1]  296 	rrc	(0x0b, sp)
      008DD4 06 0C            [ 1]  297 	rrc	(0x0c, sp)
      008DD6 04 09            [ 1]  298 	srl	(0x09, sp)
      008DD8 06 0A            [ 1]  299 	rrc	(0x0a, sp)
      008DDA 06 0B            [ 1]  300 	rrc	(0x0b, sp)
      008DDC 06 0C            [ 1]  301 	rrc	(0x0c, sp)
      008DDE 04 09            [ 1]  302 	srl	(0x09, sp)
      008DE0 06 0A            [ 1]  303 	rrc	(0x0a, sp)
      008DE2 06 0B            [ 1]  304 	rrc	(0x0b, sp)
      008DE4 06 0C            [ 1]  305 	rrc	(0x0c, sp)
      008DE6 04 09            [ 1]  306 	srl	(0x09, sp)
      008DE8 06 0A            [ 1]  307 	rrc	(0x0a, sp)
      008DEA 06 0B            [ 1]  308 	rrc	(0x0b, sp)
      008DEC 06 0C            [ 1]  309 	rrc	(0x0c, sp)
      008DEE 1E 03            [ 2]  310 	ldw	x, (0x03, sp)
      008DF0 72 F0 0B         [ 2]  311 	subw	x, (0x0b, sp)
      008DF3 1F 07            [ 2]  312 	ldw	(0x07, sp), x
      008DF5 7B 02            [ 1]  313 	ld	a, (0x02, sp)
      008DF7 12 0A            [ 1]  314 	sbc	a, (0x0a, sp)
      008DF9 6B 06            [ 1]  315 	ld	(0x06, sp), a
      008DFB 7B 01            [ 1]  316 	ld	a, (0x01, sp)
      008DFD 12 09            [ 1]  317 	sbc	a, (0x09, sp)
      008DFF 6B 05            [ 1]  318 	ld	(0x05, sp), a
      008E01 CE 00 26         [ 2]  319 	ldw	x, _averaged+2
      008E04 72 FB 07         [ 2]  320 	addw	x, (0x07, sp)
      008E07 1F 0B            [ 2]  321 	ldw	(0x0b, sp), x
      008E09 C6 00 25         [ 1]  322 	ld	a, _averaged+1
      008E0C 19 06            [ 1]  323 	adc	a, (0x06, sp)
      008E0E 6B 0A            [ 1]  324 	ld	(0x0a, sp), a
      008E10 C6 00 24         [ 1]  325 	ld	a, _averaged+0
      008E13 19 05            [ 1]  326 	adc	a, (0x05, sp)
      008E15 6B 09            [ 1]  327 	ld	(0x09, sp), a
      008E17 1E 0B            [ 2]  328 	ldw	x, (0x0b, sp)
      008E19 CF 00 26         [ 2]  329 	ldw	_averaged+2, x
      008E1C 1E 09            [ 2]  330 	ldw	x, (0x09, sp)
      008E1E CF 00 24         [ 2]  331 	ldw	_averaged+0, x
      008E21                        332 00103$:
                                    333 ;	./adc.c: 263: if (result_fail == 0) {
      008E21 CE 00 22         [ 2]  334 	ldw	x, _result_fail+2
      008E24 26 14            [ 1]  335 	jrne	00105$
      008E26 CE 00 20         [ 2]  336 	ldw	x, _result_fail+0
      008E29 26 0F            [ 1]  337 	jrne	00105$
                                    338 ;	./adc.c: 264: result_fail = result << ADC_AVERAGING_FAIL_BITS;
      008E2B CE 00 1E         [ 2]  339 	ldw	x, _result+0
      008E2E 58               [ 2]  340 	sllw	x
      008E2F 90 5F            [ 1]  341 	clrw	y
      008E31 CF 00 22         [ 2]  342 	ldw	_result_fail+2, x
      008E34 90 CF 00 20      [ 2]  343 	ldw	_result_fail+0, y
      008E38 20 3B            [ 2]  344 	jra	00107$
      008E3A                        345 00105$:
                                    346 ;	./adc.c: 266: result_fail += result - (result_fail >> ADC_AVERAGING_FAIL_BITS);
      008E3A CE 00 22         [ 2]  347 	ldw	x, _result_fail+2
      008E3D 1F 07            [ 2]  348 	ldw	(0x07, sp), x
      008E3F CE 00 20         [ 2]  349 	ldw	x, _result_fail+0
      008E42 1F 05            [ 2]  350 	ldw	(0x05, sp), x
      008E44 04 05            [ 1]  351 	srl	(0x05, sp)
      008E46 06 06            [ 1]  352 	rrc	(0x06, sp)
      008E48 06 07            [ 1]  353 	rrc	(0x07, sp)
      008E4A 06 08            [ 1]  354 	rrc	(0x08, sp)
      008E4C 1E 03            [ 2]  355 	ldw	x, (0x03, sp)
      008E4E 72 F0 07         [ 2]  356 	subw	x, (0x07, sp)
      008E51 7B 02            [ 1]  357 	ld	a, (0x02, sp)
      008E53 12 06            [ 1]  358 	sbc	a, (0x06, sp)
      008E55 88               [ 1]  359 	push	a
      008E56 7B 02            [ 1]  360 	ld	a, (0x02, sp)
      008E58 12 06            [ 1]  361 	sbc	a, (0x06, sp)
      008E5A 6B 0A            [ 1]  362 	ld	(0x0a, sp), a
      008E5C 84               [ 1]  363 	pop	a
      008E5D 72 BB 00 22      [ 2]  364 	addw	x, _result_fail+2
      008E61 C9 00 21         [ 1]  365 	adc	a, _result_fail+1
      008E64 6B 06            [ 1]  366 	ld	(0x06, sp), a
      008E66 7B 09            [ 1]  367 	ld	a, (0x09, sp)
      008E68 C9 00 20         [ 1]  368 	adc	a, _result_fail+0
      008E6B 6B 05            [ 1]  369 	ld	(0x05, sp), a
      008E6D CF 00 22         [ 2]  370 	ldw	_result_fail+2, x
      008E70 1E 05            [ 2]  371 	ldw	x, (0x05, sp)
      008E72 CF 00 20         [ 2]  372 	ldw	_result_fail+0, x
      008E75                        373 00107$:
                                    374 ;	./adc.c: 268: }
      008E75 5B 0C            [ 2]  375 	addw	sp, #12
      008E77 80               [11]  376 	iret
                                    377 ;	./adc.c: 270: int getSensorFail()
                                    378 ;	-----------------------------------------
                                    379 ;	 function getSensorFail
                                    380 ;	-----------------------------------------
      008E78                        381 _getSensorFail:
      008E78 52 08            [ 2]  382 	sub	sp, #8
                                    383 ;	./adc.c: 272: if((result_fail >> ADC_AVERAGING_FAIL_BITS) > rawAdc[0]) {
      008E7A CE 00 22         [ 2]  384 	ldw	x, _result_fail+2
      008E7D 1F 03            [ 2]  385 	ldw	(0x03, sp), x
      008E7F CE 00 20         [ 2]  386 	ldw	x, _result_fail+0
      008E82 1F 01            [ 2]  387 	ldw	(0x01, sp), x
      008E84 04 01            [ 1]  388 	srl	(0x01, sp)
      008E86 06 02            [ 1]  389 	rrc	(0x02, sp)
      008E88 06 03            [ 1]  390 	rrc	(0x03, sp)
      008E8A 06 04            [ 1]  391 	rrc	(0x04, sp)
      008E8C CE 80 BE         [ 2]  392 	ldw	x, _rawAdc+0
      008E8F 90 5F            [ 1]  393 	clrw	y
      008E91 13 03            [ 2]  394 	cpw	x, (0x03, sp)
      008E93 90 9F            [ 1]  395 	ld	a, yl
      008E95 12 02            [ 1]  396 	sbc	a, (0x02, sp)
      008E97 90 9E            [ 1]  397 	ld	a, yh
      008E99 12 01            [ 1]  398 	sbc	a, (0x01, sp)
      008E9B 24 05            [ 1]  399 	jrnc	00105$
                                    400 ;	./adc.c: 273: return 2;
      008E9D AE 00 02         [ 2]  401 	ldw	x, #0x0002
      008EA0 20 1B            [ 2]  402 	jra	00107$
      008EA2                        403 00105$:
                                    404 ;	./adc.c: 274: } else if((result_fail >> ADC_AVERAGING_FAIL_BITS) < rawAdc[ADC_RAW_TABLE_SIZE - 1]) {
      008EA2 CE 82 06         [ 2]  405 	ldw	x, _rawAdc+328
      008EA5 1F 07            [ 2]  406 	ldw	(0x07, sp), x
      008EA7 0F 06            [ 1]  407 	clr	(0x06, sp)
      008EA9 0F 05            [ 1]  408 	clr	(0x05, sp)
      008EAB 1E 03            [ 2]  409 	ldw	x, (0x03, sp)
      008EAD 13 07            [ 2]  410 	cpw	x, (0x07, sp)
      008EAF 7B 02            [ 1]  411 	ld	a, (0x02, sp)
      008EB1 12 06            [ 1]  412 	sbc	a, (0x06, sp)
      008EB3 7B 01            [ 1]  413 	ld	a, (0x01, sp)
      008EB5 12 05            [ 1]  414 	sbc	a, (0x05, sp)
      008EB7 24 03            [ 1]  415 	jrnc	00102$
                                    416 ;	./adc.c: 275: return 1;
      008EB9 5F               [ 1]  417 	clrw	x
      008EBA 5C               [ 1]  418 	incw	x
                                    419 ;	./adc.c: 277: return 0;
      008EBB 21                     420 	.byte 0x21
      008EBC                        421 00102$:
      008EBC 5F               [ 1]  422 	clrw	x
      008EBD                        423 00107$:
                                    424 ;	./adc.c: 279: }
      008EBD 5B 08            [ 2]  425 	addw	sp, #8
      008EBF 81               [ 4]  426 	ret
                                    427 	.area CODE
                                    428 	.area CONST
      0080BE                        429 _rawAdc:
      0080BE 03 FB                  430 	.dw #0x03fb
      0080C0 03 FA                  431 	.dw #0x03fa
      0080C2 03 FA                  432 	.dw #0x03fa
      0080C4 03 F9                  433 	.dw #0x03f9
      0080C6 03 F9                  434 	.dw #0x03f9
      0080C8 03 F8                  435 	.dw #0x03f8
      0080CA 03 F8                  436 	.dw #0x03f8
      0080CC 03 F7                  437 	.dw #0x03f7
      0080CE 03 F6                  438 	.dw #0x03f6
      0080D0 03 F6                  439 	.dw #0x03f6
      0080D2 03 F5                  440 	.dw #0x03f5
      0080D4 03 F4                  441 	.dw #0x03f4
      0080D6 03 F3                  442 	.dw #0x03f3
      0080D8 03 F2                  443 	.dw #0x03f2
      0080DA 03 F1                  444 	.dw #0x03f1
      0080DC 03 F0                  445 	.dw #0x03f0
      0080DE 03 EF                  446 	.dw #0x03ef
      0080E0 03 EE                  447 	.dw #0x03ee
      0080E2 03 EC                  448 	.dw #0x03ec
      0080E4 03 EB                  449 	.dw #0x03eb
      0080E6 03 EA                  450 	.dw #0x03ea
      0080E8 03 E8                  451 	.dw #0x03e8
      0080EA 03 E7                  452 	.dw #0x03e7
      0080EC 03 E5                  453 	.dw #0x03e5
      0080EE 03 E3                  454 	.dw #0x03e3
      0080F0 03 E1                  455 	.dw #0x03e1
      0080F2 03 DF                  456 	.dw #0x03df
      0080F4 03 DD                  457 	.dw #0x03dd
      0080F6 03 DB                  458 	.dw #0x03db
      0080F8 03 D8                  459 	.dw #0x03d8
      0080FA 03 D6                  460 	.dw #0x03d6
      0080FC 03 D3                  461 	.dw #0x03d3
      0080FE 03 D1                  462 	.dw #0x03d1
      008100 03 CE                  463 	.dw #0x03ce
      008102 03 CB                  464 	.dw #0x03cb
      008104 03 C8                  465 	.dw #0x03c8
      008106 03 C5                  466 	.dw #0x03c5
      008108 03 C1                  467 	.dw #0x03c1
      00810A 03 BD                  468 	.dw #0x03bd
      00810C 03 BA                  469 	.dw #0x03ba
      00810E 03 B6                  470 	.dw #0x03b6
      008110 03 B2                  471 	.dw #0x03b2
      008112 03 AE                  472 	.dw #0x03ae
      008114 03 A9                  473 	.dw #0x03a9
      008116 03 A5                  474 	.dw #0x03a5
      008118 03 A0                  475 	.dw #0x03a0
      00811A 03 9B                  476 	.dw #0x039b
      00811C 03 96                  477 	.dw #0x0396
      00811E 03 90                  478 	.dw #0x0390
      008120 03 8B                  479 	.dw #0x038b
      008122 03 85                  480 	.dw #0x0385
      008124 03 7F                  481 	.dw #0x037f
      008126 03 79                  482 	.dw #0x0379
      008128 03 73                  483 	.dw #0x0373
      00812A 03 6C                  484 	.dw #0x036c
      00812C 03 66                  485 	.dw #0x0366
      00812E 03 5F                  486 	.dw #0x035f
      008130 03 58                  487 	.dw #0x0358
      008132 03 50                  488 	.dw #0x0350
      008134 03 49                  489 	.dw #0x0349
      008136 03 41                  490 	.dw #0x0341
      008138 03 39                  491 	.dw #0x0339
      00813A 03 31                  492 	.dw #0x0331
      00813C 03 29                  493 	.dw #0x0329
      00813E 03 21                  494 	.dw #0x0321
      008140 03 18                  495 	.dw #0x0318
      008142 03 0F                  496 	.dw #0x030f
      008144 03 07                  497 	.dw #0x0307
      008146 02 FE                  498 	.dw #0x02fe
      008148 02 F4                  499 	.dw #0x02f4
      00814A 02 EB                  500 	.dw #0x02eb
      00814C 02 E1                  501 	.dw #0x02e1
      00814E 02 D8                  502 	.dw #0x02d8
      008150 02 CE                  503 	.dw #0x02ce
      008152 02 C4                  504 	.dw #0x02c4
      008154 02 BA                  505 	.dw #0x02ba
      008156 02 B0                  506 	.dw #0x02b0
      008158 02 A6                  507 	.dw #0x02a6
      00815A 02 9C                  508 	.dw #0x029c
      00815C 02 92                  509 	.dw #0x0292
      00815E 02 87                  510 	.dw #0x0287
      008160 02 7D                  511 	.dw #0x027d
      008162 02 72                  512 	.dw #0x0272
      008164 02 68                  513 	.dw #0x0268
      008166 02 5E                  514 	.dw #0x025e
      008168 02 53                  515 	.dw #0x0253
      00816A 02 49                  516 	.dw #0x0249
      00816C 02 3E                  517 	.dw #0x023e
      00816E 02 34                  518 	.dw #0x0234
      008170 02 29                  519 	.dw #0x0229
      008172 02 1F                  520 	.dw #0x021f
      008174 02 14                  521 	.dw #0x0214
      008176 02 0A                  522 	.dw #0x020a
      008178 02 00                  523 	.dw #0x0200
      00817A 01 F5                  524 	.dw #0x01f5
      00817C 01 EB                  525 	.dw #0x01eb
      00817E 01 E1                  526 	.dw #0x01e1
      008180 01 D7                  527 	.dw #0x01d7
      008182 01 CD                  528 	.dw #0x01cd
      008184 01 C4                  529 	.dw #0x01c4
      008186 01 BA                  530 	.dw #0x01ba
      008188 01 B0                  531 	.dw #0x01b0
      00818A 01 A7                  532 	.dw #0x01a7
      00818C 01 9E                  533 	.dw #0x019e
      00818E 01 94                  534 	.dw #0x0194
      008190 01 8B                  535 	.dw #0x018b
      008192 01 82                  536 	.dw #0x0182
      008194 01 7A                  537 	.dw #0x017a
      008196 01 71                  538 	.dw #0x0171
      008198 01 68                  539 	.dw #0x0168
      00819A 01 60                  540 	.dw #0x0160
      00819C 01 58                  541 	.dw #0x0158
      00819E 01 50                  542 	.dw #0x0150
      0081A0 01 48                  543 	.dw #0x0148
      0081A2 01 40                  544 	.dw #0x0140
      0081A4 01 38                  545 	.dw #0x0138
      0081A6 01 31                  546 	.dw #0x0131
      0081A8 01 29                  547 	.dw #0x0129
      0081AA 01 22                  548 	.dw #0x0122
      0081AC 01 1B                  549 	.dw #0x011b
      0081AE 01 14                  550 	.dw #0x0114
      0081B0 01 0D                  551 	.dw #0x010d
      0081B2 01 07                  552 	.dw #0x0107
      0081B4 01 00                  553 	.dw #0x0100
      0081B6 00 FA                  554 	.dw #0x00fa
      0081B8 00 F4                  555 	.dw #0x00f4
      0081BA 00 EE                  556 	.dw #0x00ee
      0081BC 00 E8                  557 	.dw #0x00e8
      0081BE 00 E2                  558 	.dw #0x00e2
      0081C0 00 DC                  559 	.dw #0x00dc
      0081C2 00 D7                  560 	.dw #0x00d7
      0081C4 00 D1                  561 	.dw #0x00d1
      0081C6 00 CC                  562 	.dw #0x00cc
      0081C8 00 C7                  563 	.dw #0x00c7
      0081CA 00 C2                  564 	.dw #0x00c2
      0081CC 00 BD                  565 	.dw #0x00bd
      0081CE 00 B8                  566 	.dw #0x00b8
      0081D0 00 B4                  567 	.dw #0x00b4
      0081D2 00 AF                  568 	.dw #0x00af
      0081D4 00 AB                  569 	.dw #0x00ab
      0081D6 00 A7                  570 	.dw #0x00a7
      0081D8 00 A3                  571 	.dw #0x00a3
      0081DA 00 9E                  572 	.dw #0x009e
      0081DC 00 9A                  573 	.dw #0x009a
      0081DE 00 97                  574 	.dw #0x0097
      0081E0 00 93                  575 	.dw #0x0093
      0081E2 00 8F                  576 	.dw #0x008f
      0081E4 00 8C                  577 	.dw #0x008c
      0081E6 00 88                  578 	.dw #0x0088
      0081E8 00 85                  579 	.dw #0x0085
      0081EA 00 82                  580 	.dw #0x0082
      0081EC 00 7E                  581 	.dw #0x007e
      0081EE 00 7B                  582 	.dw #0x007b
      0081F0 00 78                  583 	.dw #0x0078
      0081F2 00 75                  584 	.dw #0x0075
      0081F4 00 72                  585 	.dw #0x0072
      0081F6 00 70                  586 	.dw #0x0070
      0081F8 00 6D                  587 	.dw #0x006d
      0081FA 00 6A                  588 	.dw #0x006a
      0081FC 00 68                  589 	.dw #0x0068
      0081FE 00 65                  590 	.dw #0x0065
      008200 00 63                  591 	.dw #0x0063
      008202 00 60                  592 	.dw #0x0060
      008204 00 5E                  593 	.dw #0x005e
      008206 00 5C                  594 	.dw #0x005c
                                    595 	.area INITIALIZER
                                    596 	.area CABS (ABS)

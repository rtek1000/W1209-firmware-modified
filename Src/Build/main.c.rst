                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module main
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _getUptimeSeconds
                                     13 	.globl _getUptimeTicks
                                     14 	.globl _getUptime
                                     15 	.globl _initTimer
                                     16 	.globl _initRelay
                                     17 	.globl _itofpa
                                     18 	.globl _paramToString
                                     19 	.globl _getParamById
                                     20 	.globl _getParamId
                                     21 	.globl _initParamsEEPROM
                                     22 	.globl _getMenuDisplay
                                     23 	.globl _initMenu
                                     24 	.globl _setDisplayTestMode
                                     25 	.globl _setDisplayStr
                                     26 	.globl _setDisplayOff
                                     27 	.globl _initDisplay
                                     28 	.globl _initButtons
                                     29 	.globl _getTemperature
                                     30 	.globl _getSensorFail
                                     31 	.globl _initADC
                                     32 ;--------------------------------------------------------
                                     33 ; ram data
                                     34 ;--------------------------------------------------------
                                     35 	.area DATA
      000001                         36 _main_stringBuffer_65536_16:
      000001                         37 	.ds 14
                                     38 ;--------------------------------------------------------
                                     39 ; ram data
                                     40 ;--------------------------------------------------------
                                     41 	.area INITIALIZED
                                     42 ;--------------------------------------------------------
                                     43 ; Stack segment in internal ram 
                                     44 ;--------------------------------------------------------
                                     45 	.area	SSEG
      FFFFFF                         46 __start__stack:
      FFFFFF                         47 	.ds	1
                                     48 
                                     49 ;--------------------------------------------------------
                                     50 ; absolute external ram data
                                     51 ;--------------------------------------------------------
                                     52 	.area DABS (ABS)
                                     53 
                                     54 ; default segment ordering for linker
                                     55 	.area HOME
                                     56 	.area GSINIT
                                     57 	.area GSFINAL
                                     58 	.area CONST
                                     59 	.area INITIALIZER
                                     60 	.area CODE
                                     61 
                                     62 ;--------------------------------------------------------
                                     63 ; interrupt vector 
                                     64 ;--------------------------------------------------------
                                     65 	.area HOME
      008000                         66 __interrupt_vect:
      008000 82 00 80 6B             67 	int s_GSINIT ; reset
      008004 82 00 00 00             68 	int 0x000000 ; trap
      008008 82 00 00 00             69 	int 0x000000 ; int0
      00800C 82 00 00 00             70 	int 0x000000 ; int1
      008010 82 00 00 00             71 	int 0x000000 ; int2
      008014 82 00 00 00             72 	int 0x000000 ; int3
      008018 82 00 00 00             73 	int 0x000000 ; int4
      00801C 82 00 8C 25             74 	int _EXTI2_handler ; int5
      008020 82 00 00 00             75 	int 0x000000 ; int6
      008024 82 00 00 00             76 	int 0x000000 ; int7
      008028 82 00 00 00             77 	int 0x000000 ; int8
      00802C 82 00 00 00             78 	int 0x000000 ; int9
      008030 82 00 00 00             79 	int 0x000000 ; int10
      008034 82 00 00 00             80 	int 0x000000 ; int11
      008038 82 00 00 00             81 	int 0x000000 ; int12
      00803C 82 00 00 00             82 	int 0x000000 ; int13
      008040 82 00 00 00             83 	int 0x000000 ; int14
      008044 82 00 00 00             84 	int 0x000000 ; int15
      008048 82 00 00 00             85 	int 0x000000 ; int16
      00804C 82 00 00 00             86 	int 0x000000 ; int17
      008050 82 00 00 00             87 	int 0x000000 ; int18
      008054 82 00 00 00             88 	int 0x000000 ; int19
      008058 82 00 00 00             89 	int 0x000000 ; int20
      00805C 82 00 00 00             90 	int 0x000000 ; int21
      008060 82 00 8D 7E             91 	int _ADC1_EOC_handler ; int22
      008064 82 00 8A 4B             92 	int _TIM4_UPD_handler ; int23
                                     93 ;--------------------------------------------------------
                                     94 ; global & static initialisations
                                     95 ;--------------------------------------------------------
                                     96 	.area HOME
                                     97 	.area GSINIT
                                     98 	.area GSFINAL
                                     99 	.area GSINIT
      00806B                        100 __sdcc_gs_init_startup:
      00806B                        101 __sdcc_init_data:
                                    102 ; stm8_genXINIT() start
      00806B AE 00 43         [ 2]  103 	ldw x, #l_DATA
      00806E 27 07            [ 1]  104 	jreq	00002$
      008070                        105 00001$:
      008070 72 4F 00 00      [ 1]  106 	clr (s_DATA - 1, x)
      008074 5A               [ 2]  107 	decw x
      008075 26 F9            [ 1]  108 	jrne	00001$
      008077                        109 00002$:
      008077 AE 00 07         [ 2]  110 	ldw	x, #l_INITIALIZER
      00807A 27 09            [ 1]  111 	jreq	00004$
      00807C                        112 00003$:
      00807C D6 82 43         [ 1]  113 	ld	a, (s_INITIALIZER - 1, x)
      00807F D7 00 43         [ 1]  114 	ld	(s_INITIALIZED - 1, x), a
      008082 5A               [ 2]  115 	decw	x
      008083 26 F7            [ 1]  116 	jrne	00003$
      008085                        117 00004$:
                                    118 ; stm8_genXINIT() end
                                    119 	.area GSFINAL
      008085 CC 80 68         [ 2]  120 	jp	__sdcc_program_startup
                                    121 ;--------------------------------------------------------
                                    122 ; Home
                                    123 ;--------------------------------------------------------
                                    124 	.area HOME
                                    125 	.area HOME
      008068                        126 __sdcc_program_startup:
      008068 CC 82 4B         [ 2]  127 	jp	_main
                                    128 ;	return from main will return to caller
                                    129 ;--------------------------------------------------------
                                    130 ; code
                                    131 ;--------------------------------------------------------
                                    132 	.area CODE
                                    133 ;	./main.c: 34: int main()
                                    134 ;	-----------------------------------------
                                    135 ;	 function main
                                    136 ;	-----------------------------------------
      00824B                        137 _main:
      00824B 52 09            [ 2]  138 	sub	sp, #9
                                    139 ;	./main.c: 37: unsigned char paramMsg[] = {'P', '0', 0};
      00824D A6 50            [ 1]  140 	ld	a, #0x50
      00824F 6B 01            [ 1]  141 	ld	(0x01, sp), a
      008251 96               [ 1]  142 	ldw	x, sp
      008252 1C 00 02         [ 2]  143 	addw	x, #2
      008255 1F 04            [ 2]  144 	ldw	(0x04, sp), x
      008257 A6 30            [ 1]  145 	ld	a, #0x30
      008259 F7               [ 1]  146 	ld	(x), a
      00825A 96               [ 1]  147 	ldw	x, sp
      00825B 1C 00 03         [ 2]  148 	addw	x, #3
      00825E 7F               [ 1]  149 	clr	(x)
                                    150 ;	./main.c: 39: initMenu();
      00825F CD 8E C0         [ 4]  151 	call	_initMenu
                                    152 ;	./main.c: 40: initButtons();
      008262 CD 8B 70         [ 4]  153 	call	_initButtons
                                    154 ;	./main.c: 41: initParamsEEPROM();
      008265 CD 93 69         [ 4]  155 	call	_initParamsEEPROM
                                    156 ;	./main.c: 42: initDisplay();
      008268 CD 84 95         [ 4]  157 	call	_initDisplay
                                    158 ;	./main.c: 43: initADC();
      00826B CD 8C 8C         [ 4]  159 	call	_initADC
                                    160 ;	./main.c: 44: initRelay();
      00826E CD 97 96         [ 4]  161 	call	_initRelay
                                    162 ;	./main.c: 45: initTimer();
      008271 CD 89 E9         [ 4]  163 	call	_initTimer
                                    164 ;	./main.c: 47: INTERRUPT_ENABLE
      008274 9A               [ 1]  165 	rim	
                                    166 ;	./main.c: 50: while (true) {
      008275                        167 00150$:
                                    168 ;	./main.c: 51: if (getUptimeSeconds() > 0) {
      008275 CD 8A 18         [ 4]  169 	call	_getUptimeSeconds
      008278 4D               [ 1]  170 	tnz	a
      008279 27 0B            [ 1]  171 	jreq	00102$
                                    172 ;	./main.c: 52: setDisplayTestMode (false, "");
      00827B 4B 88            [ 1]  173 	push	#<(___str_0 + 0)
      00827D 4B 80            [ 1]  174 	push	#((___str_0 + 0) >> 8)
      00827F 4B 00            [ 1]  175 	push	#0x00
      008281 CD 85 76         [ 4]  176 	call	_setDisplayTestMode
      008284 5B 03            [ 2]  177 	addw	sp, #3
      008286                        178 00102$:
                                    179 ;	./main.c: 55: if (getMenuDisplay() == MENU_ROOT) {
      008286 CD 8E CD         [ 4]  180 	call	_getMenuDisplay
      008289 6B 09            [ 1]  181 	ld	(0x09, sp), a
      00828B 27 03            [ 1]  182 	jreq	00245$
      00828D CC 83 3C         [ 2]  183 	jp	00147$
      008290                        184 00245$:
                                    185 ;	./main.c: 56: int temp = getTemperature();
      008290 CD 8C CE         [ 4]  186 	call	_getTemperature
      008293 1F 06            [ 2]  187 	ldw	(0x06, sp), x
                                    188 ;	./main.c: 57: int sensor_fail = getSensorFail();
      008295 CD 8E 78         [ 4]  189 	call	_getSensorFail
                                    190 ;	./main.c: 59: if(sensor_fail > 0) {
      008298 A3 00 00         [ 2]  191 	cpw	x, #0x0000
      00829B 2D 30            [ 1]  192 	jrsle	00114$
                                    193 ;	./main.c: 60: bool blink = (bool) ( (unsigned char) getUptimeTicks() & 0x40);
      00829D 89               [ 2]  194 	pushw	x
      00829E CD 8A 10         [ 4]  195 	call	_getUptimeTicks
      0082A1 1F 0A            [ 2]  196 	ldw	(0x0a, sp), x
      0082A3 85               [ 2]  197 	popw	x
      0082A4 7B 09            [ 1]  198 	ld	a, (0x09, sp)
      0082A6 48               [ 1]  199 	sll	a
      0082A7 48               [ 1]  200 	sll	a
      0082A8 4F               [ 1]  201 	clr	a
      0082A9 49               [ 1]  202 	rlc	a
      0082AA 6B 09            [ 1]  203 	ld	(0x09, sp), a
                                    204 ;	./main.c: 62: if(sensor_fail == 1) {
      0082AC 5A               [ 2]  205 	decw	x
      0082AD 26 0B            [ 1]  206 	jrne	00104$
                                    207 ;	./main.c: 63: setDisplayStr ("HHH");
      0082AF 4B 89            [ 1]  208 	push	#<(___str_1 + 0)
      0082B1 4B 80            [ 1]  209 	push	#((___str_1 + 0) >> 8)
      0082B3 CD 85 BF         [ 4]  210 	call	_setDisplayStr
      0082B6 5B 02            [ 2]  211 	addw	sp, #2
      0082B8 20 09            [ 2]  212 	jra	00105$
      0082BA                        213 00104$:
                                    214 ;	./main.c: 65: setDisplayStr ("LLL");
      0082BA 4B 8D            [ 1]  215 	push	#<(___str_2 + 0)
      0082BC 4B 80            [ 1]  216 	push	#((___str_2 + 0) >> 8)
      0082BE CD 85 BF         [ 4]  217 	call	_setDisplayStr
      0082C1 5B 02            [ 2]  218 	addw	sp, #2
      0082C3                        219 00105$:
                                    220 ;	./main.c: 68: setDisplayOff (blink);
      0082C3 7B 09            [ 1]  221 	ld	a, (0x09, sp)
      0082C5 88               [ 1]  222 	push	a
      0082C6 CD 85 9D         [ 4]  223 	call	_setDisplayOff
      0082C9 84               [ 1]  224 	pop	a
      0082CA CC 84 8B         [ 2]  225 	jp	00148$
      0082CD                        226 00114$:
                                    227 ;	./main.c: 70: itofpa (temp, (char*) stringBuffer, 0);
      0082CD AE 00 01         [ 2]  228 	ldw	x, #(_main_stringBuffer_65536_16 + 0)
      0082D0 4B 00            [ 1]  229 	push	#0x00
      0082D2 89               [ 2]  230 	pushw	x
      0082D3 1E 09            [ 2]  231 	ldw	x, (0x09, sp)
      0082D5 89               [ 2]  232 	pushw	x
      0082D6 CD 96 94         [ 4]  233 	call	_itofpa
      0082D9 5B 05            [ 2]  234 	addw	sp, #5
                                    235 ;	./main.c: 71: setDisplayStr ( (char*) stringBuffer);
      0082DB AE 00 01         [ 2]  236 	ldw	x, #(_main_stringBuffer_65536_16 + 0)
      0082DE 89               [ 2]  237 	pushw	x
      0082DF CD 85 BF         [ 4]  238 	call	_setDisplayStr
      0082E2 5B 02            [ 2]  239 	addw	sp, #2
                                    240 ;	./main.c: 73: if (getParamById (PARAM_OVERHEAT_INDICATION) ) {
      0082E4 4B 06            [ 1]  241 	push	#0x06
      0082E6 CD 93 E4         [ 4]  242 	call	_getParamById
      0082E9 84               [ 1]  243 	pop	a
      0082EA 5D               [ 2]  244 	tnzw	x
      0082EB 26 03            [ 1]  245 	jrne	00250$
      0082ED CC 84 8B         [ 2]  246 	jp	00148$
      0082F0                        247 00250$:
                                    248 ;	./main.c: 74: bool blink = (bool) ( (unsigned char) getUptimeTicks() & 0x80);
      0082F0 CD 8A 10         [ 4]  249 	call	_getUptimeTicks
      0082F3 9F               [ 1]  250 	ld	a, xl
      0082F4 48               [ 1]  251 	sll	a
      0082F5 4F               [ 1]  252 	clr	a
      0082F6 49               [ 1]  253 	rlc	a
                                    254 ;	./main.c: 76: if (temp < (getParamById (PARAM_MIN_TEMPERATURE) * 10) ) {
      0082F7 88               [ 1]  255 	push	a
      0082F8 4B 03            [ 1]  256 	push	#0x03
      0082FA CD 93 E4         [ 4]  257 	call	_getParamById
      0082FD 84               [ 1]  258 	pop	a
      0082FE 84               [ 1]  259 	pop	a
      0082FF 89               [ 2]  260 	pushw	x
      008300 58               [ 2]  261 	sllw	x
      008301 58               [ 2]  262 	sllw	x
      008302 72 FB 01         [ 2]  263 	addw	x, (1, sp)
      008305 58               [ 2]  264 	sllw	x
      008306 5B 02            [ 2]  265 	addw	sp, #2
      008308 1F 08            [ 2]  266 	ldw	(0x08, sp), x
      00830A 1E 06            [ 2]  267 	ldw	x, (0x06, sp)
      00830C 13 08            [ 2]  268 	cpw	x, (0x08, sp)
      00830E 2E 08            [ 1]  269 	jrsge	00109$
                                    270 ;	./main.c: 77: setDisplayOff (blink);
      008310 88               [ 1]  271 	push	a
      008311 CD 85 9D         [ 4]  272 	call	_setDisplayOff
      008314 84               [ 1]  273 	pop	a
      008315 CC 84 8B         [ 2]  274 	jp	00148$
      008318                        275 00109$:
                                    276 ;	./main.c: 78: } else if (temp >= (getParamById (PARAM_MAX_TEMPERATURE) * 10) ) {
      008318 88               [ 1]  277 	push	a
      008319 4B 02            [ 1]  278 	push	#0x02
      00831B CD 93 E4         [ 4]  279 	call	_getParamById
      00831E 84               [ 1]  280 	pop	a
      00831F 84               [ 1]  281 	pop	a
      008320 89               [ 2]  282 	pushw	x
      008321 58               [ 2]  283 	sllw	x
      008322 58               [ 2]  284 	sllw	x
      008323 72 FB 01         [ 2]  285 	addw	x, (1, sp)
      008326 58               [ 2]  286 	sllw	x
      008327 5B 02            [ 2]  287 	addw	sp, #2
      008329 1F 08            [ 2]  288 	ldw	(0x08, sp), x
      00832B 1E 06            [ 2]  289 	ldw	x, (0x06, sp)
      00832D 13 08            [ 2]  290 	cpw	x, (0x08, sp)
      00832F 2E 03            [ 1]  291 	jrsge	00252$
      008331 CC 84 8B         [ 2]  292 	jp	00148$
      008334                        293 00252$:
                                    294 ;	./main.c: 79: setDisplayOff (blink);
      008334 88               [ 1]  295 	push	a
      008335 CD 85 9D         [ 4]  296 	call	_setDisplayOff
      008338 84               [ 1]  297 	pop	a
      008339 CC 84 8B         [ 2]  298 	jp	00148$
      00833C                        299 00147$:
                                    300 ;	./main.c: 83: } else if (getMenuDisplay() == MENU_SET_THRESHOLD) {
      00833C CD 8E CD         [ 4]  301 	call	_getMenuDisplay
      00833F 4A               [ 1]  302 	dec	a
      008340 26 17            [ 1]  303 	jrne	00144$
                                    304 ;	./main.c: 84: paramToString (PARAM_THRESHOLD, (char*) stringBuffer);
      008342 AE 00 01         [ 2]  305 	ldw	x, #(_main_stringBuffer_65536_16 + 0)
      008345 89               [ 2]  306 	pushw	x
      008346 4B 09            [ 1]  307 	push	#0x09
      008348 CD 94 E6         [ 4]  308 	call	_paramToString
      00834B 5B 03            [ 2]  309 	addw	sp, #3
                                    310 ;	./main.c: 85: setDisplayStr ( (char*) stringBuffer);
      00834D AE 00 01         [ 2]  311 	ldw	x, #(_main_stringBuffer_65536_16 + 0)
      008350 89               [ 2]  312 	pushw	x
      008351 CD 85 BF         [ 4]  313 	call	_setDisplayStr
      008354 5B 02            [ 2]  314 	addw	sp, #2
      008356 CC 84 8B         [ 2]  315 	jp	00148$
      008359                        316 00144$:
                                    317 ;	./main.c: 86: } else if (getMenuDisplay() == MENU_SELECT_PARAM) {
      008359 CD 8E CD         [ 4]  318 	call	_getMenuDisplay
      00835C A1 02            [ 1]  319 	cp	a, #0x02
      00835E 26 13            [ 1]  320 	jrne	00141$
                                    321 ;	./main.c: 87: paramMsg[1] = '0' + getParamId();
      008360 CD 94 B4         [ 4]  322 	call	_getParamId
      008363 AB 30            [ 1]  323 	add	a, #0x30
      008365 1E 04            [ 2]  324 	ldw	x, (0x04, sp)
      008367 F7               [ 1]  325 	ld	(x), a
                                    326 ;	./main.c: 88: setDisplayStr ( (unsigned char*) &paramMsg);
      008368 96               [ 1]  327 	ldw	x, sp
      008369 5C               [ 1]  328 	incw	x
      00836A 89               [ 2]  329 	pushw	x
      00836B CD 85 BF         [ 4]  330 	call	_setDisplayStr
      00836E 5B 02            [ 2]  331 	addw	sp, #2
      008370 CC 84 8B         [ 2]  332 	jp	00148$
      008373                        333 00141$:
                                    334 ;	./main.c: 89: } else if (getMenuDisplay() == MENU_CHANGE_PARAM) {
      008373 CD 8E CD         [ 4]  335 	call	_getMenuDisplay
      008376 A1 03            [ 1]  336 	cp	a, #0x03
      008378 26 19            [ 1]  337 	jrne	00138$
                                    338 ;	./main.c: 90: paramToString (getParamId(), (char*) stringBuffer);
      00837A AE 00 01         [ 2]  339 	ldw	x, #(_main_stringBuffer_65536_16 + 0)
      00837D 89               [ 2]  340 	pushw	x
      00837E CD 94 B4         [ 4]  341 	call	_getParamId
      008381 88               [ 1]  342 	push	a
      008382 CD 94 E6         [ 4]  343 	call	_paramToString
      008385 5B 03            [ 2]  344 	addw	sp, #3
                                    345 ;	./main.c: 91: setDisplayStr ( (char *) stringBuffer);
      008387 AE 00 01         [ 2]  346 	ldw	x, #(_main_stringBuffer_65536_16 + 0)
      00838A 89               [ 2]  347 	pushw	x
      00838B CD 85 BF         [ 4]  348 	call	_setDisplayStr
      00838E 5B 02            [ 2]  349 	addw	sp, #2
      008390 CC 84 8B         [ 2]  350 	jp	00148$
      008393                        351 00138$:
                                    352 ;	./main.c: 92: } else if (getMenuDisplay() == MENU_ALARM) {
      008393 CD 8E CD         [ 4]  353 	call	_getMenuDisplay
      008396 A1 04            [ 1]  354 	cp	a, #0x04
      008398 26 2E            [ 1]  355 	jrne	00135$
                                    356 ;	./main.c: 93: if(getParamById(PARAM_RELAY_MODE) == 2) {
      00839A 4B 00            [ 1]  357 	push	#0x00
      00839C CD 93 E4         [ 4]  358 	call	_getParamById
      00839F 84               [ 1]  359 	pop	a
      0083A0 A3 00 02         [ 2]  360 	cpw	x, #0x0002
      0083A3 26 0B            [ 1]  361 	jrne	00117$
                                    362 ;	./main.c: 94: setDisplayStr ("AL1");
      0083A5 4B 91            [ 1]  363 	push	#<(___str_3 + 0)
      0083A7 4B 80            [ 1]  364 	push	#((___str_3 + 0) >> 8)
      0083A9 CD 85 BF         [ 4]  365 	call	_setDisplayStr
      0083AC 5B 02            [ 2]  366 	addw	sp, #2
      0083AE 20 09            [ 2]  367 	jra	00118$
      0083B0                        368 00117$:
                                    369 ;	./main.c: 96: setDisplayStr ("AL2");
      0083B0 4B 95            [ 1]  370 	push	#<(___str_4 + 0)
      0083B2 4B 80            [ 1]  371 	push	#((___str_4 + 0) >> 8)
      0083B4 CD 85 BF         [ 4]  372 	call	_setDisplayStr
      0083B7 5B 02            [ 2]  373 	addw	sp, #2
      0083B9                        374 00118$:
                                    375 ;	./main.c: 98: setDisplayOff ( (bool) (getUptime() & 0x80) );
      0083B9 CD 8A 08         [ 4]  376 	call	_getUptime
      0083BC 9F               [ 1]  377 	ld	a, xl
      0083BD 48               [ 1]  378 	sll	a
      0083BE 4F               [ 1]  379 	clr	a
      0083BF 49               [ 1]  380 	rlc	a
      0083C0 88               [ 1]  381 	push	a
      0083C1 CD 85 9D         [ 4]  382 	call	_setDisplayOff
      0083C4 84               [ 1]  383 	pop	a
      0083C5 CC 84 8B         [ 2]  384 	jp	00148$
      0083C8                        385 00135$:
                                    386 ;	./main.c: 99: } else if (getMenuDisplay() == MENU_ALARM_HIGH) {
      0083C8 CD 8E CD         [ 4]  387 	call	_getMenuDisplay
      0083CB A1 05            [ 1]  388 	cp	a, #0x05
      0083CD 26 35            [ 1]  389 	jrne	00132$
                                    390 ;	./main.c: 100: int temp = getParamById (PARAM_MAX_TEMPERATURE) * 10;
      0083CF 4B 02            [ 1]  391 	push	#0x02
      0083D1 CD 93 E4         [ 4]  392 	call	_getParamById
      0083D4 84               [ 1]  393 	pop	a
      0083D5 89               [ 2]  394 	pushw	x
      0083D6 58               [ 2]  395 	sllw	x
      0083D7 58               [ 2]  396 	sllw	x
      0083D8 72 FB 01         [ 2]  397 	addw	x, (1, sp)
      0083DB 58               [ 2]  398 	sllw	x
      0083DC 5B 02            [ 2]  399 	addw	sp, #2
                                    400 ;	./main.c: 101: itofpa (temp, (char*) stringBuffer, 0);
      0083DE 90 AE 00 01      [ 2]  401 	ldw	y, #(_main_stringBuffer_65536_16 + 0)
      0083E2 4B 00            [ 1]  402 	push	#0x00
      0083E4 90 89            [ 2]  403 	pushw	y
      0083E6 89               [ 2]  404 	pushw	x
      0083E7 CD 96 94         [ 4]  405 	call	_itofpa
      0083EA 5B 05            [ 2]  406 	addw	sp, #5
                                    407 ;	./main.c: 102: setDisplayStr ( (char*) stringBuffer);
      0083EC AE 00 01         [ 2]  408 	ldw	x, #(_main_stringBuffer_65536_16 + 0)
      0083EF 89               [ 2]  409 	pushw	x
      0083F0 CD 85 BF         [ 4]  410 	call	_setDisplayStr
      0083F3 5B 02            [ 2]  411 	addw	sp, #2
                                    412 ;	./main.c: 103: setDisplayOff ( (bool) (getUptime() & 0x80) );
      0083F5 CD 8A 08         [ 4]  413 	call	_getUptime
      0083F8 9F               [ 1]  414 	ld	a, xl
      0083F9 48               [ 1]  415 	sll	a
      0083FA 4F               [ 1]  416 	clr	a
      0083FB 49               [ 1]  417 	rlc	a
      0083FC 88               [ 1]  418 	push	a
      0083FD CD 85 9D         [ 4]  419 	call	_setDisplayOff
      008400 84               [ 1]  420 	pop	a
      008401 CC 84 8B         [ 2]  421 	jp	00148$
      008404                        422 00132$:
                                    423 ;	./main.c: 104: } else if (getMenuDisplay() == MENU_ALARM_LOW) {
      008404 CD 8E CD         [ 4]  424 	call	_getMenuDisplay
      008407 A1 06            [ 1]  425 	cp	a, #0x06
      008409 26 34            [ 1]  426 	jrne	00129$
                                    427 ;	./main.c: 105: int temp = getParamById (PARAM_MIN_TEMPERATURE) * 10;
      00840B 4B 03            [ 1]  428 	push	#0x03
      00840D CD 93 E4         [ 4]  429 	call	_getParamById
      008410 84               [ 1]  430 	pop	a
      008411 89               [ 2]  431 	pushw	x
      008412 58               [ 2]  432 	sllw	x
      008413 58               [ 2]  433 	sllw	x
      008414 72 FB 01         [ 2]  434 	addw	x, (1, sp)
      008417 58               [ 2]  435 	sllw	x
      008418 5B 02            [ 2]  436 	addw	sp, #2
                                    437 ;	./main.c: 106: itofpa (temp, (char*) stringBuffer, 0);
      00841A 90 AE 00 01      [ 2]  438 	ldw	y, #(_main_stringBuffer_65536_16 + 0)
      00841E 4B 00            [ 1]  439 	push	#0x00
      008420 90 89            [ 2]  440 	pushw	y
      008422 89               [ 2]  441 	pushw	x
      008423 CD 96 94         [ 4]  442 	call	_itofpa
      008426 5B 05            [ 2]  443 	addw	sp, #5
                                    444 ;	./main.c: 107: setDisplayStr ( (char*) stringBuffer);
      008428 AE 00 01         [ 2]  445 	ldw	x, #(_main_stringBuffer_65536_16 + 0)
      00842B 89               [ 2]  446 	pushw	x
      00842C CD 85 BF         [ 4]  447 	call	_setDisplayStr
      00842F 5B 02            [ 2]  448 	addw	sp, #2
                                    449 ;	./main.c: 108: setDisplayOff ( (bool) (getUptime() & 0x80) );
      008431 CD 8A 08         [ 4]  450 	call	_getUptime
      008434 9F               [ 1]  451 	ld	a, xl
      008435 48               [ 1]  452 	sll	a
      008436 4F               [ 1]  453 	clr	a
      008437 49               [ 1]  454 	rlc	a
      008438 88               [ 1]  455 	push	a
      008439 CD 85 9D         [ 4]  456 	call	_setDisplayOff
      00843C 84               [ 1]  457 	pop	a
      00843D 20 4C            [ 2]  458 	jra	00148$
      00843F                        459 00129$:
                                    460 ;	./main.c: 110: if(getMenuDisplay() == MENU_EEPROM_RESET) {
      00843F CD 8E CD         [ 4]  461 	call	_getMenuDisplay
      008442 A1 07            [ 1]  462 	cp	a, #0x07
      008444 26 0B            [ 1]  463 	jrne	00126$
                                    464 ;	./main.c: 111: setDisplayStr ("RST");
      008446 4B 99            [ 1]  465 	push	#<(___str_5 + 0)
      008448 4B 80            [ 1]  466 	push	#((___str_5 + 0) >> 8)
      00844A CD 85 BF         [ 4]  467 	call	_setDisplayStr
      00844D 5B 02            [ 2]  468 	addw	sp, #2
      00844F 20 3A            [ 2]  469 	jra	00148$
      008451                        470 00126$:
                                    471 ;	./main.c: 112: } else if(getMenuDisplay() == MENU_EEPROM_LOCKED) {
      008451 CD 8E CD         [ 4]  472 	call	_getMenuDisplay
      008454 A1 08            [ 1]  473 	cp	a, #0x08
      008456 26 0B            [ 1]  474 	jrne	00123$
                                    475 ;	./main.c: 113: setDisplayStr (" P7");
      008458 4B 9D            [ 1]  476 	push	#<(___str_6 + 0)
      00845A 4B 80            [ 1]  477 	push	#((___str_6 + 0) >> 8)
      00845C CD 85 BF         [ 4]  478 	call	_setDisplayStr
      00845F 5B 02            [ 2]  479 	addw	sp, #2
      008461 20 28            [ 2]  480 	jra	00148$
      008463                        481 00123$:
                                    482 ;	./main.c: 114: } else if(getMenuDisplay() == MENU_EEPROM_LOC_2) {
      008463 CD 8E CD         [ 4]  483 	call	_getMenuDisplay
      008466 A1 09            [ 1]  484 	cp	a, #0x09
      008468 26 0B            [ 1]  485 	jrne	00120$
                                    486 ;	./main.c: 115: setDisplayStr ("LOC");
      00846A 4B A1            [ 1]  487 	push	#<(___str_7 + 0)
      00846C 4B 80            [ 1]  488 	push	#((___str_7 + 0) >> 8)
      00846E CD 85 BF         [ 4]  489 	call	_setDisplayStr
      008471 5B 02            [ 2]  490 	addw	sp, #2
      008473 20 16            [ 2]  491 	jra	00148$
      008475                        492 00120$:
                                    493 ;	./main.c: 117: setDisplayStr ("ERR");
      008475 4B A5            [ 1]  494 	push	#<(___str_8 + 0)
      008477 4B 80            [ 1]  495 	push	#((___str_8 + 0) >> 8)
      008479 CD 85 BF         [ 4]  496 	call	_setDisplayStr
      00847C 5B 02            [ 2]  497 	addw	sp, #2
                                    498 ;	./main.c: 118: setDisplayOff ( (bool) (getUptime() & 0x40) );
      00847E CD 8A 08         [ 4]  499 	call	_getUptime
      008481 9F               [ 1]  500 	ld	a, xl
      008482 48               [ 1]  501 	sll	a
      008483 48               [ 1]  502 	sll	a
      008484 4F               [ 1]  503 	clr	a
      008485 49               [ 1]  504 	rlc	a
      008486 88               [ 1]  505 	push	a
      008487 CD 85 9D         [ 4]  506 	call	_setDisplayOff
      00848A 84               [ 1]  507 	pop	a
      00848B                        508 00148$:
                                    509 ;	./main.c: 122: WAIT_FOR_INTERRUPT
      00848B 8F               [10]  510 	wfi	
                                    511 ;	./main.c: 124: }
      00848C CC 82 75         [ 2]  512 	jp	00150$
                                    513 	.area CODE
                                    514 	.area CONST
                                    515 	.area CONST
      008088                        516 ___str_0:
      008088 00                     517 	.db 0x00
                                    518 	.area CODE
                                    519 	.area CONST
      008089                        520 ___str_1:
      008089 48 48 48               521 	.ascii "HHH"
      00808C 00                     522 	.db 0x00
                                    523 	.area CODE
                                    524 	.area CONST
      00808D                        525 ___str_2:
      00808D 4C 4C 4C               526 	.ascii "LLL"
      008090 00                     527 	.db 0x00
                                    528 	.area CODE
                                    529 	.area CONST
      008091                        530 ___str_3:
      008091 41 4C 31               531 	.ascii "AL1"
      008094 00                     532 	.db 0x00
                                    533 	.area CODE
                                    534 	.area CONST
      008095                        535 ___str_4:
      008095 41 4C 32               536 	.ascii "AL2"
      008098 00                     537 	.db 0x00
                                    538 	.area CODE
                                    539 	.area CONST
      008099                        540 ___str_5:
      008099 52 53 54               541 	.ascii "RST"
      00809C 00                     542 	.db 0x00
                                    543 	.area CODE
                                    544 	.area CONST
      00809D                        545 ___str_6:
      00809D 20 50 37               546 	.ascii " P7"
      0080A0 00                     547 	.db 0x00
                                    548 	.area CODE
                                    549 	.area CONST
      0080A1                        550 ___str_7:
      0080A1 4C 4F 43               551 	.ascii "LOC"
      0080A4 00                     552 	.db 0x00
                                    553 	.area CODE
                                    554 	.area CONST
      0080A5                        555 ___str_8:
      0080A5 45 52 52               556 	.ascii "ERR"
      0080A8 00                     557 	.db 0x00
                                    558 	.area CODE
                                    559 	.area INITIALIZER
                                    560 	.area CABS (ABS)

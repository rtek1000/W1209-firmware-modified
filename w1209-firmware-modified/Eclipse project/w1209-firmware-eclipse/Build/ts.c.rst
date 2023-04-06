                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module ts
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _getUptimeSeconds
                                     13 	.globl _getUptime
                                     14 	.globl _initTimer
                                     15 	.globl _initRelay
                                     16 	.globl _itofpa
                                     17 	.globl _paramToString
                                     18 	.globl _getParamById
                                     19 	.globl _getParamId
                                     20 	.globl _initParamsEEPROM
                                     21 	.globl _getMenuDisplay
                                     22 	.globl _initMenu
                                     23 	.globl _setDisplayTestMode
                                     24 	.globl _setDisplayStr
                                     25 	.globl _setDisplayOff
                                     26 	.globl _initDisplay
                                     27 	.globl _initButtons
                                     28 	.globl _getTemperature
                                     29 	.globl _initADC
                                     30 ;--------------------------------------------------------
                                     31 ; ram data
                                     32 ;--------------------------------------------------------
                                     33 	.area DATA
      000001                         34 _main_stringBuffer_65536_13:
      000001                         35 	.ds 14
                                     36 ;--------------------------------------------------------
                                     37 ; ram data
                                     38 ;--------------------------------------------------------
                                     39 	.area INITIALIZED
                                     40 ;--------------------------------------------------------
                                     41 ; Stack segment in internal ram 
                                     42 ;--------------------------------------------------------
                                     43 	.area	SSEG
      FFFFFF                         44 __start__stack:
      FFFFFF                         45 	.ds	1
                                     46 
                                     47 ;--------------------------------------------------------
                                     48 ; absolute external ram data
                                     49 ;--------------------------------------------------------
                                     50 	.area DABS (ABS)
                                     51 
                                     52 ; default segment ordering for linker
                                     53 	.area HOME
                                     54 	.area GSINIT
                                     55 	.area GSFINAL
                                     56 	.area CONST
                                     57 	.area INITIALIZER
                                     58 	.area CODE
                                     59 
                                     60 ;--------------------------------------------------------
                                     61 ; interrupt vector 
                                     62 ;--------------------------------------------------------
                                     63 	.area HOME
      008000                         64 __interrupt_vect:
      008000 82 00 80 6B             65 	int s_GSINIT ; reset
      008004 82 00 00 00             66 	int 0x000000 ; trap
      008008 82 00 00 00             67 	int 0x000000 ; int0
      00800C 82 00 00 00             68 	int 0x000000 ; int1
      008010 82 00 00 00             69 	int 0x000000 ; int2
      008014 82 00 00 00             70 	int 0x000000 ; int3
      008018 82 00 00 00             71 	int 0x000000 ; int4
      00801C 82 00 8A 67             72 	int _EXTI2_handler ; int5
      008020 82 00 00 00             73 	int 0x000000 ; int6
      008024 82 00 00 00             74 	int 0x000000 ; int7
      008028 82 00 00 00             75 	int 0x000000 ; int8
      00802C 82 00 00 00             76 	int 0x000000 ; int9
      008030 82 00 00 00             77 	int 0x000000 ; int10
      008034 82 00 00 00             78 	int 0x000000 ; int11
      008038 82 00 00 00             79 	int 0x000000 ; int12
      00803C 82 00 00 00             80 	int 0x000000 ; int13
      008040 82 00 00 00             81 	int 0x000000 ; int14
      008044 82 00 00 00             82 	int 0x000000 ; int15
      008048 82 00 00 00             83 	int 0x000000 ; int16
      00804C 82 00 00 00             84 	int 0x000000 ; int17
      008050 82 00 00 00             85 	int 0x000000 ; int18
      008054 82 00 00 00             86 	int 0x000000 ; int19
      008058 82 00 00 00             87 	int 0x000000 ; int20
      00805C 82 00 00 00             88 	int 0x000000 ; int21
      008060 82 00 8B AE             89 	int _ADC1_EOC_handler ; int22
      008064 82 00 88 CA             90 	int _TIM4_UPD_handler ; int23
                                     91 ;--------------------------------------------------------
                                     92 ; global & static initialisations
                                     93 ;--------------------------------------------------------
                                     94 	.area HOME
                                     95 	.area GSINIT
                                     96 	.area GSFINAL
                                     97 	.area GSINIT
      00806B                         98 __sdcc_gs_init_startup:
      00806B                         99 __sdcc_init_data:
                                    100 ; stm8_genXINIT() start
      00806B AE 00 3F         [ 2]  101 	ldw x, #l_DATA
      00806E 27 07            [ 1]  102 	jreq	00002$
      008070                        103 00001$:
      008070 72 4F 00 00      [ 1]  104 	clr (s_DATA - 1, x)
      008074 5A               [ 2]  105 	decw x
      008075 26 F9            [ 1]  106 	jrne	00001$
      008077                        107 00002$:
      008077 AE 00 00         [ 2]  108 	ldw	x, #l_INITIALIZER
      00807A 27 09            [ 1]  109 	jreq	00004$
      00807C                        110 00003$:
      00807C D6 82 2F         [ 1]  111 	ld	a, (s_INITIALIZER - 1, x)
      00807F D7 00 3F         [ 1]  112 	ld	(s_INITIALIZED - 1, x), a
      008082 5A               [ 2]  113 	decw	x
      008083 26 F7            [ 1]  114 	jrne	00003$
      008085                        115 00004$:
                                    116 ; stm8_genXINIT() end
                                    117 	.area GSFINAL
      008085 CC 80 68         [ 2]  118 	jp	__sdcc_program_startup
                                    119 ;--------------------------------------------------------
                                    120 ; Home
                                    121 ;--------------------------------------------------------
                                    122 	.area HOME
                                    123 	.area HOME
      008068                        124 __sdcc_program_startup:
      008068 CC 82 30         [ 2]  125 	jp	_main
                                    126 ;	return from main will return to caller
                                    127 ;--------------------------------------------------------
                                    128 ; code
                                    129 ;--------------------------------------------------------
                                    130 	.area CODE
                                    131 ;	./ts.c: 33: int main()
                                    132 ;	-----------------------------------------
                                    133 ;	 function main
                                    134 ;	-----------------------------------------
      008230                        135 _main:
      008230 52 0B            [ 2]  136 	sub	sp, #11
                                    137 ;	./ts.c: 36: unsigned char paramMsg[] = {'P', '0', 0};
      008232 A6 50            [ 1]  138 	ld	a, #0x50
      008234 6B 03            [ 1]  139 	ld	(0x03, sp), a
      008236 96               [ 1]  140 	ldw	x, sp
      008237 1C 00 04         [ 2]  141 	addw	x, #4
      00823A 1F 06            [ 2]  142 	ldw	(0x06, sp), x
      00823C A6 30            [ 1]  143 	ld	a, #0x30
      00823E F7               [ 1]  144 	ld	(x), a
      00823F 96               [ 1]  145 	ldw	x, sp
      008240 1C 00 05         [ 2]  146 	addw	x, #5
      008243 7F               [ 1]  147 	clr	(x)
                                    148 ;	./ts.c: 38: initMenu();
      008244 CD 8C 48         [ 4]  149 	call	_initMenu
                                    150 ;	./ts.c: 39: initButtons();
      008247 CD 89 EF         [ 4]  151 	call	_initButtons
                                    152 ;	./ts.c: 40: initParamsEEPROM();
      00824A CD 8F 37         [ 4]  153 	call	_initParamsEEPROM
                                    154 ;	./ts.c: 41: initDisplay();
      00824D CD 83 52         [ 4]  155 	call	_initDisplay
                                    156 ;	./ts.c: 42: initADC();
      008250 CD 8A BC         [ 4]  157 	call	_initADC
                                    158 ;	./ts.c: 43: initRelay();
      008253 CD 92 F2         [ 4]  159 	call	_initRelay
                                    160 ;	./ts.c: 44: initTimer();
      008256 CD 88 68         [ 4]  161 	call	_initTimer
                                    162 ;	./ts.c: 46: INTERRUPT_ENABLE
      008259 9A               [ 1]  163 	rim	
                                    164 ;	./ts.c: 49: while (true) {
      00825A                        165 00123$:
                                    166 ;	./ts.c: 50: if (getUptimeSeconds() > 0) {
      00825A CD 88 97         [ 4]  167 	call	_getUptimeSeconds
      00825D 4D               [ 1]  168 	tnz	a
      00825E 27 0B            [ 1]  169 	jreq	00102$
                                    170 ;	./ts.c: 51: setDisplayTestMode (false, "");
      008260 4B 88            [ 1]  171 	push	#<(___str_0 + 0)
      008262 4B 80            [ 1]  172 	push	#((___str_0 + 0) >> 8)
      008264 4B 00            [ 1]  173 	push	#0x00
      008266 CD 84 1C         [ 4]  174 	call	_setDisplayTestMode
      008269 5B 03            [ 2]  175 	addw	sp, #3
      00826B                        176 00102$:
                                    177 ;	./ts.c: 54: if (getMenuDisplay() == MENU_ROOT) {
      00826B CD 8C 55         [ 4]  178 	call	_getMenuDisplay
      00826E 6B 0B            [ 1]  179 	ld	(0x0b, sp), a
      008270 26 5B            [ 1]  180 	jrne	00120$
                                    181 ;	./ts.c: 55: int temp = getTemperature();
      008272 CD 8A FE         [ 4]  182 	call	_getTemperature
      008275 1F 08            [ 2]  183 	ldw	(0x08, sp), x
                                    184 ;	./ts.c: 56: itofpa (temp, (char*) stringBuffer, 0);
      008277 AE 00 01         [ 2]  185 	ldw	x, #(_main_stringBuffer_65536_13 + 0)
      00827A 4B 00            [ 1]  186 	push	#0x00
      00827C 89               [ 2]  187 	pushw	x
      00827D 1E 0B            [ 2]  188 	ldw	x, (0x0b, sp)
      00827F 89               [ 2]  189 	pushw	x
      008280 CD 91 F0         [ 4]  190 	call	_itofpa
      008283 5B 05            [ 2]  191 	addw	sp, #5
                                    192 ;	./ts.c: 57: setDisplayStr ( (char*) stringBuffer);
      008285 AE 00 01         [ 2]  193 	ldw	x, #(_main_stringBuffer_65536_13 + 0)
      008288 89               [ 2]  194 	pushw	x
      008289 CD 84 65         [ 4]  195 	call	_setDisplayStr
      00828C 5B 02            [ 2]  196 	addw	sp, #2
                                    197 ;	./ts.c: 59: if (getParamById (PARAM_OVERHEAT_INDICATION) ) {
      00828E 4B 06            [ 1]  198 	push	#0x06
      008290 CD 8F 8F         [ 4]  199 	call	_getParamById
      008293 84               [ 1]  200 	pop	a
      008294 5D               [ 2]  201 	tnzw	x
      008295 26 03            [ 1]  202 	jrne	00174$
      008297 CC 83 4E         [ 2]  203 	jp	00121$
      00829A                        204 00174$:
                                    205 ;	./ts.c: 60: if (temp < getParamById (PARAM_MIN_TEMPERATURE) ) {
      00829A 4B 03            [ 1]  206 	push	#0x03
      00829C CD 8F 8F         [ 4]  207 	call	_getParamById
      00829F 84               [ 1]  208 	pop	a
      0082A0 1F 0A            [ 2]  209 	ldw	(0x0a, sp), x
      0082A2 1E 08            [ 2]  210 	ldw	x, (0x08, sp)
      0082A4 13 0A            [ 2]  211 	cpw	x, (0x0a, sp)
      0082A6 2E 0C            [ 1]  212 	jrsge	00106$
                                    213 ;	./ts.c: 61: setDisplayStr ("LLL");
      0082A8 4B 89            [ 1]  214 	push	#<(___str_1 + 0)
      0082AA 4B 80            [ 1]  215 	push	#((___str_1 + 0) >> 8)
      0082AC CD 84 65         [ 4]  216 	call	_setDisplayStr
      0082AF 5B 02            [ 2]  217 	addw	sp, #2
      0082B1 CC 83 4E         [ 2]  218 	jp	00121$
      0082B4                        219 00106$:
                                    220 ;	./ts.c: 62: } else if (temp > getParamById (PARAM_MAX_TEMPERATURE) ) {
      0082B4 4B 02            [ 1]  221 	push	#0x02
      0082B6 CD 8F 8F         [ 4]  222 	call	_getParamById
      0082B9 84               [ 1]  223 	pop	a
      0082BA 13 08            [ 2]  224 	cpw	x, (0x08, sp)
      0082BC 2F 03            [ 1]  225 	jrslt	00176$
      0082BE CC 83 4E         [ 2]  226 	jp	00121$
      0082C1                        227 00176$:
                                    228 ;	./ts.c: 63: setDisplayStr ("HHH");
      0082C1 4B 8D            [ 1]  229 	push	#<(___str_2 + 0)
      0082C3 4B 80            [ 1]  230 	push	#((___str_2 + 0) >> 8)
      0082C5 CD 84 65         [ 4]  231 	call	_setDisplayStr
      0082C8 5B 02            [ 2]  232 	addw	sp, #2
      0082CA CC 83 4E         [ 2]  233 	jp	00121$
      0082CD                        234 00120$:
                                    235 ;	./ts.c: 66: } else if (getMenuDisplay() == MENU_SET_THRESHOLD) {
      0082CD CD 8C 55         [ 4]  236 	call	_getMenuDisplay
      0082D0 4A               [ 1]  237 	dec	a
      0082D1 26 16            [ 1]  238 	jrne	00117$
                                    239 ;	./ts.c: 67: paramToString (PARAM_THRESHOLD, (char*) stringBuffer);
      0082D3 AE 00 01         [ 2]  240 	ldw	x, #(_main_stringBuffer_65536_13 + 0)
      0082D6 89               [ 2]  241 	pushw	x
      0082D7 4B 09            [ 1]  242 	push	#0x09
      0082D9 CD 90 81         [ 4]  243 	call	_paramToString
      0082DC 5B 03            [ 2]  244 	addw	sp, #3
                                    245 ;	./ts.c: 68: setDisplayStr ( (char*) stringBuffer);
      0082DE AE 00 01         [ 2]  246 	ldw	x, #(_main_stringBuffer_65536_13 + 0)
      0082E1 89               [ 2]  247 	pushw	x
      0082E2 CD 84 65         [ 4]  248 	call	_setDisplayStr
      0082E5 5B 02            [ 2]  249 	addw	sp, #2
      0082E7 20 65            [ 2]  250 	jra	00121$
      0082E9                        251 00117$:
                                    252 ;	./ts.c: 69: } else if (getMenuDisplay() == MENU_SELECT_PARAM) {
      0082E9 CD 8C 55         [ 4]  253 	call	_getMenuDisplay
      0082EC A1 02            [ 1]  254 	cp	a, #0x02
      0082EE 26 14            [ 1]  255 	jrne	00114$
                                    256 ;	./ts.c: 70: paramMsg[1] = '0' + getParamId();
      0082F0 CD 90 4F         [ 4]  257 	call	_getParamId
      0082F3 AB 30            [ 1]  258 	add	a, #0x30
      0082F5 1E 06            [ 2]  259 	ldw	x, (0x06, sp)
      0082F7 F7               [ 1]  260 	ld	(x), a
                                    261 ;	./ts.c: 71: setDisplayStr ( (unsigned char*) &paramMsg);
      0082F8 96               [ 1]  262 	ldw	x, sp
      0082F9 1C 00 03         [ 2]  263 	addw	x, #3
      0082FC 89               [ 2]  264 	pushw	x
      0082FD CD 84 65         [ 4]  265 	call	_setDisplayStr
      008300 5B 02            [ 2]  266 	addw	sp, #2
      008302 20 4A            [ 2]  267 	jra	00121$
      008304                        268 00114$:
                                    269 ;	./ts.c: 72: } else if (getMenuDisplay() == MENU_CHANGE_PARAM) {
      008304 CD 8C 55         [ 4]  270 	call	_getMenuDisplay
      008307 A1 03            [ 1]  271 	cp	a, #0x03
      008309 26 26            [ 1]  272 	jrne	00111$
                                    273 ;	./ts.c: 73: paramToString (getParamId(), (char*) stringBuffer);
      00830B AE 00 01         [ 2]  274 	ldw	x, #(_main_stringBuffer_65536_13 + 0)
      00830E 1F 01            [ 2]  275 	ldw	(0x01, sp), x
      008310 90 93            [ 1]  276 	ldw	y, x
      008312 17 09            [ 2]  277 	ldw	(0x09, sp), y
      008314 CD 90 4F         [ 4]  278 	call	_getParamId
      008317 6B 0B            [ 1]  279 	ld	(0x0b, sp), a
      008319 1E 09            [ 2]  280 	ldw	x, (0x09, sp)
      00831B 89               [ 2]  281 	pushw	x
      00831C 7B 0D            [ 1]  282 	ld	a, (0x0d, sp)
      00831E 88               [ 1]  283 	push	a
      00831F CD 90 81         [ 4]  284 	call	_paramToString
      008322 5B 03            [ 2]  285 	addw	sp, #3
                                    286 ;	./ts.c: 74: setDisplayStr ( (char *) stringBuffer);
      008324 AE 00 01         [ 2]  287 	ldw	x, #(_main_stringBuffer_65536_13 + 0)
      008327 1F 0A            [ 2]  288 	ldw	(0x0a, sp), x
      008329 89               [ 2]  289 	pushw	x
      00832A CD 84 65         [ 4]  290 	call	_setDisplayStr
      00832D 5B 02            [ 2]  291 	addw	sp, #2
      00832F 20 1D            [ 2]  292 	jra	00121$
      008331                        293 00111$:
                                    294 ;	./ts.c: 76: setDisplayStr ("ERR");
      008331 4B 91            [ 1]  295 	push	#<(___str_3 + 0)
      008333 4B 80            [ 1]  296 	push	#((___str_3 + 0) >> 8)
      008335 CD 84 65         [ 4]  297 	call	_setDisplayStr
      008338 5B 02            [ 2]  298 	addw	sp, #2
                                    299 ;	./ts.c: 77: setDisplayOff ( (bool) (getUptime() & 0x40) );
      00833A CD 88 87         [ 4]  300 	call	_getUptime
      00833D 1F 0A            [ 2]  301 	ldw	(0x0a, sp), x
      00833F 17 08            [ 2]  302 	ldw	(0x08, sp), y
      008341 7B 0B            [ 1]  303 	ld	a, (0x0b, sp)
      008343 48               [ 1]  304 	sll	a
      008344 48               [ 1]  305 	sll	a
      008345 4F               [ 1]  306 	clr	a
      008346 49               [ 1]  307 	rlc	a
      008347 6B 0B            [ 1]  308 	ld	(0x0b, sp), a
      008349 88               [ 1]  309 	push	a
      00834A CD 84 43         [ 4]  310 	call	_setDisplayOff
      00834D 84               [ 1]  311 	pop	a
      00834E                        312 00121$:
                                    313 ;	./ts.c: 80: WAIT_FOR_INTERRUPT
      00834E 8F               [10]  314 	wfi	
                                    315 ;	./ts.c: 82: }
      00834F CC 82 5A         [ 2]  316 	jp	00123$
                                    317 	.area CODE
                                    318 	.area CONST
                                    319 	.area CONST
      008088                        320 ___str_0:
      008088 00                     321 	.db 0x00
                                    322 	.area CODE
                                    323 	.area CONST
      008089                        324 ___str_1:
      008089 4C 4C 4C               325 	.ascii "LLL"
      00808C 00                     326 	.db 0x00
                                    327 	.area CODE
                                    328 	.area CONST
      00808D                        329 ___str_2:
      00808D 48 48 48               330 	.ascii "HHH"
      008090 00                     331 	.db 0x00
                                    332 	.area CODE
                                    333 	.area CONST
      008091                        334 ___str_3:
      008091 45 52 52               335 	.ascii "ERR"
      008094 00                     336 	.db 0x00
                                    337 	.area CODE
                                    338 	.area INITIALIZER
                                    339 	.area CABS (ABS)

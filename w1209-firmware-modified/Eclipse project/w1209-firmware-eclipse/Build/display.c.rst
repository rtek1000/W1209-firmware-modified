                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module display
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _Hex2CharMap
                                     12 	.globl _setDisplayDot
                                     13 	.globl _initDisplay
                                     14 	.globl _refreshDisplay
                                     15 	.globl _setDisplayTestMode
                                     16 	.globl _setDisplayOff
                                     17 	.globl _setDisplayStr
                                     18 ;--------------------------------------------------------
                                     19 ; ram data
                                     20 ;--------------------------------------------------------
                                     21 	.area DATA
      00000F                         22 _activeDigitId:
      00000F                         23 	.ds 1
      000010                         24 _displayAC:
      000010                         25 	.ds 3
      000013                         26 _displayD:
      000013                         27 	.ds 3
      000016                         28 _displayOff:
      000016                         29 	.ds 1
      000017                         30 _testMode:
      000017                         31 	.ds 1
                                     32 ;--------------------------------------------------------
                                     33 ; ram data
                                     34 ;--------------------------------------------------------
                                     35 	.area INITIALIZED
                                     36 ;--------------------------------------------------------
                                     37 ; absolute external ram data
                                     38 ;--------------------------------------------------------
                                     39 	.area DABS (ABS)
                                     40 
                                     41 ; default segment ordering for linker
                                     42 	.area HOME
                                     43 	.area GSINIT
                                     44 	.area GSFINAL
                                     45 	.area CONST
                                     46 	.area INITIALIZER
                                     47 	.area CODE
                                     48 
                                     49 ;--------------------------------------------------------
                                     50 ; global & static initialisations
                                     51 ;--------------------------------------------------------
                                     52 	.area HOME
                                     53 	.area GSINIT
                                     54 	.area GSFINAL
                                     55 	.area GSINIT
                                     56 ;--------------------------------------------------------
                                     57 ; Home
                                     58 ;--------------------------------------------------------
                                     59 	.area HOME
                                     60 	.area HOME
                                     61 ;--------------------------------------------------------
                                     62 ; code
                                     63 ;--------------------------------------------------------
                                     64 	.area CODE
                                     65 ;	./display.c: 86: void initDisplay()
                                     66 ;	-----------------------------------------
                                     67 ;	 function initDisplay
                                     68 ;	-----------------------------------------
      008352                         69 _initDisplay:
                                     70 ;	./display.c: 88: PA_DDR |= SSD_SEG_B_BIT | SSD_SEG_F_BIT;
      008352 C6 50 02         [ 1]   71 	ld	a, 0x5002
      008355 AA 06            [ 1]   72 	or	a, #0x06
      008357 C7 50 02         [ 1]   73 	ld	0x5002, a
                                     74 ;	./display.c: 89: PA_CR1 |= SSD_SEG_B_BIT | SSD_SEG_F_BIT;
      00835A C6 50 03         [ 1]   75 	ld	a, 0x5003
      00835D AA 06            [ 1]   76 	or	a, #0x06
      00835F C7 50 03         [ 1]   77 	ld	0x5003, a
                                     78 ;	./display.c: 90: PB_DDR |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
      008362 C6 50 07         [ 1]   79 	ld	a, 0x5007
      008365 AA 30            [ 1]   80 	or	a, #0x30
      008367 C7 50 07         [ 1]   81 	ld	0x5007, a
                                     82 ;	./display.c: 91: PB_CR1 |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
      00836A C6 50 08         [ 1]   83 	ld	a, 0x5008
      00836D AA 30            [ 1]   84 	or	a, #0x30
      00836F C7 50 08         [ 1]   85 	ld	0x5008, a
                                     86 ;	./display.c: 92: PC_DDR |= SSD_SEG_C_BIT | SSD_SEG_G_BIT;
      008372 C6 50 0C         [ 1]   87 	ld	a, 0x500c
      008375 AA C0            [ 1]   88 	or	a, #0xc0
      008377 C7 50 0C         [ 1]   89 	ld	0x500c, a
                                     90 ;	./display.c: 93: PC_CR1 |= SSD_SEG_C_BIT | SSD_SEG_G_BIT;
      00837A C6 50 0D         [ 1]   91 	ld	a, 0x500d
      00837D AA C0            [ 1]   92 	or	a, #0xc0
      00837F C7 50 0D         [ 1]   93 	ld	0x500d, a
                                     94 ;	./display.c: 94: PD_DDR |= SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT | SSD_SEG_P_BIT | SSD_DIGIT_3_BIT;
      008382 C6 50 11         [ 1]   95 	ld	a, 0x5011
      008385 AA 3E            [ 1]   96 	or	a, #0x3e
      008387 C7 50 11         [ 1]   97 	ld	0x5011, a
                                     98 ;	./display.c: 95: PD_CR1 |= SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT | SSD_SEG_P_BIT | SSD_DIGIT_3_BIT;
      00838A C6 50 12         [ 1]   99 	ld	a, 0x5012
      00838D AA 3E            [ 1]  100 	or	a, #0x3e
      00838F C7 50 12         [ 1]  101 	ld	0x5012, a
                                    102 ;	./display.c: 96: displayOff = false;
      008392 72 5F 00 16      [ 1]  103 	clr	_displayOff+0
                                    104 ;	./display.c: 97: activeDigitId = 0;
      008396 72 5F 00 0F      [ 1]  105 	clr	_activeDigitId+0
                                    106 ;	./display.c: 98: setDisplayTestMode (true, "");
      00839A 4B A5            [ 1]  107 	push	#<(___str_0 + 0)
      00839C 4B 80            [ 1]  108 	push	#((___str_0 + 0) >> 8)
      00839E 4B 01            [ 1]  109 	push	#0x01
      0083A0 CD 84 1C         [ 4]  110 	call	_setDisplayTestMode
      0083A3 5B 03            [ 2]  111 	addw	sp, #3
                                    112 ;	./display.c: 99: }
      0083A5 81               [ 4]  113 	ret
                                    114 ;	./display.c: 107: void refreshDisplay()
                                    115 ;	-----------------------------------------
                                    116 ;	 function refreshDisplay
                                    117 ;	-----------------------------------------
      0083A6                        118 _refreshDisplay:
      0083A6 88               [ 1]  119 	push	a
                                    120 ;	./display.c: 109: enableDigit (3);
      0083A7 4B 03            [ 1]  121 	push	#0x03
      0083A9 CD 85 12         [ 4]  122 	call	_enableDigit
      0083AC 84               [ 1]  123 	pop	a
                                    124 ;	./display.c: 111: if (displayOff) {
      0083AD 72 00 00 16 02   [ 2]  125 	btjt	_displayOff+0, #0, 00118$
      0083B2 20 02            [ 2]  126 	jra	00102$
      0083B4                        127 00118$:
                                    128 ;	./display.c: 112: return;
      0083B4 20 64            [ 2]  129 	jra	00106$
      0083B6                        130 00102$:
                                    131 ;	./display.c: 115: SSD_SEG_BF_PORT &= ~SSD_BF_PORT_MASK;
      0083B6 C6 50 00         [ 1]  132 	ld	a, 0x5000
      0083B9 A4 F9            [ 1]  133 	and	a, #0xf9
                                    134 ;	./display.c: 116: SSD_SEG_BF_PORT |= displayAC[activeDigitId] & SSD_BF_PORT_MASK;
      0083BB C7 50 00         [ 1]  135 	ld	0x5000, a
      0083BE 6B 01            [ 1]  136 	ld	(0x01, sp), a
      0083C0 5F               [ 1]  137 	clrw	x
      0083C1 C6 00 0F         [ 1]  138 	ld	a, _activeDigitId+0
      0083C4 97               [ 1]  139 	ld	xl, a
      0083C5 1C 00 10         [ 2]  140 	addw	x, #(_displayAC + 0)
      0083C8 F6               [ 1]  141 	ld	a, (x)
      0083C9 A4 06            [ 1]  142 	and	a, #0x06
      0083CB 1A 01            [ 1]  143 	or	a, (0x01, sp)
      0083CD C7 50 00         [ 1]  144 	ld	0x5000, a
                                    145 ;	./display.c: 117: SSD_SEG_CG_PORT &= ~SSD_CG_PORT_MASK;
      0083D0 C6 50 0A         [ 1]  146 	ld	a, 0x500a
      0083D3 A4 3F            [ 1]  147 	and	a, #0x3f
                                    148 ;	./display.c: 118: SSD_SEG_CG_PORT |= displayAC[activeDigitId] & SSD_CG_PORT_MASK;
      0083D5 C7 50 0A         [ 1]  149 	ld	0x500a, a
      0083D8 6B 01            [ 1]  150 	ld	(0x01, sp), a
      0083DA 5F               [ 1]  151 	clrw	x
      0083DB C6 00 0F         [ 1]  152 	ld	a, _activeDigitId+0
      0083DE 97               [ 1]  153 	ld	xl, a
      0083DF 1C 00 10         [ 2]  154 	addw	x, #(_displayAC + 0)
      0083E2 F6               [ 1]  155 	ld	a, (x)
      0083E3 A4 C0            [ 1]  156 	and	a, #0xc0
      0083E5 1A 01            [ 1]  157 	or	a, (0x01, sp)
      0083E7 C7 50 0A         [ 1]  158 	ld	0x500a, a
                                    159 ;	./display.c: 119: SSD_SEG_AEDP_PORT &= ~SSD_AEDP_PORT_MASK;
      0083EA C6 50 0F         [ 1]  160 	ld	a, 0x500f
      0083ED A4 D1            [ 1]  161 	and	a, #0xd1
                                    162 ;	./display.c: 120: SSD_SEG_AEDP_PORT |= displayD[activeDigitId];
      0083EF C7 50 0F         [ 1]  163 	ld	0x500f, a
      0083F2 6B 01            [ 1]  164 	ld	(0x01, sp), a
      0083F4 5F               [ 1]  165 	clrw	x
      0083F5 C6 00 0F         [ 1]  166 	ld	a, _activeDigitId+0
      0083F8 97               [ 1]  167 	ld	xl, a
      0083F9 1C 00 13         [ 2]  168 	addw	x, #(_displayD + 0)
      0083FC F6               [ 1]  169 	ld	a, (x)
      0083FD 1A 01            [ 1]  170 	or	a, (0x01, sp)
      0083FF C7 50 0F         [ 1]  171 	ld	0x500f, a
                                    172 ;	./display.c: 121: enableDigit (activeDigitId);
      008402 3B 00 0F         [ 1]  173 	push	_activeDigitId+0
      008405 CD 85 12         [ 4]  174 	call	_enableDigit
      008408 84               [ 1]  175 	pop	a
                                    176 ;	./display.c: 123: if (activeDigitId > 1) {
      008409 C6 00 0F         [ 1]  177 	ld	a, _activeDigitId+0
      00840C A1 01            [ 1]  178 	cp	a, #0x01
      00840E 23 06            [ 2]  179 	jrule	00104$
                                    180 ;	./display.c: 124: activeDigitId = 0;
      008410 72 5F 00 0F      [ 1]  181 	clr	_activeDigitId+0
      008414 20 04            [ 2]  182 	jra	00106$
      008416                        183 00104$:
                                    184 ;	./display.c: 126: activeDigitId++;
      008416 72 5C 00 0F      [ 1]  185 	inc	_activeDigitId+0
      00841A                        186 00106$:
                                    187 ;	./display.c: 128: }
      00841A 84               [ 1]  188 	pop	a
      00841B 81               [ 4]  189 	ret
                                    190 ;	./display.c: 137: void setDisplayTestMode (bool val, char* str)
                                    191 ;	-----------------------------------------
                                    192 ;	 function setDisplayTestMode
                                    193 ;	-----------------------------------------
      00841C                        194 _setDisplayTestMode:
                                    195 ;	./display.c: 139: if (!testMode && val) {
      00841C 72 01 00 17 02   [ 2]  196 	btjf	_testMode+0, #0, 00124$
      008421 20 1A            [ 2]  197 	jra	00105$
      008423                        198 00124$:
      008423 0D 03            [ 1]  199 	tnz	(0x03, sp)
      008425 27 16            [ 1]  200 	jreq	00105$
                                    201 ;	./display.c: 140: if (*str == 0) {
      008427 1E 04            [ 2]  202 	ldw	x, (0x04, sp)
      008429 F6               [ 1]  203 	ld	a, (x)
      00842A 26 0B            [ 1]  204 	jrne	00102$
                                    205 ;	./display.c: 141: setDisplayStr ("888");
      00842C 4B A6            [ 1]  206 	push	#<(___str_1 + 0)
      00842E 4B 80            [ 1]  207 	push	#((___str_1 + 0) >> 8)
      008430 CD 84 65         [ 4]  208 	call	_setDisplayStr
      008433 5B 02            [ 2]  209 	addw	sp, #2
      008435 20 06            [ 2]  210 	jra	00105$
      008437                        211 00102$:
                                    212 ;	./display.c: 143: setDisplayStr (str);
      008437 89               [ 2]  213 	pushw	x
      008438 CD 84 65         [ 4]  214 	call	_setDisplayStr
      00843B 5B 02            [ 2]  215 	addw	sp, #2
      00843D                        216 00105$:
                                    217 ;	./display.c: 147: testMode = val;
      00843D 7B 03            [ 1]  218 	ld	a, (0x03, sp)
      00843F C7 00 17         [ 1]  219 	ld	_testMode+0, a
                                    220 ;	./display.c: 148: }
      008442 81               [ 4]  221 	ret
                                    222 ;	./display.c: 155: void setDisplayOff (bool val)
                                    223 ;	-----------------------------------------
                                    224 ;	 function setDisplayOff
                                    225 ;	-----------------------------------------
      008443                        226 _setDisplayOff:
                                    227 ;	./display.c: 157: displayOff = val;
      008443 7B 03            [ 1]  228 	ld	a, (0x03, sp)
      008445 C7 00 16         [ 1]  229 	ld	_displayOff+0, a
                                    230 ;	./display.c: 158: }
      008448 81               [ 4]  231 	ret
                                    232 ;	./display.c: 168: void setDisplayDot (unsigned char id, bool val)
                                    233 ;	-----------------------------------------
                                    234 ;	 function setDisplayDot
                                    235 ;	-----------------------------------------
      008449                        236 _setDisplayDot:
                                    237 ;	./display.c: 170: if (val) {
      008449 0D 04            [ 1]  238 	tnz	(0x04, sp)
      00844B 27 0C            [ 1]  239 	jreq	00102$
                                    240 ;	./display.c: 171: displayD[id] |= SSD_SEG_P_BIT;
      00844D 5F               [ 1]  241 	clrw	x
      00844E 7B 03            [ 1]  242 	ld	a, (0x03, sp)
      008450 97               [ 1]  243 	ld	xl, a
      008451 1C 00 13         [ 2]  244 	addw	x, #(_displayD + 0)
      008454 F6               [ 1]  245 	ld	a, (x)
      008455 AA 04            [ 1]  246 	or	a, #0x04
      008457 F7               [ 1]  247 	ld	(x), a
      008458 81               [ 4]  248 	ret
      008459                        249 00102$:
                                    250 ;	./display.c: 173: displayD[id] &= ~SSD_SEG_P_BIT;
      008459 5F               [ 1]  251 	clrw	x
      00845A 7B 03            [ 1]  252 	ld	a, (0x03, sp)
      00845C 97               [ 1]  253 	ld	xl, a
      00845D 1C 00 13         [ 2]  254 	addw	x, #(_displayD + 0)
      008460 F6               [ 1]  255 	ld	a, (x)
      008461 A4 FB            [ 1]  256 	and	a, #0xfb
      008463 F7               [ 1]  257 	ld	(x), a
                                    258 ;	./display.c: 175: }
      008464 81               [ 4]  259 	ret
                                    260 ;	./display.c: 182: void setDisplayStr (const unsigned char* val)
                                    261 ;	-----------------------------------------
                                    262 ;	 function setDisplayStr
                                    263 ;	-----------------------------------------
      008465                        264 _setDisplayStr:
      008465 52 06            [ 2]  265 	sub	sp, #6
                                    266 ;	./display.c: 187: for (i = 0, d = 0; * (val + i) != 0; i++, d++) {
      008467 0F 06            [ 1]  267 	clr	(0x06, sp)
      008469 0F 05            [ 1]  268 	clr	(0x05, sp)
      00846B                        269 00114$:
      00846B 5F               [ 1]  270 	clrw	x
      00846C 7B 05            [ 1]  271 	ld	a, (0x05, sp)
      00846E 97               [ 1]  272 	ld	xl, a
      00846F 72 FB 09         [ 2]  273 	addw	x, (0x09, sp)
      008472 F6               [ 1]  274 	ld	a, (x)
      008473 27 18            [ 1]  275 	jreq	00105$
                                    276 ;	./display.c: 188: if (* (val + i) == '.' && i > 0 && * (val + i - 1) != '.') d--;
      008475 A1 2E            [ 1]  277 	cp	a, #0x2e
      008477 26 0E            [ 1]  278 	jrne	00115$
      008479 0D 05            [ 1]  279 	tnz	(0x05, sp)
      00847B 27 0A            [ 1]  280 	jreq	00115$
      00847D 1C FF FF         [ 2]  281 	addw	x, #0xffff
      008480 F6               [ 1]  282 	ld	a, (x)
      008481 A1 2E            [ 1]  283 	cp	a, #0x2e
      008483 27 02            [ 1]  284 	jreq	00115$
      008485 0A 06            [ 1]  285 	dec	(0x06, sp)
      008487                        286 00115$:
                                    287 ;	./display.c: 187: for (i = 0, d = 0; * (val + i) != 0; i++, d++) {
      008487 0C 05            [ 1]  288 	inc	(0x05, sp)
      008489 0C 06            [ 1]  289 	inc	(0x06, sp)
      00848B 20 DE            [ 2]  290 	jra	00114$
      00848D                        291 00105$:
                                    292 ;	./display.c: 193: if (d > 3) {
      00848D 7B 06            [ 1]  293 	ld	a, (0x06, sp)
      00848F A1 03            [ 1]  294 	cp	a, #0x03
      008491 23 04            [ 2]  295 	jrule	00107$
                                    296 ;	./display.c: 194: d = 3;
      008493 A6 03            [ 1]  297 	ld	a, #0x03
      008495 6B 06            [ 1]  298 	ld	(0x06, sp), a
      008497                        299 00107$:
                                    300 ;	./display.c: 198: for (i = 3 - d; i > 0; i--) {
      008497 7B 06            [ 1]  301 	ld	a, (0x06, sp)
      008499 6B 05            [ 1]  302 	ld	(0x05, sp), a
      00849B A6 03            [ 1]  303 	ld	a, #0x03
      00849D 10 05            [ 1]  304 	sub	a, (0x05, sp)
      00849F 6B 05            [ 1]  305 	ld	(0x05, sp), a
      0084A1                        306 00117$:
      0084A1 0D 05            [ 1]  307 	tnz	(0x05, sp)
      0084A3 27 16            [ 1]  308 	jreq	00108$
                                    309 ;	./display.c: 199: setDigit (3 - i, ' ', false);
      0084A5 7B 05            [ 1]  310 	ld	a, (0x05, sp)
      0084A7 6B 04            [ 1]  311 	ld	(0x04, sp), a
      0084A9 A6 03            [ 1]  312 	ld	a, #0x03
      0084AB 10 04            [ 1]  313 	sub	a, (0x04, sp)
      0084AD 4B 00            [ 1]  314 	push	#0x00
      0084AF 4B 20            [ 1]  315 	push	#0x20
      0084B1 88               [ 1]  316 	push	a
      0084B2 CD 85 63         [ 4]  317 	call	_setDigit
      0084B5 5B 03            [ 2]  318 	addw	sp, #3
                                    319 ;	./display.c: 198: for (i = 3 - d; i > 0; i--) {
      0084B7 0A 05            [ 1]  320 	dec	(0x05, sp)
      0084B9 20 E6            [ 2]  321 	jra	00117$
      0084BB                        322 00108$:
                                    323 ;	./display.c: 203: for (i = 0; d != 0 && *val + i != 0; i++, d--) {
      0084BB 0F 05            [ 1]  324 	clr	(0x05, sp)
      0084BD                        325 00121$:
      0084BD 0D 06            [ 1]  326 	tnz	(0x06, sp)
      0084BF 27 4E            [ 1]  327 	jreq	00123$
      0084C1 16 09            [ 2]  328 	ldw	y, (0x09, sp)
      0084C3 17 01            [ 2]  329 	ldw	(0x01, sp), y
      0084C5 93               [ 1]  330 	ldw	x, y
      0084C6 F6               [ 1]  331 	ld	a, (x)
      0084C7 6B 04            [ 1]  332 	ld	(0x04, sp), a
      0084C9 0F 03            [ 1]  333 	clr	(0x03, sp)
      0084CB 7B 05            [ 1]  334 	ld	a, (0x05, sp)
      0084CD 5F               [ 1]  335 	clrw	x
      0084CE 97               [ 1]  336 	ld	xl, a
      0084CF 72 FB 03         [ 2]  337 	addw	x, (0x03, sp)
      0084D2 5D               [ 2]  338 	tnzw	x
      0084D3 27 3A            [ 1]  339 	jreq	00123$
                                    340 ;	./display.c: 204: if (* (val + i + 1) == '.') {
      0084D5 5F               [ 1]  341 	clrw	x
      0084D6 7B 05            [ 1]  342 	ld	a, (0x05, sp)
      0084D8 97               [ 1]  343 	ld	xl, a
      0084D9 72 FB 01         [ 2]  344 	addw	x, (0x01, sp)
      0084DC 90 93            [ 1]  345 	ldw	y, x
      0084DE 90 E6 01         [ 1]  346 	ld	a, (0x1, y)
      0084E1 6B 04            [ 1]  347 	ld	(0x04, sp), a
                                    348 ;	./display.c: 205: setDigit (d - 1, * (val + i), true);
      0084E3 F6               [ 1]  349 	ld	a, (x)
      0084E4 97               [ 1]  350 	ld	xl, a
      0084E5 7B 06            [ 1]  351 	ld	a, (0x06, sp)
      0084E7 4A               [ 1]  352 	dec	a
      0084E8 95               [ 1]  353 	ld	xh, a
                                    354 ;	./display.c: 204: if (* (val + i + 1) == '.') {
      0084E9 7B 04            [ 1]  355 	ld	a, (0x04, sp)
      0084EB A1 2E            [ 1]  356 	cp	a, #0x2e
      0084ED 26 0F            [ 1]  357 	jrne	00110$
                                    358 ;	./display.c: 205: setDigit (d - 1, * (val + i), true);
      0084EF 4B 01            [ 1]  359 	push	#0x01
      0084F1 9F               [ 1]  360 	ld	a, xl
      0084F2 88               [ 1]  361 	push	a
      0084F3 9E               [ 1]  362 	ld	a, xh
      0084F4 88               [ 1]  363 	push	a
      0084F5 CD 85 63         [ 4]  364 	call	_setDigit
      0084F8 5B 03            [ 2]  365 	addw	sp, #3
                                    366 ;	./display.c: 206: i++;
      0084FA 0C 05            [ 1]  367 	inc	(0x05, sp)
      0084FC 20 0B            [ 2]  368 	jra	00122$
      0084FE                        369 00110$:
                                    370 ;	./display.c: 208: setDigit (d - 1, * (val + i), false);
      0084FE 4B 00            [ 1]  371 	push	#0x00
      008500 9F               [ 1]  372 	ld	a, xl
      008501 88               [ 1]  373 	push	a
      008502 9E               [ 1]  374 	ld	a, xh
      008503 88               [ 1]  375 	push	a
      008504 CD 85 63         [ 4]  376 	call	_setDigit
      008507 5B 03            [ 2]  377 	addw	sp, #3
      008509                        378 00122$:
                                    379 ;	./display.c: 203: for (i = 0; d != 0 && *val + i != 0; i++, d--) {
      008509 0C 05            [ 1]  380 	inc	(0x05, sp)
      00850B 0A 06            [ 1]  381 	dec	(0x06, sp)
      00850D 20 AE            [ 2]  382 	jra	00121$
      00850F                        383 00123$:
                                    384 ;	./display.c: 211: }
      00850F 5B 06            [ 2]  385 	addw	sp, #6
      008511 81               [ 4]  386 	ret
                                    387 ;	./display.c: 221: static void enableDigit (unsigned char id)
                                    388 ;	-----------------------------------------
                                    389 ;	 function enableDigit
                                    390 ;	-----------------------------------------
      008512                        391 _enableDigit:
                                    392 ;	./display.c: 223: switch (id) {
      008512 7B 03            [ 1]  393 	ld	a, (0x03, sp)
      008514 A1 00            [ 1]  394 	cp	a, #0x00
      008516 27 0D            [ 1]  395 	jreq	00101$
      008518 7B 03            [ 1]  396 	ld	a, (0x03, sp)
      00851A 4A               [ 1]  397 	dec	a
      00851B 27 1A            [ 1]  398 	jreq	00102$
      00851D 7B 03            [ 1]  399 	ld	a, (0x03, sp)
      00851F A1 02            [ 1]  400 	cp	a, #0x02
      008521 27 26            [ 1]  401 	jreq	00103$
      008523 20 31            [ 2]  402 	jra	00104$
                                    403 ;	./display.c: 224: case 0:
      008525                        404 00101$:
                                    405 ;	./display.c: 225: SSD_DIGIT_12_PORT &= ~SSD_DIGIT_1_BIT;
      008525 C6 50 05         [ 1]  406 	ld	a, 0x5005
      008528 A4 EF            [ 1]  407 	and	a, #0xef
                                    408 ;	./display.c: 226: SSD_DIGIT_12_PORT |= SSD_DIGIT_2_BIT;
      00852A C7 50 05         [ 1]  409 	ld	0x5005, a
      00852D AA 20            [ 1]  410 	or	a, #0x20
      00852F C7 50 05         [ 1]  411 	ld	0x5005, a
                                    412 ;	./display.c: 227: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
      008532 72 18 50 0F      [ 1]  413 	bset	20495, #4
                                    414 ;	./display.c: 228: break;
      008536 81               [ 4]  415 	ret
                                    416 ;	./display.c: 230: case 1:
      008537                        417 00102$:
                                    418 ;	./display.c: 231: SSD_DIGIT_12_PORT &= ~SSD_DIGIT_2_BIT;
      008537 C6 50 05         [ 1]  419 	ld	a, 0x5005
      00853A A4 DF            [ 1]  420 	and	a, #0xdf
                                    421 ;	./display.c: 232: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT;
      00853C C7 50 05         [ 1]  422 	ld	0x5005, a
      00853F AA 10            [ 1]  423 	or	a, #0x10
      008541 C7 50 05         [ 1]  424 	ld	0x5005, a
                                    425 ;	./display.c: 233: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
      008544 72 18 50 0F      [ 1]  426 	bset	20495, #4
                                    427 ;	./display.c: 234: break;
      008548 81               [ 4]  428 	ret
                                    429 ;	./display.c: 236: case 2:
      008549                        430 00103$:
                                    431 ;	./display.c: 237: SSD_DIGIT_3_PORT &= ~SSD_DIGIT_3_BIT;
      008549 72 19 50 0F      [ 1]  432 	bres	20495, #4
                                    433 ;	./display.c: 238: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
      00854D C6 50 05         [ 1]  434 	ld	a, 0x5005
      008550 AA 30            [ 1]  435 	or	a, #0x30
      008552 C7 50 05         [ 1]  436 	ld	0x5005, a
                                    437 ;	./display.c: 239: break;
      008555 81               [ 4]  438 	ret
                                    439 ;	./display.c: 241: default:
      008556                        440 00104$:
                                    441 ;	./display.c: 242: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
      008556 C6 50 05         [ 1]  442 	ld	a, 0x5005
      008559 AA 30            [ 1]  443 	or	a, #0x30
      00855B C7 50 05         [ 1]  444 	ld	0x5005, a
                                    445 ;	./display.c: 243: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
      00855E 72 18 50 0F      [ 1]  446 	bset	20495, #4
                                    447 ;	./display.c: 245: }
                                    448 ;	./display.c: 246: }
      008562 81               [ 4]  449 	ret
                                    450 ;	./display.c: 276: static void setDigit (unsigned char id, unsigned char val, bool dot)
                                    451 ;	-----------------------------------------
                                    452 ;	 function setDigit
                                    453 ;	-----------------------------------------
      008563                        454 _setDigit:
                                    455 ;	./display.c: 279: if (id > 2) return;
      008563 7B 03            [ 1]  456 	ld	a, (0x03, sp)
      008565 A1 02            [ 1]  457 	cp	a, #0x02
      008567 23 01            [ 2]  458 	jrule	00102$
      008569 81               [ 4]  459 	ret
      00856A                        460 00102$:
                                    461 ;	./display.c: 281: if (testMode) return;
      00856A 72 00 00 17 02   [ 2]  462 	btjt	_testMode+0, #0, 00272$
      00856F 20 01            [ 2]  463 	jra	00104$
      008571                        464 00272$:
      008571 81               [ 4]  465 	ret
      008572                        466 00104$:
                                    467 ;	./display.c: 283: switch (val) {
      008572 7B 04            [ 1]  468 	ld	a, (0x04, sp)
      008574 A1 20            [ 1]  469 	cp	a, #0x20
      008576 26 03            [ 1]  470 	jrne	00274$
      008578 CC 86 61         [ 2]  471 	jp	00106$
      00857B                        472 00274$:
      00857B 7B 04            [ 1]  473 	ld	a, (0x04, sp)
      00857D A1 2D            [ 1]  474 	cp	a, #0x2d
      00857F 26 03            [ 1]  475 	jrne	00277$
      008581 CC 86 4D         [ 2]  476 	jp	00105$
      008584                        477 00277$:
      008584 7B 04            [ 1]  478 	ld	a, (0x04, sp)
      008586 A1 30            [ 1]  479 	cp	a, #0x30
      008588 26 03            [ 1]  480 	jrne	00280$
      00858A CC 86 74         [ 2]  481 	jp	00107$
      00858D                        482 00280$:
      00858D 7B 04            [ 1]  483 	ld	a, (0x04, sp)
      00858F A1 31            [ 1]  484 	cp	a, #0x31
      008591 26 03            [ 1]  485 	jrne	00283$
      008593 CC 86 89         [ 2]  486 	jp	00108$
      008596                        487 00283$:
      008596 7B 04            [ 1]  488 	ld	a, (0x04, sp)
      008598 A1 32            [ 1]  489 	cp	a, #0x32
      00859A 26 03            [ 1]  490 	jrne	00286$
      00859C CC 86 9D         [ 2]  491 	jp	00109$
      00859F                        492 00286$:
      00859F 7B 04            [ 1]  493 	ld	a, (0x04, sp)
      0085A1 A1 33            [ 1]  494 	cp	a, #0x33
      0085A3 26 03            [ 1]  495 	jrne	00289$
      0085A5 CC 86 B2         [ 2]  496 	jp	00110$
      0085A8                        497 00289$:
      0085A8 7B 04            [ 1]  498 	ld	a, (0x04, sp)
      0085AA A1 34            [ 1]  499 	cp	a, #0x34
      0085AC 26 03            [ 1]  500 	jrne	00292$
      0085AE CC 86 C7         [ 2]  501 	jp	00111$
      0085B1                        502 00292$:
      0085B1 7B 04            [ 1]  503 	ld	a, (0x04, sp)
      0085B3 A1 35            [ 1]  504 	cp	a, #0x35
      0085B5 26 03            [ 1]  505 	jrne	00295$
      0085B7 CC 86 DB         [ 2]  506 	jp	00112$
      0085BA                        507 00295$:
      0085BA 7B 04            [ 1]  508 	ld	a, (0x04, sp)
      0085BC A1 36            [ 1]  509 	cp	a, #0x36
      0085BE 26 03            [ 1]  510 	jrne	00298$
      0085C0 CC 86 F0         [ 2]  511 	jp	00113$
      0085C3                        512 00298$:
      0085C3 7B 04            [ 1]  513 	ld	a, (0x04, sp)
      0085C5 A1 37            [ 1]  514 	cp	a, #0x37
      0085C7 26 03            [ 1]  515 	jrne	00301$
      0085C9 CC 87 05         [ 2]  516 	jp	00114$
      0085CC                        517 00301$:
      0085CC 7B 04            [ 1]  518 	ld	a, (0x04, sp)
      0085CE A1 38            [ 1]  519 	cp	a, #0x38
      0085D0 26 03            [ 1]  520 	jrne	00304$
      0085D2 CC 87 1A         [ 2]  521 	jp	00115$
      0085D5                        522 00304$:
      0085D5 7B 04            [ 1]  523 	ld	a, (0x04, sp)
      0085D7 A1 39            [ 1]  524 	cp	a, #0x39
      0085D9 26 03            [ 1]  525 	jrne	00307$
      0085DB CC 87 2F         [ 2]  526 	jp	00116$
      0085DE                        527 00307$:
      0085DE 7B 04            [ 1]  528 	ld	a, (0x04, sp)
      0085E0 A1 41            [ 1]  529 	cp	a, #0x41
      0085E2 26 03            [ 1]  530 	jrne	00310$
      0085E4 CC 87 44         [ 2]  531 	jp	00117$
      0085E7                        532 00310$:
      0085E7 7B 04            [ 1]  533 	ld	a, (0x04, sp)
      0085E9 A1 42            [ 1]  534 	cp	a, #0x42
      0085EB 26 03            [ 1]  535 	jrne	00313$
      0085ED CC 87 59         [ 2]  536 	jp	00118$
      0085F0                        537 00313$:
      0085F0 7B 04            [ 1]  538 	ld	a, (0x04, sp)
      0085F2 A1 43            [ 1]  539 	cp	a, #0x43
      0085F4 26 03            [ 1]  540 	jrne	00316$
      0085F6 CC 87 6E         [ 2]  541 	jp	00119$
      0085F9                        542 00316$:
      0085F9 7B 04            [ 1]  543 	ld	a, (0x04, sp)
      0085FB A1 44            [ 1]  544 	cp	a, #0x44
      0085FD 26 03            [ 1]  545 	jrne	00319$
      0085FF CC 87 83         [ 2]  546 	jp	00120$
      008602                        547 00319$:
      008602 7B 04            [ 1]  548 	ld	a, (0x04, sp)
      008604 A1 45            [ 1]  549 	cp	a, #0x45
      008606 26 03            [ 1]  550 	jrne	00322$
      008608 CC 87 98         [ 2]  551 	jp	00121$
      00860B                        552 00322$:
      00860B 7B 04            [ 1]  553 	ld	a, (0x04, sp)
      00860D A1 46            [ 1]  554 	cp	a, #0x46
      00860F 26 03            [ 1]  555 	jrne	00325$
      008611 CC 87 AD         [ 2]  556 	jp	00122$
      008614                        557 00325$:
      008614 7B 04            [ 1]  558 	ld	a, (0x04, sp)
      008616 A1 48            [ 1]  559 	cp	a, #0x48
      008618 26 03            [ 1]  560 	jrne	00328$
      00861A CC 87 C2         [ 2]  561 	jp	00123$
      00861D                        562 00328$:
      00861D 7B 04            [ 1]  563 	ld	a, (0x04, sp)
      00861F A1 4C            [ 1]  564 	cp	a, #0x4c
      008621 26 03            [ 1]  565 	jrne	00331$
      008623 CC 87 D7         [ 2]  566 	jp	00124$
      008626                        567 00331$:
      008626 7B 04            [ 1]  568 	ld	a, (0x04, sp)
      008628 A1 4E            [ 1]  569 	cp	a, #0x4e
      00862A 26 03            [ 1]  570 	jrne	00334$
      00862C CC 87 EB         [ 2]  571 	jp	00125$
      00862F                        572 00334$:
      00862F 7B 04            [ 1]  573 	ld	a, (0x04, sp)
      008631 A1 4F            [ 1]  574 	cp	a, #0x4f
      008633 26 03            [ 1]  575 	jrne	00337$
      008635 CC 87 FF         [ 2]  576 	jp	00126$
      008638                        577 00337$:
      008638 7B 04            [ 1]  578 	ld	a, (0x04, sp)
      00863A A1 50            [ 1]  579 	cp	a, #0x50
      00863C 26 03            [ 1]  580 	jrne	00340$
      00863E CC 88 13         [ 2]  581 	jp	00127$
      008641                        582 00340$:
      008641 7B 04            [ 1]  583 	ld	a, (0x04, sp)
      008643 A1 52            [ 1]  584 	cp	a, #0x52
      008645 26 03            [ 1]  585 	jrne	00343$
      008647 CC 88 27         [ 2]  586 	jp	00128$
      00864A                        587 00343$:
      00864A CC 88 3B         [ 2]  588 	jp	00129$
                                    589 ;	./display.c: 284: case '-':
      00864D                        590 00105$:
                                    591 ;	./display.c: 285: displayAC[id] = SSD_SEG_G_BIT;
      00864D 5F               [ 1]  592 	clrw	x
      00864E 7B 03            [ 1]  593 	ld	a, (0x03, sp)
      008650 97               [ 1]  594 	ld	xl, a
      008651 A6 40            [ 1]  595 	ld	a, #0x40
      008653 D7 00 10         [ 1]  596 	ld	((_displayAC + 0), x), a
                                    597 ;	./display.c: 286: displayD[id] = 0;
      008656 5F               [ 1]  598 	clrw	x
      008657 7B 03            [ 1]  599 	ld	a, (0x03, sp)
      008659 97               [ 1]  600 	ld	xl, a
      00865A 72 4F 00 13      [ 1]  601 	clr	((_displayD + 0), x)
                                    602 ;	./display.c: 287: break;
      00865E CC 88 4C         [ 2]  603 	jp	00130$
                                    604 ;	./display.c: 289: case ' ':
      008661                        605 00106$:
                                    606 ;	./display.c: 290: displayAC[id] = 0;
      008661 5F               [ 1]  607 	clrw	x
      008662 7B 03            [ 1]  608 	ld	a, (0x03, sp)
      008664 97               [ 1]  609 	ld	xl, a
      008665 72 4F 00 10      [ 1]  610 	clr	((_displayAC + 0), x)
                                    611 ;	./display.c: 291: displayD[id] = 0;
      008669 5F               [ 1]  612 	clrw	x
      00866A 7B 03            [ 1]  613 	ld	a, (0x03, sp)
      00866C 97               [ 1]  614 	ld	xl, a
      00866D 72 4F 00 13      [ 1]  615 	clr	((_displayD + 0), x)
                                    616 ;	./display.c: 292: break;
      008671 CC 88 4C         [ 2]  617 	jp	00130$
                                    618 ;	./display.c: 294: case '0':
      008674                        619 00107$:
                                    620 ;	./display.c: 295: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
      008674 5F               [ 1]  621 	clrw	x
      008675 7B 03            [ 1]  622 	ld	a, (0x03, sp)
      008677 97               [ 1]  623 	ld	xl, a
      008678 A6 86            [ 1]  624 	ld	a, #0x86
      00867A D7 00 10         [ 1]  625 	ld	((_displayAC + 0), x), a
                                    626 ;	./display.c: 296: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      00867D 5F               [ 1]  627 	clrw	x
      00867E 7B 03            [ 1]  628 	ld	a, (0x03, sp)
      008680 97               [ 1]  629 	ld	xl, a
      008681 A6 2A            [ 1]  630 	ld	a, #0x2a
      008683 D7 00 13         [ 1]  631 	ld	((_displayD + 0), x), a
                                    632 ;	./display.c: 297: break;
      008686 CC 88 4C         [ 2]  633 	jp	00130$
                                    634 ;	./display.c: 299: case '1':
      008689                        635 00108$:
                                    636 ;	./display.c: 300: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
      008689 5F               [ 1]  637 	clrw	x
      00868A 7B 03            [ 1]  638 	ld	a, (0x03, sp)
      00868C 97               [ 1]  639 	ld	xl, a
      00868D A6 84            [ 1]  640 	ld	a, #0x84
      00868F D7 00 10         [ 1]  641 	ld	((_displayAC + 0), x), a
                                    642 ;	./display.c: 301: displayD[id] = 0;
      008692 5F               [ 1]  643 	clrw	x
      008693 7B 03            [ 1]  644 	ld	a, (0x03, sp)
      008695 97               [ 1]  645 	ld	xl, a
      008696 72 4F 00 13      [ 1]  646 	clr	((_displayD + 0), x)
                                    647 ;	./display.c: 302: break;
      00869A CC 88 4C         [ 2]  648 	jp	00130$
                                    649 ;	./display.c: 304: case '2':
      00869D                        650 00109$:
                                    651 ;	./display.c: 305: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_G_BIT;
      00869D 5F               [ 1]  652 	clrw	x
      00869E 7B 03            [ 1]  653 	ld	a, (0x03, sp)
      0086A0 97               [ 1]  654 	ld	xl, a
      0086A1 A6 44            [ 1]  655 	ld	a, #0x44
      0086A3 D7 00 10         [ 1]  656 	ld	((_displayAC + 0), x), a
                                    657 ;	./display.c: 306: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0086A6 5F               [ 1]  658 	clrw	x
      0086A7 7B 03            [ 1]  659 	ld	a, (0x03, sp)
      0086A9 97               [ 1]  660 	ld	xl, a
      0086AA A6 2A            [ 1]  661 	ld	a, #0x2a
      0086AC D7 00 13         [ 1]  662 	ld	((_displayD + 0), x), a
                                    663 ;	./display.c: 307: break;
      0086AF CC 88 4C         [ 2]  664 	jp	00130$
                                    665 ;	./display.c: 309: case '3':
      0086B2                        666 00110$:
                                    667 ;	./display.c: 310: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT;
      0086B2 5F               [ 1]  668 	clrw	x
      0086B3 7B 03            [ 1]  669 	ld	a, (0x03, sp)
      0086B5 97               [ 1]  670 	ld	xl, a
      0086B6 A6 C4            [ 1]  671 	ld	a, #0xc4
      0086B8 D7 00 10         [ 1]  672 	ld	((_displayAC + 0), x), a
                                    673 ;	./display.c: 311: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
      0086BB 5F               [ 1]  674 	clrw	x
      0086BC 7B 03            [ 1]  675 	ld	a, (0x03, sp)
      0086BE 97               [ 1]  676 	ld	xl, a
      0086BF A6 28            [ 1]  677 	ld	a, #0x28
      0086C1 D7 00 13         [ 1]  678 	ld	((_displayD + 0), x), a
                                    679 ;	./display.c: 312: break;
      0086C4 CC 88 4C         [ 2]  680 	jp	00130$
                                    681 ;	./display.c: 314: case '4':
      0086C7                        682 00111$:
                                    683 ;	./display.c: 315: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      0086C7 5F               [ 1]  684 	clrw	x
      0086C8 7B 03            [ 1]  685 	ld	a, (0x03, sp)
      0086CA 97               [ 1]  686 	ld	xl, a
      0086CB A6 C6            [ 1]  687 	ld	a, #0xc6
      0086CD D7 00 10         [ 1]  688 	ld	((_displayAC + 0), x), a
                                    689 ;	./display.c: 316: displayD[id] = 0;
      0086D0 5F               [ 1]  690 	clrw	x
      0086D1 7B 03            [ 1]  691 	ld	a, (0x03, sp)
      0086D3 97               [ 1]  692 	ld	xl, a
      0086D4 72 4F 00 13      [ 1]  693 	clr	((_displayD + 0), x)
                                    694 ;	./display.c: 317: break;
      0086D8 CC 88 4C         [ 2]  695 	jp	00130$
                                    696 ;	./display.c: 319: case '5':
      0086DB                        697 00112$:
                                    698 ;	./display.c: 320: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      0086DB 5F               [ 1]  699 	clrw	x
      0086DC 7B 03            [ 1]  700 	ld	a, (0x03, sp)
      0086DE 97               [ 1]  701 	ld	xl, a
      0086DF A6 C2            [ 1]  702 	ld	a, #0xc2
      0086E1 D7 00 10         [ 1]  703 	ld	((_displayAC + 0), x), a
                                    704 ;	./display.c: 321: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
      0086E4 5F               [ 1]  705 	clrw	x
      0086E5 7B 03            [ 1]  706 	ld	a, (0x03, sp)
      0086E7 97               [ 1]  707 	ld	xl, a
      0086E8 A6 28            [ 1]  708 	ld	a, #0x28
      0086EA D7 00 13         [ 1]  709 	ld	((_displayD + 0), x), a
                                    710 ;	./display.c: 322: break;
      0086ED CC 88 4C         [ 2]  711 	jp	00130$
                                    712 ;	./display.c: 324: case '6':
      0086F0                        713 00113$:
                                    714 ;	./display.c: 325: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      0086F0 5F               [ 1]  715 	clrw	x
      0086F1 7B 03            [ 1]  716 	ld	a, (0x03, sp)
      0086F3 97               [ 1]  717 	ld	xl, a
      0086F4 A6 C2            [ 1]  718 	ld	a, #0xc2
      0086F6 D7 00 10         [ 1]  719 	ld	((_displayAC + 0), x), a
                                    720 ;	./display.c: 326: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0086F9 5F               [ 1]  721 	clrw	x
      0086FA 7B 03            [ 1]  722 	ld	a, (0x03, sp)
      0086FC 97               [ 1]  723 	ld	xl, a
      0086FD A6 2A            [ 1]  724 	ld	a, #0x2a
      0086FF D7 00 13         [ 1]  725 	ld	((_displayD + 0), x), a
                                    726 ;	./display.c: 327: break;
      008702 CC 88 4C         [ 2]  727 	jp	00130$
                                    728 ;	./display.c: 329: case '7':
      008705                        729 00114$:
                                    730 ;	./display.c: 330: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
      008705 5F               [ 1]  731 	clrw	x
      008706 7B 03            [ 1]  732 	ld	a, (0x03, sp)
      008708 97               [ 1]  733 	ld	xl, a
      008709 A6 84            [ 1]  734 	ld	a, #0x84
      00870B D7 00 10         [ 1]  735 	ld	((_displayAC + 0), x), a
                                    736 ;	./display.c: 331: displayD[id] = SSD_SEG_A_BIT;
      00870E 5F               [ 1]  737 	clrw	x
      00870F 7B 03            [ 1]  738 	ld	a, (0x03, sp)
      008711 97               [ 1]  739 	ld	xl, a
      008712 A6 20            [ 1]  740 	ld	a, #0x20
      008714 D7 00 13         [ 1]  741 	ld	((_displayD + 0), x), a
                                    742 ;	./display.c: 332: break;
      008717 CC 88 4C         [ 2]  743 	jp	00130$
                                    744 ;	./display.c: 334: case '8':
      00871A                        745 00115$:
                                    746 ;	./display.c: 335: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      00871A 5F               [ 1]  747 	clrw	x
      00871B 7B 03            [ 1]  748 	ld	a, (0x03, sp)
      00871D 97               [ 1]  749 	ld	xl, a
      00871E A6 C6            [ 1]  750 	ld	a, #0xc6
      008720 D7 00 10         [ 1]  751 	ld	((_displayAC + 0), x), a
                                    752 ;	./display.c: 336: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      008723 5F               [ 1]  753 	clrw	x
      008724 7B 03            [ 1]  754 	ld	a, (0x03, sp)
      008726 97               [ 1]  755 	ld	xl, a
      008727 A6 2A            [ 1]  756 	ld	a, #0x2a
      008729 D7 00 13         [ 1]  757 	ld	((_displayD + 0), x), a
                                    758 ;	./display.c: 337: break;
      00872C CC 88 4C         [ 2]  759 	jp	00130$
                                    760 ;	./display.c: 339: case '9':
      00872F                        761 00116$:
                                    762 ;	./display.c: 340: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      00872F 5F               [ 1]  763 	clrw	x
      008730 7B 03            [ 1]  764 	ld	a, (0x03, sp)
      008732 97               [ 1]  765 	ld	xl, a
      008733 A6 C6            [ 1]  766 	ld	a, #0xc6
      008735 D7 00 10         [ 1]  767 	ld	((_displayAC + 0), x), a
                                    768 ;	./display.c: 341: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
      008738 5F               [ 1]  769 	clrw	x
      008739 7B 03            [ 1]  770 	ld	a, (0x03, sp)
      00873B 97               [ 1]  771 	ld	xl, a
      00873C A6 28            [ 1]  772 	ld	a, #0x28
      00873E D7 00 13         [ 1]  773 	ld	((_displayD + 0), x), a
                                    774 ;	./display.c: 342: break;
      008741 CC 88 4C         [ 2]  775 	jp	00130$
                                    776 ;	./display.c: 344: case 'A':
      008744                        777 00117$:
                                    778 ;	./display.c: 345: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008744 5F               [ 1]  779 	clrw	x
      008745 7B 03            [ 1]  780 	ld	a, (0x03, sp)
      008747 97               [ 1]  781 	ld	xl, a
      008748 A6 C6            [ 1]  782 	ld	a, #0xc6
      00874A D7 00 10         [ 1]  783 	ld	((_displayAC + 0), x), a
                                    784 ;	./display.c: 346: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      00874D 5F               [ 1]  785 	clrw	x
      00874E 7B 03            [ 1]  786 	ld	a, (0x03, sp)
      008750 97               [ 1]  787 	ld	xl, a
      008751 A6 22            [ 1]  788 	ld	a, #0x22
      008753 D7 00 13         [ 1]  789 	ld	((_displayD + 0), x), a
                                    790 ;	./display.c: 347: break;
      008756 CC 88 4C         [ 2]  791 	jp	00130$
                                    792 ;	./display.c: 349: case 'B':
      008759                        793 00118$:
                                    794 ;	./display.c: 350: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008759 5F               [ 1]  795 	clrw	x
      00875A 7B 03            [ 1]  796 	ld	a, (0x03, sp)
      00875C 97               [ 1]  797 	ld	xl, a
      00875D A6 C2            [ 1]  798 	ld	a, #0xc2
      00875F D7 00 10         [ 1]  799 	ld	((_displayAC + 0), x), a
                                    800 ;	./display.c: 351: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      008762 5F               [ 1]  801 	clrw	x
      008763 7B 03            [ 1]  802 	ld	a, (0x03, sp)
      008765 97               [ 1]  803 	ld	xl, a
      008766 A6 0A            [ 1]  804 	ld	a, #0x0a
      008768 D7 00 13         [ 1]  805 	ld	((_displayD + 0), x), a
                                    806 ;	./display.c: 352: break;
      00876B CC 88 4C         [ 2]  807 	jp	00130$
                                    808 ;	./display.c: 354: case 'C':
      00876E                        809 00119$:
                                    810 ;	./display.c: 355: displayAC[id] = SSD_SEG_F_BIT;
      00876E 5F               [ 1]  811 	clrw	x
      00876F 7B 03            [ 1]  812 	ld	a, (0x03, sp)
      008771 97               [ 1]  813 	ld	xl, a
      008772 A6 02            [ 1]  814 	ld	a, #0x02
      008774 D7 00 10         [ 1]  815 	ld	((_displayAC + 0), x), a
                                    816 ;	./display.c: 356: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      008777 5F               [ 1]  817 	clrw	x
      008778 7B 03            [ 1]  818 	ld	a, (0x03, sp)
      00877A 97               [ 1]  819 	ld	xl, a
      00877B A6 2A            [ 1]  820 	ld	a, #0x2a
      00877D D7 00 13         [ 1]  821 	ld	((_displayD + 0), x), a
                                    822 ;	./display.c: 357: break;
      008780 CC 88 4C         [ 2]  823 	jp	00130$
                                    824 ;	./display.c: 359: case 'D':
      008783                        825 00120$:
                                    826 ;	./display.c: 360: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT;
      008783 5F               [ 1]  827 	clrw	x
      008784 7B 03            [ 1]  828 	ld	a, (0x03, sp)
      008786 97               [ 1]  829 	ld	xl, a
      008787 A6 C4            [ 1]  830 	ld	a, #0xc4
      008789 D7 00 10         [ 1]  831 	ld	((_displayAC + 0), x), a
                                    832 ;	./display.c: 361: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      00878C 5F               [ 1]  833 	clrw	x
      00878D 7B 03            [ 1]  834 	ld	a, (0x03, sp)
      00878F 97               [ 1]  835 	ld	xl, a
      008790 A6 0A            [ 1]  836 	ld	a, #0x0a
      008792 D7 00 13         [ 1]  837 	ld	((_displayD + 0), x), a
                                    838 ;	./display.c: 362: break;
      008795 CC 88 4C         [ 2]  839 	jp	00130$
                                    840 ;	./display.c: 364: case 'E':
      008798                        841 00121$:
                                    842 ;	./display.c: 365: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008798 5F               [ 1]  843 	clrw	x
      008799 7B 03            [ 1]  844 	ld	a, (0x03, sp)
      00879B 97               [ 1]  845 	ld	xl, a
      00879C A6 42            [ 1]  846 	ld	a, #0x42
      00879E D7 00 10         [ 1]  847 	ld	((_displayAC + 0), x), a
                                    848 ;	./display.c: 366: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0087A1 5F               [ 1]  849 	clrw	x
      0087A2 7B 03            [ 1]  850 	ld	a, (0x03, sp)
      0087A4 97               [ 1]  851 	ld	xl, a
      0087A5 A6 2A            [ 1]  852 	ld	a, #0x2a
      0087A7 D7 00 13         [ 1]  853 	ld	((_displayD + 0), x), a
                                    854 ;	./display.c: 367: break;
      0087AA CC 88 4C         [ 2]  855 	jp	00130$
                                    856 ;	./display.c: 369: case 'F':
      0087AD                        857 00122$:
                                    858 ;	./display.c: 370: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      0087AD 5F               [ 1]  859 	clrw	x
      0087AE 7B 03            [ 1]  860 	ld	a, (0x03, sp)
      0087B0 97               [ 1]  861 	ld	xl, a
      0087B1 A6 42            [ 1]  862 	ld	a, #0x42
      0087B3 D7 00 10         [ 1]  863 	ld	((_displayAC + 0), x), a
                                    864 ;	./display.c: 371: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      0087B6 5F               [ 1]  865 	clrw	x
      0087B7 7B 03            [ 1]  866 	ld	a, (0x03, sp)
      0087B9 97               [ 1]  867 	ld	xl, a
      0087BA A6 22            [ 1]  868 	ld	a, #0x22
      0087BC D7 00 13         [ 1]  869 	ld	((_displayD + 0), x), a
                                    870 ;	./display.c: 372: break;
      0087BF CC 88 4C         [ 2]  871 	jp	00130$
                                    872 ;	./display.c: 374: case 'H':
      0087C2                        873 00123$:
                                    874 ;	./display.c: 375: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      0087C2 5F               [ 1]  875 	clrw	x
      0087C3 7B 03            [ 1]  876 	ld	a, (0x03, sp)
      0087C5 97               [ 1]  877 	ld	xl, a
      0087C6 A6 C6            [ 1]  878 	ld	a, #0xc6
      0087C8 D7 00 10         [ 1]  879 	ld	((_displayAC + 0), x), a
                                    880 ;	./display.c: 376: displayD[id] = SSD_SEG_E_BIT;
      0087CB 5F               [ 1]  881 	clrw	x
      0087CC 7B 03            [ 1]  882 	ld	a, (0x03, sp)
      0087CE 97               [ 1]  883 	ld	xl, a
      0087CF A6 02            [ 1]  884 	ld	a, #0x02
      0087D1 D7 00 13         [ 1]  885 	ld	((_displayD + 0), x), a
                                    886 ;	./display.c: 377: break;
      0087D4 CC 88 4C         [ 2]  887 	jp	00130$
                                    888 ;	./display.c: 379: case 'L':
      0087D7                        889 00124$:
                                    890 ;	./display.c: 380: displayAC[id] = SSD_SEG_F_BIT;
      0087D7 5F               [ 1]  891 	clrw	x
      0087D8 7B 03            [ 1]  892 	ld	a, (0x03, sp)
      0087DA 97               [ 1]  893 	ld	xl, a
      0087DB A6 02            [ 1]  894 	ld	a, #0x02
      0087DD D7 00 10         [ 1]  895 	ld	((_displayAC + 0), x), a
                                    896 ;	./display.c: 381: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0087E0 5F               [ 1]  897 	clrw	x
      0087E1 7B 03            [ 1]  898 	ld	a, (0x03, sp)
      0087E3 97               [ 1]  899 	ld	xl, a
      0087E4 A6 0A            [ 1]  900 	ld	a, #0x0a
      0087E6 D7 00 13         [ 1]  901 	ld	((_displayD + 0), x), a
                                    902 ;	./display.c: 382: break;
      0087E9 20 61            [ 2]  903 	jra	00130$
                                    904 ;	./display.c: 384: case 'N':
      0087EB                        905 00125$:
                                    906 ;	./display.c: 385: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
      0087EB 5F               [ 1]  907 	clrw	x
      0087EC 7B 03            [ 1]  908 	ld	a, (0x03, sp)
      0087EE 97               [ 1]  909 	ld	xl, a
      0087EF A6 86            [ 1]  910 	ld	a, #0x86
      0087F1 D7 00 10         [ 1]  911 	ld	((_displayAC + 0), x), a
                                    912 ;	./display.c: 386: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      0087F4 5F               [ 1]  913 	clrw	x
      0087F5 7B 03            [ 1]  914 	ld	a, (0x03, sp)
      0087F7 97               [ 1]  915 	ld	xl, a
      0087F8 A6 22            [ 1]  916 	ld	a, #0x22
      0087FA D7 00 13         [ 1]  917 	ld	((_displayD + 0), x), a
                                    918 ;	./display.c: 387: break;
      0087FD 20 4D            [ 2]  919 	jra	00130$
                                    920 ;	./display.c: 389: case 'O':
      0087FF                        921 00126$:
                                    922 ;	./display.c: 390: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
      0087FF 5F               [ 1]  923 	clrw	x
      008800 7B 03            [ 1]  924 	ld	a, (0x03, sp)
      008802 97               [ 1]  925 	ld	xl, a
      008803 A6 86            [ 1]  926 	ld	a, #0x86
      008805 D7 00 10         [ 1]  927 	ld	((_displayAC + 0), x), a
                                    928 ;	./display.c: 391: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      008808 5F               [ 1]  929 	clrw	x
      008809 7B 03            [ 1]  930 	ld	a, (0x03, sp)
      00880B 97               [ 1]  931 	ld	xl, a
      00880C A6 2A            [ 1]  932 	ld	a, #0x2a
      00880E D7 00 13         [ 1]  933 	ld	((_displayD + 0), x), a
                                    934 ;	./display.c: 392: break;
      008811 20 39            [ 2]  935 	jra	00130$
                                    936 ;	./display.c: 394: case 'P':
      008813                        937 00127$:
                                    938 ;	./display.c: 395: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008813 5F               [ 1]  939 	clrw	x
      008814 7B 03            [ 1]  940 	ld	a, (0x03, sp)
      008816 97               [ 1]  941 	ld	xl, a
      008817 A6 46            [ 1]  942 	ld	a, #0x46
      008819 D7 00 10         [ 1]  943 	ld	((_displayAC + 0), x), a
                                    944 ;	./display.c: 396: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      00881C 5F               [ 1]  945 	clrw	x
      00881D 7B 03            [ 1]  946 	ld	a, (0x03, sp)
      00881F 97               [ 1]  947 	ld	xl, a
      008820 A6 22            [ 1]  948 	ld	a, #0x22
      008822 D7 00 13         [ 1]  949 	ld	((_displayD + 0), x), a
                                    950 ;	./display.c: 397: break;
      008825 20 25            [ 2]  951 	jra	00130$
                                    952 ;	./display.c: 399: case 'R':
      008827                        953 00128$:
                                    954 ;	./display.c: 400: displayAC[id] = SSD_SEG_F_BIT;
      008827 5F               [ 1]  955 	clrw	x
      008828 7B 03            [ 1]  956 	ld	a, (0x03, sp)
      00882A 97               [ 1]  957 	ld	xl, a
      00882B A6 02            [ 1]  958 	ld	a, #0x02
      00882D D7 00 10         [ 1]  959 	ld	((_displayAC + 0), x), a
                                    960 ;	./display.c: 401: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      008830 5F               [ 1]  961 	clrw	x
      008831 7B 03            [ 1]  962 	ld	a, (0x03, sp)
      008833 97               [ 1]  963 	ld	xl, a
      008834 A6 22            [ 1]  964 	ld	a, #0x22
      008836 D7 00 13         [ 1]  965 	ld	((_displayD + 0), x), a
                                    966 ;	./display.c: 402: break;
      008839 20 11            [ 2]  967 	jra	00130$
                                    968 ;	./display.c: 404: default:
      00883B                        969 00129$:
                                    970 ;	./display.c: 405: displayAC[id] = 0;
      00883B 5F               [ 1]  971 	clrw	x
      00883C 7B 03            [ 1]  972 	ld	a, (0x03, sp)
      00883E 97               [ 1]  973 	ld	xl, a
      00883F 72 4F 00 10      [ 1]  974 	clr	((_displayAC + 0), x)
                                    975 ;	./display.c: 406: displayD[id] = SSD_SEG_D_BIT;
      008843 5F               [ 1]  976 	clrw	x
      008844 7B 03            [ 1]  977 	ld	a, (0x03, sp)
      008846 97               [ 1]  978 	ld	xl, a
      008847 A6 08            [ 1]  979 	ld	a, #0x08
      008849 D7 00 13         [ 1]  980 	ld	((_displayD + 0), x), a
                                    981 ;	./display.c: 407: }
      00884C                        982 00130$:
                                    983 ;	./display.c: 409: if (dot) {
      00884C 0D 05            [ 1]  984 	tnz	(0x05, sp)
      00884E 27 0C            [ 1]  985 	jreq	00132$
                                    986 ;	./display.c: 410: displayD[id] |= SSD_SEG_P_BIT;
      008850 5F               [ 1]  987 	clrw	x
      008851 7B 03            [ 1]  988 	ld	a, (0x03, sp)
      008853 97               [ 1]  989 	ld	xl, a
      008854 1C 00 13         [ 2]  990 	addw	x, #(_displayD + 0)
      008857 F6               [ 1]  991 	ld	a, (x)
      008858 AA 04            [ 1]  992 	or	a, #0x04
      00885A F7               [ 1]  993 	ld	(x), a
      00885B 81               [ 4]  994 	ret
      00885C                        995 00132$:
                                    996 ;	./display.c: 412: displayD[id] &= ~SSD_SEG_P_BIT;
      00885C 5F               [ 1]  997 	clrw	x
      00885D 7B 03            [ 1]  998 	ld	a, (0x03, sp)
      00885F 97               [ 1]  999 	ld	xl, a
      008860 1C 00 13         [ 2] 1000 	addw	x, #(_displayD + 0)
      008863 F6               [ 1] 1001 	ld	a, (x)
      008864 A4 FB            [ 1] 1002 	and	a, #0xfb
      008866 F7               [ 1] 1003 	ld	(x), a
                                   1004 ;	./display.c: 415: return;
                                   1005 ;	./display.c: 416: }
      008867 81               [ 4] 1006 	ret
                                   1007 	.area CODE
                                   1008 	.area CONST
      008095                       1009 _Hex2CharMap:
      008095 30                    1010 	.db #0x30	; 48	'0'
      008096 31                    1011 	.db #0x31	; 49	'1'
      008097 32                    1012 	.db #0x32	; 50	'2'
      008098 33                    1013 	.db #0x33	; 51	'3'
      008099 34                    1014 	.db #0x34	; 52	'4'
      00809A 35                    1015 	.db #0x35	; 53	'5'
      00809B 36                    1016 	.db #0x36	; 54	'6'
      00809C 37                    1017 	.db #0x37	; 55	'7'
      00809D 38                    1018 	.db #0x38	; 56	'8'
      00809E 39                    1019 	.db #0x39	; 57	'9'
      00809F 41                    1020 	.db #0x41	; 65	'A'
      0080A0 42                    1021 	.db #0x42	; 66	'B'
      0080A1 43                    1022 	.db #0x43	; 67	'C'
      0080A2 44                    1023 	.db #0x44	; 68	'D'
      0080A3 45                    1024 	.db #0x45	; 69	'E'
      0080A4 46                    1025 	.db #0x46	; 70	'F'
                                   1026 	.area CONST
      0080A5                       1027 ___str_0:
      0080A5 00                    1028 	.db 0x00
                                   1029 	.area CODE
                                   1030 	.area CONST
      0080A6                       1031 ___str_1:
      0080A6 38 38 38              1032 	.ascii "888"
      0080A9 00                    1033 	.db 0x00
                                   1034 	.area CODE
                                   1035 	.area INITIALIZER
                                   1036 	.area CABS (ABS)

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
                                     13 	.globl _dimmerBrightness
                                     14 	.globl _initDisplay
                                     15 	.globl _refreshDisplay
                                     16 	.globl _setDisplayTestMode
                                     17 	.globl _setDisplayOff
                                     18 	.globl _setDisplayStr
                                     19 	.globl _enableDigit
                                     20 ;--------------------------------------------------------
                                     21 ; ram data
                                     22 ;--------------------------------------------------------
                                     23 	.area DATA
      00000F                         24 _activeDigitId:
      00000F                         25 	.ds 1
      000010                         26 _displayAC:
      000010                         27 	.ds 3
      000013                         28 _displayD:
      000013                         29 	.ds 3
      000016                         30 _displayOff:
      000016                         31 	.ds 1
      000017                         32 _testMode:
      000017                         33 	.ds 1
                                     34 ;--------------------------------------------------------
                                     35 ; ram data
                                     36 ;--------------------------------------------------------
                                     37 	.area INITIALIZED
      000044                         38 _lowBrightness:
      000044                         39 	.ds 1
                                     40 ;--------------------------------------------------------
                                     41 ; absolute external ram data
                                     42 ;--------------------------------------------------------
                                     43 	.area DABS (ABS)
                                     44 
                                     45 ; default segment ordering for linker
                                     46 	.area HOME
                                     47 	.area GSINIT
                                     48 	.area GSFINAL
                                     49 	.area CONST
                                     50 	.area INITIALIZER
                                     51 	.area CODE
                                     52 
                                     53 ;--------------------------------------------------------
                                     54 ; global & static initialisations
                                     55 ;--------------------------------------------------------
                                     56 	.area HOME
                                     57 	.area GSINIT
                                     58 	.area GSFINAL
                                     59 	.area GSINIT
                                     60 ;--------------------------------------------------------
                                     61 ; Home
                                     62 ;--------------------------------------------------------
                                     63 	.area HOME
                                     64 	.area HOME
                                     65 ;--------------------------------------------------------
                                     66 ; code
                                     67 ;--------------------------------------------------------
                                     68 	.area CODE
                                     69 ;	./display.c: 83: void dimmerBrightness(bool _state)
                                     70 ;	-----------------------------------------
                                     71 ;	 function dimmerBrightness
                                     72 ;	-----------------------------------------
      00848F                         73 _dimmerBrightness:
                                     74 ;	./display.c: 85: lowBrightness = _state;
      00848F 7B 03            [ 1]   75 	ld	a, (0x03, sp)
      008491 C7 00 44         [ 1]   76 	ld	_lowBrightness+0, a
                                     77 ;	./display.c: 86: }
      008494 81               [ 4]   78 	ret
                                     79 ;	./display.c: 92: void initDisplay()
                                     80 ;	-----------------------------------------
                                     81 ;	 function initDisplay
                                     82 ;	-----------------------------------------
      008495                         83 _initDisplay:
                                     84 ;	./display.c: 94: PA_DDR |= SSD_SEG_B_BIT | SSD_SEG_F_BIT;
      008495 C6 50 02         [ 1]   85 	ld	a, 0x5002
      008498 AA 06            [ 1]   86 	or	a, #0x06
      00849A C7 50 02         [ 1]   87 	ld	0x5002, a
                                     88 ;	./display.c: 95: PA_CR1 |= SSD_SEG_B_BIT | SSD_SEG_F_BIT;
      00849D C6 50 03         [ 1]   89 	ld	a, 0x5003
      0084A0 AA 06            [ 1]   90 	or	a, #0x06
      0084A2 C7 50 03         [ 1]   91 	ld	0x5003, a
                                     92 ;	./display.c: 96: PB_DDR |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
      0084A5 C6 50 07         [ 1]   93 	ld	a, 0x5007
      0084A8 AA 30            [ 1]   94 	or	a, #0x30
      0084AA C7 50 07         [ 1]   95 	ld	0x5007, a
                                     96 ;	./display.c: 97: PB_CR1 |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
      0084AD C6 50 08         [ 1]   97 	ld	a, 0x5008
      0084B0 AA 30            [ 1]   98 	or	a, #0x30
      0084B2 C7 50 08         [ 1]   99 	ld	0x5008, a
                                    100 ;	./display.c: 98: PC_DDR |= SSD_SEG_C_BIT | SSD_SEG_G_BIT;
      0084B5 C6 50 0C         [ 1]  101 	ld	a, 0x500c
      0084B8 AA C0            [ 1]  102 	or	a, #0xc0
      0084BA C7 50 0C         [ 1]  103 	ld	0x500c, a
                                    104 ;	./display.c: 99: PC_CR1 |= SSD_SEG_C_BIT | SSD_SEG_G_BIT;
      0084BD C6 50 0D         [ 1]  105 	ld	a, 0x500d
      0084C0 AA C0            [ 1]  106 	or	a, #0xc0
      0084C2 C7 50 0D         [ 1]  107 	ld	0x500d, a
                                    108 ;	./display.c: 100: PD_DDR |= SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT | SSD_SEG_P_BIT | SSD_DIGIT_3_BIT;
      0084C5 C6 50 11         [ 1]  109 	ld	a, 0x5011
      0084C8 AA 3E            [ 1]  110 	or	a, #0x3e
      0084CA C7 50 11         [ 1]  111 	ld	0x5011, a
                                    112 ;	./display.c: 101: PD_CR1 |= SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT | SSD_SEG_P_BIT | SSD_DIGIT_3_BIT;
      0084CD C6 50 12         [ 1]  113 	ld	a, 0x5012
      0084D0 AA 3E            [ 1]  114 	or	a, #0x3e
      0084D2 C7 50 12         [ 1]  115 	ld	0x5012, a
                                    116 ;	./display.c: 102: displayOff = false;
      0084D5 72 5F 00 16      [ 1]  117 	clr	_displayOff+0
                                    118 ;	./display.c: 103: activeDigitId = 0;
      0084D9 72 5F 00 0F      [ 1]  119 	clr	_activeDigitId+0
                                    120 ;	./display.c: 104: setDisplayTestMode (true, "");
      0084DD 4B B9            [ 1]  121 	push	#<(___str_0 + 0)
      0084DF 4B 80            [ 1]  122 	push	#((___str_0 + 0) >> 8)
      0084E1 4B 01            [ 1]  123 	push	#0x01
      0084E3 CD 85 76         [ 4]  124 	call	_setDisplayTestMode
      0084E6 5B 03            [ 2]  125 	addw	sp, #3
                                    126 ;	./display.c: 105: }
      0084E8 81               [ 4]  127 	ret
                                    128 ;	./display.c: 113: void refreshDisplay()
                                    129 ;	-----------------------------------------
                                    130 ;	 function refreshDisplay
                                    131 ;	-----------------------------------------
      0084E9                        132 _refreshDisplay:
      0084E9 88               [ 1]  133 	push	a
                                    134 ;	./display.c: 115: enableDigit (3);
      0084EA 4B 03            [ 1]  135 	push	#0x03
      0084EC CD 86 6C         [ 4]  136 	call	_enableDigit
      0084EF 84               [ 1]  137 	pop	a
                                    138 ;	./display.c: 117: if (displayOff) {
      0084F0 72 00 00 16 02   [ 2]  139 	btjt	_displayOff+0, #0, 00139$
      0084F5 20 02            [ 2]  140 	jra	00102$
      0084F7                        141 00139$:
                                    142 ;	./display.c: 118: return;
      0084F7 20 7B            [ 2]  143 	jra	00111$
      0084F9                        144 00102$:
                                    145 ;	./display.c: 121: SSD_SEG_BF_PORT &= ~SSD_BF_PORT_MASK;
      0084F9 C6 50 00         [ 1]  146 	ld	a, 0x5000
      0084FC A4 F9            [ 1]  147 	and	a, #0xf9
                                    148 ;	./display.c: 122: SSD_SEG_BF_PORT |= displayAC[activeDigitId] & SSD_BF_PORT_MASK;
      0084FE C7 50 00         [ 1]  149 	ld	0x5000, a
      008501 6B 01            [ 1]  150 	ld	(0x01, sp), a
      008503 5F               [ 1]  151 	clrw	x
      008504 C6 00 0F         [ 1]  152 	ld	a, _activeDigitId+0
      008507 97               [ 1]  153 	ld	xl, a
      008508 1C 00 10         [ 2]  154 	addw	x, #(_displayAC + 0)
      00850B F6               [ 1]  155 	ld	a, (x)
      00850C A4 06            [ 1]  156 	and	a, #0x06
      00850E 1A 01            [ 1]  157 	or	a, (0x01, sp)
      008510 C7 50 00         [ 1]  158 	ld	0x5000, a
                                    159 ;	./display.c: 123: SSD_SEG_CG_PORT &= ~SSD_CG_PORT_MASK;
      008513 C6 50 0A         [ 1]  160 	ld	a, 0x500a
      008516 A4 3F            [ 1]  161 	and	a, #0x3f
                                    162 ;	./display.c: 124: SSD_SEG_CG_PORT |= displayAC[activeDigitId] & SSD_CG_PORT_MASK;
      008518 C7 50 0A         [ 1]  163 	ld	0x500a, a
      00851B 6B 01            [ 1]  164 	ld	(0x01, sp), a
      00851D 5F               [ 1]  165 	clrw	x
      00851E C6 00 0F         [ 1]  166 	ld	a, _activeDigitId+0
      008521 97               [ 1]  167 	ld	xl, a
      008522 1C 00 10         [ 2]  168 	addw	x, #(_displayAC + 0)
      008525 F6               [ 1]  169 	ld	a, (x)
      008526 A4 C0            [ 1]  170 	and	a, #0xc0
      008528 1A 01            [ 1]  171 	or	a, (0x01, sp)
      00852A C7 50 0A         [ 1]  172 	ld	0x500a, a
                                    173 ;	./display.c: 125: SSD_SEG_AEDP_PORT &= ~SSD_AEDP_PORT_MASK;
      00852D C6 50 0F         [ 1]  174 	ld	a, 0x500f
      008530 A4 D1            [ 1]  175 	and	a, #0xd1
                                    176 ;	./display.c: 126: SSD_SEG_AEDP_PORT |= displayD[activeDigitId];
      008532 C7 50 0F         [ 1]  177 	ld	0x500f, a
      008535 6B 01            [ 1]  178 	ld	(0x01, sp), a
      008537 5F               [ 1]  179 	clrw	x
      008538 C6 00 0F         [ 1]  180 	ld	a, _activeDigitId+0
      00853B 97               [ 1]  181 	ld	xl, a
      00853C 1C 00 13         [ 2]  182 	addw	x, #(_displayD + 0)
      00853F F6               [ 1]  183 	ld	a, (x)
      008540 1A 01            [ 1]  184 	or	a, (0x01, sp)
      008542 C7 50 0F         [ 1]  185 	ld	0x500f, a
                                    186 ;	./display.c: 127: enableDigit (activeDigitId);
      008545 3B 00 0F         [ 1]  187 	push	_activeDigitId+0
      008548 CD 86 6C         [ 4]  188 	call	_enableDigit
      00854B 84               [ 1]  189 	pop	a
                                    190 ;	./display.c: 129: if (activeDigitId > 1) {
      00854C C6 00 0F         [ 1]  191 	ld	a, _activeDigitId+0
      00854F A1 01            [ 1]  192 	cp	a, #0x01
      008551 23 06            [ 2]  193 	jrule	00104$
                                    194 ;	./display.c: 130: activeDigitId = 0;
      008553 72 5F 00 0F      [ 1]  195 	clr	_activeDigitId+0
      008557 20 04            [ 2]  196 	jra	00105$
      008559                        197 00104$:
                                    198 ;	./display.c: 132: activeDigitId++;
      008559 72 5C 00 0F      [ 1]  199 	inc	_activeDigitId+0
      00855D                        200 00105$:
                                    201 ;	./display.c: 135: if(lowBrightness) {
      00855D 72 00 00 44 02   [ 2]  202 	btjt	_lowBrightness+0, #0, 00141$
      008562 20 10            [ 2]  203 	jra	00111$
      008564                        204 00141$:
                                    205 ;	./display.c: 138: while(i--);
      008564 AE 03 E8         [ 2]  206 	ldw	x, #0x03e8
      008567                        207 00106$:
      008567 90 93            [ 1]  208 	ldw	y, x
      008569 5A               [ 2]  209 	decw	x
      00856A 90 5D            [ 2]  210 	tnzw	y
      00856C 26 F9            [ 1]  211 	jrne	00106$
                                    212 ;	./display.c: 140: enableDigit (3);
      00856E 4B 03            [ 1]  213 	push	#0x03
      008570 CD 86 6C         [ 4]  214 	call	_enableDigit
      008573 84               [ 1]  215 	pop	a
      008574                        216 00111$:
                                    217 ;	./display.c: 142: }
      008574 84               [ 1]  218 	pop	a
      008575 81               [ 4]  219 	ret
                                    220 ;	./display.c: 151: void setDisplayTestMode (bool val, char* str)
                                    221 ;	-----------------------------------------
                                    222 ;	 function setDisplayTestMode
                                    223 ;	-----------------------------------------
      008576                        224 _setDisplayTestMode:
                                    225 ;	./display.c: 153: if (!testMode && val) {
      008576 72 01 00 17 02   [ 2]  226 	btjf	_testMode+0, #0, 00124$
      00857B 20 1A            [ 2]  227 	jra	00105$
      00857D                        228 00124$:
      00857D 0D 03            [ 1]  229 	tnz	(0x03, sp)
      00857F 27 16            [ 1]  230 	jreq	00105$
                                    231 ;	./display.c: 154: if (*str == 0) {
      008581 1E 04            [ 2]  232 	ldw	x, (0x04, sp)
      008583 F6               [ 1]  233 	ld	a, (x)
      008584 26 0B            [ 1]  234 	jrne	00102$
                                    235 ;	./display.c: 155: setDisplayStr ("888");
      008586 4B BA            [ 1]  236 	push	#<(___str_1 + 0)
      008588 4B 80            [ 1]  237 	push	#((___str_1 + 0) >> 8)
      00858A CD 85 BF         [ 4]  238 	call	_setDisplayStr
      00858D 5B 02            [ 2]  239 	addw	sp, #2
      00858F 20 06            [ 2]  240 	jra	00105$
      008591                        241 00102$:
                                    242 ;	./display.c: 157: setDisplayStr (str);
      008591 89               [ 2]  243 	pushw	x
      008592 CD 85 BF         [ 4]  244 	call	_setDisplayStr
      008595 5B 02            [ 2]  245 	addw	sp, #2
      008597                        246 00105$:
                                    247 ;	./display.c: 161: testMode = val;
      008597 7B 03            [ 1]  248 	ld	a, (0x03, sp)
      008599 C7 00 17         [ 1]  249 	ld	_testMode+0, a
                                    250 ;	./display.c: 162: }
      00859C 81               [ 4]  251 	ret
                                    252 ;	./display.c: 169: void setDisplayOff (bool val)
                                    253 ;	-----------------------------------------
                                    254 ;	 function setDisplayOff
                                    255 ;	-----------------------------------------
      00859D                        256 _setDisplayOff:
                                    257 ;	./display.c: 171: displayOff = val;
      00859D 7B 03            [ 1]  258 	ld	a, (0x03, sp)
      00859F C7 00 16         [ 1]  259 	ld	_displayOff+0, a
                                    260 ;	./display.c: 172: }
      0085A2 81               [ 4]  261 	ret
                                    262 ;	./display.c: 182: void setDisplayDot (unsigned char id, bool val)
                                    263 ;	-----------------------------------------
                                    264 ;	 function setDisplayDot
                                    265 ;	-----------------------------------------
      0085A3                        266 _setDisplayDot:
                                    267 ;	./display.c: 184: if (val) {
      0085A3 0D 04            [ 1]  268 	tnz	(0x04, sp)
      0085A5 27 0C            [ 1]  269 	jreq	00102$
                                    270 ;	./display.c: 185: displayD[id] |= SSD_SEG_P_BIT;
      0085A7 5F               [ 1]  271 	clrw	x
      0085A8 7B 03            [ 1]  272 	ld	a, (0x03, sp)
      0085AA 97               [ 1]  273 	ld	xl, a
      0085AB 1C 00 13         [ 2]  274 	addw	x, #(_displayD + 0)
      0085AE F6               [ 1]  275 	ld	a, (x)
      0085AF AA 04            [ 1]  276 	or	a, #0x04
      0085B1 F7               [ 1]  277 	ld	(x), a
      0085B2 81               [ 4]  278 	ret
      0085B3                        279 00102$:
                                    280 ;	./display.c: 187: displayD[id] &= ~SSD_SEG_P_BIT;
      0085B3 5F               [ 1]  281 	clrw	x
      0085B4 7B 03            [ 1]  282 	ld	a, (0x03, sp)
      0085B6 97               [ 1]  283 	ld	xl, a
      0085B7 1C 00 13         [ 2]  284 	addw	x, #(_displayD + 0)
      0085BA F6               [ 1]  285 	ld	a, (x)
      0085BB A4 FB            [ 1]  286 	and	a, #0xfb
      0085BD F7               [ 1]  287 	ld	(x), a
                                    288 ;	./display.c: 189: }
      0085BE 81               [ 4]  289 	ret
                                    290 ;	./display.c: 196: void setDisplayStr (const unsigned char* val)
                                    291 ;	-----------------------------------------
                                    292 ;	 function setDisplayStr
                                    293 ;	-----------------------------------------
      0085BF                        294 _setDisplayStr:
      0085BF 52 06            [ 2]  295 	sub	sp, #6
                                    296 ;	./display.c: 201: for (i = 0, d = 0; * (val + i) != 0; i++, d++) {
      0085C1 0F 06            [ 1]  297 	clr	(0x06, sp)
      0085C3 0F 05            [ 1]  298 	clr	(0x05, sp)
      0085C5                        299 00114$:
      0085C5 5F               [ 1]  300 	clrw	x
      0085C6 7B 05            [ 1]  301 	ld	a, (0x05, sp)
      0085C8 97               [ 1]  302 	ld	xl, a
      0085C9 72 FB 09         [ 2]  303 	addw	x, (0x09, sp)
      0085CC F6               [ 1]  304 	ld	a, (x)
      0085CD 27 18            [ 1]  305 	jreq	00105$
                                    306 ;	./display.c: 202: if (* (val + i) == '.' && i > 0 && * (val + i - 1) != '.') d--;
      0085CF A1 2E            [ 1]  307 	cp	a, #0x2e
      0085D1 26 0E            [ 1]  308 	jrne	00115$
      0085D3 0D 05            [ 1]  309 	tnz	(0x05, sp)
      0085D5 27 0A            [ 1]  310 	jreq	00115$
      0085D7 1C FF FF         [ 2]  311 	addw	x, #0xffff
      0085DA F6               [ 1]  312 	ld	a, (x)
      0085DB A1 2E            [ 1]  313 	cp	a, #0x2e
      0085DD 27 02            [ 1]  314 	jreq	00115$
      0085DF 0A 06            [ 1]  315 	dec	(0x06, sp)
      0085E1                        316 00115$:
                                    317 ;	./display.c: 201: for (i = 0, d = 0; * (val + i) != 0; i++, d++) {
      0085E1 0C 05            [ 1]  318 	inc	(0x05, sp)
      0085E3 0C 06            [ 1]  319 	inc	(0x06, sp)
      0085E5 20 DE            [ 2]  320 	jra	00114$
      0085E7                        321 00105$:
                                    322 ;	./display.c: 207: if (d > 3) {
      0085E7 7B 06            [ 1]  323 	ld	a, (0x06, sp)
      0085E9 A1 03            [ 1]  324 	cp	a, #0x03
      0085EB 23 04            [ 2]  325 	jrule	00107$
                                    326 ;	./display.c: 208: d = 3;
      0085ED A6 03            [ 1]  327 	ld	a, #0x03
      0085EF 6B 06            [ 1]  328 	ld	(0x06, sp), a
      0085F1                        329 00107$:
                                    330 ;	./display.c: 212: for (i = 3 - d; i > 0; i--) {
      0085F1 7B 06            [ 1]  331 	ld	a, (0x06, sp)
      0085F3 6B 05            [ 1]  332 	ld	(0x05, sp), a
      0085F5 A6 03            [ 1]  333 	ld	a, #0x03
      0085F7 10 05            [ 1]  334 	sub	a, (0x05, sp)
      0085F9 6B 05            [ 1]  335 	ld	(0x05, sp), a
      0085FB                        336 00117$:
      0085FB 0D 05            [ 1]  337 	tnz	(0x05, sp)
      0085FD 27 16            [ 1]  338 	jreq	00108$
                                    339 ;	./display.c: 213: setDigit (3 - i, ' ', false);
      0085FF 7B 05            [ 1]  340 	ld	a, (0x05, sp)
      008601 6B 04            [ 1]  341 	ld	(0x04, sp), a
      008603 A6 03            [ 1]  342 	ld	a, #0x03
      008605 10 04            [ 1]  343 	sub	a, (0x04, sp)
      008607 4B 00            [ 1]  344 	push	#0x00
      008609 4B 20            [ 1]  345 	push	#0x20
      00860B 88               [ 1]  346 	push	a
      00860C CD 86 BD         [ 4]  347 	call	_setDigit
      00860F 5B 03            [ 2]  348 	addw	sp, #3
                                    349 ;	./display.c: 212: for (i = 3 - d; i > 0; i--) {
      008611 0A 05            [ 1]  350 	dec	(0x05, sp)
      008613 20 E6            [ 2]  351 	jra	00117$
      008615                        352 00108$:
                                    353 ;	./display.c: 217: for (i = 0; d != 0 && *val + i != 0; i++, d--) {
      008615 0F 05            [ 1]  354 	clr	(0x05, sp)
      008617                        355 00121$:
      008617 0D 06            [ 1]  356 	tnz	(0x06, sp)
      008619 27 4E            [ 1]  357 	jreq	00123$
      00861B 16 09            [ 2]  358 	ldw	y, (0x09, sp)
      00861D 17 01            [ 2]  359 	ldw	(0x01, sp), y
      00861F 93               [ 1]  360 	ldw	x, y
      008620 F6               [ 1]  361 	ld	a, (x)
      008621 6B 04            [ 1]  362 	ld	(0x04, sp), a
      008623 0F 03            [ 1]  363 	clr	(0x03, sp)
      008625 7B 05            [ 1]  364 	ld	a, (0x05, sp)
      008627 5F               [ 1]  365 	clrw	x
      008628 97               [ 1]  366 	ld	xl, a
      008629 72 FB 03         [ 2]  367 	addw	x, (0x03, sp)
      00862C 5D               [ 2]  368 	tnzw	x
      00862D 27 3A            [ 1]  369 	jreq	00123$
                                    370 ;	./display.c: 218: if (* (val + i + 1) == '.') {
      00862F 5F               [ 1]  371 	clrw	x
      008630 7B 05            [ 1]  372 	ld	a, (0x05, sp)
      008632 97               [ 1]  373 	ld	xl, a
      008633 72 FB 01         [ 2]  374 	addw	x, (0x01, sp)
      008636 90 93            [ 1]  375 	ldw	y, x
      008638 90 E6 01         [ 1]  376 	ld	a, (0x1, y)
      00863B 6B 04            [ 1]  377 	ld	(0x04, sp), a
                                    378 ;	./display.c: 219: setDigit (d - 1, * (val + i), true);
      00863D F6               [ 1]  379 	ld	a, (x)
      00863E 97               [ 1]  380 	ld	xl, a
      00863F 7B 06            [ 1]  381 	ld	a, (0x06, sp)
      008641 4A               [ 1]  382 	dec	a
      008642 95               [ 1]  383 	ld	xh, a
                                    384 ;	./display.c: 218: if (* (val + i + 1) == '.') {
      008643 7B 04            [ 1]  385 	ld	a, (0x04, sp)
      008645 A1 2E            [ 1]  386 	cp	a, #0x2e
      008647 26 0F            [ 1]  387 	jrne	00110$
                                    388 ;	./display.c: 219: setDigit (d - 1, * (val + i), true);
      008649 4B 01            [ 1]  389 	push	#0x01
      00864B 9F               [ 1]  390 	ld	a, xl
      00864C 88               [ 1]  391 	push	a
      00864D 9E               [ 1]  392 	ld	a, xh
      00864E 88               [ 1]  393 	push	a
      00864F CD 86 BD         [ 4]  394 	call	_setDigit
      008652 5B 03            [ 2]  395 	addw	sp, #3
                                    396 ;	./display.c: 220: i++;
      008654 0C 05            [ 1]  397 	inc	(0x05, sp)
      008656 20 0B            [ 2]  398 	jra	00122$
      008658                        399 00110$:
                                    400 ;	./display.c: 222: setDigit (d - 1, * (val + i), false);
      008658 4B 00            [ 1]  401 	push	#0x00
      00865A 9F               [ 1]  402 	ld	a, xl
      00865B 88               [ 1]  403 	push	a
      00865C 9E               [ 1]  404 	ld	a, xh
      00865D 88               [ 1]  405 	push	a
      00865E CD 86 BD         [ 4]  406 	call	_setDigit
      008661 5B 03            [ 2]  407 	addw	sp, #3
      008663                        408 00122$:
                                    409 ;	./display.c: 217: for (i = 0; d != 0 && *val + i != 0; i++, d--) {
      008663 0C 05            [ 1]  410 	inc	(0x05, sp)
      008665 0A 06            [ 1]  411 	dec	(0x06, sp)
      008667 20 AE            [ 2]  412 	jra	00121$
      008669                        413 00123$:
                                    414 ;	./display.c: 225: }
      008669 5B 06            [ 2]  415 	addw	sp, #6
      00866B 81               [ 4]  416 	ret
                                    417 ;	./display.c: 235: void enableDigit (unsigned char id)
                                    418 ;	-----------------------------------------
                                    419 ;	 function enableDigit
                                    420 ;	-----------------------------------------
      00866C                        421 _enableDigit:
                                    422 ;	./display.c: 237: switch (id) {
      00866C 7B 03            [ 1]  423 	ld	a, (0x03, sp)
      00866E A1 00            [ 1]  424 	cp	a, #0x00
      008670 27 0D            [ 1]  425 	jreq	00101$
      008672 7B 03            [ 1]  426 	ld	a, (0x03, sp)
      008674 4A               [ 1]  427 	dec	a
      008675 27 1A            [ 1]  428 	jreq	00102$
      008677 7B 03            [ 1]  429 	ld	a, (0x03, sp)
      008679 A1 02            [ 1]  430 	cp	a, #0x02
      00867B 27 26            [ 1]  431 	jreq	00103$
      00867D 20 31            [ 2]  432 	jra	00104$
                                    433 ;	./display.c: 238: case 0:
      00867F                        434 00101$:
                                    435 ;	./display.c: 239: SSD_DIGIT_12_PORT &= ~SSD_DIGIT_1_BIT;
      00867F C6 50 05         [ 1]  436 	ld	a, 0x5005
      008682 A4 EF            [ 1]  437 	and	a, #0xef
                                    438 ;	./display.c: 240: SSD_DIGIT_12_PORT |= SSD_DIGIT_2_BIT;
      008684 C7 50 05         [ 1]  439 	ld	0x5005, a
      008687 AA 20            [ 1]  440 	or	a, #0x20
      008689 C7 50 05         [ 1]  441 	ld	0x5005, a
                                    442 ;	./display.c: 241: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
      00868C 72 18 50 0F      [ 1]  443 	bset	20495, #4
                                    444 ;	./display.c: 242: break;
      008690 81               [ 4]  445 	ret
                                    446 ;	./display.c: 244: case 1:
      008691                        447 00102$:
                                    448 ;	./display.c: 245: SSD_DIGIT_12_PORT &= ~SSD_DIGIT_2_BIT;
      008691 C6 50 05         [ 1]  449 	ld	a, 0x5005
      008694 A4 DF            [ 1]  450 	and	a, #0xdf
                                    451 ;	./display.c: 246: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT;
      008696 C7 50 05         [ 1]  452 	ld	0x5005, a
      008699 AA 10            [ 1]  453 	or	a, #0x10
      00869B C7 50 05         [ 1]  454 	ld	0x5005, a
                                    455 ;	./display.c: 247: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
      00869E 72 18 50 0F      [ 1]  456 	bset	20495, #4
                                    457 ;	./display.c: 248: break;
      0086A2 81               [ 4]  458 	ret
                                    459 ;	./display.c: 250: case 2:
      0086A3                        460 00103$:
                                    461 ;	./display.c: 251: SSD_DIGIT_3_PORT &= ~SSD_DIGIT_3_BIT;
      0086A3 72 19 50 0F      [ 1]  462 	bres	20495, #4
                                    463 ;	./display.c: 252: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
      0086A7 C6 50 05         [ 1]  464 	ld	a, 0x5005
      0086AA AA 30            [ 1]  465 	or	a, #0x30
      0086AC C7 50 05         [ 1]  466 	ld	0x5005, a
                                    467 ;	./display.c: 253: break;
      0086AF 81               [ 4]  468 	ret
                                    469 ;	./display.c: 255: default:
      0086B0                        470 00104$:
                                    471 ;	./display.c: 256: SSD_DIGIT_12_PORT |= SSD_DIGIT_1_BIT | SSD_DIGIT_2_BIT;
      0086B0 C6 50 05         [ 1]  472 	ld	a, 0x5005
      0086B3 AA 30            [ 1]  473 	or	a, #0x30
      0086B5 C7 50 05         [ 1]  474 	ld	0x5005, a
                                    475 ;	./display.c: 257: SSD_DIGIT_3_PORT |= SSD_DIGIT_3_BIT;
      0086B8 72 18 50 0F      [ 1]  476 	bset	20495, #4
                                    477 ;	./display.c: 259: }
                                    478 ;	./display.c: 260: }
      0086BC 81               [ 4]  479 	ret
                                    480 ;	./display.c: 290: static void setDigit (unsigned char id, unsigned char val, bool dot)
                                    481 ;	-----------------------------------------
                                    482 ;	 function setDigit
                                    483 ;	-----------------------------------------
      0086BD                        484 _setDigit:
                                    485 ;	./display.c: 293: if (id > 2) return;
      0086BD 7B 03            [ 1]  486 	ld	a, (0x03, sp)
      0086BF A1 02            [ 1]  487 	cp	a, #0x02
      0086C1 23 01            [ 2]  488 	jrule	00102$
      0086C3 81               [ 4]  489 	ret
      0086C4                        490 00102$:
                                    491 ;	./display.c: 295: if (testMode) return;
      0086C4 72 00 00 17 02   [ 2]  492 	btjt	_testMode+0, #0, 00284$
      0086C9 20 01            [ 2]  493 	jra	00104$
      0086CB                        494 00284$:
      0086CB 81               [ 4]  495 	ret
      0086CC                        496 00104$:
                                    497 ;	./display.c: 297: switch (val) {
      0086CC 7B 04            [ 1]  498 	ld	a, (0x04, sp)
      0086CE A1 20            [ 1]  499 	cp	a, #0x20
      0086D0 26 03            [ 1]  500 	jrne	00286$
      0086D2 CC 87 CD         [ 2]  501 	jp	00106$
      0086D5                        502 00286$:
      0086D5 7B 04            [ 1]  503 	ld	a, (0x04, sp)
      0086D7 A1 2D            [ 1]  504 	cp	a, #0x2d
      0086D9 26 03            [ 1]  505 	jrne	00289$
      0086DB CC 87 B9         [ 2]  506 	jp	00105$
      0086DE                        507 00289$:
      0086DE 7B 04            [ 1]  508 	ld	a, (0x04, sp)
      0086E0 A1 30            [ 1]  509 	cp	a, #0x30
      0086E2 26 03            [ 1]  510 	jrne	00292$
      0086E4 CC 87 E0         [ 2]  511 	jp	00107$
      0086E7                        512 00292$:
      0086E7 7B 04            [ 1]  513 	ld	a, (0x04, sp)
      0086E9 A1 31            [ 1]  514 	cp	a, #0x31
      0086EB 26 03            [ 1]  515 	jrne	00295$
      0086ED CC 87 F5         [ 2]  516 	jp	00108$
      0086F0                        517 00295$:
      0086F0 7B 04            [ 1]  518 	ld	a, (0x04, sp)
      0086F2 A1 32            [ 1]  519 	cp	a, #0x32
      0086F4 26 03            [ 1]  520 	jrne	00298$
      0086F6 CC 88 09         [ 2]  521 	jp	00109$
      0086F9                        522 00298$:
      0086F9 7B 04            [ 1]  523 	ld	a, (0x04, sp)
      0086FB A1 33            [ 1]  524 	cp	a, #0x33
      0086FD 26 03            [ 1]  525 	jrne	00301$
      0086FF CC 88 1E         [ 2]  526 	jp	00110$
      008702                        527 00301$:
      008702 7B 04            [ 1]  528 	ld	a, (0x04, sp)
      008704 A1 34            [ 1]  529 	cp	a, #0x34
      008706 26 03            [ 1]  530 	jrne	00304$
      008708 CC 88 33         [ 2]  531 	jp	00111$
      00870B                        532 00304$:
      00870B 7B 04            [ 1]  533 	ld	a, (0x04, sp)
      00870D A1 35            [ 1]  534 	cp	a, #0x35
      00870F 26 03            [ 1]  535 	jrne	00307$
      008711 CC 88 47         [ 2]  536 	jp	00113$
      008714                        537 00307$:
      008714 7B 04            [ 1]  538 	ld	a, (0x04, sp)
      008716 A1 36            [ 1]  539 	cp	a, #0x36
      008718 26 03            [ 1]  540 	jrne	00310$
      00871A CC 88 5C         [ 2]  541 	jp	00114$
      00871D                        542 00310$:
      00871D 7B 04            [ 1]  543 	ld	a, (0x04, sp)
      00871F A1 37            [ 1]  544 	cp	a, #0x37
      008721 26 03            [ 1]  545 	jrne	00313$
      008723 CC 88 71         [ 2]  546 	jp	00115$
      008726                        547 00313$:
      008726 7B 04            [ 1]  548 	ld	a, (0x04, sp)
      008728 A1 38            [ 1]  549 	cp	a, #0x38
      00872A 26 03            [ 1]  550 	jrne	00316$
      00872C CC 88 86         [ 2]  551 	jp	00116$
      00872F                        552 00316$:
      00872F 7B 04            [ 1]  553 	ld	a, (0x04, sp)
      008731 A1 39            [ 1]  554 	cp	a, #0x39
      008733 26 03            [ 1]  555 	jrne	00319$
      008735 CC 88 9B         [ 2]  556 	jp	00117$
      008738                        557 00319$:
      008738 7B 04            [ 1]  558 	ld	a, (0x04, sp)
      00873A A1 41            [ 1]  559 	cp	a, #0x41
      00873C 26 03            [ 1]  560 	jrne	00322$
      00873E CC 88 B0         [ 2]  561 	jp	00118$
      008741                        562 00322$:
      008741 7B 04            [ 1]  563 	ld	a, (0x04, sp)
      008743 A1 42            [ 1]  564 	cp	a, #0x42
      008745 26 03            [ 1]  565 	jrne	00325$
      008747 CC 88 C5         [ 2]  566 	jp	00119$
      00874A                        567 00325$:
      00874A 7B 04            [ 1]  568 	ld	a, (0x04, sp)
      00874C A1 43            [ 1]  569 	cp	a, #0x43
      00874E 26 03            [ 1]  570 	jrne	00328$
      008750 CC 88 DA         [ 2]  571 	jp	00120$
      008753                        572 00328$:
      008753 7B 04            [ 1]  573 	ld	a, (0x04, sp)
      008755 A1 44            [ 1]  574 	cp	a, #0x44
      008757 26 03            [ 1]  575 	jrne	00331$
      008759 CC 88 EF         [ 2]  576 	jp	00121$
      00875C                        577 00331$:
      00875C 7B 04            [ 1]  578 	ld	a, (0x04, sp)
      00875E A1 45            [ 1]  579 	cp	a, #0x45
      008760 26 03            [ 1]  580 	jrne	00334$
      008762 CC 89 04         [ 2]  581 	jp	00122$
      008765                        582 00334$:
      008765 7B 04            [ 1]  583 	ld	a, (0x04, sp)
      008767 A1 46            [ 1]  584 	cp	a, #0x46
      008769 26 03            [ 1]  585 	jrne	00337$
      00876B CC 89 19         [ 2]  586 	jp	00123$
      00876E                        587 00337$:
      00876E 7B 04            [ 1]  588 	ld	a, (0x04, sp)
      008770 A1 48            [ 1]  589 	cp	a, #0x48
      008772 26 03            [ 1]  590 	jrne	00340$
      008774 CC 89 2E         [ 2]  591 	jp	00124$
      008777                        592 00340$:
      008777 7B 04            [ 1]  593 	ld	a, (0x04, sp)
      008779 A1 4C            [ 1]  594 	cp	a, #0x4c
      00877B 26 03            [ 1]  595 	jrne	00343$
      00877D CC 89 43         [ 2]  596 	jp	00125$
      008780                        597 00343$:
      008780 7B 04            [ 1]  598 	ld	a, (0x04, sp)
      008782 A1 4E            [ 1]  599 	cp	a, #0x4e
      008784 26 03            [ 1]  600 	jrne	00346$
      008786 CC 89 58         [ 2]  601 	jp	00126$
      008789                        602 00346$:
      008789 7B 04            [ 1]  603 	ld	a, (0x04, sp)
      00878B A1 4F            [ 1]  604 	cp	a, #0x4f
      00878D 26 03            [ 1]  605 	jrne	00349$
      00878F CC 89 6C         [ 2]  606 	jp	00127$
      008792                        607 00349$:
      008792 7B 04            [ 1]  608 	ld	a, (0x04, sp)
      008794 A1 50            [ 1]  609 	cp	a, #0x50
      008796 26 03            [ 1]  610 	jrne	00352$
      008798 CC 89 80         [ 2]  611 	jp	00128$
      00879B                        612 00352$:
      00879B 7B 04            [ 1]  613 	ld	a, (0x04, sp)
      00879D A1 52            [ 1]  614 	cp	a, #0x52
      00879F 26 03            [ 1]  615 	jrne	00355$
      0087A1 CC 89 94         [ 2]  616 	jp	00129$
      0087A4                        617 00355$:
      0087A4 7B 04            [ 1]  618 	ld	a, (0x04, sp)
      0087A6 A1 53            [ 1]  619 	cp	a, #0x53
      0087A8 26 03            [ 1]  620 	jrne	00358$
      0087AA CC 88 47         [ 2]  621 	jp	00113$
      0087AD                        622 00358$:
      0087AD 7B 04            [ 1]  623 	ld	a, (0x04, sp)
      0087AF A1 54            [ 1]  624 	cp	a, #0x54
      0087B1 26 03            [ 1]  625 	jrne	00361$
      0087B3 CC 89 A8         [ 2]  626 	jp	00130$
      0087B6                        627 00361$:
      0087B6 CC 89 BC         [ 2]  628 	jp	00131$
                                    629 ;	./display.c: 298: case '-':
      0087B9                        630 00105$:
                                    631 ;	./display.c: 299: displayAC[id] = SSD_SEG_G_BIT;
      0087B9 5F               [ 1]  632 	clrw	x
      0087BA 7B 03            [ 1]  633 	ld	a, (0x03, sp)
      0087BC 97               [ 1]  634 	ld	xl, a
      0087BD A6 40            [ 1]  635 	ld	a, #0x40
      0087BF D7 00 10         [ 1]  636 	ld	((_displayAC + 0), x), a
                                    637 ;	./display.c: 300: displayD[id] = 0;
      0087C2 5F               [ 1]  638 	clrw	x
      0087C3 7B 03            [ 1]  639 	ld	a, (0x03, sp)
      0087C5 97               [ 1]  640 	ld	xl, a
      0087C6 72 4F 00 13      [ 1]  641 	clr	((_displayD + 0), x)
                                    642 ;	./display.c: 301: break;
      0087CA CC 89 CD         [ 2]  643 	jp	00132$
                                    644 ;	./display.c: 303: case ' ':
      0087CD                        645 00106$:
                                    646 ;	./display.c: 304: displayAC[id] = 0;
      0087CD 5F               [ 1]  647 	clrw	x
      0087CE 7B 03            [ 1]  648 	ld	a, (0x03, sp)
      0087D0 97               [ 1]  649 	ld	xl, a
      0087D1 72 4F 00 10      [ 1]  650 	clr	((_displayAC + 0), x)
                                    651 ;	./display.c: 305: displayD[id] = 0;
      0087D5 5F               [ 1]  652 	clrw	x
      0087D6 7B 03            [ 1]  653 	ld	a, (0x03, sp)
      0087D8 97               [ 1]  654 	ld	xl, a
      0087D9 72 4F 00 13      [ 1]  655 	clr	((_displayD + 0), x)
                                    656 ;	./display.c: 306: break;
      0087DD CC 89 CD         [ 2]  657 	jp	00132$
                                    658 ;	./display.c: 308: case '0':
      0087E0                        659 00107$:
                                    660 ;	./display.c: 309: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
      0087E0 5F               [ 1]  661 	clrw	x
      0087E1 7B 03            [ 1]  662 	ld	a, (0x03, sp)
      0087E3 97               [ 1]  663 	ld	xl, a
      0087E4 A6 86            [ 1]  664 	ld	a, #0x86
      0087E6 D7 00 10         [ 1]  665 	ld	((_displayAC + 0), x), a
                                    666 ;	./display.c: 310: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0087E9 5F               [ 1]  667 	clrw	x
      0087EA 7B 03            [ 1]  668 	ld	a, (0x03, sp)
      0087EC 97               [ 1]  669 	ld	xl, a
      0087ED A6 2A            [ 1]  670 	ld	a, #0x2a
      0087EF D7 00 13         [ 1]  671 	ld	((_displayD + 0), x), a
                                    672 ;	./display.c: 311: break;
      0087F2 CC 89 CD         [ 2]  673 	jp	00132$
                                    674 ;	./display.c: 313: case '1':
      0087F5                        675 00108$:
                                    676 ;	./display.c: 314: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
      0087F5 5F               [ 1]  677 	clrw	x
      0087F6 7B 03            [ 1]  678 	ld	a, (0x03, sp)
      0087F8 97               [ 1]  679 	ld	xl, a
      0087F9 A6 84            [ 1]  680 	ld	a, #0x84
      0087FB D7 00 10         [ 1]  681 	ld	((_displayAC + 0), x), a
                                    682 ;	./display.c: 315: displayD[id] = 0;
      0087FE 5F               [ 1]  683 	clrw	x
      0087FF 7B 03            [ 1]  684 	ld	a, (0x03, sp)
      008801 97               [ 1]  685 	ld	xl, a
      008802 72 4F 00 13      [ 1]  686 	clr	((_displayD + 0), x)
                                    687 ;	./display.c: 316: break;
      008806 CC 89 CD         [ 2]  688 	jp	00132$
                                    689 ;	./display.c: 318: case '2':
      008809                        690 00109$:
                                    691 ;	./display.c: 319: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_G_BIT;
      008809 5F               [ 1]  692 	clrw	x
      00880A 7B 03            [ 1]  693 	ld	a, (0x03, sp)
      00880C 97               [ 1]  694 	ld	xl, a
      00880D A6 44            [ 1]  695 	ld	a, #0x44
      00880F D7 00 10         [ 1]  696 	ld	((_displayAC + 0), x), a
                                    697 ;	./display.c: 320: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      008812 5F               [ 1]  698 	clrw	x
      008813 7B 03            [ 1]  699 	ld	a, (0x03, sp)
      008815 97               [ 1]  700 	ld	xl, a
      008816 A6 2A            [ 1]  701 	ld	a, #0x2a
      008818 D7 00 13         [ 1]  702 	ld	((_displayD + 0), x), a
                                    703 ;	./display.c: 321: break;
      00881B CC 89 CD         [ 2]  704 	jp	00132$
                                    705 ;	./display.c: 323: case '3':
      00881E                        706 00110$:
                                    707 ;	./display.c: 324: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT;
      00881E 5F               [ 1]  708 	clrw	x
      00881F 7B 03            [ 1]  709 	ld	a, (0x03, sp)
      008821 97               [ 1]  710 	ld	xl, a
      008822 A6 C4            [ 1]  711 	ld	a, #0xc4
      008824 D7 00 10         [ 1]  712 	ld	((_displayAC + 0), x), a
                                    713 ;	./display.c: 325: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
      008827 5F               [ 1]  714 	clrw	x
      008828 7B 03            [ 1]  715 	ld	a, (0x03, sp)
      00882A 97               [ 1]  716 	ld	xl, a
      00882B A6 28            [ 1]  717 	ld	a, #0x28
      00882D D7 00 13         [ 1]  718 	ld	((_displayD + 0), x), a
                                    719 ;	./display.c: 326: break;
      008830 CC 89 CD         [ 2]  720 	jp	00132$
                                    721 ;	./display.c: 328: case '4':
      008833                        722 00111$:
                                    723 ;	./display.c: 329: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008833 5F               [ 1]  724 	clrw	x
      008834 7B 03            [ 1]  725 	ld	a, (0x03, sp)
      008836 97               [ 1]  726 	ld	xl, a
      008837 A6 C6            [ 1]  727 	ld	a, #0xc6
      008839 D7 00 10         [ 1]  728 	ld	((_displayAC + 0), x), a
                                    729 ;	./display.c: 330: displayD[id] = 0;
      00883C 5F               [ 1]  730 	clrw	x
      00883D 7B 03            [ 1]  731 	ld	a, (0x03, sp)
      00883F 97               [ 1]  732 	ld	xl, a
      008840 72 4F 00 13      [ 1]  733 	clr	((_displayD + 0), x)
                                    734 ;	./display.c: 331: break;
      008844 CC 89 CD         [ 2]  735 	jp	00132$
                                    736 ;	./display.c: 334: case 'S':
      008847                        737 00113$:
                                    738 ;	./display.c: 335: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008847 5F               [ 1]  739 	clrw	x
      008848 7B 03            [ 1]  740 	ld	a, (0x03, sp)
      00884A 97               [ 1]  741 	ld	xl, a
      00884B A6 C2            [ 1]  742 	ld	a, #0xc2
      00884D D7 00 10         [ 1]  743 	ld	((_displayAC + 0), x), a
                                    744 ;	./display.c: 336: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
      008850 5F               [ 1]  745 	clrw	x
      008851 7B 03            [ 1]  746 	ld	a, (0x03, sp)
      008853 97               [ 1]  747 	ld	xl, a
      008854 A6 28            [ 1]  748 	ld	a, #0x28
      008856 D7 00 13         [ 1]  749 	ld	((_displayD + 0), x), a
                                    750 ;	./display.c: 337: break;
      008859 CC 89 CD         [ 2]  751 	jp	00132$
                                    752 ;	./display.c: 339: case '6':
      00885C                        753 00114$:
                                    754 ;	./display.c: 340: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      00885C 5F               [ 1]  755 	clrw	x
      00885D 7B 03            [ 1]  756 	ld	a, (0x03, sp)
      00885F 97               [ 1]  757 	ld	xl, a
      008860 A6 C2            [ 1]  758 	ld	a, #0xc2
      008862 D7 00 10         [ 1]  759 	ld	((_displayAC + 0), x), a
                                    760 ;	./display.c: 341: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      008865 5F               [ 1]  761 	clrw	x
      008866 7B 03            [ 1]  762 	ld	a, (0x03, sp)
      008868 97               [ 1]  763 	ld	xl, a
      008869 A6 2A            [ 1]  764 	ld	a, #0x2a
      00886B D7 00 13         [ 1]  765 	ld	((_displayD + 0), x), a
                                    766 ;	./display.c: 342: break;
      00886E CC 89 CD         [ 2]  767 	jp	00132$
                                    768 ;	./display.c: 344: case '7':
      008871                        769 00115$:
                                    770 ;	./display.c: 345: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT;
      008871 5F               [ 1]  771 	clrw	x
      008872 7B 03            [ 1]  772 	ld	a, (0x03, sp)
      008874 97               [ 1]  773 	ld	xl, a
      008875 A6 84            [ 1]  774 	ld	a, #0x84
      008877 D7 00 10         [ 1]  775 	ld	((_displayAC + 0), x), a
                                    776 ;	./display.c: 346: displayD[id] = SSD_SEG_A_BIT;
      00887A 5F               [ 1]  777 	clrw	x
      00887B 7B 03            [ 1]  778 	ld	a, (0x03, sp)
      00887D 97               [ 1]  779 	ld	xl, a
      00887E A6 20            [ 1]  780 	ld	a, #0x20
      008880 D7 00 13         [ 1]  781 	ld	((_displayD + 0), x), a
                                    782 ;	./display.c: 347: break;
      008883 CC 89 CD         [ 2]  783 	jp	00132$
                                    784 ;	./display.c: 349: case '8':
      008886                        785 00116$:
                                    786 ;	./display.c: 350: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008886 5F               [ 1]  787 	clrw	x
      008887 7B 03            [ 1]  788 	ld	a, (0x03, sp)
      008889 97               [ 1]  789 	ld	xl, a
      00888A A6 C6            [ 1]  790 	ld	a, #0xc6
      00888C D7 00 10         [ 1]  791 	ld	((_displayAC + 0), x), a
                                    792 ;	./display.c: 351: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      00888F 5F               [ 1]  793 	clrw	x
      008890 7B 03            [ 1]  794 	ld	a, (0x03, sp)
      008892 97               [ 1]  795 	ld	xl, a
      008893 A6 2A            [ 1]  796 	ld	a, #0x2a
      008895 D7 00 13         [ 1]  797 	ld	((_displayD + 0), x), a
                                    798 ;	./display.c: 352: break;
      008898 CC 89 CD         [ 2]  799 	jp	00132$
                                    800 ;	./display.c: 354: case '9':
      00889B                        801 00117$:
                                    802 ;	./display.c: 355: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      00889B 5F               [ 1]  803 	clrw	x
      00889C 7B 03            [ 1]  804 	ld	a, (0x03, sp)
      00889E 97               [ 1]  805 	ld	xl, a
      00889F A6 C6            [ 1]  806 	ld	a, #0xc6
      0088A1 D7 00 10         [ 1]  807 	ld	((_displayAC + 0), x), a
                                    808 ;	./display.c: 356: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT;
      0088A4 5F               [ 1]  809 	clrw	x
      0088A5 7B 03            [ 1]  810 	ld	a, (0x03, sp)
      0088A7 97               [ 1]  811 	ld	xl, a
      0088A8 A6 28            [ 1]  812 	ld	a, #0x28
      0088AA D7 00 13         [ 1]  813 	ld	((_displayD + 0), x), a
                                    814 ;	./display.c: 357: break;
      0088AD CC 89 CD         [ 2]  815 	jp	00132$
                                    816 ;	./display.c: 359: case 'A':
      0088B0                        817 00118$:
                                    818 ;	./display.c: 360: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      0088B0 5F               [ 1]  819 	clrw	x
      0088B1 7B 03            [ 1]  820 	ld	a, (0x03, sp)
      0088B3 97               [ 1]  821 	ld	xl, a
      0088B4 A6 C6            [ 1]  822 	ld	a, #0xc6
      0088B6 D7 00 10         [ 1]  823 	ld	((_displayAC + 0), x), a
                                    824 ;	./display.c: 361: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      0088B9 5F               [ 1]  825 	clrw	x
      0088BA 7B 03            [ 1]  826 	ld	a, (0x03, sp)
      0088BC 97               [ 1]  827 	ld	xl, a
      0088BD A6 22            [ 1]  828 	ld	a, #0x22
      0088BF D7 00 13         [ 1]  829 	ld	((_displayD + 0), x), a
                                    830 ;	./display.c: 362: break;
      0088C2 CC 89 CD         [ 2]  831 	jp	00132$
                                    832 ;	./display.c: 364: case 'B':
      0088C5                        833 00119$:
                                    834 ;	./display.c: 365: displayAC[id] = SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      0088C5 5F               [ 1]  835 	clrw	x
      0088C6 7B 03            [ 1]  836 	ld	a, (0x03, sp)
      0088C8 97               [ 1]  837 	ld	xl, a
      0088C9 A6 C2            [ 1]  838 	ld	a, #0xc2
      0088CB D7 00 10         [ 1]  839 	ld	((_displayAC + 0), x), a
                                    840 ;	./display.c: 366: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0088CE 5F               [ 1]  841 	clrw	x
      0088CF 7B 03            [ 1]  842 	ld	a, (0x03, sp)
      0088D1 97               [ 1]  843 	ld	xl, a
      0088D2 A6 0A            [ 1]  844 	ld	a, #0x0a
      0088D4 D7 00 13         [ 1]  845 	ld	((_displayD + 0), x), a
                                    846 ;	./display.c: 367: break;
      0088D7 CC 89 CD         [ 2]  847 	jp	00132$
                                    848 ;	./display.c: 369: case 'C':
      0088DA                        849 00120$:
                                    850 ;	./display.c: 370: displayAC[id] = SSD_SEG_F_BIT;
      0088DA 5F               [ 1]  851 	clrw	x
      0088DB 7B 03            [ 1]  852 	ld	a, (0x03, sp)
      0088DD 97               [ 1]  853 	ld	xl, a
      0088DE A6 02            [ 1]  854 	ld	a, #0x02
      0088E0 D7 00 10         [ 1]  855 	ld	((_displayAC + 0), x), a
                                    856 ;	./display.c: 371: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0088E3 5F               [ 1]  857 	clrw	x
      0088E4 7B 03            [ 1]  858 	ld	a, (0x03, sp)
      0088E6 97               [ 1]  859 	ld	xl, a
      0088E7 A6 2A            [ 1]  860 	ld	a, #0x2a
      0088E9 D7 00 13         [ 1]  861 	ld	((_displayD + 0), x), a
                                    862 ;	./display.c: 372: break;
      0088EC CC 89 CD         [ 2]  863 	jp	00132$
                                    864 ;	./display.c: 374: case 'D':
      0088EF                        865 00121$:
                                    866 ;	./display.c: 375: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_G_BIT;
      0088EF 5F               [ 1]  867 	clrw	x
      0088F0 7B 03            [ 1]  868 	ld	a, (0x03, sp)
      0088F2 97               [ 1]  869 	ld	xl, a
      0088F3 A6 C4            [ 1]  870 	ld	a, #0xc4
      0088F5 D7 00 10         [ 1]  871 	ld	((_displayAC + 0), x), a
                                    872 ;	./display.c: 376: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0088F8 5F               [ 1]  873 	clrw	x
      0088F9 7B 03            [ 1]  874 	ld	a, (0x03, sp)
      0088FB 97               [ 1]  875 	ld	xl, a
      0088FC A6 0A            [ 1]  876 	ld	a, #0x0a
      0088FE D7 00 13         [ 1]  877 	ld	((_displayD + 0), x), a
                                    878 ;	./display.c: 377: break;
      008901 CC 89 CD         [ 2]  879 	jp	00132$
                                    880 ;	./display.c: 379: case 'E':
      008904                        881 00122$:
                                    882 ;	./display.c: 380: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008904 5F               [ 1]  883 	clrw	x
      008905 7B 03            [ 1]  884 	ld	a, (0x03, sp)
      008907 97               [ 1]  885 	ld	xl, a
      008908 A6 42            [ 1]  886 	ld	a, #0x42
      00890A D7 00 10         [ 1]  887 	ld	((_displayAC + 0), x), a
                                    888 ;	./display.c: 381: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      00890D 5F               [ 1]  889 	clrw	x
      00890E 7B 03            [ 1]  890 	ld	a, (0x03, sp)
      008910 97               [ 1]  891 	ld	xl, a
      008911 A6 2A            [ 1]  892 	ld	a, #0x2a
      008913 D7 00 13         [ 1]  893 	ld	((_displayD + 0), x), a
                                    894 ;	./display.c: 382: break;
      008916 CC 89 CD         [ 2]  895 	jp	00132$
                                    896 ;	./display.c: 384: case 'F':
      008919                        897 00123$:
                                    898 ;	./display.c: 385: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008919 5F               [ 1]  899 	clrw	x
      00891A 7B 03            [ 1]  900 	ld	a, (0x03, sp)
      00891C 97               [ 1]  901 	ld	xl, a
      00891D A6 42            [ 1]  902 	ld	a, #0x42
      00891F D7 00 10         [ 1]  903 	ld	((_displayAC + 0), x), a
                                    904 ;	./display.c: 386: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      008922 5F               [ 1]  905 	clrw	x
      008923 7B 03            [ 1]  906 	ld	a, (0x03, sp)
      008925 97               [ 1]  907 	ld	xl, a
      008926 A6 22            [ 1]  908 	ld	a, #0x22
      008928 D7 00 13         [ 1]  909 	ld	((_displayD + 0), x), a
                                    910 ;	./display.c: 387: break;
      00892B CC 89 CD         [ 2]  911 	jp	00132$
                                    912 ;	./display.c: 389: case 'H':
      00892E                        913 00124$:
                                    914 ;	./display.c: 390: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_C_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      00892E 5F               [ 1]  915 	clrw	x
      00892F 7B 03            [ 1]  916 	ld	a, (0x03, sp)
      008931 97               [ 1]  917 	ld	xl, a
      008932 A6 C6            [ 1]  918 	ld	a, #0xc6
      008934 D7 00 10         [ 1]  919 	ld	((_displayAC + 0), x), a
                                    920 ;	./display.c: 391: displayD[id] = SSD_SEG_E_BIT;
      008937 5F               [ 1]  921 	clrw	x
      008938 7B 03            [ 1]  922 	ld	a, (0x03, sp)
      00893A 97               [ 1]  923 	ld	xl, a
      00893B A6 02            [ 1]  924 	ld	a, #0x02
      00893D D7 00 13         [ 1]  925 	ld	((_displayD + 0), x), a
                                    926 ;	./display.c: 392: break;
      008940 CC 89 CD         [ 2]  927 	jp	00132$
                                    928 ;	./display.c: 394: case 'L':
      008943                        929 00125$:
                                    930 ;	./display.c: 395: displayAC[id] = SSD_SEG_F_BIT;
      008943 5F               [ 1]  931 	clrw	x
      008944 7B 03            [ 1]  932 	ld	a, (0x03, sp)
      008946 97               [ 1]  933 	ld	xl, a
      008947 A6 02            [ 1]  934 	ld	a, #0x02
      008949 D7 00 10         [ 1]  935 	ld	((_displayAC + 0), x), a
                                    936 ;	./display.c: 396: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      00894C 5F               [ 1]  937 	clrw	x
      00894D 7B 03            [ 1]  938 	ld	a, (0x03, sp)
      00894F 97               [ 1]  939 	ld	xl, a
      008950 A6 0A            [ 1]  940 	ld	a, #0x0a
      008952 D7 00 13         [ 1]  941 	ld	((_displayD + 0), x), a
                                    942 ;	./display.c: 397: break;
      008955 CC 89 CD         [ 2]  943 	jp	00132$
                                    944 ;	./display.c: 399: case 'N':
      008958                        945 00126$:
                                    946 ;	./display.c: 400: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
      008958 5F               [ 1]  947 	clrw	x
      008959 7B 03            [ 1]  948 	ld	a, (0x03, sp)
      00895B 97               [ 1]  949 	ld	xl, a
      00895C A6 86            [ 1]  950 	ld	a, #0x86
      00895E D7 00 10         [ 1]  951 	ld	((_displayAC + 0), x), a
                                    952 ;	./display.c: 401: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      008961 5F               [ 1]  953 	clrw	x
      008962 7B 03            [ 1]  954 	ld	a, (0x03, sp)
      008964 97               [ 1]  955 	ld	xl, a
      008965 A6 22            [ 1]  956 	ld	a, #0x22
      008967 D7 00 13         [ 1]  957 	ld	((_displayD + 0), x), a
                                    958 ;	./display.c: 402: break;
      00896A 20 61            [ 2]  959 	jra	00132$
                                    960 ;	./display.c: 404: case 'O':
      00896C                        961 00127$:
                                    962 ;	./display.c: 405: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_C_BIT;
      00896C 5F               [ 1]  963 	clrw	x
      00896D 7B 03            [ 1]  964 	ld	a, (0x03, sp)
      00896F 97               [ 1]  965 	ld	xl, a
      008970 A6 86            [ 1]  966 	ld	a, #0x86
      008972 D7 00 10         [ 1]  967 	ld	((_displayAC + 0), x), a
                                    968 ;	./display.c: 406: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      008975 5F               [ 1]  969 	clrw	x
      008976 7B 03            [ 1]  970 	ld	a, (0x03, sp)
      008978 97               [ 1]  971 	ld	xl, a
      008979 A6 2A            [ 1]  972 	ld	a, #0x2a
      00897B D7 00 13         [ 1]  973 	ld	((_displayD + 0), x), a
                                    974 ;	./display.c: 407: break;
      00897E 20 4D            [ 2]  975 	jra	00132$
                                    976 ;	./display.c: 409: case 'P':
      008980                        977 00128$:
                                    978 ;	./display.c: 410: displayAC[id] = SSD_SEG_B_BIT | SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      008980 5F               [ 1]  979 	clrw	x
      008981 7B 03            [ 1]  980 	ld	a, (0x03, sp)
      008983 97               [ 1]  981 	ld	xl, a
      008984 A6 46            [ 1]  982 	ld	a, #0x46
      008986 D7 00 10         [ 1]  983 	ld	((_displayAC + 0), x), a
                                    984 ;	./display.c: 411: displayD[id] = SSD_SEG_A_BIT | SSD_SEG_E_BIT;
      008989 5F               [ 1]  985 	clrw	x
      00898A 7B 03            [ 1]  986 	ld	a, (0x03, sp)
      00898C 97               [ 1]  987 	ld	xl, a
      00898D A6 22            [ 1]  988 	ld	a, #0x22
      00898F D7 00 13         [ 1]  989 	ld	((_displayD + 0), x), a
                                    990 ;	./display.c: 412: break;
      008992 20 39            [ 2]  991 	jra	00132$
                                    992 ;	./display.c: 414: case 'R':
      008994                        993 00129$:
                                    994 ;	./display.c: 415: displayAC[id] = SSD_SEG_G_BIT;
      008994 5F               [ 1]  995 	clrw	x
      008995 7B 03            [ 1]  996 	ld	a, (0x03, sp)
      008997 97               [ 1]  997 	ld	xl, a
      008998 A6 40            [ 1]  998 	ld	a, #0x40
      00899A D7 00 10         [ 1]  999 	ld	((_displayAC + 0), x), a
                                   1000 ;	./display.c: 416: displayD[id] = SSD_SEG_E_BIT;
      00899D 5F               [ 1] 1001 	clrw	x
      00899E 7B 03            [ 1] 1002 	ld	a, (0x03, sp)
      0089A0 97               [ 1] 1003 	ld	xl, a
      0089A1 A6 02            [ 1] 1004 	ld	a, #0x02
      0089A3 D7 00 13         [ 1] 1005 	ld	((_displayD + 0), x), a
                                   1006 ;	./display.c: 417: break;
      0089A6 20 25            [ 2] 1007 	jra	00132$
                                   1008 ;	./display.c: 419: case 'T':
      0089A8                       1009 00130$:
                                   1010 ;	./display.c: 420: displayAC[id] = SSD_SEG_F_BIT | SSD_SEG_G_BIT;
      0089A8 5F               [ 1] 1011 	clrw	x
      0089A9 7B 03            [ 1] 1012 	ld	a, (0x03, sp)
      0089AB 97               [ 1] 1013 	ld	xl, a
      0089AC A6 42            [ 1] 1014 	ld	a, #0x42
      0089AE D7 00 10         [ 1] 1015 	ld	((_displayAC + 0), x), a
                                   1016 ;	./display.c: 421: displayD[id] = SSD_SEG_D_BIT | SSD_SEG_E_BIT;
      0089B1 5F               [ 1] 1017 	clrw	x
      0089B2 7B 03            [ 1] 1018 	ld	a, (0x03, sp)
      0089B4 97               [ 1] 1019 	ld	xl, a
      0089B5 A6 0A            [ 1] 1020 	ld	a, #0x0a
      0089B7 D7 00 13         [ 1] 1021 	ld	((_displayD + 0), x), a
                                   1022 ;	./display.c: 422: break;
      0089BA 20 11            [ 2] 1023 	jra	00132$
                                   1024 ;	./display.c: 424: default:
      0089BC                       1025 00131$:
                                   1026 ;	./display.c: 425: displayAC[id] = 0;
      0089BC 5F               [ 1] 1027 	clrw	x
      0089BD 7B 03            [ 1] 1028 	ld	a, (0x03, sp)
      0089BF 97               [ 1] 1029 	ld	xl, a
      0089C0 72 4F 00 10      [ 1] 1030 	clr	((_displayAC + 0), x)
                                   1031 ;	./display.c: 426: displayD[id] = SSD_SEG_D_BIT;
      0089C4 5F               [ 1] 1032 	clrw	x
      0089C5 7B 03            [ 1] 1033 	ld	a, (0x03, sp)
      0089C7 97               [ 1] 1034 	ld	xl, a
      0089C8 A6 08            [ 1] 1035 	ld	a, #0x08
      0089CA D7 00 13         [ 1] 1036 	ld	((_displayD + 0), x), a
                                   1037 ;	./display.c: 427: }
      0089CD                       1038 00132$:
                                   1039 ;	./display.c: 429: if (dot) {
      0089CD 0D 05            [ 1] 1040 	tnz	(0x05, sp)
      0089CF 27 0C            [ 1] 1041 	jreq	00134$
                                   1042 ;	./display.c: 430: displayD[id] |= SSD_SEG_P_BIT;
      0089D1 5F               [ 1] 1043 	clrw	x
      0089D2 7B 03            [ 1] 1044 	ld	a, (0x03, sp)
      0089D4 97               [ 1] 1045 	ld	xl, a
      0089D5 1C 00 13         [ 2] 1046 	addw	x, #(_displayD + 0)
      0089D8 F6               [ 1] 1047 	ld	a, (x)
      0089D9 AA 04            [ 1] 1048 	or	a, #0x04
      0089DB F7               [ 1] 1049 	ld	(x), a
      0089DC 81               [ 4] 1050 	ret
      0089DD                       1051 00134$:
                                   1052 ;	./display.c: 432: displayD[id] &= ~SSD_SEG_P_BIT;
      0089DD 5F               [ 1] 1053 	clrw	x
      0089DE 7B 03            [ 1] 1054 	ld	a, (0x03, sp)
      0089E0 97               [ 1] 1055 	ld	xl, a
      0089E1 1C 00 13         [ 2] 1056 	addw	x, #(_displayD + 0)
      0089E4 F6               [ 1] 1057 	ld	a, (x)
      0089E5 A4 FB            [ 1] 1058 	and	a, #0xfb
      0089E7 F7               [ 1] 1059 	ld	(x), a
                                   1060 ;	./display.c: 435: return;
                                   1061 ;	./display.c: 436: }
      0089E8 81               [ 4] 1062 	ret
                                   1063 	.area CODE
                                   1064 	.area CONST
      0080A9                       1065 _Hex2CharMap:
      0080A9 30                    1066 	.db #0x30	; 48	'0'
      0080AA 31                    1067 	.db #0x31	; 49	'1'
      0080AB 32                    1068 	.db #0x32	; 50	'2'
      0080AC 33                    1069 	.db #0x33	; 51	'3'
      0080AD 34                    1070 	.db #0x34	; 52	'4'
      0080AE 35                    1071 	.db #0x35	; 53	'5'
      0080AF 36                    1072 	.db #0x36	; 54	'6'
      0080B0 37                    1073 	.db #0x37	; 55	'7'
      0080B1 38                    1074 	.db #0x38	; 56	'8'
      0080B2 39                    1075 	.db #0x39	; 57	'9'
      0080B3 41                    1076 	.db #0x41	; 65	'A'
      0080B4 42                    1077 	.db #0x42	; 66	'B'
      0080B5 43                    1078 	.db #0x43	; 67	'C'
      0080B6 44                    1079 	.db #0x44	; 68	'D'
      0080B7 45                    1080 	.db #0x45	; 69	'E'
      0080B8 46                    1081 	.db #0x46	; 70	'F'
                                   1082 	.area CONST
      0080B9                       1083 ___str_0:
      0080B9 00                    1084 	.db 0x00
                                   1085 	.area CODE
                                   1086 	.area CONST
      0080BA                       1087 ___str_1:
      0080BA 38 38 38              1088 	.ascii "888"
      0080BD 00                    1089 	.db 0x00
                                   1090 	.area CODE
                                   1091 	.area INITIALIZER
      008244                       1092 __xinit__lowBrightness:
      008244 00                    1093 	.db #0x00	;  0
                                   1094 	.area CABS (ABS)

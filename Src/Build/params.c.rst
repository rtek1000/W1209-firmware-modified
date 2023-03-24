                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module params
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _paramDefault
                                     12 	.globl _paramMax
                                     13 	.globl _paramMin
                                     14 	.globl _setMenuDisplay
                                     15 	.globl _getButton3
                                     16 	.globl _getButton2
                                     17 	.globl _initParamsEEPROM
                                     18 	.globl _getParamById
                                     19 	.globl _setParamById
                                     20 	.globl _getParam
                                     21 	.globl _setParam
                                     22 	.globl _incParam
                                     23 	.globl _decParam
                                     24 	.globl _getParamId
                                     25 	.globl _setParamId
                                     26 	.globl _incParamId
                                     27 	.globl _decParamId
                                     28 	.globl _paramToString
                                     29 	.globl _storeParams
                                     30 	.globl _itofpa
                                     31 ;--------------------------------------------------------
                                     32 ; ram data
                                     33 ;--------------------------------------------------------
                                     34 	.area DATA
      00002C                         35 _paramId:
      00002C                         36 	.ds 1
      00002D                         37 _paramCache:
      00002D                         38 	.ds 20
                                     39 ;--------------------------------------------------------
                                     40 ; ram data
                                     41 ;--------------------------------------------------------
                                     42 	.area INITIALIZED
                                     43 ;--------------------------------------------------------
                                     44 ; absolute external ram data
                                     45 ;--------------------------------------------------------
                                     46 	.area DABS (ABS)
                                     47 
                                     48 ; default segment ordering for linker
                                     49 	.area HOME
                                     50 	.area GSINIT
                                     51 	.area GSFINAL
                                     52 	.area CONST
                                     53 	.area INITIALIZER
                                     54 	.area CODE
                                     55 
                                     56 ;--------------------------------------------------------
                                     57 ; global & static initialisations
                                     58 ;--------------------------------------------------------
                                     59 	.area HOME
                                     60 	.area GSINIT
                                     61 	.area GSFINAL
                                     62 	.area GSINIT
                                     63 ;--------------------------------------------------------
                                     64 ; Home
                                     65 ;--------------------------------------------------------
                                     66 	.area HOME
                                     67 	.area HOME
                                     68 ;--------------------------------------------------------
                                     69 ; code
                                     70 ;--------------------------------------------------------
                                     71 	.area CODE
                                     72 ;	./params.c: 62: void initParamsEEPROM()
                                     73 ;	-----------------------------------------
                                     74 ;	 function initParamsEEPROM
                                     75 ;	-----------------------------------------
      009369                         76 _initParamsEEPROM:
                                     77 ;	./params.c: 64: if (getButton2() && getButton3() ) {
      009369 CD 8B A6         [ 4]   78 	call	_getButton2
      00936C 4D               [ 1]   79 	tnz	a
      00936D 27 18            [ 1]   80 	jreq	00104$
      00936F CD 8B B0         [ 4]   81 	call	_getButton3
      009372 4D               [ 1]   82 	tnz	a
      009373 27 12            [ 1]   83 	jreq	00104$
                                     84 ;	./params.c: 65: if (getParamById (PARAM_LOCK_BUTTONS)) {
      009375 4B 07            [ 1]   85 	push	#0x07
      009377 CD 93 E4         [ 4]   86 	call	_getParamById
      00937A 84               [ 1]   87 	pop	a
      00937B 5D               [ 2]   88 	tnzw	x
      00937C 27 09            [ 1]   89 	jreq	00104$
                                     90 ;	./params.c: 66: resetParamsEEPROM();
      00937E CD 93 9E         [ 4]   91 	call	_resetParamsEEPROM
                                     92 ;	./params.c: 67: setMenuDisplay(MENU_EEPROM_RESET);
      009381 4B 07            [ 1]   93 	push	#0x07
      009383 CD 8E D1         [ 4]   94 	call	_setMenuDisplay
      009386 84               [ 1]   95 	pop	a
      009387                         96 00104$:
                                     97 ;	./params.c: 71: loadParamsEEPROM();
      009387 CD 93 C2         [ 4]   98 	call	_loadParamsEEPROM
                                     99 ;	./params.c: 73: if (getParamById (PARAM_LOCK_BUTTONS)) {
      00938A 4B 07            [ 1]  100 	push	#0x07
      00938C CD 93 E4         [ 4]  101 	call	_getParamById
      00938F 84               [ 1]  102 	pop	a
      009390 5D               [ 2]  103 	tnzw	x
      009391 27 06            [ 1]  104 	jreq	00107$
                                    105 ;	./params.c: 74: setMenuDisplay(MENU_EEPROM_LOCKED);
      009393 4B 08            [ 1]  106 	push	#0x08
      009395 CD 8E D1         [ 4]  107 	call	_setMenuDisplay
      009398 84               [ 1]  108 	pop	a
      009399                        109 00107$:
                                    110 ;	./params.c: 77: paramId = 0;
      009399 72 5F 00 2C      [ 1]  111 	clr	_paramId+0
                                    112 ;	./params.c: 78: }
      00939D 81               [ 4]  113 	ret
                                    114 ;	./params.c: 80: static void resetParamsEEPROM()
                                    115 ;	-----------------------------------------
                                    116 ;	 function resetParamsEEPROM
                                    117 ;	-----------------------------------------
      00939E                        118 _resetParamsEEPROM:
                                    119 ;	./params.c: 83: for (paramId = 0; paramId < paramLen; paramId++) {
      00939E 72 5F 00 2C      [ 1]  120 	clr	_paramId+0
      0093A2                        121 00102$:
                                    122 ;	./params.c: 84: paramCache[paramId] = paramDefault[paramId];
      0093A2 C6 00 2C         [ 1]  123 	ld	a, _paramId+0
      0093A5 5F               [ 1]  124 	clrw	x
      0093A6 97               [ 1]  125 	ld	xl, a
      0093A7 58               [ 2]  126 	sllw	x
      0093A8 90 93            [ 1]  127 	ldw	y, x
      0093AA 72 A9 00 2D      [ 2]  128 	addw	y, #(_paramCache + 0)
      0093AE 1C 82 30         [ 2]  129 	addw	x, #(_paramDefault + 0)
      0093B1 FE               [ 2]  130 	ldw	x, (x)
      0093B2 90 FF            [ 2]  131 	ldw	(y), x
                                    132 ;	./params.c: 83: for (paramId = 0; paramId < paramLen; paramId++) {
      0093B4 72 5C 00 2C      [ 1]  133 	inc	_paramId+0
      0093B8 C6 00 2C         [ 1]  134 	ld	a, _paramId+0
      0093BB A1 0A            [ 1]  135 	cp	a, #0x0a
      0093BD 25 E3            [ 1]  136 	jrc	00102$
                                    137 ;	./params.c: 87: storeParams();
                                    138 ;	./params.c: 88: }
      0093BF CC 96 3F         [ 2]  139 	jp	_storeParams
                                    140 ;	./params.c: 90: static void loadParamsEEPROM()
                                    141 ;	-----------------------------------------
                                    142 ;	 function loadParamsEEPROM
                                    143 ;	-----------------------------------------
      0093C2                        144 _loadParamsEEPROM:
                                    145 ;	./params.c: 93: for (paramId = 0; paramId < paramLen; paramId++) {
      0093C2 72 5F 00 2C      [ 1]  146 	clr	_paramId+0
      0093C6                        147 00102$:
                                    148 ;	./params.c: 94: paramCache[paramId] = * (int*) (EEPROM_BASE_ADDR + EEPROM_PARAMS_OFFSET
      0093C6 C6 00 2C         [ 1]  149 	ld	a, _paramId+0
      0093C9 5F               [ 1]  150 	clrw	x
      0093CA 97               [ 1]  151 	ld	xl, a
      0093CB 58               [ 2]  152 	sllw	x
      0093CC 90 93            [ 1]  153 	ldw	y, x
      0093CE 72 A9 00 2D      [ 2]  154 	addw	y, #(_paramCache + 0)
                                    155 ;	./params.c: 95: + (paramId * sizeof paramCache[0]) );
      0093D2 1C 40 64         [ 2]  156 	addw	x, #0x4064
      0093D5 FE               [ 2]  157 	ldw	x, (x)
      0093D6 90 FF            [ 2]  158 	ldw	(y), x
                                    159 ;	./params.c: 93: for (paramId = 0; paramId < paramLen; paramId++) {
      0093D8 72 5C 00 2C      [ 1]  160 	inc	_paramId+0
      0093DC C6 00 2C         [ 1]  161 	ld	a, _paramId+0
      0093DF A1 0A            [ 1]  162 	cp	a, #0x0a
      0093E1 25 E3            [ 1]  163 	jrc	00102$
                                    164 ;	./params.c: 97: }
      0093E3 81               [ 4]  165 	ret
                                    166 ;	./params.c: 104: int getParamById (unsigned char id)
                                    167 ;	-----------------------------------------
                                    168 ;	 function getParamById
                                    169 ;	-----------------------------------------
      0093E4                        170 _getParamById:
                                    171 ;	./params.c: 106: if (id < paramLen) {
      0093E4 7B 03            [ 1]  172 	ld	a, (0x03, sp)
      0093E6 A1 0A            [ 1]  173 	cp	a, #0x0a
      0093E8 24 0A            [ 1]  174 	jrnc	00102$
                                    175 ;	./params.c: 107: return paramCache[id];
      0093EA 7B 03            [ 1]  176 	ld	a, (0x03, sp)
      0093EC 5F               [ 1]  177 	clrw	x
      0093ED 97               [ 1]  178 	ld	xl, a
      0093EE 58               [ 2]  179 	sllw	x
      0093EF 1C 00 2D         [ 2]  180 	addw	x, #(_paramCache + 0)
      0093F2 FE               [ 2]  181 	ldw	x, (x)
      0093F3 81               [ 4]  182 	ret
      0093F4                        183 00102$:
                                    184 ;	./params.c: 110: return -1;
      0093F4 5F               [ 1]  185 	clrw	x
      0093F5 5A               [ 2]  186 	decw	x
                                    187 ;	./params.c: 111: }
      0093F6 81               [ 4]  188 	ret
                                    189 ;	./params.c: 118: void setParamById (unsigned char id, int val)
                                    190 ;	-----------------------------------------
                                    191 ;	 function setParamById
                                    192 ;	-----------------------------------------
      0093F7                        193 _setParamById:
                                    194 ;	./params.c: 120: if (id < paramLen) {
      0093F7 7B 03            [ 1]  195 	ld	a, (0x03, sp)
      0093F9 A1 0A            [ 1]  196 	cp	a, #0x0a
      0093FB 25 01            [ 1]  197 	jrc	00110$
      0093FD 81               [ 4]  198 	ret
      0093FE                        199 00110$:
                                    200 ;	./params.c: 121: paramCache[id] = val;
      0093FE 7B 03            [ 1]  201 	ld	a, (0x03, sp)
      009400 5F               [ 1]  202 	clrw	x
      009401 97               [ 1]  203 	ld	xl, a
      009402 58               [ 2]  204 	sllw	x
      009403 16 04            [ 2]  205 	ldw	y, (0x04, sp)
      009405 DF 00 2D         [ 2]  206 	ldw	((_paramCache + 0), x), y
                                    207 ;	./params.c: 123: }
      009408 81               [ 4]  208 	ret
                                    209 ;	./params.c: 129: int getParam()
                                    210 ;	-----------------------------------------
                                    211 ;	 function getParam
                                    212 ;	-----------------------------------------
      009409                        213 _getParam:
                                    214 ;	./params.c: 131: return paramCache[paramId];
      009409 C6 00 2C         [ 1]  215 	ld	a, _paramId+0
      00940C 5F               [ 1]  216 	clrw	x
      00940D 97               [ 1]  217 	ld	xl, a
      00940E 58               [ 2]  218 	sllw	x
      00940F 1C 00 2D         [ 2]  219 	addw	x, #(_paramCache + 0)
      009412 FE               [ 2]  220 	ldw	x, (x)
                                    221 ;	./params.c: 132: }
      009413 81               [ 4]  222 	ret
                                    223 ;	./params.c: 138: void setParam (int val)
                                    224 ;	-----------------------------------------
                                    225 ;	 function setParam
                                    226 ;	-----------------------------------------
      009414                        227 _setParam:
                                    228 ;	./params.c: 140: paramCache[paramId] = val;
      009414 C6 00 2C         [ 1]  229 	ld	a, _paramId+0
      009417 5F               [ 1]  230 	clrw	x
      009418 97               [ 1]  231 	ld	xl, a
      009419 58               [ 2]  232 	sllw	x
      00941A 16 03            [ 2]  233 	ldw	y, (0x03, sp)
      00941C DF 00 2D         [ 2]  234 	ldw	((_paramCache + 0), x), y
                                    235 ;	./params.c: 141: }
      00941F 81               [ 4]  236 	ret
                                    237 ;	./params.c: 146: void incParam()
                                    238 ;	-----------------------------------------
                                    239 ;	 function incParam
                                    240 ;	-----------------------------------------
      009420                        241 _incParam:
      009420 52 04            [ 2]  242 	sub	sp, #4
                                    243 ;	./params.c: 151: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
      009422 5F               [ 1]  244 	clrw	x
      009423 C6 00 2C         [ 1]  245 	ld	a, _paramId+0
      009426 97               [ 1]  246 	ld	xl, a
      009427 58               [ 2]  247 	sllw	x
      009428 51               [ 1]  248 	exgw	x, y
                                    249 ;	./params.c: 149: if (paramId == PARAM_OVERHEAT_INDICATION ||
      009429 C6 00 2C         [ 1]  250 	ld	a, _paramId+0
      00942C A1 06            [ 1]  251 	cp	a, #0x06
      00942E 27 0E            [ 1]  252 	jreq	00103$
                                    253 ;	./params.c: 150: paramId == PARAM_LOCK_BUTTONS || paramId == PARAM_AUTO_BRIGHT) {
      009430 C6 00 2C         [ 1]  254 	ld	a, _paramId+0
      009433 A1 07            [ 1]  255 	cp	a, #0x07
      009435 27 07            [ 1]  256 	jreq	00103$
      009437 C6 00 2C         [ 1]  257 	ld	a, _paramId+0
      00943A A1 08            [ 1]  258 	cp	a, #0x08
      00943C 26 11            [ 1]  259 	jrne	00104$
      00943E                        260 00103$:
                                    261 ;	./params.c: 151: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
      00943E 72 A9 00 2D      [ 2]  262 	addw	y, #(_paramCache + 0)
      009442 93               [ 1]  263 	ldw	x, y
      009443 FE               [ 2]  264 	ldw	x, (x)
      009444 53               [ 2]  265 	cplw	x
      009445 9F               [ 1]  266 	ld	a, xl
      009446 A4 01            [ 1]  267 	and	a, #0x01
      009448 97               [ 1]  268 	ld	xl, a
      009449 4F               [ 1]  269 	clr	a
      00944A 95               [ 1]  270 	ld	xh, a
      00944B 90 FF            [ 2]  271 	ldw	(y), x
      00944D 20 18            [ 2]  272 	jra	00108$
      00944F                        273 00104$:
                                    274 ;	./params.c: 152: } else if (paramCache[paramId] < paramMax[paramId]) {
      00944F 93               [ 1]  275 	ldw	x, y
      009450 1C 00 2D         [ 2]  276 	addw	x, #(_paramCache + 0)
      009453 1F 01            [ 2]  277 	ldw	(0x01, sp), x
      009455 FE               [ 2]  278 	ldw	x, (x)
      009456 72 A9 82 1C      [ 2]  279 	addw	y, #(_paramMax + 0)
      00945A 90 FE            [ 2]  280 	ldw	y, (y)
      00945C 17 03            [ 2]  281 	ldw	(0x03, sp), y
      00945E 13 03            [ 2]  282 	cpw	x, (0x03, sp)
      009460 2E 05            [ 1]  283 	jrsge	00108$
                                    284 ;	./params.c: 153: paramCache[paramId]++;
      009462 5C               [ 1]  285 	incw	x
      009463 16 01            [ 2]  286 	ldw	y, (0x01, sp)
      009465 90 FF            [ 2]  287 	ldw	(y), x
      009467                        288 00108$:
                                    289 ;	./params.c: 155: }
      009467 5B 04            [ 2]  290 	addw	sp, #4
      009469 81               [ 4]  291 	ret
                                    292 ;	./params.c: 160: void decParam()
                                    293 ;	-----------------------------------------
                                    294 ;	 function decParam
                                    295 ;	-----------------------------------------
      00946A                        296 _decParam:
      00946A 52 04            [ 2]  297 	sub	sp, #4
                                    298 ;	./params.c: 165: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
      00946C 5F               [ 1]  299 	clrw	x
      00946D C6 00 2C         [ 1]  300 	ld	a, _paramId+0
      009470 97               [ 1]  301 	ld	xl, a
      009471 58               [ 2]  302 	sllw	x
      009472 51               [ 1]  303 	exgw	x, y
                                    304 ;	./params.c: 163: if (paramId == PARAM_OVERHEAT_INDICATION ||
      009473 C6 00 2C         [ 1]  305 	ld	a, _paramId+0
      009476 A1 06            [ 1]  306 	cp	a, #0x06
      009478 27 0E            [ 1]  307 	jreq	00103$
                                    308 ;	./params.c: 164: paramId == PARAM_LOCK_BUTTONS || paramId == PARAM_AUTO_BRIGHT) {
      00947A C6 00 2C         [ 1]  309 	ld	a, _paramId+0
      00947D A1 07            [ 1]  310 	cp	a, #0x07
      00947F 27 07            [ 1]  311 	jreq	00103$
      009481 C6 00 2C         [ 1]  312 	ld	a, _paramId+0
      009484 A1 08            [ 1]  313 	cp	a, #0x08
      009486 26 11            [ 1]  314 	jrne	00104$
      009488                        315 00103$:
                                    316 ;	./params.c: 165: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
      009488 72 A9 00 2D      [ 2]  317 	addw	y, #(_paramCache + 0)
      00948C 93               [ 1]  318 	ldw	x, y
      00948D FE               [ 2]  319 	ldw	x, (x)
      00948E 53               [ 2]  320 	cplw	x
      00948F 9F               [ 1]  321 	ld	a, xl
      009490 A4 01            [ 1]  322 	and	a, #0x01
      009492 97               [ 1]  323 	ld	xl, a
      009493 4F               [ 1]  324 	clr	a
      009494 95               [ 1]  325 	ld	xh, a
      009495 90 FF            [ 2]  326 	ldw	(y), x
      009497 20 18            [ 2]  327 	jra	00108$
      009499                        328 00104$:
                                    329 ;	./params.c: 166: } else if (paramCache[paramId] > paramMin[paramId]) {
      009499 93               [ 1]  330 	ldw	x, y
      00949A 1C 00 2D         [ 2]  331 	addw	x, #(_paramCache + 0)
      00949D 1F 01            [ 2]  332 	ldw	(0x01, sp), x
      00949F FE               [ 2]  333 	ldw	x, (x)
      0094A0 72 A9 82 08      [ 2]  334 	addw	y, #(_paramMin + 0)
      0094A4 90 FE            [ 2]  335 	ldw	y, (y)
      0094A6 17 03            [ 2]  336 	ldw	(0x03, sp), y
      0094A8 13 03            [ 2]  337 	cpw	x, (0x03, sp)
      0094AA 2D 05            [ 1]  338 	jrsle	00108$
                                    339 ;	./params.c: 167: paramCache[paramId]--;
      0094AC 5A               [ 2]  340 	decw	x
      0094AD 16 01            [ 2]  341 	ldw	y, (0x01, sp)
      0094AF 90 FF            [ 2]  342 	ldw	(y), x
      0094B1                        343 00108$:
                                    344 ;	./params.c: 169: }
      0094B1 5B 04            [ 2]  345 	addw	sp, #4
      0094B3 81               [ 4]  346 	ret
                                    347 ;	./params.c: 175: unsigned char getParamId()
                                    348 ;	-----------------------------------------
                                    349 ;	 function getParamId
                                    350 ;	-----------------------------------------
      0094B4                        351 _getParamId:
                                    352 ;	./params.c: 177: return paramId;
      0094B4 C6 00 2C         [ 1]  353 	ld	a, _paramId+0
                                    354 ;	./params.c: 178: }
      0094B7 81               [ 4]  355 	ret
                                    356 ;	./params.c: 184: void setParamId (unsigned char val)
                                    357 ;	-----------------------------------------
                                    358 ;	 function setParamId
                                    359 ;	-----------------------------------------
      0094B8                        360 _setParamId:
                                    361 ;	./params.c: 186: if (val < paramLen) {
      0094B8 7B 03            [ 1]  362 	ld	a, (0x03, sp)
      0094BA A1 0A            [ 1]  363 	cp	a, #0x0a
      0094BC 25 01            [ 1]  364 	jrc	00110$
      0094BE 81               [ 4]  365 	ret
      0094BF                        366 00110$:
                                    367 ;	./params.c: 187: paramId = val;
      0094BF 7B 03            [ 1]  368 	ld	a, (0x03, sp)
      0094C1 C7 00 2C         [ 1]  369 	ld	_paramId+0, a
                                    370 ;	./params.c: 189: }
      0094C4 81               [ 4]  371 	ret
                                    372 ;	./params.c: 194: void incParamId()
                                    373 ;	-----------------------------------------
                                    374 ;	 function incParamId
                                    375 ;	-----------------------------------------
      0094C5                        376 _incParamId:
                                    377 ;	./params.c: 196: if (paramId < paramIdMax) {
      0094C5 C6 00 2C         [ 1]  378 	ld	a, _paramId+0
      0094C8 A1 08            [ 1]  379 	cp	a, #0x08
      0094CA 24 05            [ 1]  380 	jrnc	00102$
                                    381 ;	./params.c: 197: paramId++;
      0094CC 72 5C 00 2C      [ 1]  382 	inc	_paramId+0
      0094D0 81               [ 4]  383 	ret
      0094D1                        384 00102$:
                                    385 ;	./params.c: 199: paramId = 0;
      0094D1 72 5F 00 2C      [ 1]  386 	clr	_paramId+0
                                    387 ;	./params.c: 201: }
      0094D5 81               [ 4]  388 	ret
                                    389 ;	./params.c: 206: void decParamId()
                                    390 ;	-----------------------------------------
                                    391 ;	 function decParamId
                                    392 ;	-----------------------------------------
      0094D6                        393 _decParamId:
                                    394 ;	./params.c: 208: if (paramId > 0) {
      0094D6 72 5D 00 2C      [ 1]  395 	tnz	_paramId+0
      0094DA 27 05            [ 1]  396 	jreq	00102$
                                    397 ;	./params.c: 209: paramId--;
      0094DC 72 5A 00 2C      [ 1]  398 	dec	_paramId+0
      0094E0 81               [ 4]  399 	ret
      0094E1                        400 00102$:
                                    401 ;	./params.c: 211: paramId = paramIdMax;
      0094E1 35 08 00 2C      [ 1]  402 	mov	_paramId+0, #0x08
                                    403 ;	./params.c: 213: }
      0094E5 81               [ 4]  404 	ret
                                    405 ;	./params.c: 222: void paramToString (unsigned char id, unsigned char* strBuff)
                                    406 ;	-----------------------------------------
                                    407 ;	 function paramToString
                                    408 ;	-----------------------------------------
      0094E6                        409 _paramToString:
      0094E6 52 04            [ 2]  410 	sub	sp, #4
                                    411 ;	./params.c: 224: switch (id) {
      0094E8 7B 07            [ 1]  412 	ld	a, (0x07, sp)
      0094EA A1 09            [ 1]  413 	cp	a, #0x09
      0094EC 23 03            [ 2]  414 	jrule	00159$
      0094EE CC 96 28         [ 2]  415 	jp	00125$
      0094F1                        416 00159$:
      0094F1 5F               [ 1]  417 	clrw	x
      0094F2 7B 07            [ 1]  418 	ld	a, (0x07, sp)
      0094F4 97               [ 1]  419 	ld	xl, a
      0094F5 58               [ 2]  420 	sllw	x
      0094F6 DE 94 FA         [ 2]  421 	ldw	x, (#00160$, x)
      0094F9 FC               [ 2]  422 	jp	(x)
      0094FA                        423 00160$:
      0094FA 95 0E                  424 	.dw	#00101$
      0094FC 95 64                  425 	.dw	#00113$
      0094FE 95 7C                  426 	.dw	#00114$
      009500 95 94                  427 	.dw	#00115$
      009502 95 AC                  428 	.dw	#00116$
      009504 95 C3                  429 	.dw	#00117$
      009506 95 DA                  430 	.dw	#00120$
      009508 95 DA                  431 	.dw	#00120$
      00950A 95 DA                  432 	.dw	#00120$
      00950C 96 11                  433 	.dw	#00124$
                                    434 ;	./params.c: 225: case PARAM_RELAY_MODE:
      00950E                        435 00101$:
                                    436 ;	./params.c: 226: ( (unsigned char*) strBuff) [1] = 0;
      00950E 16 08            [ 2]  437 	ldw	y, (0x08, sp)
      009510 90 5C            [ 1]  438 	incw	y
      009512 90 7F            [ 1]  439 	clr	(y)
                                    440 ;	./params.c: 227: if (paramCache[id] == 1) {
      009514 7B 07            [ 1]  441 	ld	a, (0x07, sp)
      009516 5F               [ 1]  442 	clrw	x
      009517 97               [ 1]  443 	ld	xl, a
      009518 58               [ 2]  444 	sllw	x
      009519 1C 00 2D         [ 2]  445 	addw	x, #(_paramCache + 0)
      00951C FE               [ 2]  446 	ldw	x, (x)
      00951D A3 00 01         [ 2]  447 	cpw	x, #0x0001
      009520 26 08            [ 1]  448 	jrne	00111$
                                    449 ;	./params.c: 228: ( (unsigned char*) strBuff) [0] = 'H';
      009522 1E 08            [ 2]  450 	ldw	x, (0x08, sp)
      009524 A6 48            [ 1]  451 	ld	a, #0x48
      009526 F7               [ 1]  452 	ld	(x), a
      009527 CC 96 3C         [ 2]  453 	jp	00127$
      00952A                        454 00111$:
                                    455 ;	./params.c: 229: } else if (paramCache[id] == 0) {
      00952A 5D               [ 2]  456 	tnzw	x
      00952B 26 08            [ 1]  457 	jrne	00108$
                                    458 ;	./params.c: 230: ( (unsigned char*) strBuff) [0] = 'C';
      00952D 1E 08            [ 2]  459 	ldw	x, (0x08, sp)
      00952F A6 43            [ 1]  460 	ld	a, #0x43
      009531 F7               [ 1]  461 	ld	(x), a
      009532 CC 96 3C         [ 2]  462 	jp	00127$
      009535                        463 00108$:
                                    464 ;	./params.c: 231: } else if (paramCache[id] == 2) {
      009535 A3 00 02         [ 2]  465 	cpw	x, #0x0002
      009538 26 11            [ 1]  466 	jrne	00105$
                                    467 ;	./params.c: 232: ( (unsigned char*) strBuff) [2] = 0;
      00953A 1E 08            [ 2]  468 	ldw	x, (0x08, sp)
      00953C 5C               [ 1]  469 	incw	x
      00953D 5C               [ 1]  470 	incw	x
      00953E 7F               [ 1]  471 	clr	(x)
                                    472 ;	./params.c: 233: ( (unsigned char*) strBuff) [1] = '1';
      00953F A6 31            [ 1]  473 	ld	a, #0x31
      009541 90 F7            [ 1]  474 	ld	(y), a
                                    475 ;	./params.c: 234: ( (unsigned char*) strBuff) [0] = 'A';
      009543 1E 08            [ 2]  476 	ldw	x, (0x08, sp)
      009545 A6 41            [ 1]  477 	ld	a, #0x41
      009547 F7               [ 1]  478 	ld	(x), a
      009548 CC 96 3C         [ 2]  479 	jp	00127$
      00954B                        480 00105$:
                                    481 ;	./params.c: 235: } else if (paramCache[id] == 3) {
      00954B A3 00 03         [ 2]  482 	cpw	x, #0x0003
      00954E 27 03            [ 1]  483 	jreq	00170$
      009550 CC 96 3C         [ 2]  484 	jp	00127$
      009553                        485 00170$:
                                    486 ;	./params.c: 236: ( (unsigned char*) strBuff) [2] = 0;
      009553 1E 08            [ 2]  487 	ldw	x, (0x08, sp)
      009555 5C               [ 1]  488 	incw	x
      009556 5C               [ 1]  489 	incw	x
      009557 7F               [ 1]  490 	clr	(x)
                                    491 ;	./params.c: 237: ( (unsigned char*) strBuff) [1] = '2';
      009558 A6 32            [ 1]  492 	ld	a, #0x32
      00955A 90 F7            [ 1]  493 	ld	(y), a
                                    494 ;	./params.c: 238: ( (unsigned char*) strBuff) [0] = 'A';
      00955C 1E 08            [ 2]  495 	ldw	x, (0x08, sp)
      00955E A6 41            [ 1]  496 	ld	a, #0x41
      009560 F7               [ 1]  497 	ld	(x), a
                                    498 ;	./params.c: 241: break;
      009561 CC 96 3C         [ 2]  499 	jp	00127$
                                    500 ;	./params.c: 243: case PARAM_RELAY_HYSTERESIS:
      009564                        501 00113$:
                                    502 ;	./params.c: 244: itofpa (paramCache[id], strBuff, 0);
      009564 7B 07            [ 1]  503 	ld	a, (0x07, sp)
      009566 5F               [ 1]  504 	clrw	x
      009567 97               [ 1]  505 	ld	xl, a
      009568 58               [ 2]  506 	sllw	x
      009569 1C 00 2D         [ 2]  507 	addw	x, #(_paramCache + 0)
      00956C FE               [ 2]  508 	ldw	x, (x)
      00956D 4B 00            [ 1]  509 	push	#0x00
      00956F 16 09            [ 2]  510 	ldw	y, (0x09, sp)
      009571 90 89            [ 2]  511 	pushw	y
      009573 89               [ 2]  512 	pushw	x
      009574 CD 96 94         [ 4]  513 	call	_itofpa
      009577 5B 05            [ 2]  514 	addw	sp, #5
                                    515 ;	./params.c: 245: break;
      009579 CC 96 3C         [ 2]  516 	jp	00127$
                                    517 ;	./params.c: 247: case PARAM_MAX_TEMPERATURE:
      00957C                        518 00114$:
                                    519 ;	./params.c: 248: itofpa (paramCache[id], strBuff, 6);
      00957C 7B 07            [ 1]  520 	ld	a, (0x07, sp)
      00957E 5F               [ 1]  521 	clrw	x
      00957F 97               [ 1]  522 	ld	xl, a
      009580 58               [ 2]  523 	sllw	x
      009581 1C 00 2D         [ 2]  524 	addw	x, #(_paramCache + 0)
      009584 FE               [ 2]  525 	ldw	x, (x)
      009585 4B 06            [ 1]  526 	push	#0x06
      009587 16 09            [ 2]  527 	ldw	y, (0x09, sp)
      009589 90 89            [ 2]  528 	pushw	y
      00958B 89               [ 2]  529 	pushw	x
      00958C CD 96 94         [ 4]  530 	call	_itofpa
      00958F 5B 05            [ 2]  531 	addw	sp, #5
                                    532 ;	./params.c: 249: break;
      009591 CC 96 3C         [ 2]  533 	jp	00127$
                                    534 ;	./params.c: 251: case PARAM_MIN_TEMPERATURE:
      009594                        535 00115$:
                                    536 ;	./params.c: 252: itofpa (paramCache[id], strBuff, 6);
      009594 7B 07            [ 1]  537 	ld	a, (0x07, sp)
      009596 5F               [ 1]  538 	clrw	x
      009597 97               [ 1]  539 	ld	xl, a
      009598 58               [ 2]  540 	sllw	x
      009599 1C 00 2D         [ 2]  541 	addw	x, #(_paramCache + 0)
      00959C FE               [ 2]  542 	ldw	x, (x)
      00959D 4B 06            [ 1]  543 	push	#0x06
      00959F 16 09            [ 2]  544 	ldw	y, (0x09, sp)
      0095A1 90 89            [ 2]  545 	pushw	y
      0095A3 89               [ 2]  546 	pushw	x
      0095A4 CD 96 94         [ 4]  547 	call	_itofpa
      0095A7 5B 05            [ 2]  548 	addw	sp, #5
                                    549 ;	./params.c: 253: break;
      0095A9 CC 96 3C         [ 2]  550 	jp	00127$
                                    551 ;	./params.c: 255: case PARAM_TEMPERATURE_CORRECTION:
      0095AC                        552 00116$:
                                    553 ;	./params.c: 256: itofpa (paramCache[id], strBuff, 0);
      0095AC 7B 07            [ 1]  554 	ld	a, (0x07, sp)
      0095AE 5F               [ 1]  555 	clrw	x
      0095AF 97               [ 1]  556 	ld	xl, a
      0095B0 58               [ 2]  557 	sllw	x
      0095B1 1C 00 2D         [ 2]  558 	addw	x, #(_paramCache + 0)
      0095B4 FE               [ 2]  559 	ldw	x, (x)
      0095B5 4B 00            [ 1]  560 	push	#0x00
      0095B7 16 09            [ 2]  561 	ldw	y, (0x09, sp)
      0095B9 90 89            [ 2]  562 	pushw	y
      0095BB 89               [ 2]  563 	pushw	x
      0095BC CD 96 94         [ 4]  564 	call	_itofpa
      0095BF 5B 05            [ 2]  565 	addw	sp, #5
                                    566 ;	./params.c: 257: break;
      0095C1 20 79            [ 2]  567 	jra	00127$
                                    568 ;	./params.c: 259: case PARAM_RELAY_DELAY:
      0095C3                        569 00117$:
                                    570 ;	./params.c: 260: itofpa (paramCache[id], strBuff, 6);
      0095C3 7B 07            [ 1]  571 	ld	a, (0x07, sp)
      0095C5 5F               [ 1]  572 	clrw	x
      0095C6 97               [ 1]  573 	ld	xl, a
      0095C7 58               [ 2]  574 	sllw	x
      0095C8 1C 00 2D         [ 2]  575 	addw	x, #(_paramCache + 0)
      0095CB FE               [ 2]  576 	ldw	x, (x)
      0095CC 4B 06            [ 1]  577 	push	#0x06
      0095CE 16 09            [ 2]  578 	ldw	y, (0x09, sp)
      0095D0 90 89            [ 2]  579 	pushw	y
      0095D2 89               [ 2]  580 	pushw	x
      0095D3 CD 96 94         [ 4]  581 	call	_itofpa
      0095D6 5B 05            [ 2]  582 	addw	sp, #5
                                    583 ;	./params.c: 261: break;
      0095D8 20 62            [ 2]  584 	jra	00127$
                                    585 ;	./params.c: 265: case PARAM_AUTO_BRIGHT:
      0095DA                        586 00120$:
                                    587 ;	./params.c: 266: ( (unsigned char*) strBuff) [0] = 'O';
      0095DA 16 08            [ 2]  588 	ldw	y, (0x08, sp)
      0095DC 17 01            [ 2]  589 	ldw	(0x01, sp), y
      0095DE 93               [ 1]  590 	ldw	x, y
      0095DF A6 4F            [ 1]  591 	ld	a, #0x4f
      0095E1 F7               [ 1]  592 	ld	(x), a
                                    593 ;	./params.c: 268: if (paramCache[id]) {
      0095E2 7B 07            [ 1]  594 	ld	a, (0x07, sp)
      0095E4 5F               [ 1]  595 	clrw	x
      0095E5 97               [ 1]  596 	ld	xl, a
      0095E6 58               [ 2]  597 	sllw	x
      0095E7 1C 00 2D         [ 2]  598 	addw	x, #(_paramCache + 0)
      0095EA FE               [ 2]  599 	ldw	x, (x)
      0095EB 1F 03            [ 2]  600 	ldw	(0x03, sp), x
      0095ED 27 0F            [ 1]  601 	jreq	00122$
                                    602 ;	./params.c: 269: ( (unsigned char*) strBuff) [1] = 'N';
      0095EF 1E 01            [ 2]  603 	ldw	x, (0x01, sp)
      0095F1 5C               [ 1]  604 	incw	x
      0095F2 A6 4E            [ 1]  605 	ld	a, #0x4e
      0095F4 F7               [ 1]  606 	ld	(x), a
                                    607 ;	./params.c: 270: ( (unsigned char*) strBuff) [2] = ' ';
      0095F5 1E 01            [ 2]  608 	ldw	x, (0x01, sp)
      0095F7 5C               [ 1]  609 	incw	x
      0095F8 5C               [ 1]  610 	incw	x
      0095F9 A6 20            [ 1]  611 	ld	a, #0x20
      0095FB F7               [ 1]  612 	ld	(x), a
      0095FC 20 0D            [ 2]  613 	jra	00123$
      0095FE                        614 00122$:
                                    615 ;	./params.c: 272: ( (unsigned char*) strBuff) [1] = 'F';
      0095FE 1E 01            [ 2]  616 	ldw	x, (0x01, sp)
      009600 5C               [ 1]  617 	incw	x
      009601 A6 46            [ 1]  618 	ld	a, #0x46
      009603 F7               [ 1]  619 	ld	(x), a
                                    620 ;	./params.c: 273: ( (unsigned char*) strBuff) [2] = 'F';
      009604 1E 01            [ 2]  621 	ldw	x, (0x01, sp)
      009606 5C               [ 1]  622 	incw	x
      009607 5C               [ 1]  623 	incw	x
      009608 A6 46            [ 1]  624 	ld	a, #0x46
      00960A F7               [ 1]  625 	ld	(x), a
      00960B                        626 00123$:
                                    627 ;	./params.c: 276: ( (unsigned char*) strBuff) [3] = 0;
      00960B 1E 01            [ 2]  628 	ldw	x, (0x01, sp)
      00960D 6F 03            [ 1]  629 	clr	(0x0003, x)
                                    630 ;	./params.c: 277: break;
      00960F 20 2B            [ 2]  631 	jra	00127$
                                    632 ;	./params.c: 279: case PARAM_THRESHOLD:
      009611                        633 00124$:
                                    634 ;	./params.c: 280: itofpa (paramCache[id], strBuff, 0);
      009611 7B 07            [ 1]  635 	ld	a, (0x07, sp)
      009613 5F               [ 1]  636 	clrw	x
      009614 97               [ 1]  637 	ld	xl, a
      009615 58               [ 2]  638 	sllw	x
      009616 1C 00 2D         [ 2]  639 	addw	x, #(_paramCache + 0)
      009619 FE               [ 2]  640 	ldw	x, (x)
      00961A 4B 00            [ 1]  641 	push	#0x00
      00961C 16 09            [ 2]  642 	ldw	y, (0x09, sp)
      00961E 90 89            [ 2]  643 	pushw	y
      009620 89               [ 2]  644 	pushw	x
      009621 CD 96 94         [ 4]  645 	call	_itofpa
      009624 5B 05            [ 2]  646 	addw	sp, #5
                                    647 ;	./params.c: 281: break;
      009626 20 14            [ 2]  648 	jra	00127$
                                    649 ;	./params.c: 283: default: // Display "OFF" to all unknown ID
      009628                        650 00125$:
                                    651 ;	./params.c: 284: ( (unsigned char*) strBuff) [0] = 'O';
      009628 16 08            [ 2]  652 	ldw	y, (0x08, sp)
      00962A A6 4F            [ 1]  653 	ld	a, #0x4f
      00962C 90 F7            [ 1]  654 	ld	(y), a
                                    655 ;	./params.c: 285: ( (unsigned char*) strBuff) [1] = 'F';
      00962E 93               [ 1]  656 	ldw	x, y
      00962F 5C               [ 1]  657 	incw	x
      009630 A6 46            [ 1]  658 	ld	a, #0x46
      009632 F7               [ 1]  659 	ld	(x), a
                                    660 ;	./params.c: 286: ( (unsigned char*) strBuff) [2] = 'F';
      009633 93               [ 1]  661 	ldw	x, y
      009634 5C               [ 1]  662 	incw	x
      009635 5C               [ 1]  663 	incw	x
      009636 A6 46            [ 1]  664 	ld	a, #0x46
      009638 F7               [ 1]  665 	ld	(x), a
                                    666 ;	./params.c: 287: ( (unsigned char*) strBuff) [3] = 0;
      009639 93               [ 1]  667 	ldw	x, y
      00963A 6F 03            [ 1]  668 	clr	(0x0003, x)
                                    669 ;	./params.c: 288: }
      00963C                        670 00127$:
                                    671 ;	./params.c: 289: }
      00963C 5B 04            [ 2]  672 	addw	sp, #4
      00963E 81               [ 4]  673 	ret
                                    674 ;	./params.c: 294: void storeParams()
                                    675 ;	-----------------------------------------
                                    676 ;	 function storeParams
                                    677 ;	-----------------------------------------
      00963F                        678 _storeParams:
      00963F 52 02            [ 2]  679 	sub	sp, #2
                                    680 ;	./params.c: 299: if ( (FLASH_IAPSR & 0x08) == 0) {
      009641 C6 50 5F         [ 1]  681 	ld	a, 0x505f
      009644 A5 08            [ 1]  682 	bcp	a, #0x08
      009646 26 08            [ 1]  683 	jrne	00112$
                                    684 ;	./params.c: 300: FLASH_DUKR = 0xAE;
      009648 35 AE 50 64      [ 1]  685 	mov	0x5064+0, #0xae
                                    686 ;	./params.c: 301: FLASH_DUKR = 0x56;
      00964C 35 56 50 64      [ 1]  687 	mov	0x5064+0, #0x56
                                    688 ;	./params.c: 305: for (i = 0; i < paramLen; i++) {
      009650                        689 00112$:
      009650 4F               [ 1]  690 	clr	a
      009651                        691 00106$:
                                    692 ;	./params.c: 306: if (paramCache[i] != (* (int*) (EEPROM_BASE_ADDR + EEPROM_PARAMS_OFFSET
      009651 5F               [ 1]  693 	clrw	x
      009652 97               [ 1]  694 	ld	xl, a
      009653 58               [ 2]  695 	sllw	x
      009654 90 93            [ 1]  696 	ldw	y, x
      009656 1C 00 2D         [ 2]  697 	addw	x, #(_paramCache + 0)
      009659 FE               [ 2]  698 	ldw	x, (x)
      00965A 1F 01            [ 2]  699 	ldw	(0x01, sp), x
                                    700 ;	./params.c: 307: + (i * sizeof paramCache[0]) ) ) ) {
      00965C 72 A9 40 64      [ 2]  701 	addw	y, #0x4064
      009660 93               [ 1]  702 	ldw	x, y
      009661 FE               [ 2]  703 	ldw	x, (x)
      009662 13 01            [ 2]  704 	cpw	x, (0x01, sp)
      009664 27 04            [ 1]  705 	jreq	00107$
                                    706 ;	./params.c: 309: + (i * sizeof paramCache[0]) ) = paramCache[i];
      009666 93               [ 1]  707 	ldw	x, y
      009667 16 01            [ 2]  708 	ldw	y, (0x01, sp)
      009669 FF               [ 2]  709 	ldw	(x), y
      00966A                        710 00107$:
                                    711 ;	./params.c: 305: for (i = 0; i < paramLen; i++) {
      00966A 4C               [ 1]  712 	inc	a
      00966B A1 0A            [ 1]  713 	cp	a, #0x0a
      00966D 25 E2            [ 1]  714 	jrc	00106$
                                    715 ;	./params.c: 314: FLASH_IAPSR &= ~0x08;
      00966F 72 17 50 5F      [ 1]  716 	bres	20575, #3
                                    717 ;	./params.c: 315: }
      009673 5B 02            [ 2]  718 	addw	sp, #2
      009675 81               [ 4]  719 	ret
                                    720 ;	./params.c: 321: static void writeEEPROM (unsigned char val, unsigned char offset)
                                    721 ;	-----------------------------------------
                                    722 ;	 function writeEEPROM
                                    723 ;	-----------------------------------------
      009676                        724 _writeEEPROM:
                                    725 ;	./params.c: 324: if ( (FLASH_IAPSR & 0x08) == 0) {
      009676 C6 50 5F         [ 1]  726 	ld	a, 0x505f
      009679 A5 08            [ 1]  727 	bcp	a, #0x08
      00967B 26 08            [ 1]  728 	jrne	00102$
                                    729 ;	./params.c: 325: FLASH_DUKR = 0xAE;
      00967D 35 AE 50 64      [ 1]  730 	mov	0x5064+0, #0xae
                                    731 ;	./params.c: 326: FLASH_DUKR = 0x56;
      009681 35 56 50 64      [ 1]  732 	mov	0x5064+0, #0x56
      009685                        733 00102$:
                                    734 ;	./params.c: 330: (* (unsigned char*) (EEPROM_BASE_ADDR + offset) ) = val;
      009685 7B 04            [ 1]  735 	ld	a, (0x04, sp)
      009687 5F               [ 1]  736 	clrw	x
      009688 1C 40 00         [ 2]  737 	addw	x, #16384
      00968B 97               [ 1]  738 	ld	xl, a
      00968C 7B 03            [ 1]  739 	ld	a, (0x03, sp)
      00968E F7               [ 1]  740 	ld	(x), a
                                    741 ;	./params.c: 333: FLASH_IAPSR &= ~0x08;
      00968F 72 17 50 5F      [ 1]  742 	bres	20575, #3
                                    743 ;	./params.c: 334: }
      009693 81               [ 4]  744 	ret
                                    745 ;	./params.c: 348: void itofpa (int val, unsigned char* str, unsigned char pointPosition)
                                    746 ;	-----------------------------------------
                                    747 ;	 function itofpa
                                    748 ;	-----------------------------------------
      009694                        749 _itofpa:
      009694 52 0D            [ 2]  750 	sub	sp, #13
                                    751 ;	./params.c: 350: unsigned char i, l, buffer[] = {0, 0, 0, 0, 0, 0};
      009696 0F 01            [ 1]  752 	clr	(0x01, sp)
      009698 96               [ 1]  753 	ldw	x, sp
      009699 6F 02            [ 1]  754 	clr	(2, x)
      00969B 96               [ 1]  755 	ldw	x, sp
      00969C 6F 03            [ 1]  756 	clr	(3, x)
      00969E 96               [ 1]  757 	ldw	x, sp
      00969F 6F 04            [ 1]  758 	clr	(4, x)
      0096A1 96               [ 1]  759 	ldw	x, sp
      0096A2 6F 05            [ 1]  760 	clr	(5, x)
      0096A4 96               [ 1]  761 	ldw	x, sp
      0096A5 6F 06            [ 1]  762 	clr	(6, x)
                                    763 ;	./params.c: 351: bool minus = false;
      0096A7 0F 07            [ 1]  764 	clr	(0x07, sp)
                                    765 ;	./params.c: 354: if (val == 0) {
      0096A9 1E 10            [ 2]  766 	ldw	x, (0x10, sp)
      0096AB 26 0A            [ 1]  767 	jrne	00102$
                                    768 ;	./params.c: 355: ( (unsigned char*) str) [0] = '0';
      0096AD 1E 12            [ 2]  769 	ldw	x, (0x12, sp)
      0096AF A6 30            [ 1]  770 	ld	a, #0x30
      0096B1 F7               [ 1]  771 	ld	(x), a
                                    772 ;	./params.c: 356: ( (unsigned char*) str) [1] = 0;
      0096B2 5C               [ 1]  773 	incw	x
      0096B3 7F               [ 1]  774 	clr	(x)
                                    775 ;	./params.c: 357: return;
      0096B4 CC 97 93         [ 2]  776 	jp	00119$
      0096B7                        777 00102$:
                                    778 ;	./params.c: 361: if (val < 0) {
      0096B7 0D 10            [ 1]  779 	tnz	(0x10, sp)
      0096B9 2A 09            [ 1]  780 	jrpl	00104$
                                    781 ;	./params.c: 362: minus = true;
      0096BB A6 01            [ 1]  782 	ld	a, #0x01
      0096BD 6B 07            [ 1]  783 	ld	(0x07, sp), a
                                    784 ;	./params.c: 363: val = -val;
      0096BF 1E 10            [ 2]  785 	ldw	x, (0x10, sp)
      0096C1 50               [ 2]  786 	negw	x
      0096C2 1F 10            [ 2]  787 	ldw	(0x10, sp), x
      0096C4                        788 00104$:
                                    789 ;	./params.c: 367: for (i = 0; val != 0; i++) {
      0096C4 0F 0D            [ 1]  790 	clr	(0x0d, sp)
      0096C6                        791 00114$:
                                    792 ;	./params.c: 368: buffer[i] = '0' + (val % 10);
      0096C6 5F               [ 1]  793 	clrw	x
      0096C7 7B 0D            [ 1]  794 	ld	a, (0x0d, sp)
      0096C9 97               [ 1]  795 	ld	xl, a
      0096CA 89               [ 2]  796 	pushw	x
      0096CB 96               [ 1]  797 	ldw	x, sp
      0096CC 1C 00 03         [ 2]  798 	addw	x, #3
      0096CF 72 FB 01         [ 2]  799 	addw	x, (1, sp)
      0096D2 1F 0A            [ 2]  800 	ldw	(0x0a, sp), x
      0096D4 5B 02            [ 2]  801 	addw	sp, #2
                                    802 ;	./params.c: 371: i++;
      0096D6 7B 0D            [ 1]  803 	ld	a, (0x0d, sp)
      0096D8 4C               [ 1]  804 	inc	a
      0096D9 6B 0A            [ 1]  805 	ld	(0x0a, sp), a
                                    806 ;	./params.c: 367: for (i = 0; val != 0; i++) {
      0096DB 1E 10            [ 2]  807 	ldw	x, (0x10, sp)
      0096DD 27 43            [ 1]  808 	jreq	00107$
                                    809 ;	./params.c: 368: buffer[i] = '0' + (val % 10);
      0096DF 4B 0A            [ 1]  810 	push	#0x0a
      0096E1 4B 00            [ 1]  811 	push	#0x00
      0096E3 1E 12            [ 2]  812 	ldw	x, (0x12, sp)
      0096E5 89               [ 2]  813 	pushw	x
      0096E6 CD 99 73         [ 4]  814 	call	__modsint
      0096E9 5B 04            [ 2]  815 	addw	sp, #4
      0096EB 9F               [ 1]  816 	ld	a, xl
      0096EC AB 30            [ 1]  817 	add	a, #0x30
      0096EE 1E 08            [ 2]  818 	ldw	x, (0x08, sp)
      0096F0 F7               [ 1]  819 	ld	(x), a
                                    820 ;	./params.c: 370: if (i == pointPosition) {
      0096F1 7B 0D            [ 1]  821 	ld	a, (0x0d, sp)
      0096F3 11 14            [ 1]  822 	cp	a, (0x14, sp)
      0096F5 26 19            [ 1]  823 	jrne	00106$
                                    824 ;	./params.c: 371: i++;
      0096F7 7B 0A            [ 1]  825 	ld	a, (0x0a, sp)
      0096F9 6B 0D            [ 1]  826 	ld	(0x0d, sp), a
                                    827 ;	./params.c: 372: buffer[i] = '.';
      0096FB 5F               [ 1]  828 	clrw	x
      0096FC 7B 0D            [ 1]  829 	ld	a, (0x0d, sp)
      0096FE 97               [ 1]  830 	ld	xl, a
      0096FF 89               [ 2]  831 	pushw	x
      009700 96               [ 1]  832 	ldw	x, sp
      009701 1C 00 03         [ 2]  833 	addw	x, #3
      009704 72 FB 01         [ 2]  834 	addw	x, (1, sp)
      009707 1F 0D            [ 2]  835 	ldw	(0x0d, sp), x
      009709 5B 02            [ 2]  836 	addw	sp, #2
      00970B 1E 0B            [ 2]  837 	ldw	x, (0x0b, sp)
      00970D A6 2E            [ 1]  838 	ld	a, #0x2e
      00970F F7               [ 1]  839 	ld	(x), a
      009710                        840 00106$:
                                    841 ;	./params.c: 375: val /= 10;
      009710 4B 0A            [ 1]  842 	push	#0x0a
      009712 4B 00            [ 1]  843 	push	#0x00
      009714 1E 12            [ 2]  844 	ldw	x, (0x12, sp)
      009716 89               [ 2]  845 	pushw	x
      009717 CD 99 89         [ 4]  846 	call	__divsint
      00971A 5B 04            [ 2]  847 	addw	sp, #4
      00971C 1F 10            [ 2]  848 	ldw	(0x10, sp), x
                                    849 ;	./params.c: 367: for (i = 0; val != 0; i++) {
      00971E 0C 0D            [ 1]  850 	inc	(0x0d, sp)
      009720 20 A4            [ 2]  851 	jra	00114$
      009722                        852 00107$:
                                    853 ;	./params.c: 379: if (buffer[i - 1] == '.') {
      009722 7B 0D            [ 1]  854 	ld	a, (0x0d, sp)
      009724 4A               [ 1]  855 	dec	a
      009725 6B 0C            [ 1]  856 	ld	(0x0c, sp), a
      009727 49               [ 1]  857 	rlc	a
      009728 4F               [ 1]  858 	clr	a
      009729 A2 00            [ 1]  859 	sbc	a, #0x00
      00972B 6B 0B            [ 1]  860 	ld	(0x0b, sp), a
      00972D 96               [ 1]  861 	ldw	x, sp
      00972E 1C 00 01         [ 2]  862 	addw	x, #1
      009731 72 FB 0B         [ 2]  863 	addw	x, (0x0b, sp)
      009734 F6               [ 1]  864 	ld	a, (x)
      009735 A1 2E            [ 1]  865 	cp	a, #0x2e
      009737 26 09            [ 1]  866 	jrne	00109$
                                    867 ;	./params.c: 380: buffer[i] = '0';
      009739 1E 08            [ 2]  868 	ldw	x, (0x08, sp)
      00973B A6 30            [ 1]  869 	ld	a, #0x30
      00973D F7               [ 1]  870 	ld	(x), a
                                    871 ;	./params.c: 381: i++;
      00973E 7B 0A            [ 1]  872 	ld	a, (0x0a, sp)
      009740 6B 0D            [ 1]  873 	ld	(0x0d, sp), a
      009742                        874 00109$:
                                    875 ;	./params.c: 385: if (minus) {
      009742 0D 07            [ 1]  876 	tnz	(0x07, sp)
      009744 27 13            [ 1]  877 	jreq	00111$
                                    878 ;	./params.c: 386: buffer[i] = '-';
      009746 5F               [ 1]  879 	clrw	x
      009747 7B 0D            [ 1]  880 	ld	a, (0x0d, sp)
      009749 97               [ 1]  881 	ld	xl, a
      00974A 89               [ 2]  882 	pushw	x
      00974B 96               [ 1]  883 	ldw	x, sp
      00974C 1C 00 03         [ 2]  884 	addw	x, #3
      00974F 72 FB 01         [ 2]  885 	addw	x, (1, sp)
      009752 5B 02            [ 2]  886 	addw	sp, #2
      009754 A6 2D            [ 1]  887 	ld	a, #0x2d
      009756 F7               [ 1]  888 	ld	(x), a
                                    889 ;	./params.c: 387: i++;
      009757 0C 0D            [ 1]  890 	inc	(0x0d, sp)
      009759                        891 00111$:
                                    892 ;	./params.c: 391: for (l = i; i > 0; i--) {
      009759 7B 0D            [ 1]  893 	ld	a, (0x0d, sp)
      00975B 6B 0C            [ 1]  894 	ld	(0x0c, sp), a
      00975D                        895 00117$:
      00975D 0D 0D            [ 1]  896 	tnz	(0x0d, sp)
      00975F 27 2A            [ 1]  897 	jreq	00112$
                                    898 ;	./params.c: 392: ( (unsigned char*) str) [l - i] = buffer[i - 1];
      009761 5F               [ 1]  899 	clrw	x
      009762 7B 0C            [ 1]  900 	ld	a, (0x0c, sp)
      009764 97               [ 1]  901 	ld	xl, a
      009765 7B 0D            [ 1]  902 	ld	a, (0x0d, sp)
      009767 6B 0B            [ 1]  903 	ld	(0x0b, sp), a
      009769 0F 0A            [ 1]  904 	clr	(0x0a, sp)
      00976B 72 F0 0A         [ 2]  905 	subw	x, (0x0a, sp)
      00976E 72 FB 12         [ 2]  906 	addw	x, (0x12, sp)
      009771 51               [ 1]  907 	exgw	x, y
      009772 7B 0D            [ 1]  908 	ld	a, (0x0d, sp)
      009774 4A               [ 1]  909 	dec	a
      009775 6B 0B            [ 1]  910 	ld	(0x0b, sp), a
      009777 49               [ 1]  911 	rlc	a
      009778 4F               [ 1]  912 	clr	a
      009779 A2 00            [ 1]  913 	sbc	a, #0x00
      00977B 6B 0A            [ 1]  914 	ld	(0x0a, sp), a
      00977D 96               [ 1]  915 	ldw	x, sp
      00977E 1C 00 01         [ 2]  916 	addw	x, #1
      009781 72 FB 0A         [ 2]  917 	addw	x, (0x0a, sp)
      009784 F6               [ 1]  918 	ld	a, (x)
      009785 90 F7            [ 1]  919 	ld	(y), a
                                    920 ;	./params.c: 391: for (l = i; i > 0; i--) {
      009787 0A 0D            [ 1]  921 	dec	(0x0d, sp)
      009789 20 D2            [ 2]  922 	jra	00117$
      00978B                        923 00112$:
                                    924 ;	./params.c: 396: ( (unsigned char*) str) [l] = 0;
      00978B 5F               [ 1]  925 	clrw	x
      00978C 7B 0C            [ 1]  926 	ld	a, (0x0c, sp)
      00978E 97               [ 1]  927 	ld	xl, a
      00978F 72 FB 12         [ 2]  928 	addw	x, (0x12, sp)
      009792 7F               [ 1]  929 	clr	(x)
      009793                        930 00119$:
                                    931 ;	./params.c: 397: }
      009793 5B 0D            [ 2]  932 	addw	sp, #13
      009795 81               [ 4]  933 	ret
                                    934 	.area CODE
                                    935 	.area CONST
      008208                        936 _paramMin:
      008208 00 00                  937 	.dw #0x0000
      00820A 00 01                  938 	.dw #0x0001
      00820C FF D3                  939 	.dw #0xffd3
      00820E FF CE                  940 	.dw #0xffce
      008210 FF BA                  941 	.dw #0xffba
      008212 00 00                  942 	.dw #0x0000
      008214 00 00                  943 	.dw #0x0000
      008216 00 00                  944 	.dw #0x0000
      008218 00 00                  945 	.dw #0x0000
      00821A FE 0C                  946 	.dw #0xfe0c
      00821C                        947 _paramMax:
      00821C 00 03                  948 	.dw #0x0003
      00821E 00 96                  949 	.dw #0x0096
      008220 00 6E                  950 	.dw #0x006e
      008222 00 69                  951 	.dw #0x0069
      008224 00 46                  952 	.dw #0x0046
      008226 00 0A                  953 	.dw #0x000a
      008228 00 01                  954 	.dw #0x0001
      00822A 00 00                  955 	.dw #0x0000
      00822C 00 00                  956 	.dw #0x0000
      00822E 04 4C                  957 	.dw #0x044c
      008230                        958 _paramDefault:
      008230 00 00                  959 	.dw #0x0000
      008232 00 14                  960 	.dw #0x0014
      008234 00 6E                  961 	.dw #0x006e
      008236 FF CE                  962 	.dw #0xffce
      008238 00 00                  963 	.dw #0x0000
      00823A 00 00                  964 	.dw #0x0000
      00823C 00 00                  965 	.dw #0x0000
      00823E 00 00                  966 	.dw #0x0000
      008240 00 00                  967 	.dw #0x0000
      008242 01 18                  968 	.dw #0x0118
                                    969 	.area INITIALIZER
                                    970 	.area CABS (ABS)

                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module menu
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _getUptimeTicks
                                     12 	.globl _setParamId
                                     13 	.globl _storeParams
                                     14 	.globl _decParamId
                                     15 	.globl _incParamId
                                     16 	.globl _decParam
                                     17 	.globl _incParam
                                     18 	.globl _setDisplayOff
                                     19 	.globl _getButton3
                                     20 	.globl _getButton2
                                     21 	.globl _getButton1
                                     22 	.globl _initMenu
                                     23 	.globl _getMenuDisplay
                                     24 	.globl _feedMenu
                                     25 	.globl _refreshMenu
                                     26 ;--------------------------------------------------------
                                     27 ; ram data
                                     28 ;--------------------------------------------------------
                                     29 	.area DATA
      000024                         30 _menuDisplay:
      000024                         31 	.ds 1
      000025                         32 _menuState:
      000025                         33 	.ds 1
      000026                         34 _timer:
      000026                         35 	.ds 2
                                     36 ;--------------------------------------------------------
                                     37 ; ram data
                                     38 ;--------------------------------------------------------
                                     39 	.area INITIALIZED
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
                                     69 ;	./menu.c: 40: void initMenu()
                                     70 ;	-----------------------------------------
                                     71 ;	 function initMenu
                                     72 ;	-----------------------------------------
      008C48                         73 _initMenu:
                                     74 ;	./menu.c: 42: timer = 0;
      008C48 5F               [ 1]   75 	clrw	x
      008C49 CF 00 26         [ 2]   76 	ldw	_timer+0, x
                                     77 ;	./menu.c: 43: menuState = menuDisplay = MENU_ROOT;
      008C4C 72 5F 00 24      [ 1]   78 	clr	_menuDisplay+0
      008C50 72 5F 00 25      [ 1]   79 	clr	_menuState+0
                                     80 ;	./menu.c: 44: }
      008C54 81               [ 4]   81 	ret
                                     82 ;	./menu.c: 50: unsigned char getMenuDisplay()
                                     83 ;	-----------------------------------------
                                     84 ;	 function getMenuDisplay
                                     85 ;	-----------------------------------------
      008C55                         86 _getMenuDisplay:
                                     87 ;	./menu.c: 52: return menuDisplay;
      008C55 C6 00 24         [ 1]   88 	ld	a, _menuDisplay+0
                                     89 ;	./menu.c: 53: }
      008C58 81               [ 4]   90 	ret
                                     91 ;	./menu.c: 72: void feedMenu (unsigned char event)
                                     92 ;	-----------------------------------------
                                     93 ;	 function feedMenu
                                     94 ;	-----------------------------------------
      008C59                         95 _feedMenu:
      008C59 52 03            [ 2]   96 	sub	sp, #3
                                     97 ;	./menu.c: 84: if (timer < MENU_5_SEC_PASSED) {
      008C5B CE 00 26         [ 2]   98 	ldw	x, _timer+0
      008C5E A3 00 A0         [ 2]   99 	cpw	x, #0x00a0
      008C61 4F               [ 1]  100 	clr	a
      008C62 49               [ 1]  101 	rlc	a
      008C63 6B 01            [ 1]  102 	ld	(0x01, sp), a
                                    103 ;	./menu.c: 76: if (menuState == MENU_ROOT) {
      008C65 72 5D 00 25      [ 1]  104 	tnz	_menuState+0
      008C69 26 71            [ 1]  105 	jrne	00188$
                                    106 ;	./menu.c: 77: switch (event) {
      008C6B 7B 06            [ 1]  107 	ld	a, (0x06, sp)
      008C6D A1 00            [ 1]  108 	cp	a, #0x00
      008C6F 27 0E            [ 1]  109 	jreq	00101$
      008C71 7B 06            [ 1]  110 	ld	a, (0x06, sp)
      008C73 A1 03            [ 1]  111 	cp	a, #0x03
      008C75 27 13            [ 1]  112 	jreq	00102$
      008C77 7B 06            [ 1]  113 	ld	a, (0x06, sp)
      008C79 A1 06            [ 1]  114 	cp	a, #0x06
      008C7B 27 1C            [ 1]  115 	jreq	00105$
      008C7D 20 43            [ 2]  116 	jra	00110$
                                    117 ;	./menu.c: 78: case MENU_EVENT_PUSH_BUTTON1:
      008C7F                        118 00101$:
                                    119 ;	./menu.c: 79: timer = 0;
      008C7F 5F               [ 1]  120 	clrw	x
      008C80 CF 00 26         [ 2]  121 	ldw	_timer+0, x
                                    122 ;	./menu.c: 80: menuDisplay = MENU_SET_THRESHOLD;
      008C83 35 01 00 24      [ 1]  123 	mov	_menuDisplay+0, #0x01
                                    124 ;	./menu.c: 81: break;
      008C87 CC 8F 26         [ 2]  125 	jp	00190$
                                    126 ;	./menu.c: 83: case MENU_EVENT_RELEASE_BUTTON1:
      008C8A                        127 00102$:
                                    128 ;	./menu.c: 84: if (timer < MENU_5_SEC_PASSED) {
      008C8A 0D 01            [ 1]  129 	tnz	(0x01, sp)
      008C8C 27 04            [ 1]  130 	jreq	00104$
                                    131 ;	./menu.c: 85: menuState = MENU_SET_THRESHOLD;
      008C8E 35 01 00 25      [ 1]  132 	mov	_menuState+0, #0x01
      008C92                        133 00104$:
                                    134 ;	./menu.c: 88: timer = 0;
      008C92 5F               [ 1]  135 	clrw	x
      008C93 CF 00 26         [ 2]  136 	ldw	_timer+0, x
                                    137 ;	./menu.c: 89: break;
      008C96 CC 8F 26         [ 2]  138 	jp	00190$
                                    139 ;	./menu.c: 91: case MENU_EVENT_CHECK_TIMER:
      008C99                        140 00105$:
                                    141 ;	./menu.c: 92: if (getButton1() ) {
      008C99 CD 8A 1D         [ 4]  142 	call	_getButton1
      008C9C 4D               [ 1]  143 	tnz	a
      008C9D 26 03            [ 1]  144 	jrne	00358$
      008C9F CC 8F 26         [ 2]  145 	jp	00190$
      008CA2                        146 00358$:
                                    147 ;	./menu.c: 93: if (timer > MENU_3_SEC_PASSED) {
      008CA2 CE 00 26         [ 2]  148 	ldw	x, _timer+0
      008CA5 A3 00 60         [ 2]  149 	cpw	x, #0x0060
      008CA8 22 03            [ 1]  150 	jrugt	00359$
      008CAA CC 8F 26         [ 2]  151 	jp	00190$
      008CAD                        152 00359$:
                                    153 ;	./menu.c: 94: setParamId (0);
      008CAD 4B 00            [ 1]  154 	push	#0x00
      008CAF CD 90 53         [ 4]  155 	call	_setParamId
      008CB2 84               [ 1]  156 	pop	a
                                    157 ;	./menu.c: 95: timer = 0;
      008CB3 5F               [ 1]  158 	clrw	x
      008CB4 CF 00 26         [ 2]  159 	ldw	_timer+0, x
                                    160 ;	./menu.c: 96: menuState = menuDisplay = MENU_SELECT_PARAM;
      008CB7 35 02 00 24      [ 1]  161 	mov	_menuDisplay+0, #0x02
      008CBB 35 02 00 25      [ 1]  162 	mov	_menuState+0, #0x02
                                    163 ;	./menu.c: 100: break;
      008CBF CC 8F 26         [ 2]  164 	jp	00190$
                                    165 ;	./menu.c: 102: default:
      008CC2                        166 00110$:
                                    167 ;	./menu.c: 103: if (timer > MENU_5_SEC_PASSED) {
      008CC2 CE 00 26         [ 2]  168 	ldw	x, _timer+0
      008CC5 A3 00 A0         [ 2]  169 	cpw	x, #0x00a0
      008CC8 22 03            [ 1]  170 	jrugt	00360$
      008CCA CC 8F 26         [ 2]  171 	jp	00190$
      008CCD                        172 00360$:
                                    173 ;	./menu.c: 104: timer = 0;
      008CCD 5F               [ 1]  174 	clrw	x
      008CCE CF 00 26         [ 2]  175 	ldw	_timer+0, x
                                    176 ;	./menu.c: 105: menuState = menuDisplay = MENU_ROOT;
      008CD1 72 5F 00 24      [ 1]  177 	clr	_menuDisplay+0
      008CD5 72 5F 00 25      [ 1]  178 	clr	_menuState+0
                                    179 ;	./menu.c: 109: }
      008CD9 CC 8F 26         [ 2]  180 	jp	00190$
      008CDC                        181 00188$:
                                    182 ;	./menu.c: 111: switch (event) {
      008CDC 7B 06            [ 1]  183 	ld	a, (0x06, sp)
      008CDE A1 06            [ 1]  184 	cp	a, #0x06
      008CE0 22 04            [ 1]  185 	jrugt	00361$
      008CE2 0F 02            [ 1]  186 	clr	(0x02, sp)
      008CE4 20 04            [ 2]  187 	jra	00362$
      008CE6                        188 00361$:
      008CE6 A6 01            [ 1]  189 	ld	a, #0x01
      008CE8 6B 02            [ 1]  190 	ld	(0x02, sp), a
      008CEA                        191 00362$:
                                    192 ;	./menu.c: 134: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
      008CEA CE 00 26         [ 2]  193 	ldw	x, _timer+0
      008CED A3 00 24         [ 2]  194 	cpw	x, #0x0024
      008CF0 22 04            [ 1]  195 	jrugt	00363$
      008CF2 0F 03            [ 1]  196 	clr	(0x03, sp)
      008CF4 20 04            [ 2]  197 	jra	00364$
      008CF6                        198 00363$:
      008CF6 A6 01            [ 1]  199 	ld	a, #0x01
      008CF8 6B 03            [ 1]  200 	ld	(0x03, sp), a
      008CFA                        201 00364$:
                                    202 ;	./menu.c: 110: } else if (menuState == MENU_SELECT_PARAM) {
      008CFA C6 00 25         [ 1]  203 	ld	a, _menuState+0
      008CFD A1 02            [ 1]  204 	cp	a, #0x02
      008CFF 27 03            [ 1]  205 	jreq	00367$
      008D01 CC 8D 8C         [ 2]  206 	jp	00185$
      008D04                        207 00367$:
                                    208 ;	./menu.c: 111: switch (event) {
      008D04 0D 02            [ 1]  209 	tnz	(0x02, sp)
      008D06 27 03            [ 1]  210 	jreq	00368$
      008D08 CC 8F 26         [ 2]  211 	jp	00190$
      008D0B                        212 00368$:
      008D0B 5F               [ 1]  213 	clrw	x
      008D0C 7B 06            [ 1]  214 	ld	a, (0x06, sp)
      008D0E 97               [ 1]  215 	ld	xl, a
      008D0F 58               [ 2]  216 	sllw	x
      008D10 DE 8D 14         [ 2]  217 	ldw	x, (#00369$, x)
      008D13 FC               [ 2]  218 	jp	(x)
      008D14                        219 00369$:
      008D14 8D 22                  220 	.dw	#00114$
      008D16 8D 31                  221 	.dw	#00116$
      008D18 8D 3B                  222 	.dw	#00118$
      008D1A 8D 2A                  223 	.dw	#00115$
      008D1C 8D 34                  224 	.dw	#00117$
      008D1E 8D 3E                  225 	.dw	#00119$
      008D20 8D 45                  226 	.dw	#00120$
                                    227 ;	./menu.c: 112: case MENU_EVENT_PUSH_BUTTON1:
      008D22                        228 00114$:
                                    229 ;	./menu.c: 113: menuState = menuDisplay = MENU_CHANGE_PARAM;
      008D22 35 03 00 24      [ 1]  230 	mov	_menuDisplay+0, #0x03
      008D26 35 03 00 25      [ 1]  231 	mov	_menuState+0, #0x03
                                    232 ;	./menu.c: 115: case MENU_EVENT_RELEASE_BUTTON1:
      008D2A                        233 00115$:
                                    234 ;	./menu.c: 116: timer = 0;
      008D2A 5F               [ 1]  235 	clrw	x
      008D2B CF 00 26         [ 2]  236 	ldw	_timer+0, x
                                    237 ;	./menu.c: 117: break;
      008D2E CC 8F 26         [ 2]  238 	jp	00190$
                                    239 ;	./menu.c: 119: case MENU_EVENT_PUSH_BUTTON2:
      008D31                        240 00116$:
                                    241 ;	./menu.c: 120: incParamId();
      008D31 CD 90 60         [ 4]  242 	call	_incParamId
                                    243 ;	./menu.c: 122: case MENU_EVENT_RELEASE_BUTTON2:
      008D34                        244 00117$:
                                    245 ;	./menu.c: 123: timer = 0;
      008D34 5F               [ 1]  246 	clrw	x
      008D35 CF 00 26         [ 2]  247 	ldw	_timer+0, x
                                    248 ;	./menu.c: 124: break;
      008D38 CC 8F 26         [ 2]  249 	jp	00190$
                                    250 ;	./menu.c: 126: case MENU_EVENT_PUSH_BUTTON3:
      008D3B                        251 00118$:
                                    252 ;	./menu.c: 127: decParamId();
      008D3B CD 90 71         [ 4]  253 	call	_decParamId
                                    254 ;	./menu.c: 129: case MENU_EVENT_RELEASE_BUTTON3:
      008D3E                        255 00119$:
                                    256 ;	./menu.c: 130: timer = 0;
      008D3E 5F               [ 1]  257 	clrw	x
      008D3F CF 00 26         [ 2]  258 	ldw	_timer+0, x
                                    259 ;	./menu.c: 131: break;
      008D42 CC 8F 26         [ 2]  260 	jp	00190$
                                    261 ;	./menu.c: 133: case MENU_EVENT_CHECK_TIMER:
      008D45                        262 00120$:
                                    263 ;	./menu.c: 134: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
      008D45 0D 03            [ 1]  264 	tnz	(0x03, sp)
      008D47 27 20            [ 1]  265 	jreq	00127$
                                    266 ;	./menu.c: 135: if (getButton2() ) {
      008D49 CD 8A 25         [ 4]  267 	call	_getButton2
      008D4C 4D               [ 1]  268 	tnz	a
      008D4D 27 0B            [ 1]  269 	jreq	00124$
                                    270 ;	./menu.c: 136: incParamId();
      008D4F CD 90 60         [ 4]  271 	call	_incParamId
                                    272 ;	./menu.c: 137: timer = MENU_1_SEC_PASSED;
      008D52 AE 00 20         [ 2]  273 	ldw	x, #0x0020
      008D55 CF 00 26         [ 2]  274 	ldw	_timer+0, x
      008D58 20 0F            [ 2]  275 	jra	00127$
      008D5A                        276 00124$:
                                    277 ;	./menu.c: 138: } else if (getButton3() ) {
      008D5A CD 8A 2F         [ 4]  278 	call	_getButton3
      008D5D 4D               [ 1]  279 	tnz	a
      008D5E 27 09            [ 1]  280 	jreq	00127$
                                    281 ;	./menu.c: 139: decParamId();
      008D60 CD 90 71         [ 4]  282 	call	_decParamId
                                    283 ;	./menu.c: 140: timer = MENU_1_SEC_PASSED;
      008D63 AE 00 20         [ 2]  284 	ldw	x, #0x0020
      008D66 CF 00 26         [ 2]  285 	ldw	_timer+0, x
      008D69                        286 00127$:
                                    287 ;	./menu.c: 144: if (timer > MENU_5_SEC_PASSED) {
      008D69 CE 00 26         [ 2]  288 	ldw	x, _timer+0
      008D6C A3 00 A0         [ 2]  289 	cpw	x, #0x00a0
      008D6F 22 03            [ 1]  290 	jrugt	00373$
      008D71 CC 8F 26         [ 2]  291 	jp	00190$
      008D74                        292 00373$:
                                    293 ;	./menu.c: 145: timer = 0;
      008D74 5F               [ 1]  294 	clrw	x
      008D75 CF 00 26         [ 2]  295 	ldw	_timer+0, x
                                    296 ;	./menu.c: 146: setParamId (0);
      008D78 4B 00            [ 1]  297 	push	#0x00
      008D7A CD 90 53         [ 4]  298 	call	_setParamId
      008D7D 84               [ 1]  299 	pop	a
                                    300 ;	./menu.c: 147: storeParams();
      008D7E CD 91 9B         [ 4]  301 	call	_storeParams
                                    302 ;	./menu.c: 148: menuState = menuDisplay = MENU_ROOT;
      008D81 72 5F 00 24      [ 1]  303 	clr	_menuDisplay+0
      008D85 72 5F 00 25      [ 1]  304 	clr	_menuState+0
                                    305 ;	./menu.c: 151: break;
      008D89 CC 8F 26         [ 2]  306 	jp	00190$
                                    307 ;	./menu.c: 155: }
      008D8C                        308 00185$:
                                    309 ;	./menu.c: 156: } else if (menuState == MENU_CHANGE_PARAM) {
      008D8C C6 00 25         [ 1]  310 	ld	a, _menuState+0
      008D8F A1 03            [ 1]  311 	cp	a, #0x03
      008D91 27 03            [ 1]  312 	jreq	00376$
      008D93 CC 8E 35         [ 2]  313 	jp	00182$
      008D96                        314 00376$:
                                    315 ;	./menu.c: 157: switch (event) {
      008D96 0D 02            [ 1]  316 	tnz	(0x02, sp)
      008D98 27 03            [ 1]  317 	jreq	00377$
      008D9A CC 8F 26         [ 2]  318 	jp	00190$
      008D9D                        319 00377$:
      008D9D 5F               [ 1]  320 	clrw	x
      008D9E 7B 06            [ 1]  321 	ld	a, (0x06, sp)
      008DA0 97               [ 1]  322 	ld	xl, a
      008DA1 58               [ 2]  323 	sllw	x
      008DA2 DE 8D A6         [ 2]  324 	ldw	x, (#00378$, x)
      008DA5 FC               [ 2]  325 	jp	(x)
      008DA6                        326 00378$:
      008DA6 8D B4                  327 	.dw	#00132$
      008DA8 8D C3                  328 	.dw	#00134$
      008DAA 8D CD                  329 	.dw	#00136$
      008DAC 8D BC                  330 	.dw	#00133$
      008DAE 8D C6                  331 	.dw	#00135$
      008DB0 8D D0                  332 	.dw	#00137$
      008DB2 8D D7                  333 	.dw	#00138$
                                    334 ;	./menu.c: 158: case MENU_EVENT_PUSH_BUTTON1:
      008DB4                        335 00132$:
                                    336 ;	./menu.c: 159: menuState = menuDisplay = MENU_SELECT_PARAM;
      008DB4 35 02 00 24      [ 1]  337 	mov	_menuDisplay+0, #0x02
      008DB8 35 02 00 25      [ 1]  338 	mov	_menuState+0, #0x02
                                    339 ;	./menu.c: 161: case MENU_EVENT_RELEASE_BUTTON1:
      008DBC                        340 00133$:
                                    341 ;	./menu.c: 162: timer = 0;
      008DBC 5F               [ 1]  342 	clrw	x
      008DBD CF 00 26         [ 2]  343 	ldw	_timer+0, x
                                    344 ;	./menu.c: 163: break;
      008DC0 CC 8F 26         [ 2]  345 	jp	00190$
                                    346 ;	./menu.c: 165: case MENU_EVENT_PUSH_BUTTON2:
      008DC3                        347 00134$:
                                    348 ;	./menu.c: 166: incParam();
      008DC3 CD 8F CB         [ 4]  349 	call	_incParam
                                    350 ;	./menu.c: 168: case MENU_EVENT_RELEASE_BUTTON2:
      008DC6                        351 00135$:
                                    352 ;	./menu.c: 169: timer = 0;
      008DC6 5F               [ 1]  353 	clrw	x
      008DC7 CF 00 26         [ 2]  354 	ldw	_timer+0, x
                                    355 ;	./menu.c: 170: break;
      008DCA CC 8F 26         [ 2]  356 	jp	00190$
                                    357 ;	./menu.c: 172: case MENU_EVENT_PUSH_BUTTON3:
      008DCD                        358 00136$:
                                    359 ;	./menu.c: 173: decParam();
      008DCD CD 90 0D         [ 4]  360 	call	_decParam
                                    361 ;	./menu.c: 175: case MENU_EVENT_RELEASE_BUTTON3:
      008DD0                        362 00137$:
                                    363 ;	./menu.c: 176: timer = 0;
      008DD0 5F               [ 1]  364 	clrw	x
      008DD1 CF 00 26         [ 2]  365 	ldw	_timer+0, x
                                    366 ;	./menu.c: 177: break;
      008DD4 CC 8F 26         [ 2]  367 	jp	00190$
                                    368 ;	./menu.c: 179: case MENU_EVENT_CHECK_TIMER:
      008DD7                        369 00138$:
                                    370 ;	./menu.c: 180: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
      008DD7 0D 03            [ 1]  371 	tnz	(0x03, sp)
      008DD9 27 20            [ 1]  372 	jreq	00145$
                                    373 ;	./menu.c: 181: if (getButton2() ) {
      008DDB CD 8A 25         [ 4]  374 	call	_getButton2
      008DDE 4D               [ 1]  375 	tnz	a
      008DDF 27 0B            [ 1]  376 	jreq	00142$
                                    377 ;	./menu.c: 182: incParam();
      008DE1 CD 8F CB         [ 4]  378 	call	_incParam
                                    379 ;	./menu.c: 183: timer = MENU_1_SEC_PASSED;
      008DE4 AE 00 20         [ 2]  380 	ldw	x, #0x0020
      008DE7 CF 00 26         [ 2]  381 	ldw	_timer+0, x
      008DEA 20 0F            [ 2]  382 	jra	00145$
      008DEC                        383 00142$:
                                    384 ;	./menu.c: 184: } else if (getButton3() ) {
      008DEC CD 8A 2F         [ 4]  385 	call	_getButton3
      008DEF 4D               [ 1]  386 	tnz	a
      008DF0 27 09            [ 1]  387 	jreq	00145$
                                    388 ;	./menu.c: 185: decParam();
      008DF2 CD 90 0D         [ 4]  389 	call	_decParam
                                    390 ;	./menu.c: 186: timer = MENU_1_SEC_PASSED;
      008DF5 AE 00 20         [ 2]  391 	ldw	x, #0x0020
      008DF8 CF 00 26         [ 2]  392 	ldw	_timer+0, x
      008DFB                        393 00145$:
                                    394 ;	./menu.c: 190: if (getButton1() && timer > MENU_3_SEC_PASSED) {
      008DFB CD 8A 1D         [ 4]  395 	call	_getButton1
      008DFE 4D               [ 1]  396 	tnz	a
      008DFF 27 17            [ 1]  397 	jreq	00147$
      008E01 CE 00 26         [ 2]  398 	ldw	x, _timer+0
      008E04 A3 00 60         [ 2]  399 	cpw	x, #0x0060
      008E07 23 0F            [ 2]  400 	jrule	00147$
                                    401 ;	./menu.c: 191: timer = 0;
      008E09 5F               [ 1]  402 	clrw	x
      008E0A CF 00 26         [ 2]  403 	ldw	_timer+0, x
                                    404 ;	./menu.c: 192: menuState = menuDisplay = MENU_SELECT_PARAM;
      008E0D 35 02 00 24      [ 1]  405 	mov	_menuDisplay+0, #0x02
      008E11 35 02 00 25      [ 1]  406 	mov	_menuState+0, #0x02
                                    407 ;	./menu.c: 193: break;
      008E15 CC 8F 26         [ 2]  408 	jp	00190$
      008E18                        409 00147$:
                                    410 ;	./menu.c: 196: if (timer > MENU_5_SEC_PASSED) {
      008E18 CE 00 26         [ 2]  411 	ldw	x, _timer+0
      008E1B A3 00 A0         [ 2]  412 	cpw	x, #0x00a0
      008E1E 22 03            [ 1]  413 	jrugt	00384$
      008E20 CC 8F 26         [ 2]  414 	jp	00190$
      008E23                        415 00384$:
                                    416 ;	./menu.c: 197: timer = 0;
      008E23 5F               [ 1]  417 	clrw	x
      008E24 CF 00 26         [ 2]  418 	ldw	_timer+0, x
                                    419 ;	./menu.c: 198: storeParams();
      008E27 CD 91 9B         [ 4]  420 	call	_storeParams
                                    421 ;	./menu.c: 199: menuState = menuDisplay = MENU_ROOT;
      008E2A 72 5F 00 24      [ 1]  422 	clr	_menuDisplay+0
      008E2E 72 5F 00 25      [ 1]  423 	clr	_menuState+0
                                    424 ;	./menu.c: 202: break;
      008E32 CC 8F 26         [ 2]  425 	jp	00190$
                                    426 ;	./menu.c: 206: }
      008E35                        427 00182$:
                                    428 ;	./menu.c: 207: } else if (menuState == MENU_SET_THRESHOLD) {
      008E35 C6 00 25         [ 1]  429 	ld	a, _menuState+0
      008E38 4A               [ 1]  430 	dec	a
      008E39 27 03            [ 1]  431 	jreq	00387$
      008E3B CC 8F 26         [ 2]  432 	jp	00190$
      008E3E                        433 00387$:
                                    434 ;	./menu.c: 208: switch (event) {
      008E3E 0D 02            [ 1]  435 	tnz	(0x02, sp)
      008E40 27 03            [ 1]  436 	jreq	00388$
      008E42 CC 8F 26         [ 2]  437 	jp	00190$
      008E45                        438 00388$:
      008E45 5F               [ 1]  439 	clrw	x
      008E46 7B 06            [ 1]  440 	ld	a, (0x06, sp)
      008E48 97               [ 1]  441 	ld	xl, a
      008E49 58               [ 2]  442 	sllw	x
      008E4A DE 8E 4E         [ 2]  443 	ldw	x, (#00389$, x)
      008E4D FC               [ 2]  444 	jp	(x)
      008E4E                        445 00389$:
      008E4E 8E 5C                  446 	.dw	#00153$
      008E50 8E 85                  447 	.dw	#00157$
      008E52 8E 95                  448 	.dw	#00159$
      008E54 8E 6D                  449 	.dw	#00154$
      008E56 8E 8E                  450 	.dw	#00158$
      008E58 8E 9E                  451 	.dw	#00160$
      008E5A 8E A5                  452 	.dw	#00161$
                                    453 ;	./menu.c: 209: case MENU_EVENT_PUSH_BUTTON1:
      008E5C                        454 00153$:
                                    455 ;	./menu.c: 210: timer = 0;
      008E5C 5F               [ 1]  456 	clrw	x
      008E5D CF 00 26         [ 2]  457 	ldw	_timer+0, x
                                    458 ;	./menu.c: 211: menuDisplay = MENU_ROOT;
      008E60 72 5F 00 24      [ 1]  459 	clr	_menuDisplay+0
                                    460 ;	./menu.c: 212: setDisplayOff (false);
      008E64 4B 00            [ 1]  461 	push	#0x00
      008E66 CD 84 43         [ 4]  462 	call	_setDisplayOff
      008E69 84               [ 1]  463 	pop	a
                                    464 ;	./menu.c: 213: break;
      008E6A CC 8F 26         [ 2]  465 	jp	00190$
                                    466 ;	./menu.c: 215: case MENU_EVENT_RELEASE_BUTTON1:
      008E6D                        467 00154$:
                                    468 ;	./menu.c: 216: if (timer < MENU_5_SEC_PASSED) {
      008E6D 0D 01            [ 1]  469 	tnz	(0x01, sp)
      008E6F 27 0D            [ 1]  470 	jreq	00156$
                                    471 ;	./menu.c: 217: storeParams();
      008E71 CD 91 9B         [ 4]  472 	call	_storeParams
                                    473 ;	./menu.c: 218: menuState = MENU_ROOT;
      008E74 72 5F 00 25      [ 1]  474 	clr	_menuState+0
                                    475 ;	./menu.c: 219: setDisplayOff (false);
      008E78 4B 00            [ 1]  476 	push	#0x00
      008E7A CD 84 43         [ 4]  477 	call	_setDisplayOff
      008E7D 84               [ 1]  478 	pop	a
      008E7E                        479 00156$:
                                    480 ;	./menu.c: 222: timer = 0;
      008E7E 5F               [ 1]  481 	clrw	x
      008E7F CF 00 26         [ 2]  482 	ldw	_timer+0, x
                                    483 ;	./menu.c: 223: break;
      008E82 CC 8F 26         [ 2]  484 	jp	00190$
                                    485 ;	./menu.c: 225: case MENU_EVENT_PUSH_BUTTON2:
      008E85                        486 00157$:
                                    487 ;	./menu.c: 226: setParamId (PARAM_THRESHOLD);
      008E85 4B 09            [ 1]  488 	push	#0x09
      008E87 CD 90 53         [ 4]  489 	call	_setParamId
      008E8A 84               [ 1]  490 	pop	a
                                    491 ;	./menu.c: 227: incParam();
      008E8B CD 8F CB         [ 4]  492 	call	_incParam
                                    493 ;	./menu.c: 229: case MENU_EVENT_RELEASE_BUTTON2:
      008E8E                        494 00158$:
                                    495 ;	./menu.c: 230: timer = 0;
      008E8E 5F               [ 1]  496 	clrw	x
      008E8F CF 00 26         [ 2]  497 	ldw	_timer+0, x
                                    498 ;	./menu.c: 231: break;
      008E92 CC 8F 26         [ 2]  499 	jp	00190$
                                    500 ;	./menu.c: 233: case MENU_EVENT_PUSH_BUTTON3:
      008E95                        501 00159$:
                                    502 ;	./menu.c: 234: setParamId (PARAM_THRESHOLD);
      008E95 4B 09            [ 1]  503 	push	#0x09
      008E97 CD 90 53         [ 4]  504 	call	_setParamId
      008E9A 84               [ 1]  505 	pop	a
                                    506 ;	./menu.c: 235: decParam();
      008E9B CD 90 0D         [ 4]  507 	call	_decParam
                                    508 ;	./menu.c: 237: case MENU_EVENT_RELEASE_BUTTON3:
      008E9E                        509 00160$:
                                    510 ;	./menu.c: 238: timer = 0;
      008E9E 5F               [ 1]  511 	clrw	x
      008E9F CF 00 26         [ 2]  512 	ldw	_timer+0, x
                                    513 ;	./menu.c: 239: break;
      008EA2 CC 8F 26         [ 2]  514 	jp	00190$
                                    515 ;	./menu.c: 241: case MENU_EVENT_CHECK_TIMER:
      008EA5                        516 00161$:
                                    517 ;	./menu.c: 242: if (getButton2() || getButton3() ) {
      008EA5 CD 8A 25         [ 4]  518 	call	_getButton2
      008EA8 4D               [ 1]  519 	tnz	a
      008EA9 26 06            [ 1]  520 	jrne	00162$
      008EAB CD 8A 2F         [ 4]  521 	call	_getButton3
      008EAE 4D               [ 1]  522 	tnz	a
      008EAF 27 04            [ 1]  523 	jreq	00163$
      008EB1                        524 00162$:
                                    525 ;	./menu.c: 243: blink = false;
      008EB1 0F 03            [ 1]  526 	clr	(0x03, sp)
      008EB3 20 09            [ 2]  527 	jra	00164$
      008EB5                        528 00163$:
                                    529 ;	./menu.c: 245: blink = (bool) ( (unsigned char) getUptimeTicks() & 0x80);
      008EB5 CD 88 8F         [ 4]  530 	call	_getUptimeTicks
      008EB8 9F               [ 1]  531 	ld	a, xl
      008EB9 48               [ 1]  532 	sll	a
      008EBA 4F               [ 1]  533 	clr	a
      008EBB 49               [ 1]  534 	rlc	a
      008EBC 6B 03            [ 1]  535 	ld	(0x03, sp), a
      008EBE                        536 00164$:
                                    537 ;	./menu.c: 248: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
      008EBE CE 00 26         [ 2]  538 	ldw	x, _timer+0
      008EC1 A3 00 24         [ 2]  539 	cpw	x, #0x0024
      008EC4 23 26            [ 2]  540 	jrule	00172$
                                    541 ;	./menu.c: 249: setParamId (PARAM_THRESHOLD);
      008EC6 4B 09            [ 1]  542 	push	#0x09
      008EC8 CD 90 53         [ 4]  543 	call	_setParamId
      008ECB 84               [ 1]  544 	pop	a
                                    545 ;	./menu.c: 251: if (getButton2() ) {
      008ECC CD 8A 25         [ 4]  546 	call	_getButton2
      008ECF 4D               [ 1]  547 	tnz	a
      008ED0 27 0B            [ 1]  548 	jreq	00169$
                                    549 ;	./menu.c: 252: incParam();
      008ED2 CD 8F CB         [ 4]  550 	call	_incParam
                                    551 ;	./menu.c: 253: timer = MENU_1_SEC_PASSED;
      008ED5 AE 00 20         [ 2]  552 	ldw	x, #0x0020
      008ED8 CF 00 26         [ 2]  553 	ldw	_timer+0, x
      008EDB 20 0F            [ 2]  554 	jra	00172$
      008EDD                        555 00169$:
                                    556 ;	./menu.c: 254: } else if (getButton3() ) {
      008EDD CD 8A 2F         [ 4]  557 	call	_getButton3
      008EE0 4D               [ 1]  558 	tnz	a
      008EE1 27 09            [ 1]  559 	jreq	00172$
                                    560 ;	./menu.c: 255: decParam();
      008EE3 CD 90 0D         [ 4]  561 	call	_decParam
                                    562 ;	./menu.c: 256: timer = MENU_1_SEC_PASSED;
      008EE6 AE 00 20         [ 2]  563 	ldw	x, #0x0020
      008EE9 CF 00 26         [ 2]  564 	ldw	_timer+0, x
      008EEC                        565 00172$:
                                    566 ;	./menu.c: 260: setDisplayOff (blink);
      008EEC 7B 03            [ 1]  567 	ld	a, (0x03, sp)
      008EEE 88               [ 1]  568 	push	a
      008EEF CD 84 43         [ 4]  569 	call	_setDisplayOff
      008EF2 84               [ 1]  570 	pop	a
                                    571 ;	./menu.c: 262: if (timer > MENU_5_SEC_PASSED) {
      008EF3 CE 00 26         [ 2]  572 	ldw	x, _timer+0
      008EF6 A3 00 A0         [ 2]  573 	cpw	x, #0x00a0
      008EF9 23 2B            [ 2]  574 	jrule	00190$
                                    575 ;	./menu.c: 263: timer = 0;
      008EFB 5F               [ 1]  576 	clrw	x
      008EFC CF 00 26         [ 2]  577 	ldw	_timer+0, x
                                    578 ;	./menu.c: 265: if (getButton1() ) {
      008EFF CD 8A 1D         [ 4]  579 	call	_getButton1
      008F02 4D               [ 1]  580 	tnz	a
      008F03 27 10            [ 1]  581 	jreq	00174$
                                    582 ;	./menu.c: 266: menuState = menuDisplay = MENU_SELECT_PARAM;
      008F05 35 02 00 24      [ 1]  583 	mov	_menuDisplay+0, #0x02
      008F09 35 02 00 25      [ 1]  584 	mov	_menuState+0, #0x02
                                    585 ;	./menu.c: 267: setDisplayOff (false);
      008F0D 4B 00            [ 1]  586 	push	#0x00
      008F0F CD 84 43         [ 4]  587 	call	_setDisplayOff
      008F12 84               [ 1]  588 	pop	a
                                    589 ;	./menu.c: 268: break;
      008F13 20 11            [ 2]  590 	jra	00190$
      008F15                        591 00174$:
                                    592 ;	./menu.c: 271: storeParams();
      008F15 CD 91 9B         [ 4]  593 	call	_storeParams
                                    594 ;	./menu.c: 272: menuState = menuDisplay = MENU_ROOT;
      008F18 72 5F 00 24      [ 1]  595 	clr	_menuDisplay+0
      008F1C 72 5F 00 25      [ 1]  596 	clr	_menuState+0
                                    597 ;	./menu.c: 273: setDisplayOff (false);
      008F20 4B 00            [ 1]  598 	push	#0x00
      008F22 CD 84 43         [ 4]  599 	call	_setDisplayOff
      008F25 84               [ 1]  600 	pop	a
                                    601 ;	./menu.c: 280: }
      008F26                        602 00190$:
                                    603 ;	./menu.c: 282: }
      008F26 5B 03            [ 2]  604 	addw	sp, #3
      008F28 81               [ 4]  605 	ret
                                    606 ;	./menu.c: 292: void refreshMenu()
                                    607 ;	-----------------------------------------
                                    608 ;	 function refreshMenu
                                    609 ;	-----------------------------------------
      008F29                        610 _refreshMenu:
                                    611 ;	./menu.c: 294: timer++;
      008F29 CE 00 26         [ 2]  612 	ldw	x, _timer+0
      008F2C 5C               [ 1]  613 	incw	x
      008F2D CF 00 26         [ 2]  614 	ldw	_timer+0, x
                                    615 ;	./menu.c: 295: feedMenu (MENU_EVENT_CHECK_TIMER);
      008F30 4B 06            [ 1]  616 	push	#0x06
      008F32 CD 8C 59         [ 4]  617 	call	_feedMenu
      008F35 84               [ 1]  618 	pop	a
                                    619 ;	./menu.c: 296: }
      008F36 81               [ 4]  620 	ret
                                    621 	.area CODE
                                    622 	.area CONST
                                    623 	.area INITIALIZER
                                    624 	.area CABS (ABS)

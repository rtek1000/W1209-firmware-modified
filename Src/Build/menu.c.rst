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
                                     13 	.globl _getParamById
                                     14 	.globl _storeParams
                                     15 	.globl _decParamId
                                     16 	.globl _incParamId
                                     17 	.globl _decParam
                                     18 	.globl _incParam
                                     19 	.globl _setDisplayOff
                                     20 	.globl _dimmerBrightness
                                     21 	.globl _getButton3
                                     22 	.globl _getButton2
                                     23 	.globl _getButton1
                                     24 	.globl _getSensorFail
                                     25 	.globl _initMenu
                                     26 	.globl _getMenuDisplay
                                     27 	.globl _setMenuDisplay
                                     28 	.globl _feedMenu
                                     29 	.globl _refreshMenu
                                     30 ;--------------------------------------------------------
                                     31 ; ram data
                                     32 ;--------------------------------------------------------
                                     33 	.area DATA
      000028                         34 _menuDisplay:
      000028                         35 	.ds 1
      000029                         36 _menuState:
      000029                         37 	.ds 1
      00002A                         38 _timer:
      00002A                         39 	.ds 2
                                     40 ;--------------------------------------------------------
                                     41 ; ram data
                                     42 ;--------------------------------------------------------
                                     43 	.area INITIALIZED
      000049                         44 _autoBrightness:
      000049                         45 	.ds 1
      00004A                         46 _lowBrightness:
      00004A                         47 	.ds 1
                                     48 ;--------------------------------------------------------
                                     49 ; absolute external ram data
                                     50 ;--------------------------------------------------------
                                     51 	.area DABS (ABS)
                                     52 
                                     53 ; default segment ordering for linker
                                     54 	.area HOME
                                     55 	.area GSINIT
                                     56 	.area GSFINAL
                                     57 	.area CONST
                                     58 	.area INITIALIZER
                                     59 	.area CODE
                                     60 
                                     61 ;--------------------------------------------------------
                                     62 ; global & static initialisations
                                     63 ;--------------------------------------------------------
                                     64 	.area HOME
                                     65 	.area GSINIT
                                     66 	.area GSFINAL
                                     67 	.area GSINIT
                                     68 ;--------------------------------------------------------
                                     69 ; Home
                                     70 ;--------------------------------------------------------
                                     71 	.area HOME
                                     72 	.area HOME
                                     73 ;--------------------------------------------------------
                                     74 ; code
                                     75 ;--------------------------------------------------------
                                     76 	.area CODE
                                     77 ;	./menu.c: 44: void initMenu()
                                     78 ;	-----------------------------------------
                                     79 ;	 function initMenu
                                     80 ;	-----------------------------------------
      008EC0                         81 _initMenu:
                                     82 ;	./menu.c: 46: timer = 0;
      008EC0 5F               [ 1]   83 	clrw	x
      008EC1 CF 00 2A         [ 2]   84 	ldw	_timer+0, x
                                     85 ;	./menu.c: 47: menuState = menuDisplay = MENU_ROOT;
      008EC4 72 5F 00 28      [ 1]   86 	clr	_menuDisplay+0
      008EC8 72 5F 00 29      [ 1]   87 	clr	_menuState+0
                                     88 ;	./menu.c: 48: }
      008ECC 81               [ 4]   89 	ret
                                     90 ;	./menu.c: 54: unsigned char getMenuDisplay()
                                     91 ;	-----------------------------------------
                                     92 ;	 function getMenuDisplay
                                     93 ;	-----------------------------------------
      008ECD                         94 _getMenuDisplay:
                                     95 ;	./menu.c: 56: return menuDisplay;
      008ECD C6 00 28         [ 1]   96 	ld	a, _menuDisplay+0
                                     97 ;	./menu.c: 57: }
      008ED0 81               [ 4]   98 	ret
                                     99 ;	./menu.c: 59: void setMenuDisplay(unsigned char _menu)
                                    100 ;	-----------------------------------------
                                    101 ;	 function setMenuDisplay
                                    102 ;	-----------------------------------------
      008ED1                        103 _setMenuDisplay:
                                    104 ;	./menu.c: 61: menuDisplay = _menu;
      008ED1 7B 03            [ 1]  105 	ld	a, (0x03, sp)
      008ED3 C7 00 28         [ 1]  106 	ld	_menuDisplay+0, a
                                    107 ;	./menu.c: 62: }
      008ED6 81               [ 4]  108 	ret
                                    109 ;	./menu.c: 81: void feedMenu (unsigned char event)
                                    110 ;	-----------------------------------------
                                    111 ;	 function feedMenu
                                    112 ;	-----------------------------------------
      008ED7                        113 _feedMenu:
      008ED7 52 04            [ 2]  114 	sub	sp, #4
                                    115 ;	./menu.c: 86: switch (event) {
      008ED9 7B 07            [ 1]  116 	ld	a, (0x07, sp)
      008EDB A1 06            [ 1]  117 	cp	a, #0x06
      008EDD 22 04            [ 1]  118 	jrugt	00502$
      008EDF 0F 01            [ 1]  119 	clr	(0x01, sp)
      008EE1 20 04            [ 2]  120 	jra	00503$
      008EE3                        121 00502$:
      008EE3 A6 01            [ 1]  122 	ld	a, #0x01
      008EE5 6B 01            [ 1]  123 	ld	(0x01, sp), a
      008EE7                        124 00503$:
                                    125 ;	./menu.c: 104: if (timer < MENU_5_SEC_PASSED) {
      008EE7 CE 00 2A         [ 2]  126 	ldw	x, _timer+0
      008EEA A3 00 A0         [ 2]  127 	cpw	x, #0x00a0
      008EED 4F               [ 1]  128 	clr	a
      008EEE 49               [ 1]  129 	rlc	a
      008EEF 6B 02            [ 1]  130 	ld	(0x02, sp), a
                                    131 ;	./menu.c: 174: if (timer > MENU_5_SEC_PASSED) {
      008EF1 CE 00 2A         [ 2]  132 	ldw	x, _timer+0
      008EF4 A3 00 A0         [ 2]  133 	cpw	x, #0x00a0
      008EF7 22 04            [ 1]  134 	jrugt	00504$
      008EF9 0F 03            [ 1]  135 	clr	(0x03, sp)
      008EFB 20 04            [ 2]  136 	jra	00505$
      008EFD                        137 00504$:
      008EFD A6 01            [ 1]  138 	ld	a, #0x01
      008EFF 6B 03            [ 1]  139 	ld	(0x03, sp), a
      008F01                        140 00505$:
                                    141 ;	./menu.c: 85: if (menuState == MENU_ROOT) {
      008F01 72 5D 00 29      [ 1]  142 	tnz	_menuState+0
      008F05 27 03            [ 1]  143 	jreq	00506$
      008F07 CC 90 82         [ 2]  144 	jp	00248$
      008F0A                        145 00506$:
                                    146 ;	./menu.c: 86: switch (event) {
      008F0A 0D 01            [ 1]  147 	tnz	(0x01, sp)
      008F0C 27 03            [ 1]  148 	jreq	00507$
      008F0E CC 90 6C         [ 2]  149 	jp	00147$
      008F11                        150 00507$:
      008F11 5F               [ 1]  151 	clrw	x
      008F12 7B 07            [ 1]  152 	ld	a, (0x07, sp)
      008F14 97               [ 1]  153 	ld	xl, a
      008F15 58               [ 2]  154 	sllw	x
      008F16 DE 8F 1A         [ 2]  155 	ldw	x, (#00508$, x)
      008F19 FC               [ 2]  156 	jp	(x)
      008F1A                        157 00508$:
      008F1A 8F 28                  158 	.dw	#00101$
      008F1C 8F 96                  159 	.dw	#00115$
      008F1E 8F B0                  160 	.dw	#00119$
      008F20 8F 6B                  161 	.dw	#00108$
      008F22 8F A9                  162 	.dw	#00118$
      008F24 8F C3                  163 	.dw	#00122$
      008F26 8F CA                  164 	.dw	#00123$
                                    165 ;	./menu.c: 87: case MENU_EVENT_PUSH_BUTTON1:
      008F28                        166 00101$:
                                    167 ;	./menu.c: 88: timer = 0;
      008F28 5F               [ 1]  168 	clrw	x
      008F29 CF 00 2A         [ 2]  169 	ldw	_timer+0, x
                                    170 ;	./menu.c: 89: if ((getParamById (PARAM_RELAY_MODE) == 2) || (getParamById (PARAM_RELAY_MODE) == 3)) {
      008F2C 4B 00            [ 1]  171 	push	#0x00
      008F2E CD 93 E4         [ 4]  172 	call	_getParamById
      008F31 84               [ 1]  173 	pop	a
      008F32 A3 00 02         [ 2]  174 	cpw	x, #0x0002
      008F35 27 0B            [ 1]  175 	jreq	00102$
      008F37 4B 00            [ 1]  176 	push	#0x00
      008F39 CD 93 E4         [ 4]  177 	call	_getParamById
      008F3C 84               [ 1]  178 	pop	a
      008F3D A3 00 03         [ 2]  179 	cpw	x, #0x0003
      008F40 26 06            [ 1]  180 	jrne	00103$
      008F42                        181 00102$:
                                    182 ;	./menu.c: 90: menuDisplay = MENU_ALARM;
      008F42 35 04 00 28      [ 1]  183 	mov	_menuDisplay+0, #0x04
      008F46 20 04            [ 2]  184 	jra	00104$
      008F48                        185 00103$:
                                    186 ;	./menu.c: 92: menuDisplay = MENU_SET_THRESHOLD;
      008F48 35 01 00 28      [ 1]  187 	mov	_menuDisplay+0, #0x01
      008F4C                        188 00104$:
                                    189 ;	./menu.c: 94: setDisplayOff (0);
      008F4C 4B 00            [ 1]  190 	push	#0x00
      008F4E CD 85 9D         [ 4]  191 	call	_setDisplayOff
      008F51 84               [ 1]  192 	pop	a
                                    193 ;	./menu.c: 96: if(getParamById (PARAM_AUTO_BRIGHT) ) {
      008F52 4B 08            [ 1]  194 	push	#0x08
      008F54 CD 93 E4         [ 4]  195 	call	_getParamById
      008F57 84               [ 1]  196 	pop	a
      008F58 5D               [ 2]  197 	tnzw	x
      008F59 26 03            [ 1]  198 	jrne	00515$
      008F5B CC 93 58         [ 2]  199 	jp	00250$
      008F5E                        200 00515$:
                                    201 ;	./menu.c: 97: lowBrightness = false;
      008F5E 72 5F 00 4A      [ 1]  202 	clr	_lowBrightness+0
                                    203 ;	./menu.c: 98: dimmerBrightness(lowBrightness);
      008F62 4B 00            [ 1]  204 	push	#0x00
      008F64 CD 84 8F         [ 4]  205 	call	_dimmerBrightness
      008F67 84               [ 1]  206 	pop	a
                                    207 ;	./menu.c: 101: break;
      008F68 CC 93 58         [ 2]  208 	jp	00250$
                                    209 ;	./menu.c: 103: case MENU_EVENT_RELEASE_BUTTON1:
      008F6B                        210 00108$:
                                    211 ;	./menu.c: 104: if (timer < MENU_5_SEC_PASSED) {
      008F6B 0D 02            [ 1]  212 	tnz	(0x02, sp)
      008F6D 27 20            [ 1]  213 	jreq	00114$
                                    214 ;	./menu.c: 105: if ((getParamById (PARAM_RELAY_MODE) == 2) || (getParamById (PARAM_RELAY_MODE) == 3)) {
      008F6F 4B 00            [ 1]  215 	push	#0x00
      008F71 CD 93 E4         [ 4]  216 	call	_getParamById
      008F74 84               [ 1]  217 	pop	a
      008F75 A3 00 02         [ 2]  218 	cpw	x, #0x0002
      008F78 27 0B            [ 1]  219 	jreq	00109$
      008F7A 4B 00            [ 1]  220 	push	#0x00
      008F7C CD 93 E4         [ 4]  221 	call	_getParamById
      008F7F 84               [ 1]  222 	pop	a
      008F80 A3 00 03         [ 2]  223 	cpw	x, #0x0003
      008F83 26 06            [ 1]  224 	jrne	00110$
      008F85                        225 00109$:
                                    226 ;	./menu.c: 106: menuState = MENU_ALARM;
      008F85 35 04 00 29      [ 1]  227 	mov	_menuState+0, #0x04
      008F89 20 04            [ 2]  228 	jra	00114$
      008F8B                        229 00110$:
                                    230 ;	./menu.c: 108: menuState = MENU_SET_THRESHOLD;
      008F8B 35 01 00 29      [ 1]  231 	mov	_menuState+0, #0x01
      008F8F                        232 00114$:
                                    233 ;	./menu.c: 112: timer = 0;
      008F8F 5F               [ 1]  234 	clrw	x
      008F90 CF 00 2A         [ 2]  235 	ldw	_timer+0, x
                                    236 ;	./menu.c: 113: break;
      008F93 CC 93 58         [ 2]  237 	jp	00250$
                                    238 ;	./menu.c: 115: case MENU_EVENT_PUSH_BUTTON2:
      008F96                        239 00115$:
                                    240 ;	./menu.c: 116: if(getParamById (PARAM_AUTO_BRIGHT) ) {
      008F96 4B 08            [ 1]  241 	push	#0x08
      008F98 CD 93 E4         [ 4]  242 	call	_getParamById
      008F9B 84               [ 1]  243 	pop	a
      008F9C 5D               [ 2]  244 	tnzw	x
      008F9D 27 0A            [ 1]  245 	jreq	00118$
                                    246 ;	./menu.c: 117: lowBrightness = false;
      008F9F 72 5F 00 4A      [ 1]  247 	clr	_lowBrightness+0
                                    248 ;	./menu.c: 118: dimmerBrightness(lowBrightness);
      008FA3 4B 00            [ 1]  249 	push	#0x00
      008FA5 CD 84 8F         [ 4]  250 	call	_dimmerBrightness
      008FA8 84               [ 1]  251 	pop	a
                                    252 ;	./menu.c: 120: case MENU_EVENT_RELEASE_BUTTON2:
      008FA9                        253 00118$:
                                    254 ;	./menu.c: 121: timer = 0;
      008FA9 5F               [ 1]  255 	clrw	x
      008FAA CF 00 2A         [ 2]  256 	ldw	_timer+0, x
                                    257 ;	./menu.c: 122: break;
      008FAD CC 93 58         [ 2]  258 	jp	00250$
                                    259 ;	./menu.c: 124: case MENU_EVENT_PUSH_BUTTON3:
      008FB0                        260 00119$:
                                    261 ;	./menu.c: 125: if(getParamById (PARAM_AUTO_BRIGHT) ) {
      008FB0 4B 08            [ 1]  262 	push	#0x08
      008FB2 CD 93 E4         [ 4]  263 	call	_getParamById
      008FB5 84               [ 1]  264 	pop	a
      008FB6 5D               [ 2]  265 	tnzw	x
      008FB7 27 0A            [ 1]  266 	jreq	00122$
                                    267 ;	./menu.c: 126: lowBrightness = false;
      008FB9 72 5F 00 4A      [ 1]  268 	clr	_lowBrightness+0
                                    269 ;	./menu.c: 127: dimmerBrightness(lowBrightness);
      008FBD 4B 00            [ 1]  270 	push	#0x00
      008FBF CD 84 8F         [ 4]  271 	call	_dimmerBrightness
      008FC2 84               [ 1]  272 	pop	a
                                    273 ;	./menu.c: 130: case MENU_EVENT_RELEASE_BUTTON3:
      008FC3                        274 00122$:
                                    275 ;	./menu.c: 131: timer = 0;
      008FC3 5F               [ 1]  276 	clrw	x
      008FC4 CF 00 2A         [ 2]  277 	ldw	_timer+0, x
                                    278 ;	./menu.c: 132: break;
      008FC7 CC 93 58         [ 2]  279 	jp	00250$
                                    280 ;	./menu.c: 134: case MENU_EVENT_CHECK_TIMER:
      008FCA                        281 00123$:
                                    282 ;	./menu.c: 135: if (getButton1() ) {
      008FCA CD 8B 9E         [ 4]  283 	call	_getButton1
      008FCD 4D               [ 1]  284 	tnz	a
      008FCE 27 20            [ 1]  285 	jreq	00127$
                                    286 ;	./menu.c: 136: if (timer > MENU_3_SEC_PASSED) {
      008FD0 CE 00 2A         [ 2]  287 	ldw	x, _timer+0
      008FD3 A3 00 60         [ 2]  288 	cpw	x, #0x0060
      008FD6 23 18            [ 2]  289 	jrule	00127$
                                    290 ;	./menu.c: 137: setParamId (0);
      008FD8 4B 00            [ 1]  291 	push	#0x00
      008FDA CD 94 B8         [ 4]  292 	call	_setParamId
      008FDD 84               [ 1]  293 	pop	a
                                    294 ;	./menu.c: 138: timer = 0;
      008FDE 5F               [ 1]  295 	clrw	x
      008FDF CF 00 2A         [ 2]  296 	ldw	_timer+0, x
                                    297 ;	./menu.c: 139: setDisplayOff (0);
      008FE2 4B 00            [ 1]  298 	push	#0x00
      008FE4 CD 85 9D         [ 4]  299 	call	_setDisplayOff
      008FE7 84               [ 1]  300 	pop	a
                                    301 ;	./menu.c: 140: menuState = menuDisplay = MENU_SELECT_PARAM;
      008FE8 35 02 00 28      [ 1]  302 	mov	_menuDisplay+0, #0x02
      008FEC 35 02 00 29      [ 1]  303 	mov	_menuState+0, #0x02
      008FF0                        304 00127$:
                                    305 ;	./menu.c: 144: if (timer > MENU_3_SEC_PASSED) {
      008FF0 CE 00 2A         [ 2]  306 	ldw	x, _timer+0
      008FF3 A3 00 60         [ 2]  307 	cpw	x, #0x0060
      008FF6 23 27            [ 2]  308 	jrule	00135$
                                    309 ;	./menu.c: 145: if (menuDisplay == MENU_EEPROM_LOCKED) {
      008FF8 C6 00 28         [ 1]  310 	ld	a, _menuDisplay+0
      008FFB A1 08            [ 1]  311 	cp	a, #0x08
      008FFD 26 0A            [ 1]  312 	jrne	00132$
                                    313 ;	./menu.c: 146: menuDisplay = MENU_EEPROM_LOC_2;
      008FFF 35 09 00 28      [ 1]  314 	mov	_menuDisplay+0, #0x09
                                    315 ;	./menu.c: 147: timer = 0;
      009003 5F               [ 1]  316 	clrw	x
      009004 CF 00 2A         [ 2]  317 	ldw	_timer+0, x
      009007 20 16            [ 2]  318 	jra	00135$
      009009                        319 00132$:
                                    320 ;	./menu.c: 148: } else if ((menuDisplay == MENU_EEPROM_LOC_2) || (menuDisplay == MENU_EEPROM_RESET)) {
      009009 C6 00 28         [ 1]  321 	ld	a, _menuDisplay+0
      00900C A1 09            [ 1]  322 	cp	a, #0x09
      00900E 27 07            [ 1]  323 	jreq	00128$
      009010 C6 00 28         [ 1]  324 	ld	a, _menuDisplay+0
      009013 A1 07            [ 1]  325 	cp	a, #0x07
      009015 26 08            [ 1]  326 	jrne	00135$
      009017                        327 00128$:
                                    328 ;	./menu.c: 149: menuDisplay = MENU_ROOT;
      009017 72 5F 00 28      [ 1]  329 	clr	_menuDisplay+0
                                    330 ;	./menu.c: 150: timer = 0;
      00901B 5F               [ 1]  331 	clrw	x
      00901C CF 00 2A         [ 2]  332 	ldw	_timer+0, x
      00901F                        333 00135$:
                                    334 ;	./menu.c: 154: if(timer > MENU_15_SEC_PASSED) {
      00901F CE 00 2A         [ 2]  335 	ldw	x, _timer+0
      009022 A3 01 E0         [ 2]  336 	cpw	x, #0x01e0
      009025 23 21            [ 2]  337 	jrule	00142$
                                    338 ;	./menu.c: 155: if(getParamById (PARAM_AUTO_BRIGHT) ) {
      009027 4B 08            [ 1]  339 	push	#0x08
      009029 CD 93 E4         [ 4]  340 	call	_getParamById
      00902C 84               [ 1]  341 	pop	a
      00902D 5D               [ 2]  342 	tnzw	x
      00902E 27 18            [ 1]  343 	jreq	00142$
                                    344 ;	./menu.c: 156: if ((autoBrightness) && (!lowBrightness)) {
      009030 72 00 00 49 02   [ 2]  345 	btjt	_autoBrightness+0, #0, 00539$
      009035 20 11            [ 2]  346 	jra	00142$
      009037                        347 00539$:
      009037 72 01 00 4A 02   [ 2]  348 	btjf	_lowBrightness+0, #0, 00540$
      00903C 20 0A            [ 2]  349 	jra	00142$
      00903E                        350 00540$:
                                    351 ;	./menu.c: 157: lowBrightness = true;
      00903E 35 01 00 4A      [ 1]  352 	mov	_lowBrightness+0, #0x01
                                    353 ;	./menu.c: 158: dimmerBrightness(lowBrightness);
      009042 4B 01            [ 1]  354 	push	#0x01
      009044 CD 84 8F         [ 4]  355 	call	_dimmerBrightness
      009047 84               [ 1]  356 	pop	a
      009048                        357 00142$:
                                    358 ;	./menu.c: 163: if(lowBrightness) {
      009048 72 00 00 4A 03   [ 2]  359 	btjt	_lowBrightness+0, #0, 00541$
      00904D CC 93 58         [ 2]  360 	jp	00250$
      009050                        361 00541$:
                                    362 ;	./menu.c: 164: if(getSensorFail() > 0) {
      009050 CD 8E 78         [ 4]  363 	call	_getSensorFail
      009053 A3 00 00         [ 2]  364 	cpw	x, #0x0000
      009056 2C 03            [ 1]  365 	jrsgt	00542$
      009058 CC 93 58         [ 2]  366 	jp	00250$
      00905B                        367 00542$:
                                    368 ;	./menu.c: 165: lowBrightness = false;
      00905B 72 5F 00 4A      [ 1]  369 	clr	_lowBrightness+0
                                    370 ;	./menu.c: 166: dimmerBrightness(lowBrightness);
      00905F 4B 00            [ 1]  371 	push	#0x00
      009061 CD 84 8F         [ 4]  372 	call	_dimmerBrightness
      009064 84               [ 1]  373 	pop	a
                                    374 ;	./menu.c: 167: timer = 0;
      009065 5F               [ 1]  375 	clrw	x
      009066 CF 00 2A         [ 2]  376 	ldw	_timer+0, x
                                    377 ;	./menu.c: 171: break;
      009069 CC 93 58         [ 2]  378 	jp	00250$
                                    379 ;	./menu.c: 173: default:
      00906C                        380 00147$:
                                    381 ;	./menu.c: 174: if (timer > MENU_5_SEC_PASSED) {
      00906C 0D 03            [ 1]  382 	tnz	(0x03, sp)
      00906E 26 03            [ 1]  383 	jrne	00543$
      009070 CC 93 58         [ 2]  384 	jp	00250$
      009073                        385 00543$:
                                    386 ;	./menu.c: 175: menuState = menuDisplay = MENU_ROOT;
      009073 72 5F 00 28      [ 1]  387 	clr	_menuDisplay+0
      009077 72 5F 00 29      [ 1]  388 	clr	_menuState+0
                                    389 ;	./menu.c: 176: timer = 0;
      00907B 5F               [ 1]  390 	clrw	x
      00907C CF 00 2A         [ 2]  391 	ldw	_timer+0, x
                                    392 ;	./menu.c: 180: }
      00907F CC 93 58         [ 2]  393 	jp	00250$
      009082                        394 00248$:
                                    395 ;	./menu.c: 205: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
      009082 CE 00 2A         [ 2]  396 	ldw	x, _timer+0
      009085 A3 00 24         [ 2]  397 	cpw	x, #0x0024
      009088 22 04            [ 1]  398 	jrugt	00544$
      00908A 0F 04            [ 1]  399 	clr	(0x04, sp)
      00908C 20 04            [ 2]  400 	jra	00545$
      00908E                        401 00544$:
      00908E A6 01            [ 1]  402 	ld	a, #0x01
      009090 6B 04            [ 1]  403 	ld	(0x04, sp), a
      009092                        404 00545$:
                                    405 ;	./menu.c: 181: } else if (menuState == MENU_SELECT_PARAM) {
      009092 C6 00 29         [ 1]  406 	ld	a, _menuState+0
      009095 A1 02            [ 1]  407 	cp	a, #0x02
      009097 27 03            [ 1]  408 	jreq	00548$
      009099 CC 91 24         [ 2]  409 	jp	00245$
      00909C                        410 00548$:
                                    411 ;	./menu.c: 182: switch (event) {
      00909C 0D 01            [ 1]  412 	tnz	(0x01, sp)
      00909E 27 03            [ 1]  413 	jreq	00549$
      0090A0 CC 93 58         [ 2]  414 	jp	00250$
      0090A3                        415 00549$:
      0090A3 5F               [ 1]  416 	clrw	x
      0090A4 7B 07            [ 1]  417 	ld	a, (0x07, sp)
      0090A6 97               [ 1]  418 	ld	xl, a
      0090A7 58               [ 2]  419 	sllw	x
      0090A8 DE 90 AC         [ 2]  420 	ldw	x, (#00550$, x)
      0090AB FC               [ 2]  421 	jp	(x)
      0090AC                        422 00550$:
      0090AC 90 BA                  423 	.dw	#00151$
      0090AE 90 C9                  424 	.dw	#00153$
      0090B0 90 D3                  425 	.dw	#00155$
      0090B2 90 C2                  426 	.dw	#00152$
      0090B4 90 CC                  427 	.dw	#00154$
      0090B6 90 D6                  428 	.dw	#00156$
      0090B8 90 DD                  429 	.dw	#00157$
                                    430 ;	./menu.c: 183: case MENU_EVENT_PUSH_BUTTON1:
      0090BA                        431 00151$:
                                    432 ;	./menu.c: 184: menuState = menuDisplay = MENU_CHANGE_PARAM;
      0090BA 35 03 00 28      [ 1]  433 	mov	_menuDisplay+0, #0x03
      0090BE 35 03 00 29      [ 1]  434 	mov	_menuState+0, #0x03
                                    435 ;	./menu.c: 186: case MENU_EVENT_RELEASE_BUTTON1:
      0090C2                        436 00152$:
                                    437 ;	./menu.c: 187: timer = 0;
      0090C2 5F               [ 1]  438 	clrw	x
      0090C3 CF 00 2A         [ 2]  439 	ldw	_timer+0, x
                                    440 ;	./menu.c: 188: break;
      0090C6 CC 93 58         [ 2]  441 	jp	00250$
                                    442 ;	./menu.c: 190: case MENU_EVENT_PUSH_BUTTON2:
      0090C9                        443 00153$:
                                    444 ;	./menu.c: 191: incParamId();
      0090C9 CD 94 C5         [ 4]  445 	call	_incParamId
                                    446 ;	./menu.c: 193: case MENU_EVENT_RELEASE_BUTTON2:
      0090CC                        447 00154$:
                                    448 ;	./menu.c: 194: timer = 0;
      0090CC 5F               [ 1]  449 	clrw	x
      0090CD CF 00 2A         [ 2]  450 	ldw	_timer+0, x
                                    451 ;	./menu.c: 195: break;
      0090D0 CC 93 58         [ 2]  452 	jp	00250$
                                    453 ;	./menu.c: 197: case MENU_EVENT_PUSH_BUTTON3:
      0090D3                        454 00155$:
                                    455 ;	./menu.c: 198: decParamId();
      0090D3 CD 94 D6         [ 4]  456 	call	_decParamId
                                    457 ;	./menu.c: 200: case MENU_EVENT_RELEASE_BUTTON3:
      0090D6                        458 00156$:
                                    459 ;	./menu.c: 201: timer = 0;
      0090D6 5F               [ 1]  460 	clrw	x
      0090D7 CF 00 2A         [ 2]  461 	ldw	_timer+0, x
                                    462 ;	./menu.c: 202: break;
      0090DA CC 93 58         [ 2]  463 	jp	00250$
                                    464 ;	./menu.c: 204: case MENU_EVENT_CHECK_TIMER:
      0090DD                        465 00157$:
                                    466 ;	./menu.c: 205: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
      0090DD 0D 04            [ 1]  467 	tnz	(0x04, sp)
      0090DF 27 20            [ 1]  468 	jreq	00164$
                                    469 ;	./menu.c: 206: if (getButton2() ) {
      0090E1 CD 8B A6         [ 4]  470 	call	_getButton2
      0090E4 4D               [ 1]  471 	tnz	a
      0090E5 27 0B            [ 1]  472 	jreq	00161$
                                    473 ;	./menu.c: 207: incParamId();
      0090E7 CD 94 C5         [ 4]  474 	call	_incParamId
                                    475 ;	./menu.c: 208: timer = MENU_1_SEC_PASSED;
      0090EA AE 00 20         [ 2]  476 	ldw	x, #0x0020
      0090ED CF 00 2A         [ 2]  477 	ldw	_timer+0, x
      0090F0 20 0F            [ 2]  478 	jra	00164$
      0090F2                        479 00161$:
                                    480 ;	./menu.c: 209: } else if (getButton3() ) {
      0090F2 CD 8B B0         [ 4]  481 	call	_getButton3
      0090F5 4D               [ 1]  482 	tnz	a
      0090F6 27 09            [ 1]  483 	jreq	00164$
                                    484 ;	./menu.c: 210: decParamId();
      0090F8 CD 94 D6         [ 4]  485 	call	_decParamId
                                    486 ;	./menu.c: 211: timer = MENU_1_SEC_PASSED;
      0090FB AE 00 20         [ 2]  487 	ldw	x, #0x0020
      0090FE CF 00 2A         [ 2]  488 	ldw	_timer+0, x
      009101                        489 00164$:
                                    490 ;	./menu.c: 215: if (timer > MENU_5_SEC_PASSED) {
      009101 CE 00 2A         [ 2]  491 	ldw	x, _timer+0
      009104 A3 00 A0         [ 2]  492 	cpw	x, #0x00a0
      009107 22 03            [ 1]  493 	jrugt	00554$
      009109 CC 93 58         [ 2]  494 	jp	00250$
      00910C                        495 00554$:
                                    496 ;	./menu.c: 216: timer = 0;
      00910C 5F               [ 1]  497 	clrw	x
      00910D CF 00 2A         [ 2]  498 	ldw	_timer+0, x
                                    499 ;	./menu.c: 217: setParamId (0);
      009110 4B 00            [ 1]  500 	push	#0x00
      009112 CD 94 B8         [ 4]  501 	call	_setParamId
      009115 84               [ 1]  502 	pop	a
                                    503 ;	./menu.c: 218: storeParams();
      009116 CD 96 3F         [ 4]  504 	call	_storeParams
                                    505 ;	./menu.c: 219: menuState = menuDisplay = MENU_ROOT;
      009119 72 5F 00 28      [ 1]  506 	clr	_menuDisplay+0
      00911D 72 5F 00 29      [ 1]  507 	clr	_menuState+0
                                    508 ;	./menu.c: 222: break;
      009121 CC 93 58         [ 2]  509 	jp	00250$
                                    510 ;	./menu.c: 226: }
      009124                        511 00245$:
                                    512 ;	./menu.c: 227: } else if (menuState == MENU_CHANGE_PARAM) {
      009124 C6 00 29         [ 1]  513 	ld	a, _menuState+0
      009127 A1 03            [ 1]  514 	cp	a, #0x03
      009129 27 03            [ 1]  515 	jreq	00557$
      00912B CC 91 CD         [ 2]  516 	jp	00242$
      00912E                        517 00557$:
                                    518 ;	./menu.c: 228: switch (event) {
      00912E 0D 01            [ 1]  519 	tnz	(0x01, sp)
      009130 27 03            [ 1]  520 	jreq	00558$
      009132 CC 93 58         [ 2]  521 	jp	00250$
      009135                        522 00558$:
      009135 5F               [ 1]  523 	clrw	x
      009136 7B 07            [ 1]  524 	ld	a, (0x07, sp)
      009138 97               [ 1]  525 	ld	xl, a
      009139 58               [ 2]  526 	sllw	x
      00913A DE 91 3E         [ 2]  527 	ldw	x, (#00559$, x)
      00913D FC               [ 2]  528 	jp	(x)
      00913E                        529 00559$:
      00913E 91 4C                  530 	.dw	#00169$
      009140 91 5B                  531 	.dw	#00171$
      009142 91 65                  532 	.dw	#00173$
      009144 91 54                  533 	.dw	#00170$
      009146 91 5E                  534 	.dw	#00172$
      009148 91 68                  535 	.dw	#00174$
      00914A 91 6F                  536 	.dw	#00175$
                                    537 ;	./menu.c: 229: case MENU_EVENT_PUSH_BUTTON1:
      00914C                        538 00169$:
                                    539 ;	./menu.c: 230: menuState = menuDisplay = MENU_SELECT_PARAM;
      00914C 35 02 00 28      [ 1]  540 	mov	_menuDisplay+0, #0x02
      009150 35 02 00 29      [ 1]  541 	mov	_menuState+0, #0x02
                                    542 ;	./menu.c: 232: case MENU_EVENT_RELEASE_BUTTON1:
      009154                        543 00170$:
                                    544 ;	./menu.c: 233: timer = 0;
      009154 5F               [ 1]  545 	clrw	x
      009155 CF 00 2A         [ 2]  546 	ldw	_timer+0, x
                                    547 ;	./menu.c: 234: break;
      009158 CC 93 58         [ 2]  548 	jp	00250$
                                    549 ;	./menu.c: 236: case MENU_EVENT_PUSH_BUTTON2:
      00915B                        550 00171$:
                                    551 ;	./menu.c: 237: incParam();
      00915B CD 94 20         [ 4]  552 	call	_incParam
                                    553 ;	./menu.c: 239: case MENU_EVENT_RELEASE_BUTTON2:
      00915E                        554 00172$:
                                    555 ;	./menu.c: 240: timer = 0;
      00915E 5F               [ 1]  556 	clrw	x
      00915F CF 00 2A         [ 2]  557 	ldw	_timer+0, x
                                    558 ;	./menu.c: 241: break;
      009162 CC 93 58         [ 2]  559 	jp	00250$
                                    560 ;	./menu.c: 243: case MENU_EVENT_PUSH_BUTTON3:
      009165                        561 00173$:
                                    562 ;	./menu.c: 244: decParam();
      009165 CD 94 6A         [ 4]  563 	call	_decParam
                                    564 ;	./menu.c: 246: case MENU_EVENT_RELEASE_BUTTON3:
      009168                        565 00174$:
                                    566 ;	./menu.c: 247: timer = 0;
      009168 5F               [ 1]  567 	clrw	x
      009169 CF 00 2A         [ 2]  568 	ldw	_timer+0, x
                                    569 ;	./menu.c: 248: break;
      00916C CC 93 58         [ 2]  570 	jp	00250$
                                    571 ;	./menu.c: 250: case MENU_EVENT_CHECK_TIMER:
      00916F                        572 00175$:
                                    573 ;	./menu.c: 251: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
      00916F 0D 04            [ 1]  574 	tnz	(0x04, sp)
      009171 27 20            [ 1]  575 	jreq	00182$
                                    576 ;	./menu.c: 252: if (getButton2() ) {
      009173 CD 8B A6         [ 4]  577 	call	_getButton2
      009176 4D               [ 1]  578 	tnz	a
      009177 27 0B            [ 1]  579 	jreq	00179$
                                    580 ;	./menu.c: 253: incParam();
      009179 CD 94 20         [ 4]  581 	call	_incParam
                                    582 ;	./menu.c: 254: timer = MENU_1_SEC_PASSED;
      00917C AE 00 20         [ 2]  583 	ldw	x, #0x0020
      00917F CF 00 2A         [ 2]  584 	ldw	_timer+0, x
      009182 20 0F            [ 2]  585 	jra	00182$
      009184                        586 00179$:
                                    587 ;	./menu.c: 255: } else if (getButton3() ) {
      009184 CD 8B B0         [ 4]  588 	call	_getButton3
      009187 4D               [ 1]  589 	tnz	a
      009188 27 09            [ 1]  590 	jreq	00182$
                                    591 ;	./menu.c: 256: decParam();
      00918A CD 94 6A         [ 4]  592 	call	_decParam
                                    593 ;	./menu.c: 257: timer = MENU_1_SEC_PASSED;
      00918D AE 00 20         [ 2]  594 	ldw	x, #0x0020
      009190 CF 00 2A         [ 2]  595 	ldw	_timer+0, x
      009193                        596 00182$:
                                    597 ;	./menu.c: 261: if (getButton1() && timer > MENU_3_SEC_PASSED) {
      009193 CD 8B 9E         [ 4]  598 	call	_getButton1
      009196 4D               [ 1]  599 	tnz	a
      009197 27 17            [ 1]  600 	jreq	00184$
      009199 CE 00 2A         [ 2]  601 	ldw	x, _timer+0
      00919C A3 00 60         [ 2]  602 	cpw	x, #0x0060
      00919F 23 0F            [ 2]  603 	jrule	00184$
                                    604 ;	./menu.c: 262: timer = 0;
      0091A1 5F               [ 1]  605 	clrw	x
      0091A2 CF 00 2A         [ 2]  606 	ldw	_timer+0, x
                                    607 ;	./menu.c: 263: menuState = menuDisplay = MENU_SELECT_PARAM;
      0091A5 35 02 00 28      [ 1]  608 	mov	_menuDisplay+0, #0x02
      0091A9 35 02 00 29      [ 1]  609 	mov	_menuState+0, #0x02
                                    610 ;	./menu.c: 264: break;
      0091AD CC 93 58         [ 2]  611 	jp	00250$
      0091B0                        612 00184$:
                                    613 ;	./menu.c: 267: if (timer > MENU_5_SEC_PASSED) {
      0091B0 CE 00 2A         [ 2]  614 	ldw	x, _timer+0
      0091B3 A3 00 A0         [ 2]  615 	cpw	x, #0x00a0
      0091B6 22 03            [ 1]  616 	jrugt	00565$
      0091B8 CC 93 58         [ 2]  617 	jp	00250$
      0091BB                        618 00565$:
                                    619 ;	./menu.c: 268: timer = 0;
      0091BB 5F               [ 1]  620 	clrw	x
      0091BC CF 00 2A         [ 2]  621 	ldw	_timer+0, x
                                    622 ;	./menu.c: 269: storeParams();
      0091BF CD 96 3F         [ 4]  623 	call	_storeParams
                                    624 ;	./menu.c: 270: menuState = menuDisplay = MENU_ROOT;
      0091C2 72 5F 00 28      [ 1]  625 	clr	_menuDisplay+0
      0091C6 72 5F 00 29      [ 1]  626 	clr	_menuState+0
                                    627 ;	./menu.c: 273: break;
      0091CA CC 93 58         [ 2]  628 	jp	00250$
                                    629 ;	./menu.c: 277: }
      0091CD                        630 00242$:
                                    631 ;	./menu.c: 278: } else if (menuState == MENU_SET_THRESHOLD) {
      0091CD C6 00 29         [ 1]  632 	ld	a, _menuState+0
      0091D0 4A               [ 1]  633 	dec	a
      0091D1 27 03            [ 1]  634 	jreq	00568$
      0091D3 CC 92 E2         [ 2]  635 	jp	00239$
      0091D6                        636 00568$:
                                    637 ;	./menu.c: 279: switch (event) {
      0091D6 0D 01            [ 1]  638 	tnz	(0x01, sp)
      0091D8 27 03            [ 1]  639 	jreq	00569$
      0091DA CC 93 58         [ 2]  640 	jp	00250$
      0091DD                        641 00569$:
      0091DD 5F               [ 1]  642 	clrw	x
      0091DE 7B 07            [ 1]  643 	ld	a, (0x07, sp)
      0091E0 97               [ 1]  644 	ld	xl, a
      0091E1 58               [ 2]  645 	sllw	x
      0091E2 DE 91 E6         [ 2]  646 	ldw	x, (#00570$, x)
      0091E5 FC               [ 2]  647 	jp	(x)
      0091E6                        648 00570$:
      0091E6 91 F4                  649 	.dw	#00190$
      0091E8 92 1D                  650 	.dw	#00194$
      0091EA 92 3C                  651 	.dw	#00199$
      0091EC 92 05                  652 	.dw	#00191$
      0091EE 92 35                  653 	.dw	#00198$
      0091F0 92 54                  654 	.dw	#00203$
      0091F2 92 5B                  655 	.dw	#00204$
                                    656 ;	./menu.c: 280: case MENU_EVENT_PUSH_BUTTON1:
      0091F4                        657 00190$:
                                    658 ;	./menu.c: 281: timer = 0;
      0091F4 5F               [ 1]  659 	clrw	x
      0091F5 CF 00 2A         [ 2]  660 	ldw	_timer+0, x
                                    661 ;	./menu.c: 282: menuDisplay = MENU_ROOT;
      0091F8 72 5F 00 28      [ 1]  662 	clr	_menuDisplay+0
                                    663 ;	./menu.c: 283: setDisplayOff (false);
      0091FC 4B 00            [ 1]  664 	push	#0x00
      0091FE CD 85 9D         [ 4]  665 	call	_setDisplayOff
      009201 84               [ 1]  666 	pop	a
                                    667 ;	./menu.c: 284: break;
      009202 CC 93 58         [ 2]  668 	jp	00250$
                                    669 ;	./menu.c: 286: case MENU_EVENT_RELEASE_BUTTON1:
      009205                        670 00191$:
                                    671 ;	./menu.c: 287: if (timer < MENU_5_SEC_PASSED) {
      009205 0D 02            [ 1]  672 	tnz	(0x02, sp)
      009207 27 0D            [ 1]  673 	jreq	00193$
                                    674 ;	./menu.c: 288: storeParams();
      009209 CD 96 3F         [ 4]  675 	call	_storeParams
                                    676 ;	./menu.c: 289: menuState = MENU_ROOT;
      00920C 72 5F 00 29      [ 1]  677 	clr	_menuState+0
                                    678 ;	./menu.c: 290: setDisplayOff (false);
      009210 4B 00            [ 1]  679 	push	#0x00
      009212 CD 85 9D         [ 4]  680 	call	_setDisplayOff
      009215 84               [ 1]  681 	pop	a
      009216                        682 00193$:
                                    683 ;	./menu.c: 293: timer = 0;
      009216 5F               [ 1]  684 	clrw	x
      009217 CF 00 2A         [ 2]  685 	ldw	_timer+0, x
                                    686 ;	./menu.c: 294: break;
      00921A CC 93 58         [ 2]  687 	jp	00250$
                                    688 ;	./menu.c: 296: case MENU_EVENT_PUSH_BUTTON2:
      00921D                        689 00194$:
                                    690 ;	./menu.c: 297: setParamId (PARAM_THRESHOLD);
      00921D 4B 09            [ 1]  691 	push	#0x09
      00921F CD 94 B8         [ 4]  692 	call	_setParamId
      009222 84               [ 1]  693 	pop	a
                                    694 ;	./menu.c: 298: if (!getParamById (PARAM_LOCK_BUTTONS) ) {
      009223 4B 07            [ 1]  695 	push	#0x07
      009225 CD 93 E4         [ 4]  696 	call	_getParamById
      009228 84               [ 1]  697 	pop	a
      009229 5D               [ 2]  698 	tnzw	x
      00922A 26 05            [ 1]  699 	jrne	00196$
                                    700 ;	./menu.c: 299: incParam();
      00922C CD 94 20         [ 4]  701 	call	_incParam
      00922F 20 04            [ 2]  702 	jra	00198$
      009231                        703 00196$:
                                    704 ;	./menu.c: 301: menuDisplay = MENU_EEPROM_LOC_2;
      009231 35 09 00 28      [ 1]  705 	mov	_menuDisplay+0, #0x09
                                    706 ;	./menu.c: 304: case MENU_EVENT_RELEASE_BUTTON2:
      009235                        707 00198$:
                                    708 ;	./menu.c: 305: timer = 0;
      009235 5F               [ 1]  709 	clrw	x
      009236 CF 00 2A         [ 2]  710 	ldw	_timer+0, x
                                    711 ;	./menu.c: 306: break;
      009239 CC 93 58         [ 2]  712 	jp	00250$
                                    713 ;	./menu.c: 308: case MENU_EVENT_PUSH_BUTTON3:
      00923C                        714 00199$:
                                    715 ;	./menu.c: 309: setParamId (PARAM_THRESHOLD);
      00923C 4B 09            [ 1]  716 	push	#0x09
      00923E CD 94 B8         [ 4]  717 	call	_setParamId
      009241 84               [ 1]  718 	pop	a
                                    719 ;	./menu.c: 310: if (!getParamById (PARAM_LOCK_BUTTONS) ) {
      009242 4B 07            [ 1]  720 	push	#0x07
      009244 CD 93 E4         [ 4]  721 	call	_getParamById
      009247 84               [ 1]  722 	pop	a
      009248 5D               [ 2]  723 	tnzw	x
      009249 26 05            [ 1]  724 	jrne	00201$
                                    725 ;	./menu.c: 311: decParam();
      00924B CD 94 6A         [ 4]  726 	call	_decParam
      00924E 20 04            [ 2]  727 	jra	00203$
      009250                        728 00201$:
                                    729 ;	./menu.c: 313: menuDisplay = MENU_EEPROM_LOC_2;
      009250 35 09 00 28      [ 1]  730 	mov	_menuDisplay+0, #0x09
                                    731 ;	./menu.c: 316: case MENU_EVENT_RELEASE_BUTTON3:
      009254                        732 00203$:
                                    733 ;	./menu.c: 317: timer = 0;
      009254 5F               [ 1]  734 	clrw	x
      009255 CF 00 2A         [ 2]  735 	ldw	_timer+0, x
                                    736 ;	./menu.c: 318: break;
      009258 CC 93 58         [ 2]  737 	jp	00250$
                                    738 ;	./menu.c: 320: case MENU_EVENT_CHECK_TIMER:
      00925B                        739 00204$:
                                    740 ;	./menu.c: 321: if (getButton2() || getButton3() ) {
      00925B CD 8B A6         [ 4]  741 	call	_getButton2
      00925E 4D               [ 1]  742 	tnz	a
      00925F 26 06            [ 1]  743 	jrne	00205$
      009261 CD 8B B0         [ 4]  744 	call	_getButton3
      009264 4D               [ 1]  745 	tnz	a
      009265 27 04            [ 1]  746 	jreq	00206$
      009267                        747 00205$:
                                    748 ;	./menu.c: 322: blink = false;
      009267 0F 04            [ 1]  749 	clr	(0x04, sp)
      009269 20 09            [ 2]  750 	jra	00207$
      00926B                        751 00206$:
                                    752 ;	./menu.c: 324: blink = (bool) ( (unsigned char) getUptimeTicks() & 0x80);
      00926B CD 8A 10         [ 4]  753 	call	_getUptimeTicks
      00926E 9F               [ 1]  754 	ld	a, xl
      00926F 48               [ 1]  755 	sll	a
      009270 4F               [ 1]  756 	clr	a
      009271 49               [ 1]  757 	rlc	a
      009272 6B 04            [ 1]  758 	ld	(0x04, sp), a
      009274                        759 00207$:
                                    760 ;	./menu.c: 327: if (timer > MENU_1_SEC_PASSED + MENU_AUTOINC_DELAY) {
      009274 CE 00 2A         [ 2]  761 	ldw	x, _timer+0
      009277 A3 00 24         [ 2]  762 	cpw	x, #0x0024
      00927A 23 26            [ 2]  763 	jrule	00215$
                                    764 ;	./menu.c: 328: setParamId (PARAM_THRESHOLD);
      00927C 4B 09            [ 1]  765 	push	#0x09
      00927E CD 94 B8         [ 4]  766 	call	_setParamId
      009281 84               [ 1]  767 	pop	a
                                    768 ;	./menu.c: 330: if (getButton2() ) {
      009282 CD 8B A6         [ 4]  769 	call	_getButton2
      009285 4D               [ 1]  770 	tnz	a
      009286 27 0B            [ 1]  771 	jreq	00212$
                                    772 ;	./menu.c: 331: incParam();
      009288 CD 94 20         [ 4]  773 	call	_incParam
                                    774 ;	./menu.c: 332: timer = MENU_1_SEC_PASSED;
      00928B AE 00 20         [ 2]  775 	ldw	x, #0x0020
      00928E CF 00 2A         [ 2]  776 	ldw	_timer+0, x
      009291 20 0F            [ 2]  777 	jra	00215$
      009293                        778 00212$:
                                    779 ;	./menu.c: 333: } else if (getButton3() ) {
      009293 CD 8B B0         [ 4]  780 	call	_getButton3
      009296 4D               [ 1]  781 	tnz	a
      009297 27 09            [ 1]  782 	jreq	00215$
                                    783 ;	./menu.c: 334: decParam();
      009299 CD 94 6A         [ 4]  784 	call	_decParam
                                    785 ;	./menu.c: 335: timer = MENU_1_SEC_PASSED;
      00929C AE 00 20         [ 2]  786 	ldw	x, #0x0020
      00929F CF 00 2A         [ 2]  787 	ldw	_timer+0, x
      0092A2                        788 00215$:
                                    789 ;	./menu.c: 339: setDisplayOff (blink);
      0092A2 7B 04            [ 1]  790 	ld	a, (0x04, sp)
      0092A4 88               [ 1]  791 	push	a
      0092A5 CD 85 9D         [ 4]  792 	call	_setDisplayOff
      0092A8 84               [ 1]  793 	pop	a
                                    794 ;	./menu.c: 341: if (timer > MENU_5_SEC_PASSED) {
      0092A9 CE 00 2A         [ 2]  795 	ldw	x, _timer+0
      0092AC A3 00 A0         [ 2]  796 	cpw	x, #0x00a0
      0092AF 22 03            [ 1]  797 	jrugt	00579$
      0092B1 CC 93 58         [ 2]  798 	jp	00250$
      0092B4                        799 00579$:
                                    800 ;	./menu.c: 342: timer = 0;
      0092B4 5F               [ 1]  801 	clrw	x
      0092B5 CF 00 2A         [ 2]  802 	ldw	_timer+0, x
                                    803 ;	./menu.c: 344: if (getButton1() ) {
      0092B8 CD 8B 9E         [ 4]  804 	call	_getButton1
      0092BB 4D               [ 1]  805 	tnz	a
      0092BC 27 11            [ 1]  806 	jreq	00217$
                                    807 ;	./menu.c: 345: menuState = menuDisplay = MENU_SELECT_PARAM;
      0092BE 35 02 00 28      [ 1]  808 	mov	_menuDisplay+0, #0x02
      0092C2 35 02 00 29      [ 1]  809 	mov	_menuState+0, #0x02
                                    810 ;	./menu.c: 346: setDisplayOff (false);
      0092C6 4B 00            [ 1]  811 	push	#0x00
      0092C8 CD 85 9D         [ 4]  812 	call	_setDisplayOff
      0092CB 84               [ 1]  813 	pop	a
                                    814 ;	./menu.c: 347: break;
      0092CC CC 93 58         [ 2]  815 	jp	00250$
      0092CF                        816 00217$:
                                    817 ;	./menu.c: 350: storeParams();
      0092CF CD 96 3F         [ 4]  818 	call	_storeParams
                                    819 ;	./menu.c: 351: menuState = menuDisplay = MENU_ROOT;
      0092D2 72 5F 00 28      [ 1]  820 	clr	_menuDisplay+0
      0092D6 72 5F 00 29      [ 1]  821 	clr	_menuState+0
                                    822 ;	./menu.c: 352: setDisplayOff (false);
      0092DA 4B 00            [ 1]  823 	push	#0x00
      0092DC CD 85 9D         [ 4]  824 	call	_setDisplayOff
      0092DF 84               [ 1]  825 	pop	a
                                    826 ;	./menu.c: 355: break;
      0092E0 20 76            [ 2]  827 	jra	00250$
                                    828 ;	./menu.c: 359: }
      0092E2                        829 00239$:
                                    830 ;	./menu.c: 360: } else if (menuState == MENU_ALARM) {
      0092E2 C6 00 29         [ 1]  831 	ld	a, _menuState+0
      0092E5 A1 04            [ 1]  832 	cp	a, #0x04
      0092E7 26 6F            [ 1]  833 	jrne	00250$
                                    834 ;	./menu.c: 361: switch (event) {
      0092E9 7B 07            [ 1]  835 	ld	a, (0x07, sp)
      0092EB A1 05            [ 1]  836 	cp	a, #0x05
      0092ED 22 4D            [ 1]  837 	jrugt	00230$
      0092EF 5F               [ 1]  838 	clrw	x
      0092F0 7B 07            [ 1]  839 	ld	a, (0x07, sp)
      0092F2 97               [ 1]  840 	ld	xl, a
      0092F3 58               [ 2]  841 	sllw	x
      0092F4 DE 92 F8         [ 2]  842 	ldw	x, (#00585$, x)
      0092F7 FC               [ 2]  843 	jp	(x)
      0092F8                        844 00585$:
      0092F8 93 04                  845 	.dw	#00222$
      0092FA 93 28                  846 	.dw	#00226$
      0092FC 93 32                  847 	.dw	#00228$
      0092FE 93 14                  848 	.dw	#00223$
      009300 93 2C                  849 	.dw	#00227$
      009302 93 36                  850 	.dw	#00229$
                                    851 ;	./menu.c: 362: case MENU_EVENT_PUSH_BUTTON1:
      009304                        852 00222$:
                                    853 ;	./menu.c: 363: timer = 0;
      009304 5F               [ 1]  854 	clrw	x
      009305 CF 00 2A         [ 2]  855 	ldw	_timer+0, x
                                    856 ;	./menu.c: 364: menuDisplay = MENU_ROOT;
      009308 72 5F 00 28      [ 1]  857 	clr	_menuDisplay+0
                                    858 ;	./menu.c: 365: setDisplayOff (false);
      00930C 4B 00            [ 1]  859 	push	#0x00
      00930E CD 85 9D         [ 4]  860 	call	_setDisplayOff
      009311 84               [ 1]  861 	pop	a
                                    862 ;	./menu.c: 366: break;
      009312 20 44            [ 2]  863 	jra	00250$
                                    864 ;	./menu.c: 368: case MENU_EVENT_RELEASE_BUTTON1:
      009314                        865 00223$:
                                    866 ;	./menu.c: 369: if (timer < MENU_5_SEC_PASSED) {
      009314 0D 02            [ 1]  867 	tnz	(0x02, sp)
      009316 27 0A            [ 1]  868 	jreq	00225$
                                    869 ;	./menu.c: 370: menuState = MENU_ROOT;
      009318 72 5F 00 29      [ 1]  870 	clr	_menuState+0
                                    871 ;	./menu.c: 371: setDisplayOff (false);
      00931C 4B 00            [ 1]  872 	push	#0x00
      00931E CD 85 9D         [ 4]  873 	call	_setDisplayOff
      009321 84               [ 1]  874 	pop	a
      009322                        875 00225$:
                                    876 ;	./menu.c: 374: timer = 0;
      009322 5F               [ 1]  877 	clrw	x
      009323 CF 00 2A         [ 2]  878 	ldw	_timer+0, x
                                    879 ;	./menu.c: 375: break;
      009326 20 30            [ 2]  880 	jra	00250$
                                    881 ;	./menu.c: 377: case MENU_EVENT_PUSH_BUTTON2:
      009328                        882 00226$:
                                    883 ;	./menu.c: 378: menuDisplay = MENU_ALARM_HIGH;
      009328 35 05 00 28      [ 1]  884 	mov	_menuDisplay+0, #0x05
                                    885 ;	./menu.c: 380: case MENU_EVENT_RELEASE_BUTTON2:
      00932C                        886 00227$:
                                    887 ;	./menu.c: 381: timer = 0;
      00932C 5F               [ 1]  888 	clrw	x
      00932D CF 00 2A         [ 2]  889 	ldw	_timer+0, x
                                    890 ;	./menu.c: 382: break;
      009330 20 26            [ 2]  891 	jra	00250$
                                    892 ;	./menu.c: 384: case MENU_EVENT_PUSH_BUTTON3:
      009332                        893 00228$:
                                    894 ;	./menu.c: 385: menuDisplay = MENU_ALARM_LOW;
      009332 35 06 00 28      [ 1]  895 	mov	_menuDisplay+0, #0x06
                                    896 ;	./menu.c: 387: case MENU_EVENT_RELEASE_BUTTON3:
      009336                        897 00229$:
                                    898 ;	./menu.c: 388: timer = 0;
      009336 5F               [ 1]  899 	clrw	x
      009337 CF 00 2A         [ 2]  900 	ldw	_timer+0, x
                                    901 ;	./menu.c: 389: break;
      00933A 20 1C            [ 2]  902 	jra	00250$
                                    903 ;	./menu.c: 391: default:
      00933C                        904 00230$:
                                    905 ;	./menu.c: 392: if (timer > MENU_3_SEC_PASSED) {
      00933C CE 00 2A         [ 2]  906 	ldw	x, _timer+0
      00933F A3 00 60         [ 2]  907 	cpw	x, #0x0060
      009342 23 04            [ 2]  908 	jrule	00232$
                                    909 ;	./menu.c: 393: menuDisplay = MENU_ALARM;
      009344 35 04 00 28      [ 1]  910 	mov	_menuDisplay+0, #0x04
      009348                        911 00232$:
                                    912 ;	./menu.c: 396: if (timer > MENU_5_SEC_PASSED) {
      009348 0D 03            [ 1]  913 	tnz	(0x03, sp)
      00934A 27 0C            [ 1]  914 	jreq	00250$
                                    915 ;	./menu.c: 397: timer = 0;
      00934C 5F               [ 1]  916 	clrw	x
      00934D CF 00 2A         [ 2]  917 	ldw	_timer+0, x
                                    918 ;	./menu.c: 398: menuState = menuDisplay = MENU_ROOT;
      009350 72 5F 00 28      [ 1]  919 	clr	_menuDisplay+0
      009354 72 5F 00 29      [ 1]  920 	clr	_menuState+0
                                    921 ;	./menu.c: 402: }
      009358                        922 00250$:
                                    923 ;	./menu.c: 404: }
      009358 5B 04            [ 2]  924 	addw	sp, #4
      00935A 81               [ 4]  925 	ret
                                    926 ;	./menu.c: 414: void refreshMenu()
                                    927 ;	-----------------------------------------
                                    928 ;	 function refreshMenu
                                    929 ;	-----------------------------------------
      00935B                        930 _refreshMenu:
                                    931 ;	./menu.c: 416: timer++;
      00935B CE 00 2A         [ 2]  932 	ldw	x, _timer+0
      00935E 5C               [ 1]  933 	incw	x
      00935F CF 00 2A         [ 2]  934 	ldw	_timer+0, x
                                    935 ;	./menu.c: 417: feedMenu (MENU_EVENT_CHECK_TIMER);
      009362 4B 06            [ 1]  936 	push	#0x06
      009364 CD 8E D7         [ 4]  937 	call	_feedMenu
      009367 84               [ 1]  938 	pop	a
                                    939 ;	./menu.c: 418: }
      009368 81               [ 4]  940 	ret
                                    941 	.area CODE
                                    942 	.area CONST
                                    943 	.area INITIALIZER
      008249                        944 __xinit__autoBrightness:
      008249 01                     945 	.db #0x01	;  1
      00824A                        946 __xinit__lowBrightness:
      00824A 00                     947 	.db #0x00	;  0
                                    948 	.area CABS (ABS)

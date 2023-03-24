                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module relay
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _getParamById
                                     12 	.globl _getTemperature
                                     13 	.globl _getSensorFail
                                     14 	.globl _initRelay
                                     15 	.globl _setRelay
                                     16 	.globl _refreshRelay
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area DATA
      000041                         21 _timer:
      000041                         22 	.ds 2
      000043                         23 _state:
      000043                         24 	.ds 1
                                     25 ;--------------------------------------------------------
                                     26 ; ram data
                                     27 ;--------------------------------------------------------
                                     28 	.area INITIALIZED
                                     29 ;--------------------------------------------------------
                                     30 ; absolute external ram data
                                     31 ;--------------------------------------------------------
                                     32 	.area DABS (ABS)
                                     33 
                                     34 ; default segment ordering for linker
                                     35 	.area HOME
                                     36 	.area GSINIT
                                     37 	.area GSFINAL
                                     38 	.area CONST
                                     39 	.area INITIALIZER
                                     40 	.area CODE
                                     41 
                                     42 ;--------------------------------------------------------
                                     43 ; global & static initialisations
                                     44 ;--------------------------------------------------------
                                     45 	.area HOME
                                     46 	.area GSINIT
                                     47 	.area GSFINAL
                                     48 	.area GSINIT
                                     49 ;--------------------------------------------------------
                                     50 ; Home
                                     51 ;--------------------------------------------------------
                                     52 	.area HOME
                                     53 	.area HOME
                                     54 ;--------------------------------------------------------
                                     55 ; code
                                     56 ;--------------------------------------------------------
                                     57 	.area CODE
                                     58 ;	./relay.c: 38: void initRelay()
                                     59 ;	-----------------------------------------
                                     60 ;	 function initRelay
                                     61 ;	-----------------------------------------
      009796                         62 _initRelay:
                                     63 ;	./relay.c: 40: PA_DDR |= RELAY_BIT;
      009796 72 16 50 02      [ 1]   64 	bset	20482, #3
                                     65 ;	./relay.c: 41: PA_CR1 |= RELAY_BIT;
      00979A 72 16 50 03      [ 1]   66 	bset	20483, #3
                                     67 ;	./relay.c: 42: timer = 0;
      00979E 5F               [ 1]   68 	clrw	x
      00979F CF 00 41         [ 2]   69 	ldw	_timer+0, x
                                     70 ;	./relay.c: 43: state = false;
      0097A2 72 5F 00 43      [ 1]   71 	clr	_state+0
                                     72 ;	./relay.c: 44: }
      0097A6 81               [ 4]   73 	ret
                                     74 ;	./relay.c: 50: void setRelay (bool on)
                                     75 ;	-----------------------------------------
                                     76 ;	 function setRelay
                                     77 ;	-----------------------------------------
      0097A7                         78 _setRelay:
                                     79 ;	./relay.c: 53: RELAY_PORT |= RELAY_BIT;
      0097A7 C6 50 00         [ 1]   80 	ld	a, 0x5000
                                     81 ;	./relay.c: 52: if (on) {
      0097AA 0D 03            [ 1]   82 	tnz	(0x03, sp)
      0097AC 27 06            [ 1]   83 	jreq	00102$
                                     84 ;	./relay.c: 53: RELAY_PORT |= RELAY_BIT;
      0097AE AA 08            [ 1]   85 	or	a, #0x08
      0097B0 C7 50 00         [ 1]   86 	ld	0x5000, a
      0097B3 81               [ 4]   87 	ret
      0097B4                         88 00102$:
                                     89 ;	./relay.c: 55: RELAY_PORT &= ~RELAY_BIT;
      0097B4 A4 F7            [ 1]   90 	and	a, #0xf7
      0097B6 C7 50 00         [ 1]   91 	ld	0x5000, a
                                     92 ;	./relay.c: 58: }
      0097B9 81               [ 4]   93 	ret
                                     94 ;	./relay.c: 64: void refreshRelay()
                                     95 ;	-----------------------------------------
                                     96 ;	 function refreshRelay
                                     97 ;	-----------------------------------------
      0097BA                         98 _refreshRelay:
      0097BA 52 0A            [ 2]   99 	sub	sp, #10
                                    100 ;	./relay.c: 68: int sensor_fail = getSensorFail();
      0097BC CD 8E 78         [ 4]  101 	call	_getSensorFail
      0097BF 1F 08            [ 2]  102 	ldw	(0x08, sp), x
                                    103 ;	./relay.c: 70: if (getParamById (PARAM_RELAY_MODE) == 2) {
      0097C1 4B 00            [ 1]  104 	push	#0x00
      0097C3 CD 93 E4         [ 4]  105 	call	_getParamById
      0097C6 84               [ 1]  106 	pop	a
      0097C7 A3 00 02         [ 2]  107 	cpw	x, #0x0002
      0097CA 26 08            [ 1]  108 	jrne	00105$
                                    109 ;	./relay.c: 71: alarm_mode = 1;
                                    110 ;	./relay.c: 72: mode = 1;
      0097CC A6 01            [ 1]  111 	ld	a, #0x01
      0097CE 6B 0A            [ 1]  112 	ld	(0x0a, sp), a
      0097D0 6B 01            [ 1]  113 	ld	(0x01, sp), a
      0097D2 20 20            [ 2]  114 	jra	00106$
      0097D4                        115 00105$:
                                    116 ;	./relay.c: 73: } else if (getParamById (PARAM_RELAY_MODE) == 3) {
      0097D4 4B 00            [ 1]  117 	push	#0x00
      0097D6 CD 93 E4         [ 4]  118 	call	_getParamById
      0097D9 84               [ 1]  119 	pop	a
      0097DA A3 00 03         [ 2]  120 	cpw	x, #0x0003
      0097DD 26 08            [ 1]  121 	jrne	00102$
                                    122 ;	./relay.c: 74: alarm_mode = 1;
      0097DF A6 01            [ 1]  123 	ld	a, #0x01
      0097E1 6B 0A            [ 1]  124 	ld	(0x0a, sp), a
                                    125 ;	./relay.c: 75: mode = 0;
      0097E3 0F 01            [ 1]  126 	clr	(0x01, sp)
      0097E5 20 0D            [ 2]  127 	jra	00106$
      0097E7                        128 00102$:
                                    129 ;	./relay.c: 77: alarm_mode = 0;
      0097E7 0F 0A            [ 1]  130 	clr	(0x0a, sp)
                                    131 ;	./relay.c: 78: mode = getParamById (PARAM_RELAY_MODE);
      0097E9 4B 00            [ 1]  132 	push	#0x00
      0097EB CD 93 E4         [ 4]  133 	call	_getParamById
      0097EE 84               [ 1]  134 	pop	a
      0097EF 50               [ 2]  135 	negw	x
      0097F0 4F               [ 1]  136 	clr	a
      0097F1 49               [ 1]  137 	rlc	a
      0097F2 6B 01            [ 1]  138 	ld	(0x01, sp), a
      0097F4                        139 00106$:
                                    140 ;	./relay.c: 81: if(sensor_fail == 0) {
      0097F4 1E 08            [ 2]  141 	ldw	x, (0x08, sp)
      0097F6 27 03            [ 1]  142 	jreq	00210$
      0097F8 CC 99 4F         [ 2]  143 	jp	00135$
      0097FB                        144 00210$:
                                    145 ;	./relay.c: 86: setRelay (!mode);
      0097FB 7B 01            [ 1]  146 	ld	a, (0x01, sp)
      0097FD A8 01            [ 1]  147 	xor	a, #0x01
      0097FF 6B 02            [ 1]  148 	ld	(0x02, sp), a
                                    149 ;	./relay.c: 82: if (alarm_mode) {
      009801 0D 0A            [ 1]  150 	tnz	(0x0a, sp)
      009803 26 03            [ 1]  151 	jrne	00211$
      009805 CC 98 8C         [ 2]  152 	jp	00129$
      009808                        153 00211$:
                                    154 ;	./relay.c: 83: if ((getTemperature() > (getParamById (PARAM_MIN_TEMPERATURE) * 10) ) &&
      009808 CD 8C CE         [ 4]  155 	call	_getTemperature
      00980B 1F 09            [ 2]  156 	ldw	(0x09, sp), x
      00980D 4B 03            [ 1]  157 	push	#0x03
      00980F CD 93 E4         [ 4]  158 	call	_getParamById
      009812 84               [ 1]  159 	pop	a
      009813 89               [ 2]  160 	pushw	x
      009814 58               [ 2]  161 	sllw	x
      009815 58               [ 2]  162 	sllw	x
      009816 72 FB 01         [ 2]  163 	addw	x, (1, sp)
      009819 58               [ 2]  164 	sllw	x
      00981A 5B 02            [ 2]  165 	addw	sp, #2
      00981C 13 09            [ 2]  166 	cpw	x, (0x09, sp)
      00981E 2E 27            [ 1]  167 	jrsge	00108$
                                    168 ;	./relay.c: 84: (getTemperature() < (getParamById (PARAM_MAX_TEMPERATURE) * 10) ) ) {
      009820 CD 8C CE         [ 4]  169 	call	_getTemperature
      009823 1F 07            [ 2]  170 	ldw	(0x07, sp), x
      009825 4B 02            [ 1]  171 	push	#0x02
      009827 CD 93 E4         [ 4]  172 	call	_getParamById
      00982A 84               [ 1]  173 	pop	a
      00982B 89               [ 2]  174 	pushw	x
      00982C 58               [ 2]  175 	sllw	x
      00982D 58               [ 2]  176 	sllw	x
      00982E 72 FB 01         [ 2]  177 	addw	x, (1, sp)
      009831 58               [ 2]  178 	sllw	x
      009832 5B 02            [ 2]  179 	addw	sp, #2
      009834 1F 09            [ 2]  180 	ldw	(0x09, sp), x
      009836 1E 07            [ 2]  181 	ldw	x, (0x07, sp)
      009838 13 09            [ 2]  182 	cpw	x, (0x09, sp)
      00983A 2E 0B            [ 1]  183 	jrsge	00108$
                                    184 ;	./relay.c: 85: state = false;
      00983C 72 5F 00 43      [ 1]  185 	clr	_state+0
                                    186 ;	./relay.c: 86: setRelay (!mode);
      009840 7B 02            [ 1]  187 	ld	a, (0x02, sp)
      009842 88               [ 1]  188 	push	a
      009843 CD 97 A7         [ 4]  189 	call	_setRelay
      009846 84               [ 1]  190 	pop	a
      009847                        191 00108$:
                                    192 ;	./relay.c: 89: if ((getTemperature() <= (getParamById (PARAM_MIN_TEMPERATURE) * 10) ) ||
      009847 CD 8C CE         [ 4]  193 	call	_getTemperature
      00984A 1F 09            [ 2]  194 	ldw	(0x09, sp), x
      00984C 4B 03            [ 1]  195 	push	#0x03
      00984E CD 93 E4         [ 4]  196 	call	_getParamById
      009851 84               [ 1]  197 	pop	a
      009852 89               [ 2]  198 	pushw	x
      009853 58               [ 2]  199 	sllw	x
      009854 58               [ 2]  200 	sllw	x
      009855 72 FB 01         [ 2]  201 	addw	x, (1, sp)
      009858 58               [ 2]  202 	sllw	x
      009859 5B 02            [ 2]  203 	addw	sp, #2
      00985B 13 09            [ 2]  204 	cpw	x, (0x09, sp)
      00985D 2E 1F            [ 1]  205 	jrsge	00110$
                                    206 ;	./relay.c: 90: (getTemperature() >= (getParamById (PARAM_MAX_TEMPERATURE) * 10) ) ) {
      00985F CD 8C CE         [ 4]  207 	call	_getTemperature
      009862 1F 07            [ 2]  208 	ldw	(0x07, sp), x
      009864 4B 02            [ 1]  209 	push	#0x02
      009866 CD 93 E4         [ 4]  210 	call	_getParamById
      009869 84               [ 1]  211 	pop	a
      00986A 89               [ 2]  212 	pushw	x
      00986B 58               [ 2]  213 	sllw	x
      00986C 58               [ 2]  214 	sllw	x
      00986D 72 FB 01         [ 2]  215 	addw	x, (1, sp)
      009870 58               [ 2]  216 	sllw	x
      009871 5B 02            [ 2]  217 	addw	sp, #2
      009873 1F 09            [ 2]  218 	ldw	(0x09, sp), x
      009875 1E 07            [ 2]  219 	ldw	x, (0x07, sp)
      009877 13 09            [ 2]  220 	cpw	x, (0x09, sp)
      009879 2E 03            [ 1]  221 	jrsge	00215$
      00987B CC 99 70         [ 2]  222 	jp	00137$
      00987E                        223 00215$:
      00987E                        224 00110$:
                                    225 ;	./relay.c: 91: state = true;
      00987E 35 01 00 43      [ 1]  226 	mov	_state+0, #0x01
                                    227 ;	./relay.c: 92: setRelay (mode);
      009882 7B 01            [ 1]  228 	ld	a, (0x01, sp)
      009884 88               [ 1]  229 	push	a
      009885 CD 97 A7         [ 4]  230 	call	_setRelay
      009888 84               [ 1]  231 	pop	a
      009889 CC 99 70         [ 2]  232 	jp	00137$
      00988C                        233 00129$:
                                    234 ;	./relay.c: 95: if (state) { // Relay state is enabled
      00988C 72 00 00 43 02   [ 2]  235 	btjt	_state+0, #0, 00216$
      009891 20 63            [ 2]  236 	jra	00126$
      009893                        237 00216$:
                                    238 ;	./relay.c: 96: if (getTemperature() < (getParamById (PARAM_THRESHOLD)
      009893 CD 8C CE         [ 4]  239 	call	_getTemperature
      009896 1F 03            [ 2]  240 	ldw	(0x03, sp), x
      009898 4B 09            [ 1]  241 	push	#0x09
      00989A CD 93 E4         [ 4]  242 	call	_getParamById
      00989D 84               [ 1]  243 	pop	a
      00989E 1F 05            [ 2]  244 	ldw	(0x05, sp), x
                                    245 ;	./relay.c: 97: - (getParamById (PARAM_RELAY_HYSTERESIS) >> 3) ) ) {
      0098A0 4B 01            [ 1]  246 	push	#0x01
      0098A2 CD 93 E4         [ 4]  247 	call	_getParamById
      0098A5 84               [ 1]  248 	pop	a
      0098A6 57               [ 2]  249 	sraw	x
      0098A7 57               [ 2]  250 	sraw	x
      0098A8 57               [ 2]  251 	sraw	x
      0098A9 1F 07            [ 2]  252 	ldw	(0x07, sp), x
      0098AB 1E 05            [ 2]  253 	ldw	x, (0x05, sp)
      0098AD 72 F0 07         [ 2]  254 	subw	x, (0x07, sp)
      0098B0 1F 09            [ 2]  255 	ldw	(0x09, sp), x
      0098B2 1E 03            [ 2]  256 	ldw	x, (0x03, sp)
      0098B4 13 09            [ 2]  257 	cpw	x, (0x09, sp)
      0098B6 2E 31            [ 1]  258 	jrsge	00117$
                                    259 ;	./relay.c: 98: timer++;
      0098B8 CE 00 41         [ 2]  260 	ldw	x, _timer+0
      0098BB 5C               [ 1]  261 	incw	x
      0098BC CF 00 41         [ 2]  262 	ldw	_timer+0, x
                                    263 ;	./relay.c: 100: if ( (getParamById (PARAM_RELAY_DELAY) << RELAY_TIMER_MULTIPLIER) < timer) {
      0098BF 4B 05            [ 1]  264 	push	#0x05
      0098C1 CD 93 E4         [ 4]  265 	call	_getParamById
      0098C4 84               [ 1]  266 	pop	a
      0098C5 58               [ 2]  267 	sllw	x
      0098C6 58               [ 2]  268 	sllw	x
      0098C7 58               [ 2]  269 	sllw	x
      0098C8 58               [ 2]  270 	sllw	x
      0098C9 58               [ 2]  271 	sllw	x
      0098CA 58               [ 2]  272 	sllw	x
      0098CB 58               [ 2]  273 	sllw	x
      0098CC C3 00 41         [ 2]  274 	cpw	x, _timer+0
      0098CF 24 0E            [ 1]  275 	jrnc	00114$
                                    276 ;	./relay.c: 101: state = false;
      0098D1 72 5F 00 43      [ 1]  277 	clr	_state+0
                                    278 ;	./relay.c: 102: setRelay (mode);
      0098D5 7B 01            [ 1]  279 	ld	a, (0x01, sp)
      0098D7 88               [ 1]  280 	push	a
      0098D8 CD 97 A7         [ 4]  281 	call	_setRelay
      0098DB 84               [ 1]  282 	pop	a
      0098DC CC 99 70         [ 2]  283 	jp	00137$
      0098DF                        284 00114$:
                                    285 ;	./relay.c: 104: setRelay (!mode);
      0098DF 7B 02            [ 1]  286 	ld	a, (0x02, sp)
      0098E1 88               [ 1]  287 	push	a
      0098E2 CD 97 A7         [ 4]  288 	call	_setRelay
      0098E5 84               [ 1]  289 	pop	a
      0098E6 CC 99 70         [ 2]  290 	jp	00137$
      0098E9                        291 00117$:
                                    292 ;	./relay.c: 107: timer = 0;
      0098E9 5F               [ 1]  293 	clrw	x
      0098EA CF 00 41         [ 2]  294 	ldw	_timer+0, x
                                    295 ;	./relay.c: 108: setRelay (!mode);
      0098ED 7B 02            [ 1]  296 	ld	a, (0x02, sp)
      0098EF 88               [ 1]  297 	push	a
      0098F0 CD 97 A7         [ 4]  298 	call	_setRelay
      0098F3 84               [ 1]  299 	pop	a
      0098F4 20 7A            [ 2]  300 	jra	00137$
      0098F6                        301 00126$:
                                    302 ;	./relay.c: 112: if (getTemperature() > (getParamById (PARAM_THRESHOLD)
      0098F6 CD 8C CE         [ 4]  303 	call	_getTemperature
      0098F9 1F 07            [ 2]  304 	ldw	(0x07, sp), x
      0098FB 4B 09            [ 1]  305 	push	#0x09
      0098FD CD 93 E4         [ 4]  306 	call	_getParamById
      009900 84               [ 1]  307 	pop	a
      009901 1F 09            [ 2]  308 	ldw	(0x09, sp), x
                                    309 ;	./relay.c: 113: + (getParamById (PARAM_RELAY_HYSTERESIS) >> 3) ) ) {
      009903 4B 01            [ 1]  310 	push	#0x01
      009905 CD 93 E4         [ 4]  311 	call	_getParamById
      009908 84               [ 1]  312 	pop	a
      009909 57               [ 2]  313 	sraw	x
      00990A 57               [ 2]  314 	sraw	x
      00990B 57               [ 2]  315 	sraw	x
      00990C 72 FB 09         [ 2]  316 	addw	x, (0x09, sp)
      00990F 13 07            [ 2]  317 	cpw	x, (0x07, sp)
      009911 2E 2F            [ 1]  318 	jrsge	00123$
                                    319 ;	./relay.c: 114: timer++;
      009913 CE 00 41         [ 2]  320 	ldw	x, _timer+0
      009916 5C               [ 1]  321 	incw	x
      009917 CF 00 41         [ 2]  322 	ldw	_timer+0, x
                                    323 ;	./relay.c: 116: if ( (getParamById (PARAM_RELAY_DELAY) << RELAY_TIMER_MULTIPLIER) < timer) {
      00991A 4B 05            [ 1]  324 	push	#0x05
      00991C CD 93 E4         [ 4]  325 	call	_getParamById
      00991F 84               [ 1]  326 	pop	a
      009920 58               [ 2]  327 	sllw	x
      009921 58               [ 2]  328 	sllw	x
      009922 58               [ 2]  329 	sllw	x
      009923 58               [ 2]  330 	sllw	x
      009924 58               [ 2]  331 	sllw	x
      009925 58               [ 2]  332 	sllw	x
      009926 58               [ 2]  333 	sllw	x
      009927 C3 00 41         [ 2]  334 	cpw	x, _timer+0
      00992A 24 0D            [ 1]  335 	jrnc	00120$
                                    336 ;	./relay.c: 117: state = true;
      00992C 35 01 00 43      [ 1]  337 	mov	_state+0, #0x01
                                    338 ;	./relay.c: 118: setRelay (!mode);
      009930 7B 02            [ 1]  339 	ld	a, (0x02, sp)
      009932 88               [ 1]  340 	push	a
      009933 CD 97 A7         [ 4]  341 	call	_setRelay
      009936 84               [ 1]  342 	pop	a
      009937 20 37            [ 2]  343 	jra	00137$
      009939                        344 00120$:
                                    345 ;	./relay.c: 120: setRelay (mode);
      009939 7B 01            [ 1]  346 	ld	a, (0x01, sp)
      00993B 88               [ 1]  347 	push	a
      00993C CD 97 A7         [ 4]  348 	call	_setRelay
      00993F 84               [ 1]  349 	pop	a
      009940 20 2E            [ 2]  350 	jra	00137$
      009942                        351 00123$:
                                    352 ;	./relay.c: 123: timer = 0;
      009942 5F               [ 1]  353 	clrw	x
      009943 CF 00 41         [ 2]  354 	ldw	_timer+0, x
                                    355 ;	./relay.c: 124: setRelay (mode);
      009946 7B 01            [ 1]  356 	ld	a, (0x01, sp)
      009948 88               [ 1]  357 	push	a
      009949 CD 97 A7         [ 4]  358 	call	_setRelay
      00994C 84               [ 1]  359 	pop	a
      00994D 20 21            [ 2]  360 	jra	00137$
      00994F                        361 00135$:
                                    362 ;	./relay.c: 129: if (getParamById (PARAM_RELAY_MODE) == 2) {
      00994F 4B 00            [ 1]  363 	push	#0x00
      009951 CD 93 E4         [ 4]  364 	call	_getParamById
      009954 84               [ 1]  365 	pop	a
      009955 A3 00 02         [ 2]  366 	cpw	x, #0x0002
      009958 26 0C            [ 1]  367 	jrne	00132$
                                    368 ;	./relay.c: 130: state = true;
      00995A 35 01 00 43      [ 1]  369 	mov	_state+0, #0x01
                                    370 ;	./relay.c: 131: setRelay (1);
      00995E 4B 01            [ 1]  371 	push	#0x01
      009960 CD 97 A7         [ 4]  372 	call	_setRelay
      009963 84               [ 1]  373 	pop	a
      009964 20 0A            [ 2]  374 	jra	00137$
      009966                        375 00132$:
                                    376 ;	./relay.c: 133: state = false;
      009966 72 5F 00 43      [ 1]  377 	clr	_state+0
                                    378 ;	./relay.c: 134: setRelay (0);
      00996A 4B 00            [ 1]  379 	push	#0x00
      00996C CD 97 A7         [ 4]  380 	call	_setRelay
      00996F 84               [ 1]  381 	pop	a
      009970                        382 00137$:
                                    383 ;	./relay.c: 137: }
      009970 5B 0A            [ 2]  384 	addw	sp, #10
      009972 81               [ 4]  385 	ret
                                    386 	.area CODE
                                    387 	.area CONST
                                    388 	.area INITIALIZER
                                    389 	.area CABS (ABS)

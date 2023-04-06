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
                                     13 	.globl _initRelay
                                     14 	.globl _setRelay
                                     15 	.globl _refreshRelay
                                     16 ;--------------------------------------------------------
                                     17 ; ram data
                                     18 ;--------------------------------------------------------
                                     19 	.area DATA
      00003D                         20 _timer:
      00003D                         21 	.ds 2
      00003F                         22 _state:
      00003F                         23 	.ds 1
                                     24 ;--------------------------------------------------------
                                     25 ; ram data
                                     26 ;--------------------------------------------------------
                                     27 	.area INITIALIZED
                                     28 ;--------------------------------------------------------
                                     29 ; absolute external ram data
                                     30 ;--------------------------------------------------------
                                     31 	.area DABS (ABS)
                                     32 
                                     33 ; default segment ordering for linker
                                     34 	.area HOME
                                     35 	.area GSINIT
                                     36 	.area GSFINAL
                                     37 	.area CONST
                                     38 	.area INITIALIZER
                                     39 	.area CODE
                                     40 
                                     41 ;--------------------------------------------------------
                                     42 ; global & static initialisations
                                     43 ;--------------------------------------------------------
                                     44 	.area HOME
                                     45 	.area GSINIT
                                     46 	.area GSFINAL
                                     47 	.area GSINIT
                                     48 ;--------------------------------------------------------
                                     49 ; Home
                                     50 ;--------------------------------------------------------
                                     51 	.area HOME
                                     52 	.area HOME
                                     53 ;--------------------------------------------------------
                                     54 ; code
                                     55 ;--------------------------------------------------------
                                     56 	.area CODE
                                     57 ;	./relay.c: 38: void initRelay()
                                     58 ;	-----------------------------------------
                                     59 ;	 function initRelay
                                     60 ;	-----------------------------------------
      0092F2                         61 _initRelay:
                                     62 ;	./relay.c: 40: PA_DDR |= RELAY_BIT;
      0092F2 72 16 50 02      [ 1]   63 	bset	20482, #3
                                     64 ;	./relay.c: 41: PA_CR1 |= RELAY_BIT;
      0092F6 72 16 50 03      [ 1]   65 	bset	20483, #3
                                     66 ;	./relay.c: 42: timer = 0;
      0092FA 5F               [ 1]   67 	clrw	x
      0092FB CF 00 3D         [ 2]   68 	ldw	_timer+0, x
                                     69 ;	./relay.c: 43: state = false;
      0092FE 72 5F 00 3F      [ 1]   70 	clr	_state+0
                                     71 ;	./relay.c: 44: }
      009302 81               [ 4]   72 	ret
                                     73 ;	./relay.c: 50: void setRelay (bool on)
                                     74 ;	-----------------------------------------
                                     75 ;	 function setRelay
                                     76 ;	-----------------------------------------
      009303                         77 _setRelay:
                                     78 ;	./relay.c: 53: RELAY_PORT |= RELAY_BIT;
      009303 C6 50 00         [ 1]   79 	ld	a, 0x5000
                                     80 ;	./relay.c: 52: if (on) {
      009306 0D 03            [ 1]   81 	tnz	(0x03, sp)
      009308 27 06            [ 1]   82 	jreq	00102$
                                     83 ;	./relay.c: 53: RELAY_PORT |= RELAY_BIT;
      00930A AA 08            [ 1]   84 	or	a, #0x08
      00930C C7 50 00         [ 1]   85 	ld	0x5000, a
      00930F 81               [ 4]   86 	ret
      009310                         87 00102$:
                                     88 ;	./relay.c: 55: RELAY_PORT &= ~RELAY_BIT;
      009310 A4 F7            [ 1]   89 	and	a, #0xf7
      009312 C7 50 00         [ 1]   90 	ld	0x5000, a
                                     91 ;	./relay.c: 58: }
      009315 81               [ 4]   92 	ret
                                     93 ;	./relay.c: 64: void refreshRelay()
                                     94 ;	-----------------------------------------
                                     95 ;	 function refreshRelay
                                     96 ;	-----------------------------------------
      009316                         97 _refreshRelay:
      009316 52 0A            [ 2]   98 	sub	sp, #10
                                     99 ;	./relay.c: 66: bool mode = getParamById (PARAM_RELAY_MODE);
      009318 4B 00            [ 1]  100 	push	#0x00
      00931A CD 8F 8F         [ 4]  101 	call	_getParamById
      00931D 84               [ 1]  102 	pop	a
      00931E 50               [ 2]  103 	negw	x
      00931F 4F               [ 1]  104 	clr	a
      009320 49               [ 1]  105 	rlc	a
                                    106 ;	./relay.c: 77: setRelay (!mode);
      009321 6B 01            [ 1]  107 	ld	(0x01, sp), a
      009323 A8 01            [ 1]  108 	xor	a, #0x01
      009325 6B 02            [ 1]  109 	ld	(0x02, sp), a
                                    110 ;	./relay.c: 68: if (state) { // Relay state is enabled
      009327 72 00 00 3F 02   [ 2]  111 	btjt	_state+0, #0, 00143$
      00932C 20 61            [ 2]  112 	jra	00114$
      00932E                        113 00143$:
                                    114 ;	./relay.c: 69: if (getTemperature() < (getParamById (PARAM_THRESHOLD)
      00932E CD 8A FE         [ 4]  115 	call	_getTemperature
      009331 1F 03            [ 2]  116 	ldw	(0x03, sp), x
      009333 4B 09            [ 1]  117 	push	#0x09
      009335 CD 8F 8F         [ 4]  118 	call	_getParamById
      009338 84               [ 1]  119 	pop	a
      009339 1F 05            [ 2]  120 	ldw	(0x05, sp), x
                                    121 ;	./relay.c: 70: - (getParamById (PARAM_RELAY_HYSTERESIS) >> 3) ) ) {
      00933B 4B 01            [ 1]  122 	push	#0x01
      00933D CD 8F 8F         [ 4]  123 	call	_getParamById
      009340 84               [ 1]  124 	pop	a
      009341 57               [ 2]  125 	sraw	x
      009342 57               [ 2]  126 	sraw	x
      009343 57               [ 2]  127 	sraw	x
      009344 1F 07            [ 2]  128 	ldw	(0x07, sp), x
      009346 1E 05            [ 2]  129 	ldw	x, (0x05, sp)
      009348 72 F0 07         [ 2]  130 	subw	x, (0x07, sp)
      00934B 1F 09            [ 2]  131 	ldw	(0x09, sp), x
      00934D 1E 03            [ 2]  132 	ldw	x, (0x03, sp)
      00934F 13 09            [ 2]  133 	cpw	x, (0x09, sp)
      009351 2E 2F            [ 1]  134 	jrsge	00105$
                                    135 ;	./relay.c: 71: timer++;
      009353 CE 00 3D         [ 2]  136 	ldw	x, _timer+0
      009356 5C               [ 1]  137 	incw	x
      009357 CF 00 3D         [ 2]  138 	ldw	_timer+0, x
                                    139 ;	./relay.c: 73: if ( (getParamById (PARAM_RELAY_DELAY) << RELAY_TIMER_MULTIPLIER) < timer) {
      00935A 4B 05            [ 1]  140 	push	#0x05
      00935C CD 8F 8F         [ 4]  141 	call	_getParamById
      00935F 84               [ 1]  142 	pop	a
      009360 58               [ 2]  143 	sllw	x
      009361 58               [ 2]  144 	sllw	x
      009362 58               [ 2]  145 	sllw	x
      009363 58               [ 2]  146 	sllw	x
      009364 58               [ 2]  147 	sllw	x
      009365 58               [ 2]  148 	sllw	x
      009366 58               [ 2]  149 	sllw	x
      009367 C3 00 3D         [ 2]  150 	cpw	x, _timer+0
      00936A 24 0D            [ 1]  151 	jrnc	00102$
                                    152 ;	./relay.c: 74: state = false;
      00936C 72 5F 00 3F      [ 1]  153 	clr	_state+0
                                    154 ;	./relay.c: 75: setRelay (mode);
      009370 7B 01            [ 1]  155 	ld	a, (0x01, sp)
      009372 88               [ 1]  156 	push	a
      009373 CD 93 03         [ 4]  157 	call	_setRelay
      009376 84               [ 1]  158 	pop	a
      009377 20 6D            [ 2]  159 	jra	00116$
      009379                        160 00102$:
                                    161 ;	./relay.c: 77: setRelay (!mode);
      009379 7B 02            [ 1]  162 	ld	a, (0x02, sp)
      00937B 88               [ 1]  163 	push	a
      00937C CD 93 03         [ 4]  164 	call	_setRelay
      00937F 84               [ 1]  165 	pop	a
      009380 20 64            [ 2]  166 	jra	00116$
      009382                        167 00105$:
                                    168 ;	./relay.c: 80: timer = 0;
      009382 5F               [ 1]  169 	clrw	x
      009383 CF 00 3D         [ 2]  170 	ldw	_timer+0, x
                                    171 ;	./relay.c: 81: setRelay (!mode);
      009386 7B 02            [ 1]  172 	ld	a, (0x02, sp)
      009388 88               [ 1]  173 	push	a
      009389 CD 93 03         [ 4]  174 	call	_setRelay
      00938C 84               [ 1]  175 	pop	a
      00938D 20 57            [ 2]  176 	jra	00116$
      00938F                        177 00114$:
                                    178 ;	./relay.c: 84: if (getTemperature() > (getParamById (PARAM_THRESHOLD)
      00938F CD 8A FE         [ 4]  179 	call	_getTemperature
      009392 1F 07            [ 2]  180 	ldw	(0x07, sp), x
      009394 4B 09            [ 1]  181 	push	#0x09
      009396 CD 8F 8F         [ 4]  182 	call	_getParamById
      009399 84               [ 1]  183 	pop	a
      00939A 1F 09            [ 2]  184 	ldw	(0x09, sp), x
                                    185 ;	./relay.c: 85: + (getParamById (PARAM_RELAY_HYSTERESIS) >> 3) ) ) {
      00939C 4B 01            [ 1]  186 	push	#0x01
      00939E CD 8F 8F         [ 4]  187 	call	_getParamById
      0093A1 84               [ 1]  188 	pop	a
      0093A2 57               [ 2]  189 	sraw	x
      0093A3 57               [ 2]  190 	sraw	x
      0093A4 57               [ 2]  191 	sraw	x
      0093A5 72 FB 09         [ 2]  192 	addw	x, (0x09, sp)
      0093A8 13 07            [ 2]  193 	cpw	x, (0x07, sp)
      0093AA 2E 2F            [ 1]  194 	jrsge	00111$
                                    195 ;	./relay.c: 86: timer++;
      0093AC CE 00 3D         [ 2]  196 	ldw	x, _timer+0
      0093AF 5C               [ 1]  197 	incw	x
      0093B0 CF 00 3D         [ 2]  198 	ldw	_timer+0, x
                                    199 ;	./relay.c: 88: if ( (getParamById (PARAM_RELAY_DELAY) << RELAY_TIMER_MULTIPLIER) < timer) {
      0093B3 4B 05            [ 1]  200 	push	#0x05
      0093B5 CD 8F 8F         [ 4]  201 	call	_getParamById
      0093B8 84               [ 1]  202 	pop	a
      0093B9 58               [ 2]  203 	sllw	x
      0093BA 58               [ 2]  204 	sllw	x
      0093BB 58               [ 2]  205 	sllw	x
      0093BC 58               [ 2]  206 	sllw	x
      0093BD 58               [ 2]  207 	sllw	x
      0093BE 58               [ 2]  208 	sllw	x
      0093BF 58               [ 2]  209 	sllw	x
      0093C0 C3 00 3D         [ 2]  210 	cpw	x, _timer+0
      0093C3 24 0D            [ 1]  211 	jrnc	00108$
                                    212 ;	./relay.c: 89: state = true;
      0093C5 35 01 00 3F      [ 1]  213 	mov	_state+0, #0x01
                                    214 ;	./relay.c: 90: setRelay (!mode);
      0093C9 7B 02            [ 1]  215 	ld	a, (0x02, sp)
      0093CB 88               [ 1]  216 	push	a
      0093CC CD 93 03         [ 4]  217 	call	_setRelay
      0093CF 84               [ 1]  218 	pop	a
      0093D0 20 14            [ 2]  219 	jra	00116$
      0093D2                        220 00108$:
                                    221 ;	./relay.c: 92: setRelay (mode);
      0093D2 7B 01            [ 1]  222 	ld	a, (0x01, sp)
      0093D4 88               [ 1]  223 	push	a
      0093D5 CD 93 03         [ 4]  224 	call	_setRelay
      0093D8 84               [ 1]  225 	pop	a
      0093D9 20 0B            [ 2]  226 	jra	00116$
      0093DB                        227 00111$:
                                    228 ;	./relay.c: 95: timer = 0;
      0093DB 5F               [ 1]  229 	clrw	x
      0093DC CF 00 3D         [ 2]  230 	ldw	_timer+0, x
                                    231 ;	./relay.c: 96: setRelay (mode);
      0093DF 7B 01            [ 1]  232 	ld	a, (0x01, sp)
      0093E1 88               [ 1]  233 	push	a
      0093E2 CD 93 03         [ 4]  234 	call	_setRelay
      0093E5 84               [ 1]  235 	pop	a
      0093E6                        236 00116$:
                                    237 ;	./relay.c: 99: }
      0093E6 5B 0A            [ 2]  238 	addw	sp, #10
      0093E8 81               [ 4]  239 	ret
                                    240 	.area CODE
                                    241 	.area CONST
                                    242 	.area INITIALIZER
                                    243 	.area CABS (ABS)

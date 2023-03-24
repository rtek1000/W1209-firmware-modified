                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module timer
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _refreshRelay
                                     12 	.globl _refreshMenu
                                     13 	.globl _refreshDisplay
                                     14 	.globl _startADC
                                     15 	.globl _initTimer
                                     16 	.globl _resetUptime
                                     17 	.globl _getUptime
                                     18 	.globl _getUptimeTicks
                                     19 	.globl _getUptimeSeconds
                                     20 	.globl _getUptimeMinutes
                                     21 	.globl _getUptimeHours
                                     22 	.globl _getUptimeDays
                                     23 	.globl _TIM4_UPD_handler
                                     24 ;--------------------------------------------------------
                                     25 ; ram data
                                     26 ;--------------------------------------------------------
                                     27 	.area DATA
      000018                         28 _uptime:
      000018                         29 	.ds 4
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
                                     63 ;	./timer.c: 54: void initTimer()
                                     64 ;	-----------------------------------------
                                     65 ;	 function initTimer
                                     66 ;	-----------------------------------------
      0089E9                         67 _initTimer:
                                     68 ;	./timer.c: 56: CLK_CKDIVR = 0x00;  // Set the frequency to 16 MHz
      0089E9 35 00 50 C6      [ 1]   69 	mov	0x50c6+0, #0x00
                                     70 ;	./timer.c: 57: TIM4_PSCR = 0x07;   // CLK / 128 = 125KHz
      0089ED 35 07 53 47      [ 1]   71 	mov	0x5347+0, #0x07
                                     72 ;	./timer.c: 58: TIM4_ARR = 0xFA;    // 125KHz /  250(0xFA) = 500
      0089F1 35 FA 53 48      [ 1]   73 	mov	0x5348+0, #0xfa
                                     74 ;	./timer.c: 59: TIM4_IER = 0x01;    // Enable interrupt on update event
      0089F5 35 01 53 43      [ 1]   75 	mov	0x5343+0, #0x01
                                     76 ;	./timer.c: 60: TIM4_CR1 = 0x05;    // Enable timer
      0089F9 35 05 53 40      [ 1]   77 	mov	0x5340+0, #0x05
                                     78 ;	./timer.c: 61: resetUptime();
                                     79 ;	./timer.c: 62: }
      0089FD CC 8A 00         [ 2]   80 	jp	_resetUptime
                                     81 ;	./timer.c: 67: void resetUptime()
                                     82 ;	-----------------------------------------
                                     83 ;	 function resetUptime
                                     84 ;	-----------------------------------------
      008A00                         85 _resetUptime:
                                     86 ;	./timer.c: 69: uptime = 0;
      008A00 5F               [ 1]   87 	clrw	x
      008A01 CF 00 1A         [ 2]   88 	ldw	_uptime+2, x
      008A04 CF 00 18         [ 2]   89 	ldw	_uptime+0, x
                                     90 ;	./timer.c: 70: }
      008A07 81               [ 4]   91 	ret
                                     92 ;	./timer.c: 78: unsigned long getUptime()
                                     93 ;	-----------------------------------------
                                     94 ;	 function getUptime
                                     95 ;	-----------------------------------------
      008A08                         96 _getUptime:
                                     97 ;	./timer.c: 80: return uptime;
      008A08 CE 00 1A         [ 2]   98 	ldw	x, _uptime+2
      008A0B 90 CE 00 18      [ 2]   99 	ldw	y, _uptime+0
                                    100 ;	./timer.c: 81: }
      008A0F 81               [ 4]  101 	ret
                                    102 ;	./timer.c: 87: unsigned int getUptimeTicks()
                                    103 ;	-----------------------------------------
                                    104 ;	 function getUptimeTicks
                                    105 ;	-----------------------------------------
      008A10                        106 _getUptimeTicks:
                                    107 ;	./timer.c: 89: return (unsigned int) (uptime & BITMASK (BITS_FOR_TICKS) );
      008A10 CE 00 1A         [ 2]  108 	ldw	x, _uptime+2
      008A13 9E               [ 1]  109 	ld	a, xh
      008A14 A4 01            [ 1]  110 	and	a, #0x01
      008A16 95               [ 1]  111 	ld	xh, a
                                    112 ;	./timer.c: 90: }
      008A17 81               [ 4]  113 	ret
                                    114 ;	./timer.c: 96: unsigned char getUptimeSeconds()
                                    115 ;	-----------------------------------------
                                    116 ;	 function getUptimeSeconds
                                    117 ;	-----------------------------------------
      008A18                        118 _getUptimeSeconds:
      008A18 52 04            [ 2]  119 	sub	sp, #4
                                    120 ;	./timer.c: 98: return (unsigned char) ( (uptime >> SECONDS_FIRST_BIT) & BITMASK (BITS_FOR_SECONDS) );
      008A1A C6 00 1A         [ 1]  121 	ld	a, _uptime+2
      008A1D CE 00 18         [ 2]  122 	ldw	x, _uptime+0
      008A20 0F 01            [ 1]  123 	clr	(0x01, sp)
      008A22 54               [ 2]  124 	srlw	x
      008A23 46               [ 1]  125 	rrc	a
      008A24 54               [ 2]  126 	srlw	x
      008A25 46               [ 1]  127 	rrc	a
      008A26 A4 3F            [ 1]  128 	and	a, #0x3f
                                    129 ;	./timer.c: 99: }
      008A28 5B 04            [ 2]  130 	addw	sp, #4
      008A2A 81               [ 4]  131 	ret
                                    132 ;	./timer.c: 105: unsigned char getUptimeMinutes()
                                    133 ;	-----------------------------------------
                                    134 ;	 function getUptimeMinutes
                                    135 ;	-----------------------------------------
      008A2B                        136 _getUptimeMinutes:
                                    137 ;	./timer.c: 107: return (unsigned char) ( (uptime >> MINUTES_FIRST_BIT) & BITMASK (BITS_FOR_MINUTES) );
      008A2B CE 00 18         [ 2]  138 	ldw	x, _uptime+0
      008A2E 9F               [ 1]  139 	ld	a, xl
      008A2F A4 3F            [ 1]  140 	and	a, #0x3f
                                    141 ;	./timer.c: 108: }
      008A31 81               [ 4]  142 	ret
                                    143 ;	./timer.c: 114: unsigned char getUptimeHours()
                                    144 ;	-----------------------------------------
                                    145 ;	 function getUptimeHours
                                    146 ;	-----------------------------------------
      008A32                        147 _getUptimeHours:
                                    148 ;	./timer.c: 116: return (unsigned char) ( (uptime >> HOURS_FIRST_BIT) & BITMASK (BITS_FOR_HOURS) );
      008A32 CE 00 18         [ 2]  149 	ldw	x, _uptime+0
      008A35 A6 40            [ 1]  150 	ld	a, #0x40
      008A37 62               [ 2]  151 	div	x, a
      008A38 9F               [ 1]  152 	ld	a, xl
      008A39 A4 1F            [ 1]  153 	and	a, #0x1f
                                    154 ;	./timer.c: 117: }
      008A3B 81               [ 4]  155 	ret
                                    156 ;	./timer.c: 123: unsigned char getUptimeDays()
                                    157 ;	-----------------------------------------
                                    158 ;	 function getUptimeDays
                                    159 ;	-----------------------------------------
      008A3C                        160 _getUptimeDays:
      008A3C 52 04            [ 2]  161 	sub	sp, #4
                                    162 ;	./timer.c: 125: return (unsigned char) ( (uptime >> DAYS_FIRST_BIT) & BITMASK (BITS_FOR_DAYS) );
      008A3E C6 00 18         [ 1]  163 	ld	a, _uptime+0
      008A41 0F 01            [ 1]  164 	clr	(0x01, sp)
      008A43 44               [ 1]  165 	srl	a
      008A44 44               [ 1]  166 	srl	a
      008A45 44               [ 1]  167 	srl	a
      008A46 A4 3F            [ 1]  168 	and	a, #0x3f
                                    169 ;	./timer.c: 126: }
      008A48 5B 04            [ 2]  170 	addw	sp, #4
      008A4A 81               [ 4]  171 	ret
                                    172 ;	./timer.c: 132: void TIM4_UPD_handler() __interrupt (23)
                                    173 ;	-----------------------------------------
                                    174 ;	 function TIM4_UPD_handler
                                    175 ;	-----------------------------------------
      008A4B                        176 _TIM4_UPD_handler:
      008A4B 4F               [ 1]  177 	clr	a
      008A4C 62               [ 2]  178 	div	x, a
                                    179 ;	./timer.c: 134: TIM4_SR &= ~TIM_SR1_UIF; // Reset flag
      008A4D 72 11 53 44      [ 1]  180 	bres	21316, #0
                                    181 ;	./timer.c: 136: if ( ( (unsigned int) (uptime & BITMASK (BITS_FOR_TICKS) ) ) >= TICKS_IN_SECOND) {
      008A51 CE 00 1A         [ 2]  182 	ldw	x, _uptime+2
      008A54 9E               [ 1]  183 	ld	a, xh
      008A55 A4 01            [ 1]  184 	and	a, #0x01
      008A57 95               [ 1]  185 	ld	xh, a
      008A58 A3 01 F4         [ 2]  186 	cpw	x, #0x01f4
      008A5B 24 03            [ 1]  187 	jrnc	00154$
      008A5D CC 8B 2A         [ 2]  188 	jp	00108$
      008A60                        189 00154$:
                                    190 ;	./timer.c: 137: uptime &= NBITMASK (SECONDS_FIRST_BIT);
      008A60 4F               [ 1]  191 	clr	a
      008A61 97               [ 1]  192 	ld	xl, a
      008A62 C6 00 1A         [ 1]  193 	ld	a, _uptime+2
      008A65 A4 FC            [ 1]  194 	and	a, #0xfc
      008A67 95               [ 1]  195 	ld	xh, a
      008A68 90 CE 00 18      [ 2]  196 	ldw	y, _uptime+0
      008A6C CF 00 1A         [ 2]  197 	ldw	_uptime+2, x
      008A6F 90 CF 00 18      [ 2]  198 	ldw	_uptime+0, y
                                    199 ;	./timer.c: 138: uptime += (unsigned long) 1 << SECONDS_FIRST_BIT;
      008A73 CE 00 1A         [ 2]  200 	ldw	x, _uptime+2
      008A76 1C 04 00         [ 2]  201 	addw	x, #0x0400
      008A79 90 CE 00 18      [ 2]  202 	ldw	y, _uptime+0
      008A7D 24 02            [ 1]  203 	jrnc	00155$
      008A7F 90 5C            [ 1]  204 	incw	y
      008A81                        205 00155$:
      008A81 CF 00 1A         [ 2]  206 	ldw	_uptime+2, x
      008A84 90 CF 00 18      [ 2]  207 	ldw	_uptime+0, y
                                    208 ;	./timer.c: 141: if ( ( (unsigned char) (uptime >> SECONDS_FIRST_BIT) & BITMASK (BITS_FOR_SECONDS) ) == 60) {
      008A88 C6 00 1A         [ 1]  209 	ld	a, _uptime+2
      008A8B CE 00 18         [ 2]  210 	ldw	x, _uptime+0
      008A8E 54               [ 2]  211 	srlw	x
      008A8F 46               [ 1]  212 	rrc	a
      008A90 54               [ 2]  213 	srlw	x
      008A91 46               [ 1]  214 	rrc	a
      008A92 A4 3F            [ 1]  215 	and	a, #0x3f
      008A94 97               [ 1]  216 	ld	xl, a
      008A95 4F               [ 1]  217 	clr	a
      008A96 90 5F            [ 1]  218 	clrw	y
      008A98 95               [ 1]  219 	ld	xh, a
      008A99 A3 00 3C         [ 2]  220 	cpw	x, #0x003c
      008A9C 26 1F            [ 1]  221 	jrne	00102$
      008A9E 90 5D            [ 2]  222 	tnzw	y
      008AA0 26 1B            [ 1]  223 	jrne	00102$
                                    224 ;	./timer.c: 142: uptime &= NBITMASK (MINUTES_FIRST_BIT);
      008AA2 5F               [ 1]  225 	clrw	x
      008AA3 90 CE 00 18      [ 2]  226 	ldw	y, _uptime+0
      008AA7 CF 00 1A         [ 2]  227 	ldw	_uptime+2, x
      008AAA 90 CF 00 18      [ 2]  228 	ldw	_uptime+0, y
                                    229 ;	./timer.c: 143: uptime += (unsigned long) 1 << MINUTES_FIRST_BIT;
      008AAE 90 CE 00 1A      [ 2]  230 	ldw	y, _uptime+2
      008AB2 CE 00 18         [ 2]  231 	ldw	x, _uptime+0
      008AB5 5C               [ 1]  232 	incw	x
      008AB6 90 CF 00 1A      [ 2]  233 	ldw	_uptime+2, y
      008ABA CF 00 18         [ 2]  234 	ldw	_uptime+0, x
      008ABD                        235 00102$:
                                    236 ;	./timer.c: 147: if ( ( (unsigned char) (uptime >> MINUTES_FIRST_BIT) & BITMASK (BITS_FOR_MINUTES) ) == 60) {
      008ABD CE 00 18         [ 2]  237 	ldw	x, _uptime+0
      008AC0 9F               [ 1]  238 	ld	a, xl
      008AC1 A4 3F            [ 1]  239 	and	a, #0x3f
      008AC3 97               [ 1]  240 	ld	xl, a
      008AC4 4F               [ 1]  241 	clr	a
      008AC5 90 5F            [ 1]  242 	clrw	y
      008AC7 95               [ 1]  243 	ld	xh, a
      008AC8 A3 00 3C         [ 2]  244 	cpw	x, #0x003c
      008ACB 26 26            [ 1]  245 	jrne	00104$
                                    246 ;	./timer.c: 148: uptime &= NBITMASK (HOURS_FIRST_BIT);
      008ACD 90 5D            [ 2]  247 	tnzw	y
      008ACF 26 22            [ 1]  248 	jrne	00104$
      008AD1 C6 00 19         [ 1]  249 	ld	a, _uptime+1
      008AD4 A4 C0            [ 1]  250 	and	a, #0xc0
      008AD6 97               [ 1]  251 	ld	xl, a
      008AD7 C6 00 18         [ 1]  252 	ld	a, _uptime+0
      008ADA 95               [ 1]  253 	ld	xh, a
      008ADB 90 CF 00 1A      [ 2]  254 	ldw	_uptime+2, y
      008ADF CF 00 18         [ 2]  255 	ldw	_uptime+0, x
                                    256 ;	./timer.c: 149: uptime += (unsigned long) 1 << HOURS_FIRST_BIT;
      008AE2 90 CE 00 1A      [ 2]  257 	ldw	y, _uptime+2
      008AE6 CE 00 18         [ 2]  258 	ldw	x, _uptime+0
      008AE9 1C 00 40         [ 2]  259 	addw	x, #0x0040
      008AEC 90 CF 00 1A      [ 2]  260 	ldw	_uptime+2, y
      008AF0 CF 00 18         [ 2]  261 	ldw	_uptime+0, x
      008AF3                        262 00104$:
                                    263 ;	./timer.c: 153: if ( ( (unsigned char) (uptime >> HOURS_FIRST_BIT) & BITMASK (BITS_FOR_HOURS) ) == 24) {
      008AF3 CE 00 18         [ 2]  264 	ldw	x, _uptime+0
      008AF6 A6 40            [ 1]  265 	ld	a, #0x40
      008AF8 62               [ 2]  266 	div	x, a
      008AF9 9F               [ 1]  267 	ld	a, xl
      008AFA A4 1F            [ 1]  268 	and	a, #0x1f
      008AFC 97               [ 1]  269 	ld	xl, a
      008AFD 4F               [ 1]  270 	clr	a
      008AFE 90 5F            [ 1]  271 	clrw	y
      008B00 95               [ 1]  272 	ld	xh, a
      008B01 A3 00 18         [ 2]  273 	cpw	x, #0x0018
      008B04 26 24            [ 1]  274 	jrne	00108$
                                    275 ;	./timer.c: 154: uptime &= NBITMASK (DAYS_FIRST_BIT);
      008B06 90 5D            [ 2]  276 	tnzw	y
      008B08 26 20            [ 1]  277 	jrne	00108$
      008B0A 4F               [ 1]  278 	clr	a
      008B0B 97               [ 1]  279 	ld	xl, a
      008B0C C6 00 18         [ 1]  280 	ld	a, _uptime+0
      008B0F A4 F8            [ 1]  281 	and	a, #0xf8
      008B11 95               [ 1]  282 	ld	xh, a
      008B12 90 CF 00 1A      [ 2]  283 	ldw	_uptime+2, y
      008B16 CF 00 18         [ 2]  284 	ldw	_uptime+0, x
                                    285 ;	./timer.c: 155: uptime += (unsigned long) 1 << DAYS_FIRST_BIT;
      008B19 90 CE 00 1A      [ 2]  286 	ldw	y, _uptime+2
      008B1D CE 00 18         [ 2]  287 	ldw	x, _uptime+0
      008B20 1C 08 00         [ 2]  288 	addw	x, #0x0800
      008B23 90 CF 00 1A      [ 2]  289 	ldw	_uptime+2, y
      008B27 CF 00 18         [ 2]  290 	ldw	_uptime+0, x
      008B2A                        291 00108$:
                                    292 ;	./timer.c: 159: uptime++;
      008B2A CE 00 1A         [ 2]  293 	ldw	x, _uptime+2
      008B2D 1C 00 01         [ 2]  294 	addw	x, #0x0001
      008B30 90 CE 00 18      [ 2]  295 	ldw	y, _uptime+0
      008B34 24 02            [ 1]  296 	jrnc	00165$
      008B36 90 5C            [ 1]  297 	incw	y
      008B38                        298 00165$:
      008B38 CF 00 1A         [ 2]  299 	ldw	_uptime+2, x
      008B3B 90 CF 00 18      [ 2]  300 	ldw	_uptime+0, y
                                    301 ;	./timer.c: 162: if ( ( (unsigned char) getUptimeTicks() & 0x0F) == 1) {
      008B3F CD 8A 10         [ 4]  302 	call	_getUptimeTicks
      008B42 9F               [ 1]  303 	ld	a, xl
      008B43 A4 0F            [ 1]  304 	and	a, #0x0f
      008B45 97               [ 1]  305 	ld	xl, a
      008B46 4F               [ 1]  306 	clr	a
      008B47 95               [ 1]  307 	ld	xh, a
      008B48 5A               [ 2]  308 	decw	x
      008B49 26 05            [ 1]  309 	jrne	00115$
                                    310 ;	./timer.c: 163: refreshMenu();
      008B4B CD 93 5B         [ 4]  311 	call	_refreshMenu
      008B4E 20 1C            [ 2]  312 	jra	00116$
      008B50                        313 00115$:
                                    314 ;	./timer.c: 164: } else if ( ( (unsigned char) getUptimeTicks() & 0xFF) == 2) {
      008B50 CD 8A 10         [ 4]  315 	call	_getUptimeTicks
      008B53 4F               [ 1]  316 	clr	a
      008B54 95               [ 1]  317 	ld	xh, a
      008B55 A3 00 02         [ 2]  318 	cpw	x, #0x0002
      008B58 26 05            [ 1]  319 	jrne	00112$
                                    320 ;	./timer.c: 165: startADC();
      008B5A CD 8C B1         [ 4]  321 	call	_startADC
      008B5D 20 0D            [ 2]  322 	jra	00116$
      008B5F                        323 00112$:
                                    324 ;	./timer.c: 166: } else if ( ( (unsigned char) getUptimeTicks() & 0xFF) == 3) {
      008B5F CD 8A 10         [ 4]  325 	call	_getUptimeTicks
      008B62 4F               [ 1]  326 	clr	a
      008B63 95               [ 1]  327 	ld	xh, a
      008B64 A3 00 03         [ 2]  328 	cpw	x, #0x0003
      008B67 26 03            [ 1]  329 	jrne	00116$
                                    330 ;	./timer.c: 167: refreshRelay();
      008B69 CD 97 BA         [ 4]  331 	call	_refreshRelay
      008B6C                        332 00116$:
                                    333 ;	./timer.c: 170: refreshDisplay();
      008B6C CD 84 E9         [ 4]  334 	call	_refreshDisplay
                                    335 ;	./timer.c: 171: }
      008B6F 80               [11]  336 	iret
                                    337 	.area CODE
                                    338 	.area CONST
                                    339 	.area INITIALIZER
                                    340 	.area CABS (ABS)

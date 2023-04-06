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
      008868                         67 _initTimer:
                                     68 ;	./timer.c: 56: CLK_CKDIVR = 0x00;  // Set the frequency to 16 MHz
      008868 35 00 50 C6      [ 1]   69 	mov	0x50c6+0, #0x00
                                     70 ;	./timer.c: 57: TIM4_PSCR = 0x07;   // CLK / 128 = 125KHz
      00886C 35 07 53 47      [ 1]   71 	mov	0x5347+0, #0x07
                                     72 ;	./timer.c: 58: TIM4_ARR = 0xFA;    // 125KHz /  250(0xFA) = 500Hz
      008870 35 FA 53 48      [ 1]   73 	mov	0x5348+0, #0xfa
                                     74 ;	./timer.c: 59: TIM4_IER = 0x01;    // Enable interrupt on update event
      008874 35 01 53 43      [ 1]   75 	mov	0x5343+0, #0x01
                                     76 ;	./timer.c: 60: TIM4_CR1 = 0x05;    // Enable timer
      008878 35 05 53 40      [ 1]   77 	mov	0x5340+0, #0x05
                                     78 ;	./timer.c: 61: resetUptime();
                                     79 ;	./timer.c: 62: }
      00887C CC 88 7F         [ 2]   80 	jp	_resetUptime
                                     81 ;	./timer.c: 67: void resetUptime()
                                     82 ;	-----------------------------------------
                                     83 ;	 function resetUptime
                                     84 ;	-----------------------------------------
      00887F                         85 _resetUptime:
                                     86 ;	./timer.c: 69: uptime = 0;
      00887F 5F               [ 1]   87 	clrw	x
      008880 CF 00 1A         [ 2]   88 	ldw	_uptime+2, x
      008883 CF 00 18         [ 2]   89 	ldw	_uptime+0, x
                                     90 ;	./timer.c: 70: }
      008886 81               [ 4]   91 	ret
                                     92 ;	./timer.c: 78: unsigned long getUptime()
                                     93 ;	-----------------------------------------
                                     94 ;	 function getUptime
                                     95 ;	-----------------------------------------
      008887                         96 _getUptime:
                                     97 ;	./timer.c: 80: return uptime;
      008887 CE 00 1A         [ 2]   98 	ldw	x, _uptime+2
      00888A 90 CE 00 18      [ 2]   99 	ldw	y, _uptime+0
                                    100 ;	./timer.c: 81: }
      00888E 81               [ 4]  101 	ret
                                    102 ;	./timer.c: 87: unsigned int getUptimeTicks()
                                    103 ;	-----------------------------------------
                                    104 ;	 function getUptimeTicks
                                    105 ;	-----------------------------------------
      00888F                        106 _getUptimeTicks:
                                    107 ;	./timer.c: 89: return (unsigned int) (uptime & BITMASK (BITS_FOR_TICKS) );
      00888F CE 00 1A         [ 2]  108 	ldw	x, _uptime+2
      008892 9E               [ 1]  109 	ld	a, xh
      008893 A4 01            [ 1]  110 	and	a, #0x01
      008895 95               [ 1]  111 	ld	xh, a
                                    112 ;	./timer.c: 90: }
      008896 81               [ 4]  113 	ret
                                    114 ;	./timer.c: 96: unsigned char getUptimeSeconds()
                                    115 ;	-----------------------------------------
                                    116 ;	 function getUptimeSeconds
                                    117 ;	-----------------------------------------
      008897                        118 _getUptimeSeconds:
      008897 52 04            [ 2]  119 	sub	sp, #4
                                    120 ;	./timer.c: 98: return (unsigned char) ( (uptime >> SECONDS_FIRST_BIT) & BITMASK (BITS_FOR_SECONDS) );
      008899 C6 00 1A         [ 1]  121 	ld	a, _uptime+2
      00889C CE 00 18         [ 2]  122 	ldw	x, _uptime+0
      00889F 0F 01            [ 1]  123 	clr	(0x01, sp)
      0088A1 54               [ 2]  124 	srlw	x
      0088A2 46               [ 1]  125 	rrc	a
      0088A3 54               [ 2]  126 	srlw	x
      0088A4 46               [ 1]  127 	rrc	a
      0088A5 A4 3F            [ 1]  128 	and	a, #0x3f
                                    129 ;	./timer.c: 99: }
      0088A7 5B 04            [ 2]  130 	addw	sp, #4
      0088A9 81               [ 4]  131 	ret
                                    132 ;	./timer.c: 105: unsigned char getUptimeMinutes()
                                    133 ;	-----------------------------------------
                                    134 ;	 function getUptimeMinutes
                                    135 ;	-----------------------------------------
      0088AA                        136 _getUptimeMinutes:
                                    137 ;	./timer.c: 107: return (unsigned char) ( (uptime >> MINUTES_FIRST_BIT) & BITMASK (BITS_FOR_MINUTES) );
      0088AA CE 00 18         [ 2]  138 	ldw	x, _uptime+0
      0088AD 9F               [ 1]  139 	ld	a, xl
      0088AE A4 3F            [ 1]  140 	and	a, #0x3f
                                    141 ;	./timer.c: 108: }
      0088B0 81               [ 4]  142 	ret
                                    143 ;	./timer.c: 114: unsigned char getUptimeHours()
                                    144 ;	-----------------------------------------
                                    145 ;	 function getUptimeHours
                                    146 ;	-----------------------------------------
      0088B1                        147 _getUptimeHours:
                                    148 ;	./timer.c: 116: return (unsigned char) ( (uptime >> HOURS_FIRST_BIT) & BITMASK (BITS_FOR_HOURS) );
      0088B1 CE 00 18         [ 2]  149 	ldw	x, _uptime+0
      0088B4 A6 40            [ 1]  150 	ld	a, #0x40
      0088B6 62               [ 2]  151 	div	x, a
      0088B7 9F               [ 1]  152 	ld	a, xl
      0088B8 A4 1F            [ 1]  153 	and	a, #0x1f
                                    154 ;	./timer.c: 117: }
      0088BA 81               [ 4]  155 	ret
                                    156 ;	./timer.c: 123: unsigned char getUptimeDays()
                                    157 ;	-----------------------------------------
                                    158 ;	 function getUptimeDays
                                    159 ;	-----------------------------------------
      0088BB                        160 _getUptimeDays:
      0088BB 52 04            [ 2]  161 	sub	sp, #4
                                    162 ;	./timer.c: 125: return (unsigned char) ( (uptime >> DAYS_FIRST_BIT) & BITMASK (BITS_FOR_DAYS) );
      0088BD C6 00 18         [ 1]  163 	ld	a, _uptime+0
      0088C0 0F 01            [ 1]  164 	clr	(0x01, sp)
      0088C2 44               [ 1]  165 	srl	a
      0088C3 44               [ 1]  166 	srl	a
      0088C4 44               [ 1]  167 	srl	a
      0088C5 A4 3F            [ 1]  168 	and	a, #0x3f
                                    169 ;	./timer.c: 126: }
      0088C7 5B 04            [ 2]  170 	addw	sp, #4
      0088C9 81               [ 4]  171 	ret
                                    172 ;	./timer.c: 132: void TIM4_UPD_handler() __interrupt (23)
                                    173 ;	-----------------------------------------
                                    174 ;	 function TIM4_UPD_handler
                                    175 ;	-----------------------------------------
      0088CA                        176 _TIM4_UPD_handler:
      0088CA 4F               [ 1]  177 	clr	a
      0088CB 62               [ 2]  178 	div	x, a
                                    179 ;	./timer.c: 134: TIM4_SR &= ~TIM_SR1_UIF; // Reset flag
      0088CC 72 11 53 44      [ 1]  180 	bres	21316, #0
                                    181 ;	./timer.c: 136: if ( ( (unsigned int) (uptime & BITMASK (BITS_FOR_TICKS) ) ) >= TICKS_IN_SECOND) {
      0088D0 CE 00 1A         [ 2]  182 	ldw	x, _uptime+2
      0088D3 9E               [ 1]  183 	ld	a, xh
      0088D4 A4 01            [ 1]  184 	and	a, #0x01
      0088D6 95               [ 1]  185 	ld	xh, a
      0088D7 A3 01 F4         [ 2]  186 	cpw	x, #0x01f4
      0088DA 24 03            [ 1]  187 	jrnc	00154$
      0088DC CC 89 A9         [ 2]  188 	jp	00108$
      0088DF                        189 00154$:
                                    190 ;	./timer.c: 137: uptime &= NBITMASK (SECONDS_FIRST_BIT);
      0088DF 4F               [ 1]  191 	clr	a
      0088E0 97               [ 1]  192 	ld	xl, a
      0088E1 C6 00 1A         [ 1]  193 	ld	a, _uptime+2
      0088E4 A4 FC            [ 1]  194 	and	a, #0xfc
      0088E6 95               [ 1]  195 	ld	xh, a
      0088E7 90 CE 00 18      [ 2]  196 	ldw	y, _uptime+0
      0088EB CF 00 1A         [ 2]  197 	ldw	_uptime+2, x
      0088EE 90 CF 00 18      [ 2]  198 	ldw	_uptime+0, y
                                    199 ;	./timer.c: 138: uptime += (unsigned long) 1 << SECONDS_FIRST_BIT;
      0088F2 CE 00 1A         [ 2]  200 	ldw	x, _uptime+2
      0088F5 1C 04 00         [ 2]  201 	addw	x, #0x0400
      0088F8 90 CE 00 18      [ 2]  202 	ldw	y, _uptime+0
      0088FC 24 02            [ 1]  203 	jrnc	00155$
      0088FE 90 5C            [ 1]  204 	incw	y
      008900                        205 00155$:
      008900 CF 00 1A         [ 2]  206 	ldw	_uptime+2, x
      008903 90 CF 00 18      [ 2]  207 	ldw	_uptime+0, y
                                    208 ;	./timer.c: 141: if ( ( (unsigned char) (uptime >> SECONDS_FIRST_BIT) & BITMASK (BITS_FOR_SECONDS) ) == 60) {
      008907 C6 00 1A         [ 1]  209 	ld	a, _uptime+2
      00890A CE 00 18         [ 2]  210 	ldw	x, _uptime+0
      00890D 54               [ 2]  211 	srlw	x
      00890E 46               [ 1]  212 	rrc	a
      00890F 54               [ 2]  213 	srlw	x
      008910 46               [ 1]  214 	rrc	a
      008911 A4 3F            [ 1]  215 	and	a, #0x3f
      008913 97               [ 1]  216 	ld	xl, a
      008914 4F               [ 1]  217 	clr	a
      008915 90 5F            [ 1]  218 	clrw	y
      008917 95               [ 1]  219 	ld	xh, a
      008918 A3 00 3C         [ 2]  220 	cpw	x, #0x003c
      00891B 26 1F            [ 1]  221 	jrne	00102$
      00891D 90 5D            [ 2]  222 	tnzw	y
      00891F 26 1B            [ 1]  223 	jrne	00102$
                                    224 ;	./timer.c: 142: uptime &= NBITMASK (MINUTES_FIRST_BIT);
      008921 5F               [ 1]  225 	clrw	x
      008922 90 CE 00 18      [ 2]  226 	ldw	y, _uptime+0
      008926 CF 00 1A         [ 2]  227 	ldw	_uptime+2, x
      008929 90 CF 00 18      [ 2]  228 	ldw	_uptime+0, y
                                    229 ;	./timer.c: 143: uptime += (unsigned long) 1 << MINUTES_FIRST_BIT;
      00892D 90 CE 00 1A      [ 2]  230 	ldw	y, _uptime+2
      008931 CE 00 18         [ 2]  231 	ldw	x, _uptime+0
      008934 5C               [ 1]  232 	incw	x
      008935 90 CF 00 1A      [ 2]  233 	ldw	_uptime+2, y
      008939 CF 00 18         [ 2]  234 	ldw	_uptime+0, x
      00893C                        235 00102$:
                                    236 ;	./timer.c: 147: if ( ( (unsigned char) (uptime >> MINUTES_FIRST_BIT) & BITMASK (BITS_FOR_MINUTES) ) == 60) {
      00893C CE 00 18         [ 2]  237 	ldw	x, _uptime+0
      00893F 9F               [ 1]  238 	ld	a, xl
      008940 A4 3F            [ 1]  239 	and	a, #0x3f
      008942 97               [ 1]  240 	ld	xl, a
      008943 4F               [ 1]  241 	clr	a
      008944 90 5F            [ 1]  242 	clrw	y
      008946 95               [ 1]  243 	ld	xh, a
      008947 A3 00 3C         [ 2]  244 	cpw	x, #0x003c
      00894A 26 26            [ 1]  245 	jrne	00104$
                                    246 ;	./timer.c: 148: uptime &= NBITMASK (HOURS_FIRST_BIT);
      00894C 90 5D            [ 2]  247 	tnzw	y
      00894E 26 22            [ 1]  248 	jrne	00104$
      008950 C6 00 19         [ 1]  249 	ld	a, _uptime+1
      008953 A4 C0            [ 1]  250 	and	a, #0xc0
      008955 97               [ 1]  251 	ld	xl, a
      008956 C6 00 18         [ 1]  252 	ld	a, _uptime+0
      008959 95               [ 1]  253 	ld	xh, a
      00895A 90 CF 00 1A      [ 2]  254 	ldw	_uptime+2, y
      00895E CF 00 18         [ 2]  255 	ldw	_uptime+0, x
                                    256 ;	./timer.c: 149: uptime += (unsigned long) 1 << HOURS_FIRST_BIT;
      008961 90 CE 00 1A      [ 2]  257 	ldw	y, _uptime+2
      008965 CE 00 18         [ 2]  258 	ldw	x, _uptime+0
      008968 1C 00 40         [ 2]  259 	addw	x, #0x0040
      00896B 90 CF 00 1A      [ 2]  260 	ldw	_uptime+2, y
      00896F CF 00 18         [ 2]  261 	ldw	_uptime+0, x
      008972                        262 00104$:
                                    263 ;	./timer.c: 153: if ( ( (unsigned char) (uptime >> HOURS_FIRST_BIT) & BITMASK (BITS_FOR_HOURS) ) == 24) {
      008972 CE 00 18         [ 2]  264 	ldw	x, _uptime+0
      008975 A6 40            [ 1]  265 	ld	a, #0x40
      008977 62               [ 2]  266 	div	x, a
      008978 9F               [ 1]  267 	ld	a, xl
      008979 A4 1F            [ 1]  268 	and	a, #0x1f
      00897B 97               [ 1]  269 	ld	xl, a
      00897C 4F               [ 1]  270 	clr	a
      00897D 90 5F            [ 1]  271 	clrw	y
      00897F 95               [ 1]  272 	ld	xh, a
      008980 A3 00 18         [ 2]  273 	cpw	x, #0x0018
      008983 26 24            [ 1]  274 	jrne	00108$
                                    275 ;	./timer.c: 154: uptime &= NBITMASK (DAYS_FIRST_BIT);
      008985 90 5D            [ 2]  276 	tnzw	y
      008987 26 20            [ 1]  277 	jrne	00108$
      008989 4F               [ 1]  278 	clr	a
      00898A 97               [ 1]  279 	ld	xl, a
      00898B C6 00 18         [ 1]  280 	ld	a, _uptime+0
      00898E A4 F8            [ 1]  281 	and	a, #0xf8
      008990 95               [ 1]  282 	ld	xh, a
      008991 90 CF 00 1A      [ 2]  283 	ldw	_uptime+2, y
      008995 CF 00 18         [ 2]  284 	ldw	_uptime+0, x
                                    285 ;	./timer.c: 155: uptime += (unsigned long) 1 << DAYS_FIRST_BIT;
      008998 90 CE 00 1A      [ 2]  286 	ldw	y, _uptime+2
      00899C CE 00 18         [ 2]  287 	ldw	x, _uptime+0
      00899F 1C 08 00         [ 2]  288 	addw	x, #0x0800
      0089A2 90 CF 00 1A      [ 2]  289 	ldw	_uptime+2, y
      0089A6 CF 00 18         [ 2]  290 	ldw	_uptime+0, x
      0089A9                        291 00108$:
                                    292 ;	./timer.c: 159: uptime++;
      0089A9 CE 00 1A         [ 2]  293 	ldw	x, _uptime+2
      0089AC 1C 00 01         [ 2]  294 	addw	x, #0x0001
      0089AF 90 CE 00 18      [ 2]  295 	ldw	y, _uptime+0
      0089B3 24 02            [ 1]  296 	jrnc	00165$
      0089B5 90 5C            [ 1]  297 	incw	y
      0089B7                        298 00165$:
      0089B7 CF 00 1A         [ 2]  299 	ldw	_uptime+2, x
      0089BA 90 CF 00 18      [ 2]  300 	ldw	_uptime+0, y
                                    301 ;	./timer.c: 162: if ( ( (unsigned char) getUptimeTicks() & 0x0F) == 1) {
      0089BE CD 88 8F         [ 4]  302 	call	_getUptimeTicks
      0089C1 9F               [ 1]  303 	ld	a, xl
      0089C2 A4 0F            [ 1]  304 	and	a, #0x0f
      0089C4 97               [ 1]  305 	ld	xl, a
      0089C5 4F               [ 1]  306 	clr	a
      0089C6 95               [ 1]  307 	ld	xh, a
      0089C7 5A               [ 2]  308 	decw	x
      0089C8 26 05            [ 1]  309 	jrne	00115$
                                    310 ;	./timer.c: 163: refreshMenu();
      0089CA CD 8F 29         [ 4]  311 	call	_refreshMenu
      0089CD 20 1C            [ 2]  312 	jra	00116$
      0089CF                        313 00115$:
                                    314 ;	./timer.c: 164: } else if ( ( (unsigned char) getUptimeTicks() & 0xFF) == 2) {
      0089CF CD 88 8F         [ 4]  315 	call	_getUptimeTicks
      0089D2 4F               [ 1]  316 	clr	a
      0089D3 95               [ 1]  317 	ld	xh, a
      0089D4 A3 00 02         [ 2]  318 	cpw	x, #0x0002
      0089D7 26 05            [ 1]  319 	jrne	00112$
                                    320 ;	./timer.c: 165: startADC();
      0089D9 CD 8A E1         [ 4]  321 	call	_startADC
      0089DC 20 0D            [ 2]  322 	jra	00116$
      0089DE                        323 00112$:
                                    324 ;	./timer.c: 166: } else if ( ( (unsigned char) getUptimeTicks() & 0xFF) == 3) {
      0089DE CD 88 8F         [ 4]  325 	call	_getUptimeTicks
      0089E1 4F               [ 1]  326 	clr	a
      0089E2 95               [ 1]  327 	ld	xh, a
      0089E3 A3 00 03         [ 2]  328 	cpw	x, #0x0003
      0089E6 26 03            [ 1]  329 	jrne	00116$
                                    330 ;	./timer.c: 167: refreshRelay();
      0089E8 CD 93 16         [ 4]  331 	call	_refreshRelay
      0089EB                        332 00116$:
                                    333 ;	./timer.c: 170: refreshDisplay();
      0089EB CD 83 A6         [ 4]  334 	call	_refreshDisplay
                                    335 ;	./timer.c: 171: }
      0089EE 80               [11]  336 	iret
                                    337 	.area CODE
                                    338 	.area CONST
                                    339 	.area INITIALIZER
                                    340 	.area CABS (ABS)

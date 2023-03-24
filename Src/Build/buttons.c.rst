                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module buttons
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _debounce
                                     12 	.globl _getUptime
                                     13 	.globl _feedMenu
                                     14 	.globl _initButtons
                                     15 	.globl _getButton
                                     16 	.globl _getButtonDiff
                                     17 	.globl _getButton1
                                     18 	.globl _getButton2
                                     19 	.globl _getButton3
                                     20 	.globl _isButton1
                                     21 	.globl _isButton2
                                     22 	.globl _isButton3
                                     23 	.globl _EXTI2_handler
                                     24 ;--------------------------------------------------------
                                     25 ; ram data
                                     26 ;--------------------------------------------------------
                                     27 	.area DATA
      00001C                         28 _status:
      00001C                         29 	.ds 1
      00001D                         30 _diff:
      00001D                         31 	.ds 1
                                     32 ;--------------------------------------------------------
                                     33 ; ram data
                                     34 ;--------------------------------------------------------
                                     35 	.area INITIALIZED
      000045                         36 _debounce_buttons:
      000045                         37 	.ds 4
                                     38 ;--------------------------------------------------------
                                     39 ; absolute external ram data
                                     40 ;--------------------------------------------------------
                                     41 	.area DABS (ABS)
                                     42 
                                     43 ; default segment ordering for linker
                                     44 	.area HOME
                                     45 	.area GSINIT
                                     46 	.area GSFINAL
                                     47 	.area CONST
                                     48 	.area INITIALIZER
                                     49 	.area CODE
                                     50 
                                     51 ;--------------------------------------------------------
                                     52 ; global & static initialisations
                                     53 ;--------------------------------------------------------
                                     54 	.area HOME
                                     55 	.area GSINIT
                                     56 	.area GSFINAL
                                     57 	.area GSINIT
                                     58 ;--------------------------------------------------------
                                     59 ; Home
                                     60 ;--------------------------------------------------------
                                     61 	.area HOME
                                     62 	.area HOME
                                     63 ;--------------------------------------------------------
                                     64 ; code
                                     65 ;--------------------------------------------------------
                                     66 	.area CODE
                                     67 ;	./buttons.c: 48: void initButtons()
                                     68 ;	-----------------------------------------
                                     69 ;	 function initButtons
                                     70 ;	-----------------------------------------
      008B70                         71 _initButtons:
                                     72 ;	./buttons.c: 50: PC_CR1 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;
      008B70 C6 50 0D         [ 1]   73 	ld	a, 0x500d
      008B73 AA 38            [ 1]   74 	or	a, #0x38
      008B75 C7 50 0D         [ 1]   75 	ld	0x500d, a
                                     76 ;	./buttons.c: 51: PC_CR2 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;
      008B78 C6 50 0E         [ 1]   77 	ld	a, 0x500e
      008B7B AA 38            [ 1]   78 	or	a, #0x38
      008B7D C7 50 0E         [ 1]   79 	ld	0x500e, a
                                     80 ;	./buttons.c: 52: status = ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
      008B80 C6 50 0B         [ 1]   81 	ld	a, 0x500b
      008B83 A4 38            [ 1]   82 	and	a, #0x38
      008B85 43               [ 1]   83 	cpl	a
      008B86 C7 00 1C         [ 1]   84 	ld	_status+0, a
                                     85 ;	./buttons.c: 53: diff = 0;
      008B89 72 5F 00 1D      [ 1]   86 	clr	_diff+0
                                     87 ;	./buttons.c: 54: EXTI_CR1 |= 0x30;   // generate interrupt on falling and rising front.
      008B8D C6 50 A0         [ 1]   88 	ld	a, 0x50a0
      008B90 AA 30            [ 1]   89 	or	a, #0x30
      008B92 C7 50 A0         [ 1]   90 	ld	0x50a0, a
                                     91 ;	./buttons.c: 55: }
      008B95 81               [ 4]   92 	ret
                                     93 ;	./buttons.c: 62: unsigned char getButton()
                                     94 ;	-----------------------------------------
                                     95 ;	 function getButton
                                     96 ;	-----------------------------------------
      008B96                         97 _getButton:
                                     98 ;	./buttons.c: 64: return status;
      008B96 C6 00 1C         [ 1]   99 	ld	a, _status+0
                                    100 ;	./buttons.c: 65: }
      008B99 81               [ 4]  101 	ret
                                    102 ;	./buttons.c: 71: unsigned char getButtonDiff()
                                    103 ;	-----------------------------------------
                                    104 ;	 function getButtonDiff
                                    105 ;	-----------------------------------------
      008B9A                        106 _getButtonDiff:
                                    107 ;	./buttons.c: 73: return diff;
      008B9A C6 00 1D         [ 1]  108 	ld	a, _diff+0
                                    109 ;	./buttons.c: 74: }
      008B9D 81               [ 4]  110 	ret
                                    111 ;	./buttons.c: 80: bool getButton1()
                                    112 ;	-----------------------------------------
                                    113 ;	 function getButton1
                                    114 ;	-----------------------------------------
      008B9E                        115 _getButton1:
                                    116 ;	./buttons.c: 82: return status & BUTTON1_BIT;
      008B9E C6 00 1C         [ 1]  117 	ld	a, _status+0
      008BA1 4E               [ 1]  118 	swap	a
      008BA2 48               [ 1]  119 	sll	a
      008BA3 4F               [ 1]  120 	clr	a
      008BA4 49               [ 1]  121 	rlc	a
                                    122 ;	./buttons.c: 83: }
      008BA5 81               [ 4]  123 	ret
                                    124 ;	./buttons.c: 89: bool getButton2()
                                    125 ;	-----------------------------------------
                                    126 ;	 function getButton2
                                    127 ;	-----------------------------------------
      008BA6                        128 _getButton2:
                                    129 ;	./buttons.c: 91: return status & BUTTON2_BIT;
      008BA6 C6 00 1C         [ 1]  130 	ld	a, _status+0
      008BA9 44               [ 1]  131 	srl	a
      008BAA 44               [ 1]  132 	srl	a
      008BAB 44               [ 1]  133 	srl	a
      008BAC 44               [ 1]  134 	srl	a
      008BAD A4 01            [ 1]  135 	and	a, #0x01
                                    136 ;	./buttons.c: 92: }
      008BAF 81               [ 4]  137 	ret
                                    138 ;	./buttons.c: 98: bool getButton3()
                                    139 ;	-----------------------------------------
                                    140 ;	 function getButton3
                                    141 ;	-----------------------------------------
      008BB0                        142 _getButton3:
                                    143 ;	./buttons.c: 100: return status & BUTTON3_BIT;
      008BB0 C6 00 1C         [ 1]  144 	ld	a, _status+0
      008BB3 4E               [ 1]  145 	swap	a
      008BB4 44               [ 1]  146 	srl	a
      008BB5 A4 01            [ 1]  147 	and	a, #0x01
                                    148 ;	./buttons.c: 101: }
      008BB7 81               [ 4]  149 	ret
                                    150 ;	./buttons.c: 107: bool isButton1()
                                    151 ;	-----------------------------------------
                                    152 ;	 function isButton1
                                    153 ;	-----------------------------------------
      008BB8                        154 _isButton1:
                                    155 ;	./buttons.c: 109: if (diff & BUTTON1_BIT) {
      008BB8 C6 00 1D         [ 1]  156 	ld	a, _diff+0
      008BBB A5 08            [ 1]  157 	bcp	a, #0x08
      008BBD 27 07            [ 1]  158 	jreq	00102$
                                    159 ;	./buttons.c: 110: diff &= ~BUTTON1_BIT;
      008BBF 72 17 00 1D      [ 1]  160 	bres	_diff+0, #3
                                    161 ;	./buttons.c: 111: return true;
      008BC3 A6 01            [ 1]  162 	ld	a, #0x01
      008BC5 81               [ 4]  163 	ret
      008BC6                        164 00102$:
                                    165 ;	./buttons.c: 114: return false;
      008BC6 4F               [ 1]  166 	clr	a
                                    167 ;	./buttons.c: 115: }
      008BC7 81               [ 4]  168 	ret
                                    169 ;	./buttons.c: 121: bool isButton2()
                                    170 ;	-----------------------------------------
                                    171 ;	 function isButton2
                                    172 ;	-----------------------------------------
      008BC8                        173 _isButton2:
                                    174 ;	./buttons.c: 123: if (diff & BUTTON2_BIT) {
      008BC8 C6 00 1D         [ 1]  175 	ld	a, _diff+0
      008BCB A5 10            [ 1]  176 	bcp	a, #0x10
      008BCD 27 07            [ 1]  177 	jreq	00102$
                                    178 ;	./buttons.c: 124: diff &= ~BUTTON2_BIT;
      008BCF 72 19 00 1D      [ 1]  179 	bres	_diff+0, #4
                                    180 ;	./buttons.c: 125: return true;
      008BD3 A6 01            [ 1]  181 	ld	a, #0x01
      008BD5 81               [ 4]  182 	ret
      008BD6                        183 00102$:
                                    184 ;	./buttons.c: 128: return false;
      008BD6 4F               [ 1]  185 	clr	a
                                    186 ;	./buttons.c: 129: }
      008BD7 81               [ 4]  187 	ret
                                    188 ;	./buttons.c: 135: bool isButton3()
                                    189 ;	-----------------------------------------
                                    190 ;	 function isButton3
                                    191 ;	-----------------------------------------
      008BD8                        192 _isButton3:
                                    193 ;	./buttons.c: 137: if (diff & BUTTON3_BIT) {
      008BD8 C6 00 1D         [ 1]  194 	ld	a, _diff+0
      008BDB A5 20            [ 1]  195 	bcp	a, #0x20
      008BDD 27 07            [ 1]  196 	jreq	00102$
                                    197 ;	./buttons.c: 138: diff &= ~BUTTON3_BIT;
      008BDF 72 1B 00 1D      [ 1]  198 	bres	_diff+0, #5
                                    199 ;	./buttons.c: 139: return true;
      008BE3 A6 01            [ 1]  200 	ld	a, #0x01
      008BE5 81               [ 4]  201 	ret
      008BE6                        202 00102$:
                                    203 ;	./buttons.c: 142: return false;
      008BE6 4F               [ 1]  204 	clr	a
                                    205 ;	./buttons.c: 143: }
      008BE7 81               [ 4]  206 	ret
                                    207 ;	./buttons.c: 145: bool debounce()
                                    208 ;	-----------------------------------------
                                    209 ;	 function debounce
                                    210 ;	-----------------------------------------
      008BE8                        211 _debounce:
      008BE8 52 08            [ 2]  212 	sub	sp, #8
                                    213 ;	./buttons.c: 147: unsigned long _debounce = getUptime();
      008BEA CD 8A 08         [ 4]  214 	call	_getUptime
      008BED 1F 03            [ 2]  215 	ldw	(0x03, sp), x
      008BEF 17 01            [ 2]  216 	ldw	(0x01, sp), y
                                    217 ;	./buttons.c: 149: if((_debounce - debounce_buttons) > 75) {
      008BF1 1E 03            [ 2]  218 	ldw	x, (0x03, sp)
      008BF3 72 B0 00 47      [ 2]  219 	subw	x, _debounce_buttons+2
      008BF7 1F 07            [ 2]  220 	ldw	(0x07, sp), x
      008BF9 7B 02            [ 1]  221 	ld	a, (0x02, sp)
      008BFB C2 00 46         [ 1]  222 	sbc	a, _debounce_buttons+1
      008BFE 6B 06            [ 1]  223 	ld	(0x06, sp), a
      008C00 7B 01            [ 1]  224 	ld	a, (0x01, sp)
      008C02 C2 00 45         [ 1]  225 	sbc	a, _debounce_buttons+0
      008C05 6B 05            [ 1]  226 	ld	(0x05, sp), a
      008C07 AE 00 4B         [ 2]  227 	ldw	x, #0x004b
      008C0A 13 07            [ 2]  228 	cpw	x, (0x07, sp)
      008C0C 4F               [ 1]  229 	clr	a
      008C0D 12 06            [ 1]  230 	sbc	a, (0x06, sp)
      008C0F 4F               [ 1]  231 	clr	a
      008C10 12 05            [ 1]  232 	sbc	a, (0x05, sp)
      008C12 24 0D            [ 1]  233 	jrnc	00102$
                                    234 ;	./buttons.c: 150: debounce_buttons = _debounce;
      008C14 1E 03            [ 2]  235 	ldw	x, (0x03, sp)
      008C16 CF 00 47         [ 2]  236 	ldw	_debounce_buttons+2, x
      008C19 1E 01            [ 2]  237 	ldw	x, (0x01, sp)
      008C1B CF 00 45         [ 2]  238 	ldw	_debounce_buttons+0, x
                                    239 ;	./buttons.c: 151: return true;
      008C1E A6 01            [ 1]  240 	ld	a, #0x01
                                    241 ;	./buttons.c: 153: return false;
      008C20 21                     242 	.byte 0x21
      008C21                        243 00102$:
      008C21 4F               [ 1]  244 	clr	a
      008C22                        245 00104$:
                                    246 ;	./buttons.c: 155: }
      008C22 5B 08            [ 2]  247 	addw	sp, #8
      008C24 81               [ 4]  248 	ret
                                    249 ;	./buttons.c: 161: void EXTI2_handler() __interrupt (5)
                                    250 ;	-----------------------------------------
                                    251 ;	 function EXTI2_handler
                                    252 ;	-----------------------------------------
      008C25                        253 _EXTI2_handler:
      008C25 4F               [ 1]  254 	clr	a
      008C26 62               [ 2]  255 	div	x, a
                                    256 ;	./buttons.c: 164: diff = status ^ ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
      008C27 C6 50 0B         [ 1]  257 	ld	a, 0x500b
      008C2A A4 38            [ 1]  258 	and	a, #0x38
      008C2C 43               [ 1]  259 	cpl	a
      008C2D C8 00 1C         [ 1]  260 	xor	a, _status+0
      008C30 C7 00 1D         [ 1]  261 	ld	_diff+0, a
                                    262 ;	./buttons.c: 165: status = ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
      008C33 C6 50 0B         [ 1]  263 	ld	a, 0x500b
      008C36 A4 38            [ 1]  264 	and	a, #0x38
      008C38 43               [ 1]  265 	cpl	a
      008C39 C7 00 1C         [ 1]  266 	ld	_status+0, a
                                    267 ;	./buttons.c: 168: if (isButton1() ) {
      008C3C CD 8B B8         [ 4]  268 	call	_isButton1
      008C3F 4D               [ 1]  269 	tnz	a
      008C40 27 13            [ 1]  270 	jreq	00126$
                                    271 ;	./buttons.c: 169: if(debounce()) {
      008C42 CD 8B E8         [ 4]  272 	call	_debounce
      008C45 4D               [ 1]  273 	tnz	a
      008C46 27 43            [ 1]  274 	jreq	00128$
                                    275 ;	./buttons.c: 170: if (getButton1() ) {
      008C48 CD 8B 9E         [ 4]  276 	call	_getButton1
      008C4B 4D               [ 1]  277 	tnz	a
      008C4C 27 03            [ 1]  278 	jreq	00102$
                                    279 ;	./buttons.c: 171: event = MENU_EVENT_PUSH_BUTTON1;
      008C4E 4F               [ 1]  280 	clr	a
      008C4F 20 35            [ 2]  281 	jra	00127$
      008C51                        282 00102$:
                                    283 ;	./buttons.c: 173: event = MENU_EVENT_RELEASE_BUTTON1;
      008C51 A6 03            [ 1]  284 	ld	a, #0x03
                                    285 ;	./buttons.c: 176: return;
      008C53 20 31            [ 2]  286 	jra	00127$
      008C55                        287 00126$:
                                    288 ;	./buttons.c: 178: } else if (isButton2() ) {
      008C55 CD 8B C8         [ 4]  289 	call	_isButton2
      008C58 4D               [ 1]  290 	tnz	a
      008C59 27 14            [ 1]  291 	jreq	00123$
                                    292 ;	./buttons.c: 179: if(debounce()) {
      008C5B CD 8B E8         [ 4]  293 	call	_debounce
      008C5E 4D               [ 1]  294 	tnz	a
      008C5F 27 2A            [ 1]  295 	jreq	00128$
                                    296 ;	./buttons.c: 180: if (getButton2() ) {
      008C61 CD 8B A6         [ 4]  297 	call	_getButton2
      008C64 4D               [ 1]  298 	tnz	a
      008C65 27 04            [ 1]  299 	jreq	00108$
                                    300 ;	./buttons.c: 181: event = MENU_EVENT_PUSH_BUTTON2;
      008C67 A6 01            [ 1]  301 	ld	a, #0x01
      008C69 20 1B            [ 2]  302 	jra	00127$
      008C6B                        303 00108$:
                                    304 ;	./buttons.c: 183: event = MENU_EVENT_RELEASE_BUTTON2;
      008C6B A6 04            [ 1]  305 	ld	a, #0x04
                                    306 ;	./buttons.c: 186: return;
      008C6D 20 17            [ 2]  307 	jra	00127$
      008C6F                        308 00123$:
                                    309 ;	./buttons.c: 188: } else if (isButton3() ) {
      008C6F CD 8B D8         [ 4]  310 	call	_isButton3
      008C72 4D               [ 1]  311 	tnz	a
      008C73 27 16            [ 1]  312 	jreq	00128$
                                    313 ;	./buttons.c: 189: if(debounce()) {
      008C75 CD 8B E8         [ 4]  314 	call	_debounce
      008C78 4D               [ 1]  315 	tnz	a
      008C79 27 10            [ 1]  316 	jreq	00128$
                                    317 ;	./buttons.c: 190: if (getButton3() ) {
      008C7B CD 8B B0         [ 4]  318 	call	_getButton3
      008C7E 4D               [ 1]  319 	tnz	a
      008C7F 27 03            [ 1]  320 	jreq	00114$
                                    321 ;	./buttons.c: 191: event = MENU_EVENT_PUSH_BUTTON3;
      008C81 A6 02            [ 1]  322 	ld	a, #0x02
                                    323 ;	./buttons.c: 193: event = MENU_EVENT_RELEASE_BUTTON3;
                                    324 ;	./buttons.c: 196: return;
                                    325 ;	./buttons.c: 199: return;
      008C83 C5                     326 	.byte 0xc5
      008C84                        327 00114$:
      008C84 A6 05            [ 1]  328 	ld	a, #0x05
      008C86                        329 00127$:
                                    330 ;	./buttons.c: 202: feedMenu (event);
      008C86 88               [ 1]  331 	push	a
      008C87 CD 8E D7         [ 4]  332 	call	_feedMenu
      008C8A 84               [ 1]  333 	pop	a
      008C8B                        334 00128$:
                                    335 ;	./buttons.c: 203: }
      008C8B 80               [11]  336 	iret
                                    337 	.area CODE
                                    338 	.area CONST
                                    339 	.area INITIALIZER
      008245                        340 __xinit__debounce_buttons:
      008245 00 00 00 00            341 	.byte #0x00, #0x00, #0x00, #0x00	; 0
                                    342 	.area CABS (ABS)

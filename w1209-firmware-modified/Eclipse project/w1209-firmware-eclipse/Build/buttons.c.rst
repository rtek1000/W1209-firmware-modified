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
                                     11 	.globl _feedMenu
                                     12 	.globl _initButtons
                                     13 	.globl _getButton
                                     14 	.globl _getButtonDiff
                                     15 	.globl _getButton1
                                     16 	.globl _getButton2
                                     17 	.globl _getButton3
                                     18 	.globl _isButton1
                                     19 	.globl _isButton2
                                     20 	.globl _isButton3
                                     21 	.globl _EXTI2_handler
                                     22 ;--------------------------------------------------------
                                     23 ; ram data
                                     24 ;--------------------------------------------------------
                                     25 	.area DATA
      00001C                         26 _status:
      00001C                         27 	.ds 1
      00001D                         28 _diff:
      00001D                         29 	.ds 1
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
                                     63 ;	./buttons.c: 45: void initButtons()
                                     64 ;	-----------------------------------------
                                     65 ;	 function initButtons
                                     66 ;	-----------------------------------------
      0089EF                         67 _initButtons:
                                     68 ;	./buttons.c: 47: PC_CR1 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;
      0089EF C6 50 0D         [ 1]   69 	ld	a, 0x500d
      0089F2 AA 38            [ 1]   70 	or	a, #0x38
      0089F4 C7 50 0D         [ 1]   71 	ld	0x500d, a
                                     72 ;	./buttons.c: 48: PC_CR2 |= BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT;
      0089F7 C6 50 0E         [ 1]   73 	ld	a, 0x500e
      0089FA AA 38            [ 1]   74 	or	a, #0x38
      0089FC C7 50 0E         [ 1]   75 	ld	0x500e, a
                                     76 ;	./buttons.c: 49: status = ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
      0089FF C6 50 0B         [ 1]   77 	ld	a, 0x500b
      008A02 A4 38            [ 1]   78 	and	a, #0x38
      008A04 43               [ 1]   79 	cpl	a
      008A05 C7 00 1C         [ 1]   80 	ld	_status+0, a
                                     81 ;	./buttons.c: 50: diff = 0;
      008A08 72 5F 00 1D      [ 1]   82 	clr	_diff+0
                                     83 ;	./buttons.c: 51: EXTI_CR1 |= 0x30;   // generate interrupt on falling and rising front.
      008A0C C6 50 A0         [ 1]   84 	ld	a, 0x50a0
      008A0F AA 30            [ 1]   85 	or	a, #0x30
      008A11 C7 50 A0         [ 1]   86 	ld	0x50a0, a
                                     87 ;	./buttons.c: 52: }
      008A14 81               [ 4]   88 	ret
                                     89 ;	./buttons.c: 59: unsigned char getButton()
                                     90 ;	-----------------------------------------
                                     91 ;	 function getButton
                                     92 ;	-----------------------------------------
      008A15                         93 _getButton:
                                     94 ;	./buttons.c: 61: return status;
      008A15 C6 00 1C         [ 1]   95 	ld	a, _status+0
                                     96 ;	./buttons.c: 62: }
      008A18 81               [ 4]   97 	ret
                                     98 ;	./buttons.c: 68: unsigned char getButtonDiff()
                                     99 ;	-----------------------------------------
                                    100 ;	 function getButtonDiff
                                    101 ;	-----------------------------------------
      008A19                        102 _getButtonDiff:
                                    103 ;	./buttons.c: 70: return diff;
      008A19 C6 00 1D         [ 1]  104 	ld	a, _diff+0
                                    105 ;	./buttons.c: 71: }
      008A1C 81               [ 4]  106 	ret
                                    107 ;	./buttons.c: 77: bool getButton1()
                                    108 ;	-----------------------------------------
                                    109 ;	 function getButton1
                                    110 ;	-----------------------------------------
      008A1D                        111 _getButton1:
                                    112 ;	./buttons.c: 79: return status & BUTTON1_BIT;
      008A1D C6 00 1C         [ 1]  113 	ld	a, _status+0
      008A20 4E               [ 1]  114 	swap	a
      008A21 48               [ 1]  115 	sll	a
      008A22 4F               [ 1]  116 	clr	a
      008A23 49               [ 1]  117 	rlc	a
                                    118 ;	./buttons.c: 80: }
      008A24 81               [ 4]  119 	ret
                                    120 ;	./buttons.c: 86: bool getButton2()
                                    121 ;	-----------------------------------------
                                    122 ;	 function getButton2
                                    123 ;	-----------------------------------------
      008A25                        124 _getButton2:
                                    125 ;	./buttons.c: 88: return status & BUTTON2_BIT;
      008A25 C6 00 1C         [ 1]  126 	ld	a, _status+0
      008A28 44               [ 1]  127 	srl	a
      008A29 44               [ 1]  128 	srl	a
      008A2A 44               [ 1]  129 	srl	a
      008A2B 44               [ 1]  130 	srl	a
      008A2C A4 01            [ 1]  131 	and	a, #0x01
                                    132 ;	./buttons.c: 89: }
      008A2E 81               [ 4]  133 	ret
                                    134 ;	./buttons.c: 95: bool getButton3()
                                    135 ;	-----------------------------------------
                                    136 ;	 function getButton3
                                    137 ;	-----------------------------------------
      008A2F                        138 _getButton3:
                                    139 ;	./buttons.c: 97: return status & BUTTON3_BIT;
      008A2F C6 00 1C         [ 1]  140 	ld	a, _status+0
      008A32 4E               [ 1]  141 	swap	a
      008A33 44               [ 1]  142 	srl	a
      008A34 A4 01            [ 1]  143 	and	a, #0x01
                                    144 ;	./buttons.c: 98: }
      008A36 81               [ 4]  145 	ret
                                    146 ;	./buttons.c: 104: bool isButton1()
                                    147 ;	-----------------------------------------
                                    148 ;	 function isButton1
                                    149 ;	-----------------------------------------
      008A37                        150 _isButton1:
                                    151 ;	./buttons.c: 106: if (diff & BUTTON1_BIT) {
      008A37 C6 00 1D         [ 1]  152 	ld	a, _diff+0
      008A3A A5 08            [ 1]  153 	bcp	a, #0x08
      008A3C 27 07            [ 1]  154 	jreq	00102$
                                    155 ;	./buttons.c: 107: diff &= ~BUTTON1_BIT;
      008A3E 72 17 00 1D      [ 1]  156 	bres	_diff+0, #3
                                    157 ;	./buttons.c: 108: return true;
      008A42 A6 01            [ 1]  158 	ld	a, #0x01
      008A44 81               [ 4]  159 	ret
      008A45                        160 00102$:
                                    161 ;	./buttons.c: 111: return false;
      008A45 4F               [ 1]  162 	clr	a
                                    163 ;	./buttons.c: 112: }
      008A46 81               [ 4]  164 	ret
                                    165 ;	./buttons.c: 118: bool isButton2()
                                    166 ;	-----------------------------------------
                                    167 ;	 function isButton2
                                    168 ;	-----------------------------------------
      008A47                        169 _isButton2:
                                    170 ;	./buttons.c: 120: if (diff & BUTTON2_BIT) {
      008A47 C6 00 1D         [ 1]  171 	ld	a, _diff+0
      008A4A A5 10            [ 1]  172 	bcp	a, #0x10
      008A4C 27 07            [ 1]  173 	jreq	00102$
                                    174 ;	./buttons.c: 121: diff &= ~BUTTON2_BIT;
      008A4E 72 19 00 1D      [ 1]  175 	bres	_diff+0, #4
                                    176 ;	./buttons.c: 122: return true;
      008A52 A6 01            [ 1]  177 	ld	a, #0x01
      008A54 81               [ 4]  178 	ret
      008A55                        179 00102$:
                                    180 ;	./buttons.c: 125: return false;
      008A55 4F               [ 1]  181 	clr	a
                                    182 ;	./buttons.c: 126: }
      008A56 81               [ 4]  183 	ret
                                    184 ;	./buttons.c: 132: bool isButton3()
                                    185 ;	-----------------------------------------
                                    186 ;	 function isButton3
                                    187 ;	-----------------------------------------
      008A57                        188 _isButton3:
                                    189 ;	./buttons.c: 134: if (diff & BUTTON3_BIT) {
      008A57 C6 00 1D         [ 1]  190 	ld	a, _diff+0
      008A5A A5 20            [ 1]  191 	bcp	a, #0x20
      008A5C 27 07            [ 1]  192 	jreq	00102$
                                    193 ;	./buttons.c: 135: diff &= ~BUTTON3_BIT;
      008A5E 72 1B 00 1D      [ 1]  194 	bres	_diff+0, #5
                                    195 ;	./buttons.c: 136: return true;
      008A62 A6 01            [ 1]  196 	ld	a, #0x01
      008A64 81               [ 4]  197 	ret
      008A65                        198 00102$:
                                    199 ;	./buttons.c: 139: return false;
      008A65 4F               [ 1]  200 	clr	a
                                    201 ;	./buttons.c: 140: }
      008A66 81               [ 4]  202 	ret
                                    203 ;	./buttons.c: 146: void EXTI2_handler() __interrupt (5)
                                    204 ;	-----------------------------------------
                                    205 ;	 function EXTI2_handler
                                    206 ;	-----------------------------------------
      008A67                        207 _EXTI2_handler:
      008A67 4F               [ 1]  208 	clr	a
      008A68 62               [ 2]  209 	div	x, a
                                    210 ;	./buttons.c: 149: diff = status ^ ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
      008A69 C6 50 0B         [ 1]  211 	ld	a, 0x500b
      008A6C A4 38            [ 1]  212 	and	a, #0x38
      008A6E 43               [ 1]  213 	cpl	a
      008A6F C8 00 1C         [ 1]  214 	xor	a, _status+0
      008A72 C7 00 1D         [ 1]  215 	ld	_diff+0, a
                                    216 ;	./buttons.c: 150: status = ~ (BUTTONS_PORT & (BUTTON1_BIT | BUTTON2_BIT | BUTTON3_BIT) );
      008A75 C6 50 0B         [ 1]  217 	ld	a, 0x500b
      008A78 A4 38            [ 1]  218 	and	a, #0x38
      008A7A 43               [ 1]  219 	cpl	a
      008A7B C7 00 1C         [ 1]  220 	ld	_status+0, a
                                    221 ;	./buttons.c: 153: if (isButton1() ) {
      008A7E CD 8A 37         [ 4]  222 	call	_isButton1
      008A81 4D               [ 1]  223 	tnz	a
      008A82 27 0D            [ 1]  224 	jreq	00117$
                                    225 ;	./buttons.c: 154: if (getButton1() ) {
      008A84 CD 8A 1D         [ 4]  226 	call	_getButton1
      008A87 4D               [ 1]  227 	tnz	a
      008A88 27 03            [ 1]  228 	jreq	00102$
                                    229 ;	./buttons.c: 155: event = MENU_EVENT_PUSH_BUTTON1;
      008A8A 4F               [ 1]  230 	clr	a
      008A8B 20 29            [ 2]  231 	jra	00118$
      008A8D                        232 00102$:
                                    233 ;	./buttons.c: 157: event = MENU_EVENT_RELEASE_BUTTON1;
      008A8D A6 03            [ 1]  234 	ld	a, #0x03
      008A8F 20 25            [ 2]  235 	jra	00118$
      008A91                        236 00117$:
                                    237 ;	./buttons.c: 159: } else if (isButton2() ) {
      008A91 CD 8A 47         [ 4]  238 	call	_isButton2
      008A94 4D               [ 1]  239 	tnz	a
      008A95 27 0E            [ 1]  240 	jreq	00114$
                                    241 ;	./buttons.c: 160: if (getButton2() ) {
      008A97 CD 8A 25         [ 4]  242 	call	_getButton2
      008A9A 4D               [ 1]  243 	tnz	a
      008A9B 27 04            [ 1]  244 	jreq	00105$
                                    245 ;	./buttons.c: 161: event = MENU_EVENT_PUSH_BUTTON2;
      008A9D A6 01            [ 1]  246 	ld	a, #0x01
      008A9F 20 15            [ 2]  247 	jra	00118$
      008AA1                        248 00105$:
                                    249 ;	./buttons.c: 163: event = MENU_EVENT_RELEASE_BUTTON2;
      008AA1 A6 04            [ 1]  250 	ld	a, #0x04
      008AA3 20 11            [ 2]  251 	jra	00118$
      008AA5                        252 00114$:
                                    253 ;	./buttons.c: 165: } else if (isButton3() ) {
      008AA5 CD 8A 57         [ 4]  254 	call	_isButton3
      008AA8 4D               [ 1]  255 	tnz	a
      008AA9 27 10            [ 1]  256 	jreq	00119$
                                    257 ;	./buttons.c: 166: if (getButton3() ) {
      008AAB CD 8A 2F         [ 4]  258 	call	_getButton3
      008AAE 4D               [ 1]  259 	tnz	a
      008AAF 27 03            [ 1]  260 	jreq	00108$
                                    261 ;	./buttons.c: 167: event = MENU_EVENT_PUSH_BUTTON3;
      008AB1 A6 02            [ 1]  262 	ld	a, #0x02
                                    263 ;	./buttons.c: 169: event = MENU_EVENT_RELEASE_BUTTON3;
                                    264 ;	./buttons.c: 172: return;
      008AB3 C5                     265 	.byte 0xc5
      008AB4                        266 00108$:
      008AB4 A6 05            [ 1]  267 	ld	a, #0x05
      008AB6                        268 00118$:
                                    269 ;	./buttons.c: 175: feedMenu (event);
      008AB6 88               [ 1]  270 	push	a
      008AB7 CD 8C 59         [ 4]  271 	call	_feedMenu
      008ABA 84               [ 1]  272 	pop	a
      008ABB                        273 00119$:
                                    274 ;	./buttons.c: 176: }
      008ABB 80               [11]  275 	iret
                                    276 	.area CODE
                                    277 	.area CONST
                                    278 	.area INITIALIZER
                                    279 	.area CABS (ABS)

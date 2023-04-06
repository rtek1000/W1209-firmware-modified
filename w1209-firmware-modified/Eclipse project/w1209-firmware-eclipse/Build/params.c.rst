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
                                     14 	.globl _getButton3
                                     15 	.globl _getButton2
                                     16 	.globl _initParamsEEPROM
                                     17 	.globl _getParamById
                                     18 	.globl _setParamById
                                     19 	.globl _getParam
                                     20 	.globl _setParam
                                     21 	.globl _incParam
                                     22 	.globl _decParam
                                     23 	.globl _getParamId
                                     24 	.globl _setParamId
                                     25 	.globl _incParamId
                                     26 	.globl _decParamId
                                     27 	.globl _paramToString
                                     28 	.globl _storeParams
                                     29 	.globl _itofpa
                                     30 ;--------------------------------------------------------
                                     31 ; ram data
                                     32 ;--------------------------------------------------------
                                     33 	.area DATA
      000028                         34 _paramId:
      000028                         35 	.ds 1
      000029                         36 _paramCache:
      000029                         37 	.ds 20
                                     38 ;--------------------------------------------------------
                                     39 ; ram data
                                     40 ;--------------------------------------------------------
                                     41 	.area INITIALIZED
                                     42 ;--------------------------------------------------------
                                     43 ; absolute external ram data
                                     44 ;--------------------------------------------------------
                                     45 	.area DABS (ABS)
                                     46 
                                     47 ; default segment ordering for linker
                                     48 	.area HOME
                                     49 	.area GSINIT
                                     50 	.area GSFINAL
                                     51 	.area CONST
                                     52 	.area INITIALIZER
                                     53 	.area CODE
                                     54 
                                     55 ;--------------------------------------------------------
                                     56 ; global & static initialisations
                                     57 ;--------------------------------------------------------
                                     58 	.area HOME
                                     59 	.area GSINIT
                                     60 	.area GSFINAL
                                     61 	.area GSINIT
                                     62 ;--------------------------------------------------------
                                     63 ; Home
                                     64 ;--------------------------------------------------------
                                     65 	.area HOME
                                     66 	.area HOME
                                     67 ;--------------------------------------------------------
                                     68 ; code
                                     69 ;--------------------------------------------------------
                                     70 	.area CODE
                                     71 ;	./params.c: 53: void initParamsEEPROM()
                                     72 ;	-----------------------------------------
                                     73 ;	 function initParamsEEPROM
                                     74 ;	-----------------------------------------
      008F37                         75 _initParamsEEPROM:
                                     76 ;	./params.c: 55: if (getButton2() && getButton3() ) {
      008F37 CD 8A 25         [ 4]   77 	call	_getButton2
      008F3A 4D               [ 1]   78 	tnz	a
      008F3B 27 2C            [ 1]   79 	jreq	00104$
      008F3D CD 8A 2F         [ 4]   80 	call	_getButton3
      008F40 4D               [ 1]   81 	tnz	a
      008F41 27 26            [ 1]   82 	jreq	00104$
                                     83 ;	./params.c: 57: for (paramId = 0; paramId < 10; paramId++) {
      008F43 72 5F 00 28      [ 1]   84 	clr	_paramId+0
      008F47                         85 00107$:
                                     86 ;	./params.c: 58: paramCache[paramId] = paramDefault[paramId];
      008F47 C6 00 28         [ 1]   87 	ld	a, _paramId+0
      008F4A 5F               [ 1]   88 	clrw	x
      008F4B 97               [ 1]   89 	ld	xl, a
      008F4C 58               [ 2]   90 	sllw	x
      008F4D 90 93            [ 1]   91 	ldw	y, x
      008F4F 72 A9 00 29      [ 2]   92 	addw	y, #(_paramCache + 0)
      008F53 1C 82 1C         [ 2]   93 	addw	x, #(_paramDefault + 0)
      008F56 FE               [ 2]   94 	ldw	x, (x)
      008F57 90 FF            [ 2]   95 	ldw	(y), x
                                     96 ;	./params.c: 57: for (paramId = 0; paramId < 10; paramId++) {
      008F59 72 5C 00 28      [ 1]   97 	inc	_paramId+0
      008F5D C6 00 28         [ 1]   98 	ld	a, _paramId+0
      008F60 A1 0A            [ 1]   99 	cp	a, #0x0a
      008F62 25 E3            [ 1]  100 	jrc	00107$
                                    101 ;	./params.c: 61: storeParams();
      008F64 CD 91 9B         [ 4]  102 	call	_storeParams
      008F67 20 21            [ 2]  103 	jra	00105$
      008F69                        104 00104$:
                                    105 ;	./params.c: 64: for (paramId = 0; paramId < 10; paramId++) {
      008F69 72 5F 00 28      [ 1]  106 	clr	_paramId+0
      008F6D                        107 00109$:
                                    108 ;	./params.c: 65: paramCache[paramId] = * (int*) (EEPROM_BASE_ADDR + EEPROM_PARAMS_OFFSET
      008F6D C6 00 28         [ 1]  109 	ld	a, _paramId+0
      008F70 5F               [ 1]  110 	clrw	x
      008F71 97               [ 1]  111 	ld	xl, a
      008F72 58               [ 2]  112 	sllw	x
      008F73 90 93            [ 1]  113 	ldw	y, x
      008F75 72 A9 00 29      [ 2]  114 	addw	y, #(_paramCache + 0)
                                    115 ;	./params.c: 66: + (paramId * sizeof paramCache[0]) );
      008F79 1C 40 64         [ 2]  116 	addw	x, #0x4064
      008F7C FE               [ 2]  117 	ldw	x, (x)
      008F7D 90 FF            [ 2]  118 	ldw	(y), x
                                    119 ;	./params.c: 64: for (paramId = 0; paramId < 10; paramId++) {
      008F7F 72 5C 00 28      [ 1]  120 	inc	_paramId+0
      008F83 C6 00 28         [ 1]  121 	ld	a, _paramId+0
      008F86 A1 0A            [ 1]  122 	cp	a, #0x0a
      008F88 25 E3            [ 1]  123 	jrc	00109$
      008F8A                        124 00105$:
                                    125 ;	./params.c: 70: paramId = 0;
      008F8A 72 5F 00 28      [ 1]  126 	clr	_paramId+0
                                    127 ;	./params.c: 71: }
      008F8E 81               [ 4]  128 	ret
                                    129 ;	./params.c: 78: int getParamById (unsigned char id)
                                    130 ;	-----------------------------------------
                                    131 ;	 function getParamById
                                    132 ;	-----------------------------------------
      008F8F                        133 _getParamById:
                                    134 ;	./params.c: 80: if (id < 10) {
      008F8F 7B 03            [ 1]  135 	ld	a, (0x03, sp)
      008F91 A1 0A            [ 1]  136 	cp	a, #0x0a
      008F93 24 0A            [ 1]  137 	jrnc	00102$
                                    138 ;	./params.c: 81: return paramCache[id];
      008F95 7B 03            [ 1]  139 	ld	a, (0x03, sp)
      008F97 5F               [ 1]  140 	clrw	x
      008F98 97               [ 1]  141 	ld	xl, a
      008F99 58               [ 2]  142 	sllw	x
      008F9A 1C 00 29         [ 2]  143 	addw	x, #(_paramCache + 0)
      008F9D FE               [ 2]  144 	ldw	x, (x)
      008F9E 81               [ 4]  145 	ret
      008F9F                        146 00102$:
                                    147 ;	./params.c: 84: return -1;
      008F9F 5F               [ 1]  148 	clrw	x
      008FA0 5A               [ 2]  149 	decw	x
                                    150 ;	./params.c: 85: }
      008FA1 81               [ 4]  151 	ret
                                    152 ;	./params.c: 92: void setParamById (unsigned char id, int val)
                                    153 ;	-----------------------------------------
                                    154 ;	 function setParamById
                                    155 ;	-----------------------------------------
      008FA2                        156 _setParamById:
                                    157 ;	./params.c: 94: if (id < 10) {
      008FA2 7B 03            [ 1]  158 	ld	a, (0x03, sp)
      008FA4 A1 0A            [ 1]  159 	cp	a, #0x0a
      008FA6 25 01            [ 1]  160 	jrc	00110$
      008FA8 81               [ 4]  161 	ret
      008FA9                        162 00110$:
                                    163 ;	./params.c: 95: paramCache[id] = val;
      008FA9 7B 03            [ 1]  164 	ld	a, (0x03, sp)
      008FAB 5F               [ 1]  165 	clrw	x
      008FAC 97               [ 1]  166 	ld	xl, a
      008FAD 58               [ 2]  167 	sllw	x
      008FAE 16 04            [ 2]  168 	ldw	y, (0x04, sp)
      008FB0 DF 00 29         [ 2]  169 	ldw	((_paramCache + 0), x), y
                                    170 ;	./params.c: 97: }
      008FB3 81               [ 4]  171 	ret
                                    172 ;	./params.c: 103: int getParam()
                                    173 ;	-----------------------------------------
                                    174 ;	 function getParam
                                    175 ;	-----------------------------------------
      008FB4                        176 _getParam:
                                    177 ;	./params.c: 105: return paramCache[paramId];
      008FB4 C6 00 28         [ 1]  178 	ld	a, _paramId+0
      008FB7 5F               [ 1]  179 	clrw	x
      008FB8 97               [ 1]  180 	ld	xl, a
      008FB9 58               [ 2]  181 	sllw	x
      008FBA 1C 00 29         [ 2]  182 	addw	x, #(_paramCache + 0)
      008FBD FE               [ 2]  183 	ldw	x, (x)
                                    184 ;	./params.c: 106: }
      008FBE 81               [ 4]  185 	ret
                                    186 ;	./params.c: 112: void setParam (int val)
                                    187 ;	-----------------------------------------
                                    188 ;	 function setParam
                                    189 ;	-----------------------------------------
      008FBF                        190 _setParam:
                                    191 ;	./params.c: 114: paramCache[paramId] = val;
      008FBF C6 00 28         [ 1]  192 	ld	a, _paramId+0
      008FC2 5F               [ 1]  193 	clrw	x
      008FC3 97               [ 1]  194 	ld	xl, a
      008FC4 58               [ 2]  195 	sllw	x
      008FC5 16 03            [ 2]  196 	ldw	y, (0x03, sp)
      008FC7 DF 00 29         [ 2]  197 	ldw	((_paramCache + 0), x), y
                                    198 ;	./params.c: 115: }
      008FCA 81               [ 4]  199 	ret
                                    200 ;	./params.c: 120: void incParam()
                                    201 ;	-----------------------------------------
                                    202 ;	 function incParam
                                    203 ;	-----------------------------------------
      008FCB                        204 _incParam:
      008FCB 52 04            [ 2]  205 	sub	sp, #4
                                    206 ;	./params.c: 123: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
      008FCD 5F               [ 1]  207 	clrw	x
      008FCE C6 00 28         [ 1]  208 	ld	a, _paramId+0
      008FD1 97               [ 1]  209 	ld	xl, a
      008FD2 58               [ 2]  210 	sllw	x
      008FD3 51               [ 1]  211 	exgw	x, y
                                    212 ;	./params.c: 122: if (paramId == PARAM_RELAY_MODE || paramId == PARAM_OVERHEAT_INDICATION) {
      008FD4 72 5D 00 28      [ 1]  213 	tnz	_paramId+0
      008FD8 27 07            [ 1]  214 	jreq	00103$
      008FDA C6 00 28         [ 1]  215 	ld	a, _paramId+0
      008FDD A1 06            [ 1]  216 	cp	a, #0x06
      008FDF 26 11            [ 1]  217 	jrne	00104$
      008FE1                        218 00103$:
                                    219 ;	./params.c: 123: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
      008FE1 72 A9 00 29      [ 2]  220 	addw	y, #(_paramCache + 0)
      008FE5 93               [ 1]  221 	ldw	x, y
      008FE6 FE               [ 2]  222 	ldw	x, (x)
      008FE7 53               [ 2]  223 	cplw	x
      008FE8 9F               [ 1]  224 	ld	a, xl
      008FE9 A4 01            [ 1]  225 	and	a, #0x01
      008FEB 97               [ 1]  226 	ld	xl, a
      008FEC 4F               [ 1]  227 	clr	a
      008FED 95               [ 1]  228 	ld	xh, a
      008FEE 90 FF            [ 2]  229 	ldw	(y), x
      008FF0 20 18            [ 2]  230 	jra	00107$
      008FF2                        231 00104$:
                                    232 ;	./params.c: 124: } else if (paramCache[paramId] < paramMax[paramId]) {
      008FF2 93               [ 1]  233 	ldw	x, y
      008FF3 1C 00 29         [ 2]  234 	addw	x, #(_paramCache + 0)
      008FF6 1F 01            [ 2]  235 	ldw	(0x01, sp), x
      008FF8 FE               [ 2]  236 	ldw	x, (x)
      008FF9 72 A9 82 08      [ 2]  237 	addw	y, #(_paramMax + 0)
      008FFD 90 FE            [ 2]  238 	ldw	y, (y)
      008FFF 17 03            [ 2]  239 	ldw	(0x03, sp), y
      009001 13 03            [ 2]  240 	cpw	x, (0x03, sp)
      009003 2E 05            [ 1]  241 	jrsge	00107$
                                    242 ;	./params.c: 125: paramCache[paramId]++;
      009005 5C               [ 1]  243 	incw	x
      009006 16 01            [ 2]  244 	ldw	y, (0x01, sp)
      009008 90 FF            [ 2]  245 	ldw	(y), x
      00900A                        246 00107$:
                                    247 ;	./params.c: 127: }
      00900A 5B 04            [ 2]  248 	addw	sp, #4
      00900C 81               [ 4]  249 	ret
                                    250 ;	./params.c: 132: void decParam()
                                    251 ;	-----------------------------------------
                                    252 ;	 function decParam
                                    253 ;	-----------------------------------------
      00900D                        254 _decParam:
      00900D 52 04            [ 2]  255 	sub	sp, #4
                                    256 ;	./params.c: 135: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
      00900F 5F               [ 1]  257 	clrw	x
      009010 C6 00 28         [ 1]  258 	ld	a, _paramId+0
      009013 97               [ 1]  259 	ld	xl, a
      009014 58               [ 2]  260 	sllw	x
      009015 51               [ 1]  261 	exgw	x, y
                                    262 ;	./params.c: 134: if (paramId == PARAM_RELAY_MODE || paramId == PARAM_OVERHEAT_INDICATION) {
      009016 72 5D 00 28      [ 1]  263 	tnz	_paramId+0
      00901A 27 07            [ 1]  264 	jreq	00103$
      00901C C6 00 28         [ 1]  265 	ld	a, _paramId+0
      00901F A1 06            [ 1]  266 	cp	a, #0x06
      009021 26 11            [ 1]  267 	jrne	00104$
      009023                        268 00103$:
                                    269 ;	./params.c: 135: paramCache[paramId] = ~paramCache[paramId] & 0x0001;
      009023 72 A9 00 29      [ 2]  270 	addw	y, #(_paramCache + 0)
      009027 93               [ 1]  271 	ldw	x, y
      009028 FE               [ 2]  272 	ldw	x, (x)
      009029 53               [ 2]  273 	cplw	x
      00902A 9F               [ 1]  274 	ld	a, xl
      00902B A4 01            [ 1]  275 	and	a, #0x01
      00902D 97               [ 1]  276 	ld	xl, a
      00902E 4F               [ 1]  277 	clr	a
      00902F 95               [ 1]  278 	ld	xh, a
      009030 90 FF            [ 2]  279 	ldw	(y), x
      009032 20 18            [ 2]  280 	jra	00107$
      009034                        281 00104$:
                                    282 ;	./params.c: 136: } else if (paramCache[paramId] > paramMin[paramId]) {
      009034 93               [ 1]  283 	ldw	x, y
      009035 1C 00 29         [ 2]  284 	addw	x, #(_paramCache + 0)
      009038 1F 01            [ 2]  285 	ldw	(0x01, sp), x
      00903A FE               [ 2]  286 	ldw	x, (x)
      00903B 72 A9 81 F4      [ 2]  287 	addw	y, #(_paramMin + 0)
      00903F 90 FE            [ 2]  288 	ldw	y, (y)
      009041 17 03            [ 2]  289 	ldw	(0x03, sp), y
      009043 13 03            [ 2]  290 	cpw	x, (0x03, sp)
      009045 2D 05            [ 1]  291 	jrsle	00107$
                                    292 ;	./params.c: 137: paramCache[paramId]--;
      009047 5A               [ 2]  293 	decw	x
      009048 16 01            [ 2]  294 	ldw	y, (0x01, sp)
      00904A 90 FF            [ 2]  295 	ldw	(y), x
      00904C                        296 00107$:
                                    297 ;	./params.c: 139: }
      00904C 5B 04            [ 2]  298 	addw	sp, #4
      00904E 81               [ 4]  299 	ret
                                    300 ;	./params.c: 145: unsigned char getParamId()
                                    301 ;	-----------------------------------------
                                    302 ;	 function getParamId
                                    303 ;	-----------------------------------------
      00904F                        304 _getParamId:
                                    305 ;	./params.c: 147: return paramId;
      00904F C6 00 28         [ 1]  306 	ld	a, _paramId+0
                                    307 ;	./params.c: 148: }
      009052 81               [ 4]  308 	ret
                                    309 ;	./params.c: 154: void setParamId (unsigned char val)
                                    310 ;	-----------------------------------------
                                    311 ;	 function setParamId
                                    312 ;	-----------------------------------------
      009053                        313 _setParamId:
                                    314 ;	./params.c: 156: if (val < 10) {
      009053 7B 03            [ 1]  315 	ld	a, (0x03, sp)
      009055 A1 0A            [ 1]  316 	cp	a, #0x0a
      009057 25 01            [ 1]  317 	jrc	00110$
      009059 81               [ 4]  318 	ret
      00905A                        319 00110$:
                                    320 ;	./params.c: 157: paramId = val;
      00905A 7B 03            [ 1]  321 	ld	a, (0x03, sp)
      00905C C7 00 28         [ 1]  322 	ld	_paramId+0, a
                                    323 ;	./params.c: 159: }
      00905F 81               [ 4]  324 	ret
                                    325 ;	./params.c: 164: void incParamId()
                                    326 ;	-----------------------------------------
                                    327 ;	 function incParamId
                                    328 ;	-----------------------------------------
      009060                        329 _incParamId:
                                    330 ;	./params.c: 166: if (paramId < 6) {
      009060 C6 00 28         [ 1]  331 	ld	a, _paramId+0
      009063 A1 06            [ 1]  332 	cp	a, #0x06
      009065 24 05            [ 1]  333 	jrnc	00102$
                                    334 ;	./params.c: 167: paramId++;
      009067 72 5C 00 28      [ 1]  335 	inc	_paramId+0
      00906B 81               [ 4]  336 	ret
      00906C                        337 00102$:
                                    338 ;	./params.c: 169: paramId = 0;
      00906C 72 5F 00 28      [ 1]  339 	clr	_paramId+0
                                    340 ;	./params.c: 171: }
      009070 81               [ 4]  341 	ret
                                    342 ;	./params.c: 176: void decParamId()
                                    343 ;	-----------------------------------------
                                    344 ;	 function decParamId
                                    345 ;	-----------------------------------------
      009071                        346 _decParamId:
                                    347 ;	./params.c: 178: if (paramId > 0) {
      009071 72 5D 00 28      [ 1]  348 	tnz	_paramId+0
      009075 27 05            [ 1]  349 	jreq	00102$
                                    350 ;	./params.c: 179: paramId--;
      009077 72 5A 00 28      [ 1]  351 	dec	_paramId+0
      00907B 81               [ 4]  352 	ret
      00907C                        353 00102$:
                                    354 ;	./params.c: 181: paramId = 6;
      00907C 35 06 00 28      [ 1]  355 	mov	_paramId+0, #0x06
                                    356 ;	./params.c: 183: }
      009080 81               [ 4]  357 	ret
                                    358 ;	./params.c: 192: void paramToString (unsigned char id, unsigned char* strBuff)
                                    359 ;	-----------------------------------------
                                    360 ;	 function paramToString
                                    361 ;	-----------------------------------------
      009081                        362 _paramToString:
      009081 52 0A            [ 2]  363 	sub	sp, #10
                                    364 ;	./params.c: 197: ( (unsigned char*) strBuff) [0] = 'H';
      009083 16 0E            [ 2]  365 	ldw	y, (0x0e, sp)
                                    366 ;	./params.c: 229: ( (unsigned char*) strBuff) [1] = 'N';
      009085 17 01            [ 2]  367 	ldw	(0x01, sp), y
      009087 93               [ 1]  368 	ldw	x, y
      009088 5C               [ 1]  369 	incw	x
      009089 1F 03            [ 2]  370 	ldw	(0x03, sp), x
                                    371 ;	./params.c: 230: ( (unsigned char*) strBuff) [2] = ' ';
      00908B 1E 01            [ 2]  372 	ldw	x, (0x01, sp)
      00908D 5C               [ 1]  373 	incw	x
      00908E 5C               [ 1]  374 	incw	x
      00908F 1F 05            [ 2]  375 	ldw	(0x05, sp), x
                                    376 ;	./params.c: 236: ( (unsigned char*) strBuff) [3] = 0;
      009091 1E 01            [ 2]  377 	ldw	x, (0x01, sp)
      009093 1C 00 03         [ 2]  378 	addw	x, #0x0003
      009096 1F 07            [ 2]  379 	ldw	(0x07, sp), x
                                    380 ;	./params.c: 194: switch (id) {
      009098 7B 0D            [ 1]  381 	ld	a, (0x0d, sp)
      00909A A1 09            [ 1]  382 	cp	a, #0x09
      00909C 23 03            [ 2]  383 	jrule	00134$
      00909E CC 91 86         [ 2]  384 	jp	00115$
      0090A1                        385 00134$:
                                    386 ;	./params.c: 196: if (paramCache[id]) {
      0090A1 5F               [ 1]  387 	clrw	x
      0090A2 7B 0D            [ 1]  388 	ld	a, (0x0d, sp)
      0090A4 97               [ 1]  389 	ld	xl, a
      0090A5 58               [ 2]  390 	sllw	x
      0090A6 1F 09            [ 2]  391 	ldw	(0x09, sp), x
                                    392 ;	./params.c: 194: switch (id) {
      0090A8 5F               [ 1]  393 	clrw	x
      0090A9 7B 0D            [ 1]  394 	ld	a, (0x0d, sp)
      0090AB 97               [ 1]  395 	ld	xl, a
      0090AC 58               [ 2]  396 	sllw	x
      0090AD DE 90 B1         [ 2]  397 	ldw	x, (#00135$, x)
      0090B0 FC               [ 2]  398 	jp	(x)
      0090B1                        399 00135$:
      0090B1 90 C5                  400 	.dw	#00101$
      0090B3 90 E2                  401 	.dw	#00105$
      0090B5 90 F7                  402 	.dw	#00106$
      0090B7 91 0C                  403 	.dw	#00107$
      0090B9 91 20                  404 	.dw	#00108$
      0090BB 91 34                  405 	.dw	#00109$
      0090BD 91 48                  406 	.dw	#00110$
      0090BF 91 86                  407 	.dw	#00115$
      0090C1 91 86                  408 	.dw	#00115$
      0090C3 91 72                  409 	.dw	#00114$
                                    410 ;	./params.c: 195: case PARAM_RELAY_MODE:
      0090C5                        411 00101$:
                                    412 ;	./params.c: 196: if (paramCache[id]) {
      0090C5 1E 09            [ 2]  413 	ldw	x, (0x09, sp)
      0090C7 1C 00 29         [ 2]  414 	addw	x, #(_paramCache + 0)
      0090CA FE               [ 2]  415 	ldw	x, (x)
      0090CB 1F 09            [ 2]  416 	ldw	(0x09, sp), x
      0090CD 27 07            [ 1]  417 	jreq	00103$
                                    418 ;	./params.c: 197: ( (unsigned char*) strBuff) [0] = 'H';
      0090CF 1E 01            [ 2]  419 	ldw	x, (0x01, sp)
      0090D1 A6 48            [ 1]  420 	ld	a, #0x48
      0090D3 F7               [ 1]  421 	ld	(x), a
      0090D4 20 05            [ 2]  422 	jra	00104$
      0090D6                        423 00103$:
                                    424 ;	./params.c: 199: ( (unsigned char*) strBuff) [0] = 'C';
      0090D6 1E 01            [ 2]  425 	ldw	x, (0x01, sp)
      0090D8 A6 43            [ 1]  426 	ld	a, #0x43
      0090DA F7               [ 1]  427 	ld	(x), a
      0090DB                        428 00104$:
                                    429 ;	./params.c: 202: ( (unsigned char*) strBuff) [1] = 0;
      0090DB 1E 0E            [ 2]  430 	ldw	x, (0x0e, sp)
      0090DD 5C               [ 1]  431 	incw	x
      0090DE 7F               [ 1]  432 	clr	(x)
                                    433 ;	./params.c: 203: break;
      0090DF CC 91 98         [ 2]  434 	jp	00117$
                                    435 ;	./params.c: 205: case PARAM_RELAY_HYSTERESIS:
      0090E2                        436 00105$:
                                    437 ;	./params.c: 206: itofpa (paramCache[id], strBuff, 0);
      0090E2 1E 09            [ 2]  438 	ldw	x, (0x09, sp)
      0090E4 1C 00 29         [ 2]  439 	addw	x, #(_paramCache + 0)
      0090E7 FE               [ 2]  440 	ldw	x, (x)
      0090E8 4B 00            [ 1]  441 	push	#0x00
      0090EA 16 0F            [ 2]  442 	ldw	y, (0x0f, sp)
      0090EC 90 89            [ 2]  443 	pushw	y
      0090EE 89               [ 2]  444 	pushw	x
      0090EF CD 91 F0         [ 4]  445 	call	_itofpa
      0090F2 5B 05            [ 2]  446 	addw	sp, #5
                                    447 ;	./params.c: 207: break;
      0090F4 CC 91 98         [ 2]  448 	jp	00117$
                                    449 ;	./params.c: 209: case PARAM_MAX_TEMPERATURE:
      0090F7                        450 00106$:
                                    451 ;	./params.c: 210: itofpa (paramCache[id], strBuff, 6);
      0090F7 1E 09            [ 2]  452 	ldw	x, (0x09, sp)
      0090F9 1C 00 29         [ 2]  453 	addw	x, #(_paramCache + 0)
      0090FC FE               [ 2]  454 	ldw	x, (x)
      0090FD 4B 06            [ 1]  455 	push	#0x06
      0090FF 16 0F            [ 2]  456 	ldw	y, (0x0f, sp)
      009101 90 89            [ 2]  457 	pushw	y
      009103 89               [ 2]  458 	pushw	x
      009104 CD 91 F0         [ 4]  459 	call	_itofpa
      009107 5B 05            [ 2]  460 	addw	sp, #5
                                    461 ;	./params.c: 211: break;
      009109 CC 91 98         [ 2]  462 	jp	00117$
                                    463 ;	./params.c: 213: case PARAM_MIN_TEMPERATURE:
      00910C                        464 00107$:
                                    465 ;	./params.c: 214: itofpa (paramCache[id], strBuff, 6);
      00910C 1E 09            [ 2]  466 	ldw	x, (0x09, sp)
      00910E 1C 00 29         [ 2]  467 	addw	x, #(_paramCache + 0)
      009111 FE               [ 2]  468 	ldw	x, (x)
      009112 4B 06            [ 1]  469 	push	#0x06
      009114 16 0F            [ 2]  470 	ldw	y, (0x0f, sp)
      009116 90 89            [ 2]  471 	pushw	y
      009118 89               [ 2]  472 	pushw	x
      009119 CD 91 F0         [ 4]  473 	call	_itofpa
      00911C 5B 05            [ 2]  474 	addw	sp, #5
                                    475 ;	./params.c: 215: break;
      00911E 20 78            [ 2]  476 	jra	00117$
                                    477 ;	./params.c: 217: case PARAM_TEMPERATURE_CORRECTION:
      009120                        478 00108$:
                                    479 ;	./params.c: 218: itofpa (paramCache[id], strBuff, 0);
      009120 1E 09            [ 2]  480 	ldw	x, (0x09, sp)
      009122 1C 00 29         [ 2]  481 	addw	x, #(_paramCache + 0)
      009125 FE               [ 2]  482 	ldw	x, (x)
      009126 4B 00            [ 1]  483 	push	#0x00
      009128 16 0F            [ 2]  484 	ldw	y, (0x0f, sp)
      00912A 90 89            [ 2]  485 	pushw	y
      00912C 89               [ 2]  486 	pushw	x
      00912D CD 91 F0         [ 4]  487 	call	_itofpa
      009130 5B 05            [ 2]  488 	addw	sp, #5
                                    489 ;	./params.c: 219: break;
      009132 20 64            [ 2]  490 	jra	00117$
                                    491 ;	./params.c: 221: case PARAM_RELAY_DELAY:
      009134                        492 00109$:
                                    493 ;	./params.c: 222: itofpa (paramCache[id], strBuff, 6);
      009134 1E 09            [ 2]  494 	ldw	x, (0x09, sp)
      009136 1C 00 29         [ 2]  495 	addw	x, #(_paramCache + 0)
      009139 FE               [ 2]  496 	ldw	x, (x)
      00913A 4B 06            [ 1]  497 	push	#0x06
      00913C 16 0F            [ 2]  498 	ldw	y, (0x0f, sp)
      00913E 90 89            [ 2]  499 	pushw	y
      009140 89               [ 2]  500 	pushw	x
      009141 CD 91 F0         [ 4]  501 	call	_itofpa
      009144 5B 05            [ 2]  502 	addw	sp, #5
                                    503 ;	./params.c: 223: break;
      009146 20 50            [ 2]  504 	jra	00117$
                                    505 ;	./params.c: 225: case PARAM_OVERHEAT_INDICATION:
      009148                        506 00110$:
                                    507 ;	./params.c: 226: ( (unsigned char*) strBuff) [0] = 'O';
      009148 1E 01            [ 2]  508 	ldw	x, (0x01, sp)
      00914A A6 4F            [ 1]  509 	ld	a, #0x4f
      00914C F7               [ 1]  510 	ld	(x), a
                                    511 ;	./params.c: 228: if (paramCache[id]) {
      00914D 1E 09            [ 2]  512 	ldw	x, (0x09, sp)
      00914F 1C 00 29         [ 2]  513 	addw	x, #(_paramCache + 0)
      009152 FE               [ 2]  514 	ldw	x, (x)
      009153 1F 09            [ 2]  515 	ldw	(0x09, sp), x
      009155 27 0C            [ 1]  516 	jreq	00112$
                                    517 ;	./params.c: 229: ( (unsigned char*) strBuff) [1] = 'N';
      009157 1E 03            [ 2]  518 	ldw	x, (0x03, sp)
      009159 A6 4E            [ 1]  519 	ld	a, #0x4e
      00915B F7               [ 1]  520 	ld	(x), a
                                    521 ;	./params.c: 230: ( (unsigned char*) strBuff) [2] = ' ';
      00915C 1E 05            [ 2]  522 	ldw	x, (0x05, sp)
      00915E A6 20            [ 1]  523 	ld	a, #0x20
      009160 F7               [ 1]  524 	ld	(x), a
      009161 20 0A            [ 2]  525 	jra	00113$
      009163                        526 00112$:
                                    527 ;	./params.c: 232: ( (unsigned char*) strBuff) [1] = 'F';
      009163 1E 03            [ 2]  528 	ldw	x, (0x03, sp)
      009165 A6 46            [ 1]  529 	ld	a, #0x46
      009167 F7               [ 1]  530 	ld	(x), a
                                    531 ;	./params.c: 233: ( (unsigned char*) strBuff) [2] = 'F';
      009168 1E 05            [ 2]  532 	ldw	x, (0x05, sp)
      00916A A6 46            [ 1]  533 	ld	a, #0x46
      00916C F7               [ 1]  534 	ld	(x), a
      00916D                        535 00113$:
                                    536 ;	./params.c: 236: ( (unsigned char*) strBuff) [3] = 0;
      00916D 1E 07            [ 2]  537 	ldw	x, (0x07, sp)
      00916F 7F               [ 1]  538 	clr	(x)
                                    539 ;	./params.c: 237: break;
      009170 20 26            [ 2]  540 	jra	00117$
                                    541 ;	./params.c: 239: case PARAM_THRESHOLD:
      009172                        542 00114$:
                                    543 ;	./params.c: 240: itofpa (paramCache[id], strBuff, 0);
      009172 1E 09            [ 2]  544 	ldw	x, (0x09, sp)
      009174 1C 00 29         [ 2]  545 	addw	x, #(_paramCache + 0)
      009177 FE               [ 2]  546 	ldw	x, (x)
      009178 4B 00            [ 1]  547 	push	#0x00
      00917A 16 0F            [ 2]  548 	ldw	y, (0x0f, sp)
      00917C 90 89            [ 2]  549 	pushw	y
      00917E 89               [ 2]  550 	pushw	x
      00917F CD 91 F0         [ 4]  551 	call	_itofpa
      009182 5B 05            [ 2]  552 	addw	sp, #5
                                    553 ;	./params.c: 241: break;
      009184 20 12            [ 2]  554 	jra	00117$
                                    555 ;	./params.c: 243: default: // Display "OFF" to all unknown ID
      009186                        556 00115$:
                                    557 ;	./params.c: 244: ( (unsigned char*) strBuff) [0] = 'O';
      009186 1E 01            [ 2]  558 	ldw	x, (0x01, sp)
      009188 A6 4F            [ 1]  559 	ld	a, #0x4f
      00918A F7               [ 1]  560 	ld	(x), a
                                    561 ;	./params.c: 245: ( (unsigned char*) strBuff) [1] = 'F';
      00918B 1E 03            [ 2]  562 	ldw	x, (0x03, sp)
      00918D A6 46            [ 1]  563 	ld	a, #0x46
      00918F F7               [ 1]  564 	ld	(x), a
                                    565 ;	./params.c: 246: ( (unsigned char*) strBuff) [2] = 'F';
      009190 1E 05            [ 2]  566 	ldw	x, (0x05, sp)
      009192 A6 46            [ 1]  567 	ld	a, #0x46
      009194 F7               [ 1]  568 	ld	(x), a
                                    569 ;	./params.c: 247: ( (unsigned char*) strBuff) [3] = 0;
      009195 1E 07            [ 2]  570 	ldw	x, (0x07, sp)
      009197 7F               [ 1]  571 	clr	(x)
                                    572 ;	./params.c: 248: }
      009198                        573 00117$:
                                    574 ;	./params.c: 249: }
      009198 5B 0A            [ 2]  575 	addw	sp, #10
      00919A 81               [ 4]  576 	ret
                                    577 ;	./params.c: 254: void storeParams()
                                    578 ;	-----------------------------------------
                                    579 ;	 function storeParams
                                    580 ;	-----------------------------------------
      00919B                        581 _storeParams:
      00919B 52 02            [ 2]  582 	sub	sp, #2
                                    583 ;	./params.c: 259: if ( (FLASH_IAPSR & 0x08) == 0) {
      00919D C6 50 5F         [ 1]  584 	ld	a, 0x505f
      0091A0 A5 08            [ 1]  585 	bcp	a, #0x08
      0091A2 26 08            [ 1]  586 	jrne	00112$
                                    587 ;	./params.c: 260: FLASH_DUKR = 0xAE;
      0091A4 35 AE 50 64      [ 1]  588 	mov	0x5064+0, #0xae
                                    589 ;	./params.c: 261: FLASH_DUKR = 0x56;
      0091A8 35 56 50 64      [ 1]  590 	mov	0x5064+0, #0x56
                                    591 ;	./params.c: 265: for (i = 0; i < 10; i++) {
      0091AC                        592 00112$:
      0091AC 4F               [ 1]  593 	clr	a
      0091AD                        594 00106$:
                                    595 ;	./params.c: 266: if (paramCache[i] != (* (int*) (EEPROM_BASE_ADDR + EEPROM_PARAMS_OFFSET
      0091AD 5F               [ 1]  596 	clrw	x
      0091AE 97               [ 1]  597 	ld	xl, a
      0091AF 58               [ 2]  598 	sllw	x
      0091B0 90 93            [ 1]  599 	ldw	y, x
      0091B2 1C 00 29         [ 2]  600 	addw	x, #(_paramCache + 0)
      0091B5 FE               [ 2]  601 	ldw	x, (x)
      0091B6 1F 01            [ 2]  602 	ldw	(0x01, sp), x
                                    603 ;	./params.c: 267: + (i * sizeof paramCache[0]) ) ) ) {
      0091B8 72 A9 40 64      [ 2]  604 	addw	y, #0x4064
      0091BC 93               [ 1]  605 	ldw	x, y
      0091BD FE               [ 2]  606 	ldw	x, (x)
      0091BE 13 01            [ 2]  607 	cpw	x, (0x01, sp)
      0091C0 27 04            [ 1]  608 	jreq	00107$
                                    609 ;	./params.c: 269: + (i * sizeof paramCache[0]) ) = paramCache[i];
      0091C2 93               [ 1]  610 	ldw	x, y
      0091C3 16 01            [ 2]  611 	ldw	y, (0x01, sp)
      0091C5 FF               [ 2]  612 	ldw	(x), y
      0091C6                        613 00107$:
                                    614 ;	./params.c: 265: for (i = 0; i < 10; i++) {
      0091C6 4C               [ 1]  615 	inc	a
      0091C7 A1 0A            [ 1]  616 	cp	a, #0x0a
      0091C9 25 E2            [ 1]  617 	jrc	00106$
                                    618 ;	./params.c: 274: FLASH_IAPSR &= ~0x08;
      0091CB 72 17 50 5F      [ 1]  619 	bres	20575, #3
                                    620 ;	./params.c: 275: }
      0091CF 5B 02            [ 2]  621 	addw	sp, #2
      0091D1 81               [ 4]  622 	ret
                                    623 ;	./params.c: 281: static void writeEEPROM (unsigned char val, unsigned char offset)
                                    624 ;	-----------------------------------------
                                    625 ;	 function writeEEPROM
                                    626 ;	-----------------------------------------
      0091D2                        627 _writeEEPROM:
                                    628 ;	./params.c: 284: if ( (FLASH_IAPSR & 0x08) == 0) {
      0091D2 C6 50 5F         [ 1]  629 	ld	a, 0x505f
      0091D5 A5 08            [ 1]  630 	bcp	a, #0x08
      0091D7 26 08            [ 1]  631 	jrne	00102$
                                    632 ;	./params.c: 285: FLASH_DUKR = 0xAE;
      0091D9 35 AE 50 64      [ 1]  633 	mov	0x5064+0, #0xae
                                    634 ;	./params.c: 286: FLASH_DUKR = 0x56;
      0091DD 35 56 50 64      [ 1]  635 	mov	0x5064+0, #0x56
      0091E1                        636 00102$:
                                    637 ;	./params.c: 290: (* (unsigned char*) (EEPROM_BASE_ADDR + offset) ) = val;
      0091E1 7B 04            [ 1]  638 	ld	a, (0x04, sp)
      0091E3 5F               [ 1]  639 	clrw	x
      0091E4 1C 40 00         [ 2]  640 	addw	x, #16384
      0091E7 97               [ 1]  641 	ld	xl, a
      0091E8 7B 03            [ 1]  642 	ld	a, (0x03, sp)
      0091EA F7               [ 1]  643 	ld	(x), a
                                    644 ;	./params.c: 293: FLASH_IAPSR &= ~0x08;
      0091EB 72 17 50 5F      [ 1]  645 	bres	20575, #3
                                    646 ;	./params.c: 294: }
      0091EF 81               [ 4]  647 	ret
                                    648 ;	./params.c: 308: void itofpa (int val, unsigned char* str, unsigned char pointPosition)
                                    649 ;	-----------------------------------------
                                    650 ;	 function itofpa
                                    651 ;	-----------------------------------------
      0091F0                        652 _itofpa:
      0091F0 52 0D            [ 2]  653 	sub	sp, #13
                                    654 ;	./params.c: 310: unsigned char i, l, buffer[] = {0, 0, 0, 0, 0, 0};
      0091F2 0F 01            [ 1]  655 	clr	(0x01, sp)
      0091F4 96               [ 1]  656 	ldw	x, sp
      0091F5 6F 02            [ 1]  657 	clr	(2, x)
      0091F7 96               [ 1]  658 	ldw	x, sp
      0091F8 6F 03            [ 1]  659 	clr	(3, x)
      0091FA 96               [ 1]  660 	ldw	x, sp
      0091FB 6F 04            [ 1]  661 	clr	(4, x)
      0091FD 96               [ 1]  662 	ldw	x, sp
      0091FE 6F 05            [ 1]  663 	clr	(5, x)
      009200 96               [ 1]  664 	ldw	x, sp
      009201 6F 06            [ 1]  665 	clr	(6, x)
                                    666 ;	./params.c: 311: bool minus = false;
      009203 0F 07            [ 1]  667 	clr	(0x07, sp)
                                    668 ;	./params.c: 314: if (val == 0) {
      009205 1E 10            [ 2]  669 	ldw	x, (0x10, sp)
      009207 26 0A            [ 1]  670 	jrne	00102$
                                    671 ;	./params.c: 315: ( (unsigned char*) str) [0] = '0';
      009209 1E 12            [ 2]  672 	ldw	x, (0x12, sp)
      00920B A6 30            [ 1]  673 	ld	a, #0x30
      00920D F7               [ 1]  674 	ld	(x), a
                                    675 ;	./params.c: 316: ( (unsigned char*) str) [1] = 0;
      00920E 5C               [ 1]  676 	incw	x
      00920F 7F               [ 1]  677 	clr	(x)
                                    678 ;	./params.c: 317: return;
      009210 CC 92 EF         [ 2]  679 	jp	00119$
      009213                        680 00102$:
                                    681 ;	./params.c: 321: if (val < 0) {
      009213 0D 10            [ 1]  682 	tnz	(0x10, sp)
      009215 2A 09            [ 1]  683 	jrpl	00104$
                                    684 ;	./params.c: 322: minus = true;
      009217 A6 01            [ 1]  685 	ld	a, #0x01
      009219 6B 07            [ 1]  686 	ld	(0x07, sp), a
                                    687 ;	./params.c: 323: val = -val;
      00921B 1E 10            [ 2]  688 	ldw	x, (0x10, sp)
      00921D 50               [ 2]  689 	negw	x
      00921E 1F 10            [ 2]  690 	ldw	(0x10, sp), x
      009220                        691 00104$:
                                    692 ;	./params.c: 327: for (i = 0; val != 0; i++) {
      009220 0F 0D            [ 1]  693 	clr	(0x0d, sp)
      009222                        694 00114$:
                                    695 ;	./params.c: 328: buffer[i] = '0' + (val % 10);
      009222 5F               [ 1]  696 	clrw	x
      009223 7B 0D            [ 1]  697 	ld	a, (0x0d, sp)
      009225 97               [ 1]  698 	ld	xl, a
      009226 89               [ 2]  699 	pushw	x
      009227 96               [ 1]  700 	ldw	x, sp
      009228 1C 00 03         [ 2]  701 	addw	x, #3
      00922B 72 FB 01         [ 2]  702 	addw	x, (1, sp)
      00922E 1F 0A            [ 2]  703 	ldw	(0x0a, sp), x
      009230 5B 02            [ 2]  704 	addw	sp, #2
                                    705 ;	./params.c: 331: i++;
      009232 7B 0D            [ 1]  706 	ld	a, (0x0d, sp)
      009234 4C               [ 1]  707 	inc	a
      009235 6B 0A            [ 1]  708 	ld	(0x0a, sp), a
                                    709 ;	./params.c: 327: for (i = 0; val != 0; i++) {
      009237 1E 10            [ 2]  710 	ldw	x, (0x10, sp)
      009239 27 43            [ 1]  711 	jreq	00107$
                                    712 ;	./params.c: 328: buffer[i] = '0' + (val % 10);
      00923B 4B 0A            [ 1]  713 	push	#0x0a
      00923D 4B 00            [ 1]  714 	push	#0x00
      00923F 1E 12            [ 2]  715 	ldw	x, (0x12, sp)
      009241 89               [ 2]  716 	pushw	x
      009242 CD 93 E9         [ 4]  717 	call	__modsint
      009245 5B 04            [ 2]  718 	addw	sp, #4
      009247 9F               [ 1]  719 	ld	a, xl
      009248 AB 30            [ 1]  720 	add	a, #0x30
      00924A 1E 08            [ 2]  721 	ldw	x, (0x08, sp)
      00924C F7               [ 1]  722 	ld	(x), a
                                    723 ;	./params.c: 330: if (i == pointPosition) {
      00924D 7B 0D            [ 1]  724 	ld	a, (0x0d, sp)
      00924F 11 14            [ 1]  725 	cp	a, (0x14, sp)
      009251 26 19            [ 1]  726 	jrne	00106$
                                    727 ;	./params.c: 331: i++;
      009253 7B 0A            [ 1]  728 	ld	a, (0x0a, sp)
      009255 6B 0D            [ 1]  729 	ld	(0x0d, sp), a
                                    730 ;	./params.c: 332: buffer[i] = '.';
      009257 5F               [ 1]  731 	clrw	x
      009258 7B 0D            [ 1]  732 	ld	a, (0x0d, sp)
      00925A 97               [ 1]  733 	ld	xl, a
      00925B 89               [ 2]  734 	pushw	x
      00925C 96               [ 1]  735 	ldw	x, sp
      00925D 1C 00 03         [ 2]  736 	addw	x, #3
      009260 72 FB 01         [ 2]  737 	addw	x, (1, sp)
      009263 1F 0D            [ 2]  738 	ldw	(0x0d, sp), x
      009265 5B 02            [ 2]  739 	addw	sp, #2
      009267 1E 0B            [ 2]  740 	ldw	x, (0x0b, sp)
      009269 A6 2E            [ 1]  741 	ld	a, #0x2e
      00926B F7               [ 1]  742 	ld	(x), a
      00926C                        743 00106$:
                                    744 ;	./params.c: 335: val /= 10;
      00926C 4B 0A            [ 1]  745 	push	#0x0a
      00926E 4B 00            [ 1]  746 	push	#0x00
      009270 1E 12            [ 2]  747 	ldw	x, (0x12, sp)
      009272 89               [ 2]  748 	pushw	x
      009273 CD 93 FF         [ 4]  749 	call	__divsint
      009276 5B 04            [ 2]  750 	addw	sp, #4
      009278 1F 10            [ 2]  751 	ldw	(0x10, sp), x
                                    752 ;	./params.c: 327: for (i = 0; val != 0; i++) {
      00927A 0C 0D            [ 1]  753 	inc	(0x0d, sp)
      00927C 20 A4            [ 2]  754 	jra	00114$
      00927E                        755 00107$:
                                    756 ;	./params.c: 339: if (buffer[i - 1] == '.') {
      00927E 7B 0D            [ 1]  757 	ld	a, (0x0d, sp)
      009280 4A               [ 1]  758 	dec	a
      009281 6B 0C            [ 1]  759 	ld	(0x0c, sp), a
      009283 49               [ 1]  760 	rlc	a
      009284 4F               [ 1]  761 	clr	a
      009285 A2 00            [ 1]  762 	sbc	a, #0x00
      009287 6B 0B            [ 1]  763 	ld	(0x0b, sp), a
      009289 96               [ 1]  764 	ldw	x, sp
      00928A 1C 00 01         [ 2]  765 	addw	x, #1
      00928D 72 FB 0B         [ 2]  766 	addw	x, (0x0b, sp)
      009290 F6               [ 1]  767 	ld	a, (x)
      009291 A1 2E            [ 1]  768 	cp	a, #0x2e
      009293 26 09            [ 1]  769 	jrne	00109$
                                    770 ;	./params.c: 340: buffer[i] = '0';
      009295 1E 08            [ 2]  771 	ldw	x, (0x08, sp)
      009297 A6 30            [ 1]  772 	ld	a, #0x30
      009299 F7               [ 1]  773 	ld	(x), a
                                    774 ;	./params.c: 341: i++;
      00929A 7B 0A            [ 1]  775 	ld	a, (0x0a, sp)
      00929C 6B 0D            [ 1]  776 	ld	(0x0d, sp), a
      00929E                        777 00109$:
                                    778 ;	./params.c: 345: if (minus) {
      00929E 0D 07            [ 1]  779 	tnz	(0x07, sp)
      0092A0 27 13            [ 1]  780 	jreq	00111$
                                    781 ;	./params.c: 346: buffer[i] = '-';
      0092A2 5F               [ 1]  782 	clrw	x
      0092A3 7B 0D            [ 1]  783 	ld	a, (0x0d, sp)
      0092A5 97               [ 1]  784 	ld	xl, a
      0092A6 89               [ 2]  785 	pushw	x
      0092A7 96               [ 1]  786 	ldw	x, sp
      0092A8 1C 00 03         [ 2]  787 	addw	x, #3
      0092AB 72 FB 01         [ 2]  788 	addw	x, (1, sp)
      0092AE 5B 02            [ 2]  789 	addw	sp, #2
      0092B0 A6 2D            [ 1]  790 	ld	a, #0x2d
      0092B2 F7               [ 1]  791 	ld	(x), a
                                    792 ;	./params.c: 347: i++;
      0092B3 0C 0D            [ 1]  793 	inc	(0x0d, sp)
      0092B5                        794 00111$:
                                    795 ;	./params.c: 351: for (l = i; i > 0; i--) {
      0092B5 7B 0D            [ 1]  796 	ld	a, (0x0d, sp)
      0092B7 6B 0C            [ 1]  797 	ld	(0x0c, sp), a
      0092B9                        798 00117$:
      0092B9 0D 0D            [ 1]  799 	tnz	(0x0d, sp)
      0092BB 27 2A            [ 1]  800 	jreq	00112$
                                    801 ;	./params.c: 352: ( (unsigned char*) str) [l - i] = buffer[i - 1];
      0092BD 5F               [ 1]  802 	clrw	x
      0092BE 7B 0C            [ 1]  803 	ld	a, (0x0c, sp)
      0092C0 97               [ 1]  804 	ld	xl, a
      0092C1 7B 0D            [ 1]  805 	ld	a, (0x0d, sp)
      0092C3 6B 0B            [ 1]  806 	ld	(0x0b, sp), a
      0092C5 0F 0A            [ 1]  807 	clr	(0x0a, sp)
      0092C7 72 F0 0A         [ 2]  808 	subw	x, (0x0a, sp)
      0092CA 72 FB 12         [ 2]  809 	addw	x, (0x12, sp)
      0092CD 51               [ 1]  810 	exgw	x, y
      0092CE 7B 0D            [ 1]  811 	ld	a, (0x0d, sp)
      0092D0 4A               [ 1]  812 	dec	a
      0092D1 6B 0B            [ 1]  813 	ld	(0x0b, sp), a
      0092D3 49               [ 1]  814 	rlc	a
      0092D4 4F               [ 1]  815 	clr	a
      0092D5 A2 00            [ 1]  816 	sbc	a, #0x00
      0092D7 6B 0A            [ 1]  817 	ld	(0x0a, sp), a
      0092D9 96               [ 1]  818 	ldw	x, sp
      0092DA 1C 00 01         [ 2]  819 	addw	x, #1
      0092DD 72 FB 0A         [ 2]  820 	addw	x, (0x0a, sp)
      0092E0 F6               [ 1]  821 	ld	a, (x)
      0092E1 90 F7            [ 1]  822 	ld	(y), a
                                    823 ;	./params.c: 351: for (l = i; i > 0; i--) {
      0092E3 0A 0D            [ 1]  824 	dec	(0x0d, sp)
      0092E5 20 D2            [ 2]  825 	jra	00117$
      0092E7                        826 00112$:
                                    827 ;	./params.c: 356: ( (unsigned char*) str) [l] = 0;
      0092E7 5F               [ 1]  828 	clrw	x
      0092E8 7B 0C            [ 1]  829 	ld	a, (0x0c, sp)
      0092EA 97               [ 1]  830 	ld	xl, a
      0092EB 72 FB 12         [ 2]  831 	addw	x, (0x12, sp)
      0092EE 7F               [ 1]  832 	clr	(x)
      0092EF                        833 00119$:
                                    834 ;	./params.c: 357: }
      0092EF 5B 0D            [ 2]  835 	addw	sp, #13
      0092F1 81               [ 4]  836 	ret
                                    837 	.area CODE
                                    838 	.area CONST
      0081F4                        839 _paramMin:
      0081F4 00 00                  840 	.dw #0x0000
      0081F6 00 01                  841 	.dw #0x0001
      0081F8 FF D3                  842 	.dw #0xffd3
      0081FA FF CE                  843 	.dw #0xffce
      0081FC FF BA                  844 	.dw #0xffba
      0081FE 00 00                  845 	.dw #0x0000
      008200 00 00                  846 	.dw #0x0000
      008202 00 00                  847 	.dw #0x0000
      008204 00 00                  848 	.dw #0x0000
      008206 FE 0C                  849 	.dw #0xfe0c
      008208                        850 _paramMax:
      008208 00 01                  851 	.dw #0x0001
      00820A 00 96                  852 	.dw #0x0096
      00820C 00 6E                  853 	.dw #0x006e
      00820E 00 69                  854 	.dw #0x0069
      008210 00 46                  855 	.dw #0x0046
      008212 00 0A                  856 	.dw #0x000a
      008214 00 01                  857 	.dw #0x0001
      008216 00 00                  858 	.dw #0x0000
      008218 00 00                  859 	.dw #0x0000
      00821A 04 4C                  860 	.dw #0x044c
      00821C                        861 _paramDefault:
      00821C 00 00                  862 	.dw #0x0000
      00821E 00 14                  863 	.dw #0x0014
      008220 00 6E                  864 	.dw #0x006e
      008222 FF CE                  865 	.dw #0xffce
      008224 00 00                  866 	.dw #0x0000
      008226 00 00                  867 	.dw #0x0000
      008228 00 00                  868 	.dw #0x0000
      00822A 00 00                  869 	.dw #0x0000
      00822C 00 00                  870 	.dw #0x0000
      00822E 01 18                  871 	.dw #0x0118
                                    872 	.area INITIALIZER
                                    873 	.area CABS (ABS)

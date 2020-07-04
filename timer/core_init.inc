;----------------------------------------------------------
;	Stack initialization
;----------------------------------------------------------
Reset:
		ldi r16, low(RAMEND)
		out spl, r16

		ldi r16, high(RAMEND)
		out sph, r16

RAM_Flush:
		
		ldi zl, low(SRAM_START)
		ldi zh, high(SRAM_START)
		clr r16

Flush:
		st z+, r16
		cpi zh, high(RAMEND + 1)
		brne Flush

		cpi zl, low(RAMEND + 1)
		brne Flush

		ldi zl, 30
		clr zh
		dec zl
		st z, zh
		brne pc-2

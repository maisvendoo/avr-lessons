;----------------------------------------------------------
;	Set bit with stack
;----------------------------------------------------------
		.MACRO SETBM
		.if @0 < 0x20
		sbi @0, @1
		.else
			.if @0 < 0x40
			push r17
			in r17, @0
			ori r17, 1 << @1
			out @0, r17
			pop r17
			.else
			push r17
			lds r17,@0
			ori r17, 1 << @1
			sts @0, R17
			pop r17
			.endif
		.endif
		.ENDM

;----------------------------------------------------------
;	Clear bit with stack
;----------------------------------------------------------
		.MACRO CLRBM
		.if @0 < 0x20
		cbi @0, @1
		.else
			.if @0 < 0x40
			push r17
			in r17, @0
			andi r17, ~(1 << @1)
			out @0, r17
			pop r17
			.else
			push r17
			lds r17, @0
			andi r17, ~(1 << @1)
			sts @0, r17
			pop r17
			.endif
		.endif
		.ENDM

;----------------------------------------------------------
;	Clear bit with stack
;----------------------------------------------------------
		.MACRO INVBM
		.if @0 < 0x40
		push r16
		push r17
		in r16, @0
		ldi r17, 1 << @1
		eor r17, r16
		out @0, r17
		pop r17
		pop r16
		.else
		push r16
		push r17
		lds r16, @0
		ldi r17, 1 << @1
		eor r17, r16
		sts @0, r17
		pop r17
		pop r16
		.endif
		.ENDM


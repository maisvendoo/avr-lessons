		.include	"m16def.inc"
		
;----------------------------------------------------------
;	Macro description
;----------------------------------------------------------
		.include	"macro.inc"

;----------------------------------------------------------
;	RAM
;----------------------------------------------------------
		.dseg

count:	.byte	4

;----------------------------------------------------------
;	Flash
;----------------------------------------------------------
		.cseg
		.include	"interrupt_table.inc"

;----------------------------------------------------------
;	Interrupt handlers
;----------------------------------------------------------

		.include	"core_init.inc"

;----------------------------------------------------------
;	Internal hardware init
;----------------------------------------------------------
	SETBM	ddrd, 4
	SETBM	ddrd, 5
	SETBM	ddrd, 7

	CLRBM	ddrd, 6
	SETBM	PORTD, 6 

;----------------------------------------------------------
;	External hardware init
;----------------------------------------------------------

;----------------------------------------------------------
;	Run background threads
;----------------------------------------------------------

;----------------------------------------------------------
;	Main loop
;----------------------------------------------------------
Main:
		sbis PIND, 6
		rjmp BT_Push

		SETBM PORTD, 5
		CLRBM PORTD, 4
Next:
		lds r16, count
		lds r17, count + 1
		lds r18, count + 2
		andi r18, 0x07

		cpi r16, 0xB6
		brne NoMatch
		cpi r17, 0x9F
		brne NoMatch
		cpi r18, 0x04
		brne NoMatch

Match:
		INVBM PORTD, 7

NoMatch:

		nop

		lds r16, count
		lds r17, count + 1
		lds r18, count + 2
		lds r19, count + 3
		
		subi r16, (-1)
		sbci r17, (-1)
		sbci r18, (-1)
		sbci r19, (-1)
		
		sts count, r16
		sts count + 1, r17
		sts count + 2, r18
		sts count + 3, r19			

		jmp Main

BT_Push:
		
		SETBM	PORTD, 4
		CLRBM	PORTD, 5
		rjmp Next

;----------------------------------------------------------
;	Procedures
;----------------------------------------------------------


;----------------------------------------------------------
;	EEPROM
;----------------------------------------------------------
	.eseg

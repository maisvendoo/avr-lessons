		.include	"m16def.inc"
		
;----------------------------------------------------------
;	Macro description
;----------------------------------------------------------
		.include	"macro.inc"

;----------------------------------------------------------
;	RAM
;----------------------------------------------------------
		.dseg

recv_data:	.byte 1

StrPtr:		.byte 2

;----------------------------------------------------------
;	Flash
;----------------------------------------------------------
		.cseg
		.include	"interrupt_table.inc"

;----------------------------------------------------------
;	Interrupt handlers
;----------------------------------------------------------
RX_OK:
	
		PUSHF

		in r16, UDR
		sts recv_data, r16

		POPF

		reti

UD_OK:

		PUSHF
		push zl
		push zh

		lds zl, StrPtr
		lds zh, StrPtr + 1

		lpm r16, z+

		cpi r16, 0
		breq Stop_RX

		out UDR, r16

		sts StrPtr, zl
		sts StrPtr + 1, zh

Exit_RX:

		pop zh
		pop zl

		POPF

		reti

Stop_RX:

		ldi r16, (1 << RXEN) | (1 << TXEN) | (1 << RXCIE) | (1 << TXCIE) | ( 0 << UDRIE)
		out UCSRB, r16
		rjmp Exit_RX 

TX_OK:

		reti

;----------------------------------------------------------
;	CPU init
;----------------------------------------------------------
		.include	"core_init.inc"

;----------------------------------------------------------
;	Internal hardware init
;----------------------------------------------------------
		.equ	XTAL = 8000000
		.equ	baudrate = 9600
		.equ	divider = XTAL / (16 * baudrate) - 1

;----------------------------------------------------------
;	External hardware init
;----------------------------------------------------------

;----------------------------------------------------------
;	Run background threads
;----------------------------------------------------------

;----------------------------------------------------------
;	Main loop
;----------------------------------------------------------
		rcall uart_init
		
		sei	
	
		ldi r17, low(2*String)
		ldi r18, high(2*String)

		sts StrPtr, r17
		sts StrPtr + 1, r18		

		ldi r16, (1 << RXEN) | (1 << TXEN) | (1 << RXCIE) | (1 << TXCIE) | ( 1 << UDRIE)
		out UCSRB, r16

Main:

		jmp Main

;----------------------------------------------------------
;	Procedures
;----------------------------------------------------------
uart_init:

		ldi r16, low(divider)
		out UBRRL, r16
		ldi r16, high(divider)
		out UBRRH, r16

		ldi r16, 0
		out UCSRA, r16

		ldi r16, (1 << RXEN) | (1 << TXEN) | (1 << RXCIE) | (1 << TXCIE) | ( 0 << UDRIE)
		out UCSRB, r16

		ldi r16, (1 << URSEL) | ( 1 << UCSZ0) | (1 << UCSZ1)
		out UCSRC, r16

		ret

String:	.db		"Hello, world! ",0

;----------------------------------------------------------
;	EEPROM
;----------------------------------------------------------
		.eseg

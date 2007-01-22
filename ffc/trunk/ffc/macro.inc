;-------------------------------------------------------------
; Bin2Hex
;-------------------------------------------------------------

Bin2Hex macro
	
	xor		ah,ah		; ax = 00 AB
	shl		ax,4		; ax = 0A B0
	shr		al,4		; ax = 0A 0B
	xlat				; ax = 0A 42		// 42 = 'B'
	xchg	ah,al		; ax = 42 0A
	xlat				; ax = 42 41		// 41 = 'A'
	stosb
	xchg	ah,al
	stosb

endm

;-------------------------------------------------------------
; DSpace
;-------------------------------------------------------------

DSpace macro
	
	mov		al,' '
	stosb

endm

;-------------------------------------------------------------
; IfEAXZeroJmpTo
;-------------------------------------------------------------

IfEAXZeroJmpTo macro lpLabel

	or		eax,eax
	jnz		@F
	jmp		lpLabel		
@@:
	
endm
;-------------------------------------------------------------
;
;  CheckFloat.asm
;  04.06.05 by fnt0m32
;
;  Used <MASM32 v8.2> suite.
;
;-------------------------------------------------------------
.386
.model flat,stdcall
option casemap:none

CheckFloat			PROTO :DWORD

.data

sym		db "0123456789.,eE+-"

.code 

;-------------------------------------------------------------
; check asciiz for right float number
; also change all ',' to '.'
; return: eax = TRUE/FALSE
;-------------------------------------------------------------

CheckFloat proc uses ebx esi edi lpszStr:DWORD

	mov		ebx,lpszStr
	ret

CheckFloat endp
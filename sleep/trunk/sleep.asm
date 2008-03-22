; $Id$

.386
.model flat,stdcall
option casemap:none


include windows.inc
include kernel32.inc
include shlwapi.inc
include masm32.inc

includelib kernel32.lib
includelib shlwapi.lib
includelib masm32.lib


.code

start:

	invoke	GetCommandLine
	
	mov		ebx,eax
	invoke	StrLen, eax
	
	; find last space
	std
	mov		ecx,eax
	lea		edi,[ebx+eax-1]
	mov		al,' '
	repne scasb
	jne exit
	lea		edi,[edi+2]
	cld
	
	invoke	StrToInt, edi
	
	invoke	Sleep, eax

exit:

	invoke	ExitProcess, 0

end start
comment `#####################################################
#
#  mmh.asm    09.07.2007 by fnt0m32 'at' gmail.com
#
#  Middle Mouse Hook Hook-DLL
#
#  Used [MASM32 v8.2]
#
##############################################################`

.386
.model flat,stdcall
option casemap:none

include windows.inc

include kernel32.inc
include user32.inc

includelib kernel32.lib
includelib user32.lib


.data

hInstance	dd 0
cmd_exec	db "notepad",0


.data?

hHook		dd ?
hWnd		dd ?



.code


entry_point proc hinst:dword, reason:dword, res:dword
	
	cmp		reason,DLL_PROCESS_ATTACH
	jne		@F
	push	hinst
	pop		hInstance
@@:

	mov		eax,TRUE
	ret

entry_point endp


hook_itself proc uses edx nCode:dword, wParam:dword, lParam:dword

; when i used edx inside this proc it was crashed on Windows2KSP4. may be edx needed to be pushed/poped
; but on WindowsXPSP2 it worked fine with using edx
; also i had a crashing problems (on 2K only too) that was resolved by storing/restoring ebx,esi,edi in wnd_proc@kli.exe, because make_icon@kli.exe use them and it's called form wnd_proc
; i don't know what may happen dunder win9x because i didn't test it under them

	cmp		nCode,0
	jl		exit
	
	cmp		wParam,WM_MBUTTONDOWN
	jne		exit
	
	invoke	WinExec, addr cmd_exec, SW_SHOWNORMAL
	
	
	comment `
	mov		eax,lParam
	assume	eax:ptr CWPSTRUCT
	
	; catch WM_ACTIVATEAPP
	cmp		[eax].message,WM_ACTIVATEAPP
	jne		@F
	cmp		[eax].wParam,TRUE
	jne		exit
	jmp		send_notify
@@:

	; catch WM_INPUTLANGCHANGE 
	cmp		[eax].message,WM_INPUTLANGCHANGE
	jne		exit
	
	
send_notify:

	invoke	PostMessage, hWnd, WM_KLI_NEED_UPDATE, [eax].hwnd, 0
	`
	
exit:

	;assume	eax:nothing

	invoke	CallNextHookEx, hHook, nCode, wParam, lParam

	ret

hook_itself endp


sethook proc hwnd:dword
	
	push	hwnd
	pop		hWnd
	
	invoke	SetWindowsHookEx, WH_MOUSE, addr hook_itself, hInstance, 0
	mov		hHook,eax
	
	ret

sethook endp


unhook proc
	
	invoke	UnhookWindowsHookEx, hHook
	
	ret

unhook endp


end entry_point
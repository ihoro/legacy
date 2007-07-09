comment `#####################################################
#
#  mmh.asm    09.07.2007 by fnt0m32 'at' gmail.com
#
#  Middle Mouse Hook
#
#  Used [MASM32 v8.2]
#
##############################################################`

.386
.model flat,stdcall
option casemap:none


;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include masm32.inc
include hook\mmh.inc
include kernel32.inc
include user32.inc


;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib masm32.lib
includelib hook\mmh.lib
includelib kernel32.lib
includelib user32.lib


;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

DlgProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD


;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

IDD_DLG						equ 1000


;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

hInstance					dd ?


;-------------------------------------------------------------
; code
;-------------------------------------------------------------

.code

entry_point:


	invoke	GetModuleHandle,NULL
	mov		hInstance,eax
	
	invoke	sethook, 0
	invoke	DialogBoxParam,hInstance,IDD_DLG,NULL,DlgProc,NULL		
	invoke	unhook
	
	invoke	ExitProcess,eax
	
	
DlgProc proc uses ebx esi edi hwnd:DWORD,msg:UINT,wParam:WPARAM,lParam:LPARAM
	
	mov		eax,msg
	
	.if eax==WM_CLOSE		
		invoke	EndDialog,hwnd,NULL
	.else
		xor		eax,eax
		ret		
	.endif
	
	mov		eax,TRUE
	ret

DlgProc endp


end entry_point
comment `#####################################################
#
#  pcalc.asm    07.06.05 by fnt0m32
#
##############################################################`

.386
.model flat,stdcall
option casemap:none

;-------------------------------------------------------------
; inc,lib,data,data?,const,equ
;-------------------------------------------------------------

include pcalc.inc

;-------------------------------------------------------------
; CODE
;-------------------------------------------------------------

.code

start:

	invoke	InitCommonControls

	; handle of module
	;~~~~~~~~~~~~~~~~~
	invoke	GetModuleHandle,NULL
	mov		hInstance,eax

	; go-go-go ;)
	;~~~~~~~~~~~~
	invoke	DialogBoxParam,hInstance,IDD_DIALOG,NULL,WndProc,NULL
	
	; just go out
	;~~~~~~~~~~~~
	invoke	ExitProcess,eax
	
;-------------------------------------------------------------
; Proc for Main Dialog
;-------------------------------------------------------------

WndProc proc uses ebx hwnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	
	;-------------------------------------
	; WM_INITDIALOG
	;-------------------------------------
	
	.if eax==WM_INITDIALOG
		
		; set icon 4 dialog
		;~~~~~~~~~~~~~~~~~~
		invoke	LoadIcon,hInstance,IDI_ICON
		mov		hFont,eax
		invoke	SendMessage,hwnd,WM_SETICON,ICON_BIG,hFont
		
		; set font for edit controls
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	CreateFontIndirect,addr EditFont
		mov		hFont,eax
		invoke	SendDlgItemMessage,hwnd,IDC_EDT_1,WM_SETFONT,hFont,FALSE
		invoke	SendDlgItemMessage,hwnd,IDC_EDT_2,WM_SETFONT,hFont,FALSE
		invoke	SendDlgItemMessage,hwnd,IDC_EDT_3,WM_SETFONT,hFont,FALSE
		invoke	SendDlgItemMessage,hwnd,IDC_EDT_4,WM_SETFONT,hFont,FALSE
		
		; set limit text 4 edit controls
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_EDT_1,EM_LIMITTEXT,_LimitText4Edit,0
		invoke	SendDlgItemMessage,hwnd,IDC_EDT_2,EM_LIMITTEXT,_LimitText4Edit,0
		invoke	SendDlgItemMessage,hwnd,IDC_EDT_3,EM_LIMITTEXT,_LimitText4Edit,0
		invoke	SendDlgItemMessage,hwnd,IDC_EDT_4,EM_LIMITTEXT,_LimitText4Edit,0
		
		; set focus on first edit control "Start Sum"
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	GetDlgItem,hwnd,IDC_EDT_1		;get H of edit "Start Sum"
		invoke	SetFocus,eax					;set focus on this edit
		
	;-------------------------------------
	; WM_CTLCOLORDLG
	;-------------------------------------
		
	.elseif eax==WM_CTLCOLORDLG
	
		invoke	CreateSolidBrush,Black
		ret
		
	;-------------------------------------
	; WM_CTLCOLOREDIT
	;-------------------------------------
		
	.elseif eax==WM_CTLCOLOREDIT
		
		xor		ebx,ebx
		mov		bl,LastField
		add		ebx,IDC_EDT_1
		dec		ebx
		invoke	GetDlgItem,hwnd,ebx
		.if lParam==eax
			invoke	SetTextColor,wParam,clr_EditActive
		.else
			invoke	SetTextColor,wParam,clr_EditSimple
		.endif
		invoke	SetBkMode,wParam,TRANSPARENT
		invoke	CreateSolidBrush,Black
		ret
		
	;-------------------------------------
	; WM_CTLCOLORSTATIC
	;-------------------------------------
		
	.elseif eax==WM_CTLCOLORSTATIC
		
		invoke	SetBkMode,wParam,TRANSPARENT
		invoke	SetTextColor,wParam,clr_Static
		invoke	CreateSolidBrush,Black
		ret
		
	;-------------------------------------
	; WM_COMMAND
	;-------------------------------------
		
	.elseif eax==WM_COMMAND
		
		mov		eax,wParam
		
		; Click - IDC_CLEAR_?
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		.if (ax >= IDC_CLEAR_1) && (ax <= IDC_CLEAR_4)
			
			and		eax,0FFFFh
			lea		eax,[eax-IDC_CLEAR_1+IDC_EDT_1]		;eax = IDC_EDT_X  X=1..4
			invoke	SetDlgItemText,hwnd,eax,NULL
			
		; Click - IDC_CALC
		;~~~~~~~~~~~~~~~~~
		.elseif ax==IDC_CALC
			
			include calc.inc
			
		.endif
		
	;-------------------------------------
	; WM_CLOSE
	;-------------------------------------
		
	.elseif eax==WM_CLOSE
		
		invoke	EndDialog,hwnd,NULL
		
	;-------------------------------------
	; system Dialog Procedure
	;-------------------------------------
		
	.else
		
		xor		eax,eax
		ret
		
	.endif

	;-------------------------------------
	; all right - we got this message.
	;-------------------------------------
	
end_dlg_proc:
	
	mov		eax,TRUE
	ret

WndProc endp

;-------------------------------------------------------------
; check asciiz for right float number
; it checks only right symbols like <+-0..9,.eE>
; also change all ',' to '.'
; return: eax = TRUE/FALSE
;-------------------------------------------------------------

CheckFloat proc uses ebx esi lpszStr:DWORD

	jmp		@F
	sym		db "0123456789.eE+"
@@:
	mov		ebx,lpszStr
	
check_char:

	xor		ecx,ecx						;init cycle 
	mov		al,byte ptr [ebx]			;get current char
	mov		esi,0
	.while	ecx <= sizeof sym - 1		;ecx = 0 .. Len(sym)-1
	
		.if al == byte ptr sym[ecx]		;if char is in [sym]
			inc		esi
			.break						;then go to next char or end
		.elseif al == ','				;if char is ','
			mov		byte ptr [ebx],'.'	;change char to '.'
			inc		esi
			.break						;look for next char
		.endif
		
		inc		ecx
		
	.endw
	
	.if esi==0							;if current char is not in [sym]
		xor		eax,eax					;result is FALSE
		ret
	.endif
	
	inc		ebx							;get next char
	.if byte ptr [ebx] == 0				;if it's last char
		mov		eax,TRUE				;then set result
		ret								;and exit
	.else
		jmp		check_char				;else check next char
	.endif

CheckFloat endp


end start
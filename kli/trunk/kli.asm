comment `#####################################################
#
#  kli.asm    21.01.2007 by fnt0m32 'at' gmail.com
#
#  Keyboard Layout Indicator
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
include hook\kli.inc
include kernel32.inc
include user32.inc
include gdi32.inc
include shell32.inc


;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib masm32.lib
includelib hook\kli.lib
includelib kernel32.lib
includelib user32.lib
includelib gdi32.lib
includelib shell32.lib


;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

make_icon	proto
wnd_proc	proto :dword, :dword, :dword, :dword


;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

include hook\messages.inc

WM_SHELL_NOTIFY				equ WM_USER+110

IDM_EXIT					equ 1


;-------------------------------------------------------------
; data
;-------------------------------------------------------------

.data

include ISO639-1.inc

wnd_class					db "KlI",0
menu_exit					db "E&xit",0

text_rect					RECT <0, 4, 17, 13>
icon_lf						LOGFONT <-11,0,0,0,400,0,0,0,0,3,2,1,34,"Tahoma">
transparent					dd 0

err_title					db "Keyboard Layout Indicator",0
err_broken_command_line		db "Command line parsing error.",10
							db "Usage: r,g,b R,G,B {bold=0/1} {lower-case=0/1} {transparent_bg=0/1}"
							db 0


;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

wc							WNDCLASSEX <?>
hWnd						dd ?
m							MSG <?>
menu						dd ?

nid							NOTIFYICONDATA <?>

and_mask					db 32 dup (?)

icon						dd LANG_CODE_COUNT dup (?)
icon_id						dd ?
icon_font					dd ?
icon_color					dd ?
icon_bkcolor				dd ?


;-------------------------------------------------------------
; code
;-------------------------------------------------------------

.code

entry_point:


	; parse command line
	;~~~~~~~~~~~~~~~~~~~~~
	
	include	parsing.inc
	
	
	; register window class
	;~~~~~~~~~~~~~~~~~~~~~~
	
	mov		wc.cbSize,sizeof WNDCLASSEX
	invoke	GetModuleHandle, 0
	mov		ebx, eax
	mov		wc.hInstance, eax
	mov		wc.lpfnWndProc, offset wnd_proc
	mov		wc.lpszClassName, offset wnd_class
	invoke	RegisterClassEx, addr wc
	
	
	; create window
	;~~~~~~~~~~~~~~

	invoke	CreateWindowEx, 0, addr wnd_class, 0,0,0,0,0,0,0,0, ebx, 0
	mov		hWnd, eax
	
	
	; init icons' handles
	;~~~~~~~~~~~~~~~~~~~~
	
	mov		ecx,LANG_CODE_COUNT
@@:
	mov		icon[ecx*4-4],0
	loop	@B
			
	
	; create icon_font
	;~~~~~~~~~~~~~~~~~
	
	invoke	CreateFontIndirect, addr icon_lf
	mov		icon_font,eax


	; make current icon
	;~~~~~~~~~~~~~~~~~~
	
	invoke	GetForegroundWindow
	invoke	GetWindowThreadProcessId, eax, 0
	invoke	GetKeyboardLayout, eax
	and		eax,1ffh
	invoke	make_icon


	; install tray icon
	;~~~~~~~~~~~~~~~~~~
	
	mov		nid.cbSize, sizeof NOTIFYICONDATA
	mov		nid.uFlags, NIF_ICON or NIF_TIP or NIF_MESSAGE
	push	hWnd
	pop		nid.hwnd
	mov		nid.uID,0
	mov		ebx,icon_id
	push	icon[ebx*4]
	pop		nid.hIcon
	mov		nid.uCallbackMessage,WM_SHELL_NOTIFY
	invoke	lstrcpy, addr nid.szTip, addr err_title
	
	invoke	Shell_NotifyIcon, NIM_ADD, addr nid
	
	
	; set hook
	;~~~~~~~~~
	
	invoke	sethook, hWnd


	;--------------------------------------------------------
	; loopper :)
	;--------------------------------------------------------
	
@@:
	invoke	GetMessage, addr m, 0, 0, 0
	or		eax,eax
	jz		@F
	invoke	TranslateMessage, addr m
	invoke	DispatchMessage, addr m
	jmp		@B
@@:

	
	; remove hook
	;~~~~~~~~~~~~
	
	invoke	unhook		
	
		
	; uninstall tray icon
	;~~~~~~~~~~~~~~~~~~~~
	
	invoke	Shell_NotifyIcon, NIM_DELETE, addr nid
	
	
	; free all created icons
	;~~~~~~~~~~~~~~~~~~~~~~~
	
	mov		ecx,LANG_CODE_COUNT
	
destroy_next_icon:

	cmp		icon[ecx*4-4],0
	jz		@F
	push	ecx
	invoke	DestroyIcon, icon[ecx*4-4]
	pop		ecx
@@:
	loop	destroy_next_icon
	
	
	; free icon_font
	;~~~~~~~~~~~~~~~
	
	invoke	DeleteObject, icon_font 


	; exit
	;~~~~~
	
just_exit:
	
	invoke	ExitProcess, 0


;-------------------------------------------------------------
; Make an icon depended on primary language id
;
; [in] eax - primary language id
;-------------------------------------------------------------

make_icon proc

local	ii:ICONINFO

	; get primary language id
	
	;and		eax,1ffh			; don't forget do it before
	mov		icon_id,eax
	
	; check index bounds
	
	cmp		eax,LANG_CODE_COUNT
	jb		@F
	mov		icon_id,0				; like default
	jmp		make_icon_exit
@@:
	
	; if that icon was created before
	
	cmp		icon[eax*4],0
	jz		@F
	jmp		make_icon_exit
@@:
	
	; create DC in memory
	
	invoke	GetDC, 0
	mov		ebx,eax
	invoke	CreateCompatibleDC, ebx
	dc		equ esi
	mov		dc,eax
	
	; create XOR bitmap
	
	invoke	CreateCompatibleBitmap, ebx, 16, 16
	bmp_xor	equ edi
	mov		bmp_xor,eax
	invoke	ReleaseDC, 0, ebx
		
	; select XOR bitmap
	
	invoke	SelectObject, dc, bmp_xor
	push	eax
	
	; fill entire space
	
	invoke	CreateSolidBrush, icon_bkcolor
	mov		ebx, eax
	invoke	SelectObject, dc, eax
	invoke	Rectangle, dc, -1, -1, 17, 17
	invoke	DeleteObject, ebx
	
	; select font and its color
		
	invoke	SelectObject, dc, icon_font
	invoke	SetTextColor, dc, icon_color
	invoke	SetBkMode, dc, TRANSPARENT
	
	; draw language code

	mov		eax,icon_id
	lea		eax,lang_code[eax*2]
	invoke	DrawText, dc, eax, 2, addr text_rect, DT_CENTER or DT_SINGLELINE or DT_VCENTER or DT_INTERNAL
		
	; if need transparency then make certain and_mask
	
	cmp		transparent,0
	jz		keep_opaque
	
	push	bmp_xor
	
	; zero and_mask
	mov		ecx,8
	cld
	lea		edi,offset and_mask
	xor		eax,eax
	rep stosd	
	
	; go by lines
	mov		ecx,16
next_line:
	push	ecx
	
			; go by columns
			lea		ebx,[ecx-1]			; current line
			mov		ecx,16
		next_column:
			push	ecx
			lea		edi,[ecx-1]			; current column
			invoke	GetPixel, dc, edi, ebx
			cmp		eax,icon_bkcolor
			jne		@F
			xor		edx,edx
			lea		eax,[ebx*2]
			lea		eax,[eax*8+edi]		; like ebx*16 + edi
			mov		ecx,8
			div		ecx					; like (ebx*16 + edi) / 8 -> eax, (ebx*16 + edi) % 8 -> edx
			mov		ecx,edx
			mov		dl,80h
			shr		dl,cl				; like 0x80 >> [ (ebx*16 + edi) % 8 ]
			or		and_mask[eax],dl
		@@:
			pop		ecx
			loop	next_column
			
	pop		ecx
	loop	next_line
		
	pop		bmp_xor
	
keep_opaque:
	
	; unselect XOR bitmap
	
	pop		eax
	invoke	SelectObject, dc, eax
	
	; create AND bitmap
	
	invoke	CreateBitmap, 16, 16, 1, 1, addr and_mask
	mov		ebx, eax
	
	; create icon
	
	mov		ii.fIcon,TRUE
	mov		ii.hbmMask,eax
	mov		ii.hbmColor,bmp_xor
	invoke	CreateIconIndirect, addr ii
	mov		ecx,icon_id
	mov		icon[ecx*4],eax
	
	; free DC and bitmaps
		
	invoke	DeleteObject, ebx
	invoke	DeleteObject, bmp_xor
	invoke	DeleteDC, dc

make_icon_exit:

	ret

make_icon endp


;-------------------------------------------------------------
; window procedure
;-------------------------------------------------------------

wnd_proc proc uses ebx esi edi hwnd:dword, msg:dword, wParam:dword, lParam:dword

local	p:POINT

	mov		eax,msg 
	
	;-------------------------------------------
	; WM_CREATE
	;-------------------------------------------
	.if eax == WM_CREATE
	
		; create popup menu and fill it
		invoke	CreatePopupMenu
		mov		menu,eax
		invoke	AppendMenu, eax, MF_STRING, IDM_EXIT, addr menu_exit
	
	
	;-------------------------------------------
	; WM_DESTROY
	;-------------------------------------------
	.elseif eax == WM_DESTROY

		; delete popup menu
		invoke	DestroyMenu, menu
		
		; exit
		invoke	PostQuitMessage, 0
		 
	
	;-------------------------------------------
	; WM_KLI_NEED_UPDATE
	;-------------------------------------------
	.elseif eax == WM_KLI_NEED_UPDATE
	
		; get layout
		mov		eax,wParam
		invoke	GetWindowThreadProcessId, eax, 0
		invoke	GetKeyboardLayout, eax
		
		; check if it's the same icon
		and		eax,1ffh
		cmp		icon_id,eax
		je		@F
		
		; else make icon
		push	eax
		invoke	make_icon
		
		; and set new icon
		pop		eax
		push	icon[eax*4]
		pop		nid.hIcon
		invoke	Shell_NotifyIcon, NIM_MODIFY, addr nid
	@@:
		
		
	;-------------------------------------------
	; WM_SHELL_NOTIFY
	;-------------------------------------------
	.elseif eax == WM_SHELL_NOTIFY

		cmp		lParam,WM_RBUTTONDOWN
		jne		@F
		invoke	GetCursorPos, addr p
		invoke	SetForegroundWindow, hWnd
		invoke	TrackPopupMenu, menu, TPM_RIGHTALIGN, p.x, p.y, 0, hWnd, 0
		invoke	PostMessage, hWnd, WM_NULL, 0, 0
	@@:
	
	
	;-------------------------------------------
	; WM_COMMAND
	;-------------------------------------------
	.elseif eax == WM_COMMAND
	
		cmp		lParam,0
		jnz		@F
		
		mov		eax,wParam
		cmp		ax,IDM_EXIT
		jne		@F
		
		invoke	DestroyWindow, hWnd
		
	@@:
	
	
	;-------------------------------------------
	; DefWindowProc
	;-------------------------------------------
	.else
	
		invoke	DefWindowProc, hwnd, msg, wParam, lParam
		ret
		
	.endif
	
	xor		eax,eax
	ret

wnd_proc endp

	
end entry_point
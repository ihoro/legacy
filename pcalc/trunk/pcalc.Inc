;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc
include comctl32.inc
include masm32.inc
include ix85.inc

;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib
includelib comctl32.lib
includelib masm32.lib
includelib ix85.lib

;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

WndProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD
CheckFloat			PROTO :DWORD

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDI_ICON			equ	1		;main app icon		

	; main dialog
	;~~~~~~~~~~~~
IDD_DIALOG			equ 1000	;main dialog

IDC_EDT_1			equ 1001	;edit "Start Sum"
IDC_EDT_2			equ 1002	;edit "Percent"
IDC_EDT_3			equ 1003	;edit "N"
IDC_EDT_4			equ 1004	;edit "Result"
IDC_STC1			equ 1005
IDC_STC2			equ 1006
IDC_STC3			equ 1007
IDC_STC4			equ 1008
IDC_CLEAR_1			equ 1009	;button cls start sum
IDC_CLEAR_2			equ 1010	;button cls percent
IDC_CLEAR_3			equ 1011	;button cls N
IDC_CLEAR_4			equ 1012	;button cls Result
IDC_CALC			equ 1013	;button "calculate"

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

_LimitText4Edit		equ	20			;user can type only 20 symbols in edit controls
clr_Static			equ 0000FF00h	;green
clr_EditSimple		equ 0000FF00h	;green
clr_EditActive		equ 000000FFh	;green

;-------------------------------------------------------------
; constants
;-------------------------------------------------------------

.const

EditFont			LOGFONT <-12,0,0,0,700,0,0,0,-52,3,2,1,34,"Arial">	;font for edit controls

	; error messages
	;~~~~~~~~~~~~~~~
errError			db "Ошибка",0
errEmptyFields		db "Нужно заполнить 3 поля!",0
errInvalidNumber	db "Некорректное число.",0
errAllFull			db "Освободите поле, которое нужно вычислить.",0

;-------------------------------------------------------------
; vars
;-------------------------------------------------------------

.data

LastField			db 0	;last number of field to calc

;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

hInstance			dd ?	;handle of module

buf 				db _LimitText4Edit+1 dup(?)	;buffer 4 getting text from edit controls

Field				db ?	;number of field to calc

fStart				dq ?	;Start Sum	;float 64 bits
fPercent			dq ?	;Percent	;float 64 bits
fResult				dq ?	;Result		;float 64 bits

errVar				dd ?

cwr					dw ?	;buffer 4 Control Word Register

hFont				HFONT ?	;handle of font 4 edit controls
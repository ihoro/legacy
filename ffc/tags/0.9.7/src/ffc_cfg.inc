;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

CreateCfg			PROTO
LoadCfg				PROTO
LoadCfgFile			PROTO
SaveCfg				PROTO
SaveCfgFile			PROTO

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

fp64_size				equ 40

	; config file's structure
	;~~~~~~~~~~~~~~~~~~~~~~~~
CFG struct

	msg					db 23 dup (?)	; warning message with CR LF
	
	com_id				dd ?			; COM-port index (0,1,2,...)		FUCKING BYTE & MS !!!!!!! suck
	com_speed			dd ?			; COM-port speed index
	com_parity			dd ?			; COM-port parity index
	com_stopbits		dd ?			; COM-port stop bits index
	
	pkt_id				db 4 dup (?)	; packet id as ASCIIZ two bytes
	
	log_cfg				db ?			; log file config. bits:
										; bit #0 = 0/1 - off/on log file
										; bit #1 = 0/1 - off/on standart log file
										; bit #2 = 0/1 - off/on rewriting log file
	log_filename		db FileNameSize dup (?)	; user's log file name
	
	bytes_num			db BytesNumSize dup (?)	; user's bytes numbers for 'BIN'
	
	; table values
	g					db fp64_size dup (?)
	u11					db fp64_size dup (?)
	u12					db fp64_size dup (?)
	u13					db fp64_size dup (?)
	u14					db fp64_size dup (?)
	u21					db fp64_size dup (?)
	u22					db fp64_size dup (?)
	u23					db fp64_size dup (?)
	u24					db fp64_size dup (?)
	
	; calc64 system
	c64_count_max		dd ?
	hex_u11				dw ?	; c64_id = 0
	hex_u12				dw ?	; c64_id = 1
	hex_u13				dw ?	; c64_id = 2
	hex_u14				dw ?	; c64_id = 3
	hex_u21				dw ?	; c64_id = 0
	hex_u22				dw ?	; c64_id = 1
	hex_u23				dw ?	; c64_id = 2
	hex_u24				dw ?	; c64_id = 3
	
	kt					dw ?	; kt param
	
	wnd_rect			RECT<?> ; main window's rect
	
CFG ends

;-------------------------------------------------------------
; vars
;-------------------------------------------------------------

.data

	; config file defaults
	;~~~~~~~~~~~~~~~~~~~~~
cfg_def_name		db "\ffc.cfg",0
cfg_warning_msg		db "Don't edit this file!",13,10

; for port's settings look in 'vars' of ffc.inc

_pkt_id				dd 00004646h				; db "FF",0,0

_log_cfg			db 03h						; log use = 1, standart log = 1

table_value_size	equ 9
_g					db "9.8106",0,0,0
_u11				db "0.8072",0,0,0
_u12				db "1.880118",0
_u13				db "0.791957",0
_u14				db "-0.28058",0
_u21				db "1.87905",0,0
_u22				db "0.791327",0
_u23				db "-0.28093",0
_u24				db "0.806625",0

_c64_count_max		equ 64
_hex_u11			equ 00a55h
_hex_u12			equ 01810h
_hex_u13			equ 00a23h
_hex_u14			equ 03c69h
_hex_u21			equ 0180dh
_hex_u22			equ 00a21h
_hex_u23			equ 03c68h
_hex_u24			equ 00a53h

_kt					equ 0000h

_wnd_rect			RECT <0,0,WND_MIN_WIDTH,WND_MIN_HEIGHT>		; point (0,0) will be set by WM_INITDIALOG

;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

cfg					CFG <>
cfg_path			db FileNameSize dup (?)	; current directory
hcfg				dd ?
cfg_got				dd ?

wfd					WIN32_FIND_DATA <?>

fpu_cfg_buf			db fp64_size dup (?)	; used when loading float-params from cfg to dialog


cfgError			dd ?		; 0 - no error. Errors: 1 - CreateCfg, 2 - LoadCfg 
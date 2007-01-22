;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include user32.inc
include kernel32.inc

;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib user32.lib
includelib kernel32.lib

;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDD_RCDATA	equ 1

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

DATETIME_BLOCK_SIZE		equ 25

;-------------------------------------------------------------
; vars
;-------------------------------------------------------------

.data

sTitle		db "Updater24x v0.0 by fnt0m32",0

sFmt		db "%d",0
sUpdateFor	db "Update for file: "
sOldVersion	db "old version:",10
sNewVersion db 10,10,"new version:",10
sBytes		db " bytes",10
sMsgBegin	db 10,10

sDone		db "DONE> File has been updated completely.",0	

errUpdater	db "Update is corrupted.",0
errFileOpen db "ERROR> File not found.",0
errFile		db "ERROR> File operation error.",0
errOld		db "ERROR> This update is not intended for this file.",0

;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?


hFile		dd ?
fSize		dd ?
map			dd ?
mem			dd ?

hRes		dd ?

pBase		dd ?			; pointer to begin rcdata
pData		dd ?			; pointer to rcdata after filename

sInfo		db 2048 dup (?)	; info text
sInfoOffset dd ?
;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include user32.inc
include kernel32.inc
include comctl32.inc
include shell32.inc
include gdi32.inc

;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib user32.lib
includelib kernel32.lib
includelib comctl32.lib
includelib shell32.lib
includelib gdi32.lib

;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

DlgProc			PROTO :HWND,:UINT,:WPARAM,:LPARAM
OpenPort		PROTO
ThreadProc		PROTO :DWORD
OnOff			PROTO :DWORD
CleanData		PROTO
Bin2Hex			PROTO
DSpace			PROTO	

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDD_DIALOG			equ 101
	
IDC_GRP1			equ 1009
IDC_GRP2			equ 1010
IDC_LBLPORT			equ 1011
IDC_LBLSPEED		equ 1012
IDC_PORT			equ 1013
IDC_SPEED			equ 1014
IDC_DO				equ 1015
IDC_HELPP			equ 1016
IDC_ABOUT			equ 1017
IDC_EXIT			equ 1018
IDC_LBLPARITY		equ 1001
IDC_LBLSTOPBITS		equ 1002
IDC_PARITY			equ 1003
IDC_STOPBITS		equ 1004
IDC_LBLFF			equ 1005
IDC_FF				equ 1006
IDC_DATA			equ 1007

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

WM_DATA_RECEIVED	equ	WM_USER+100h

InComBuf			equ 2048
OutComBuf			equ 256

;-------------------------------------------------------------
; vars
;-------------------------------------------------------------

.data

	; COM port ID & list
	;~~~~~~~~~~~~~~~~~~~
port_count			equ 4

sCOM				db "\\.\"
sCOM1				db "COM"
COM_id				db "1",0
sCOM2				db "COM2",0
sCOM3				db "COM3",0
sCOM4				db "COM4",0

	; speed list
	;~~~~~~~~~~~
speed_count			equ 15
speed_default		equ 11	; 0..n-1	

sBPS1				db "110   ",0
sBPS2				db "300   ",0
sBPS3				db "600   ",0
sBPS4				db "1200  ",0
sBPS5				db "2400  ",0
sBPS6				db "4800  ",0
sBPS7				db "9600  ",0
sBPS8				db "14400 ",0
sBPS9				db "19200 ",0
sBPS10				db "38400 ",0
sBPS11				db "56000 ",0
sBPS12				db "57600 ",0
sBPS13				db "115200",0
sBPS14				db "128000",0
sBPS15				db "256000",0

	; parity list
	;~~~~~~~~~~~~
parity_count		equ 5

sParity1			db "No   ",0
sParity2			db "Even ",0
sParity3			db "Mark ",0
sParity4			db "Odd  ",0
sParity5			db "Space",0

	; stop-bits list
	;~~~~~~~~~~~~~~~
stopbits_count		equ 3

sStopBits1			db "1  ",0
sStopBits2			db "1.5",0
sStopBits3			db "2  ",0

	; status text
	;~~~~~~~~~~~~
sStart				db "Старт",0
sStop				db "Стоп",0

	; about text
	;~~~~~~~~~~~
sAbout0				db "FF Catcher v0.3",0
sAbout1				db "01.11.2005 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; error messages:
	;~~~~~~~~~~~~~~~~
errTitle			db "Ошибка",0
errOpenPort			db "Не могу открыть порт.",0

	; convert
	;~~~~~~~~
HexTable			db "0123456789ABCDEF"

	; help text
	;~~~~~~~~~~
sHelpTitle			db "Справка",0
sHelp				db "В режиме работы программа ждет поступления в порт данных. Каждый раз, получая данные, она",10
					db "ищет среди них первую встретившуюся комбинацию таких байтов:",10
					db "    0x10FF (если это самое начало данных) или 0x??10FF, где байт 0x?? не равен 0x10.",10
					db "Байт 0xFF может определяться пользователем в поле 'ID пакета'.",10
					db "Затем читает следующие после 0x10FF байты вплоть до комбинации 0x1003 и отображает их.",10
					db "Если пакет 0xFF не был обнаружен - ожидаются следующие данные.",10,10
					db "При чтении получаемой информации учитывается, что два байта подряд 0x1010 означают один",10
					db "байт 0x10."
					db 0

	; other
	;~~~~~~
pID					db 0FFh,10h			; packets ID
logfont 			LOGFONT <-13,0,0,0,400,0,0,0,-52,1,2,1,33,"Fixedsys">
;logfont LOGFONT <-13,0,0,0,700,0,0,0,-52,3,2,1,49,"Courier New">
;logfont LOGFONT <-13,0,0,0,700,0,0,0,-52,1,2,1,17,"Courier">
;logfont LOGFONT <-11,0,0,0,400,0,0,0,-52,1,2,1,17,"Courier">

;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

	; handles
	;~~~~~~~~
hInstance			dd ?
hdlg				dd ?
hIcon				dd ?
hCOM				dd ?
hFont				dd ?

	; working with ports
	;~~~~~~~~~~~~~~~~~~~
cGot				dd ?			; count of bytes input
ovr					OVERLAPPED <?>	; struct 4 asynchronous input

	; threads data
	;~~~~~~~~~~~~~
ThreadID			dd ?
ThreadOn			dd ?
	
	; interface flags
	;~~~~~~~~~~~~~~~~
Start				dd ?			; =1 (work), =0 (idle)

	; buffers
	;~~~~~~~~
inbuf				db InComBuf dup (?)		; input from port
buf					db InComBuf dup (?)		; temporary
ibuf				db 7 dup (?)			; for output 0x???? value
ffbuf				db 3 dup (?)			; packets ID
viewbuf				db InComBuf*2 dup (?)	; 4 view data
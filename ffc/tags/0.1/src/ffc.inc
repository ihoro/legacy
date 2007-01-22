;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include user32.inc
include kernel32.inc
include comctl32.inc
include shell32.inc

;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib user32.lib
includelib kernel32.lib
includelib comctl32.lib
includelib shell32.lib

;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

DlgProc			PROTO :HWND,:UINT,:WPARAM,:LPARAM
OpenPort		PROTO
ThreadProc		PROTO :DWORD
OnOff			PROTO :DWORD
ShowGroup		PROTO :DWORD
CleanData		PROTO

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDD_DIALOG			equ 101
	
	; group #1
	;~~~~~~~~~
grp1_begin			equ 1001		; first ID
grp1_count			equ 9			; number of controls
IDC_WORD1			equ 1001
IDC_WORD2			equ 1002
IDC_WORD3			equ 1003
IDC_N				equ 1004
IDC_LBLWORD1		equ 1005
IDC_LBLWORD2		equ 1006
IDC_LBLWORD3		equ 1007
IDC_LBLN			equ 1008
IDC_GRP1			equ 1009
	
	; group #2
	;~~~~~~~~~
grp2_begin			equ 1010		; first ID
grp2_count			equ 5			;number of controls
IDC_GRP2			equ 1010
IDC_LBLPORT			equ 1011
IDC_LBLSPEED		equ 1012
IDC_PORT			equ 1013
IDC_SPEED			equ 1014
	

IDC_DO				equ 1015
IDC_HELPP			equ 1016
IDC_ABOUT			equ 1017
IDC_EXIT			equ 1018

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

	; status text
	;~~~~~~~~~~~~
sStart				db "—тарт",0
sStop				db "—топ",0

	; about text
	;~~~~~~~~~~~
sAbout0				db "FF Catcher v0.1",0
sAbout1				db "30.10.2005 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; error messages:
	;~~~~~~~~~~~~~~~~
errTitle			db "ќшибка",0
errOpenPort			db "Ќе могу открыть порт.",0

	; convert
	;~~~~~~~~
HexTable			db "0123456789ABCDEF"

	; help text
	;~~~~~~~~~~
sHelpTitle			db "—правка",0
sHelp				db "¬ режиме работы программа ждет поступлени€ в порт данных.  аждый раз, получа€ данные, она",10
					db "ищет среди них первую встретившуюс€ комбинацию таких байтов:",10
					db "    0x10FF (если это самое начало данных) или 0x??10FF, где байт 0x?? не равен 0x10.",10
					db "«атем читает следующие после 0x10FF семь байтов:",10
					db "    0xNN111122223333",10
					db "√де:",10
					db "0xNN - байт, значение которого выводитс€ в виде дес€тичного числа в поле 'N'",10
					db "0x1111, 0x2222, 0x3333 - по два байта, вывод€тс€ в соответствующие пол€ '1','2','3' в",10
					db "    виде шестнадцатеричных значений.",10
					db "≈сли пакет 0xFF не был обнаружен - ожидаютс€ следующие данные.",10,10
					db "ѕри чтении получаемой информации учитываетс€, что два байта подр€д 0x1010 означают один",10
					db "байт 0x10.",10,10
					db "ќстальные настройки порта по умолчанию:",10
					db "четность - нечетное",10
					db "стоп-биты - 1",10
					db "бит в байте - 8"
					db 0

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
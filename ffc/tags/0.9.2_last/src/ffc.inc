;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include macro.inc
	
include windows.inc
include user32.inc
include kernel32.inc
include comctl32.inc
include shell32.inc
include gdi32.inc
include comdlg32.inc
include shlwapi.inc
include masm32.inc

;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib user32.lib
includelib kernel32.lib
includelib comctl32.lib
includelib shell32.lib
includelib gdi32.lib
includelib comdlg32.lib
includelib shlwapi.lib
includelib masm32.lib

;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

DlgProc			PROTO :HWND,:UINT,:WPARAM,:LPARAM
OpenPort		PROTO
ThreadProc		PROTO :DWORD
OnOff			PROTO :DWORD
CleanData		PROTO
OpenLog			PROTO
CloseLog		PROTO
ShowHideIntf	PROTO
LogUseShow		PROTO
CalcParams		PROTO

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
IDC_HEX				equ 1007
IDC_GRP3			equ 1008
IDC_LBLLOGFILENAME	equ 1019
IDC_LOGFILENAME		equ 1020
IDC_OPENLOG			equ 1021
IDC_DEFAULTLOG		equ 1022
IDC_REWRITELOG		equ 1023
IDC_USELOG			equ 1024
IDC_GRP4			equ 1025
IDC_BIN				equ 1026
IDC_LBLNUM			equ 1027
IDC_NUM				equ 1028
IDC_LBLBYTES		equ 1029
IDC_BYTES			equ 1030
IDC_LBLLOGSIZE		equ 1031
IDC_LOGSIZE			equ 1032
IDC_LBLPACKETS		equ 1033
IDC_PACKETS			equ 1034
IDC_SETMARK			equ 1035
IDC_MARK			equ 1036
IDC_GRP0			equ 1037
IDC_DEC				equ 1038
IDC_GRP5			equ 1039
IDC_GRAD			equ 1040
IDC_U11				equ 1042
IDC_U12				equ 1043
IDC_U13				equ 1044
IDC_U14				equ 1045
IDC_U10				equ 1056
IDC_K1				equ 1057
IDC_A1				equ 1058
IDC_A2				equ 1061
IDC_K2				equ 1060
IDC_U20				equ 1059
IDC_U24				equ 1049
IDC_U23				equ 1048
IDC_U22				equ 1047
IDC_U21				equ 1046
IDC_STC1			equ 1052
IDC_STC2			equ 1053
IDC_STC3			equ 1054
IDC_STC4			equ 1055
IDC_STC5			equ 1051
IDC_G				equ 1041
IDC_STC6			equ 1050

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

WM_DATA_RECEIVED	equ	WM_USER+100h

InComBuf			equ 2048
OutComBuf			equ 256

FileNameSize		equ 500
MarkBufSize			equ 256
ParamOfTableSize	equ 256

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
speed_default		equ 6	; 0..n-1	

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
sAbout0				db "FF Catcher v0.9.2",0
sAbout1				db "06.02.2006 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; error messages:
	;~~~~~~~~~~~~~~~~
errTitle			db "Ошибка",0
errOpenPort			db "Не могу открыть порт.",0
err_value			dd  52524520h 

	; convert
	;~~~~~~~~
HexTable			db "0123456789ABCDEF"
fmt_f12				db "F1 = "
f1_sign				db " "
					db "%3d.%2d.%2d  F2 = "
f2_sign				db " " 
					db "%3d.%2d.%2d",0

	; open dialog text
	;~~~~~~~~~~~~~~~~~
ofnTitle			db "Сохранить в лог-файл",0				
ofnFilter			db "Log Files (*.log)",0,"*.log",0,0
ofnDefExt			db "log"

	; log file
	;~~~~~~~~~
logDefName			db "\ffc.log",0

	; help text
	;~~~~~~~~~~
sHelpTitle			db "Справка",0
sHelp				db "В режиме работы программа ждет поступления в порт данных. Каждый раз, получая данные, она "
					db "ищет среди них комбинации таких байтов: "
					db "0x10FF (если это самое начало данных) или 0x??10FF, где байт 0x?? не равен 0x10. "
					db "Байт 0xFF может определяться пользователем в поле 'ID пакета'. "
					db "Затем читает следующие после 0x10FF байты вплоть до комбинации 0x1003 и отображает их в поле Данные-HEX. "
					db "Так выводятся все пакеты 0xFF, найденные в текущих данных, затем ожидаются новые "
					db "поступления с порта.",10,10
					db "При чтении получаемой информации учитывается, что два байта подряд 0x1010 означают один "
					db "байт 0x10.",10,10
					db "Данные-BIN. Есть возможность выводить отдельные байты в двоичном коде, для этого нужно в поле ввода "
					db "'Номера байтов' через запятую ввести номера, первым считается тот байт, который "
					db "отображается первым в поле 'Данные - HEX'. Максимальный номер байта - 64. В каком порядке "
					db "были заданы номера, в таком же будут выводиться соответствующие байты.",10,10
					db "Статус 'Всего' отображает общее количество принятых с порта байт и общее число пакетов "
					db "0x10FF, которые были найдены и прочитаны.",10,10
					db "Данные-DEC. Из данных каждого пакета 0x10FF выделяются слова: w1 (2-ой и 3-ий байты), w2 (4-ый и 5-ый), w3 (6-ой и 7-ой), w4 (8-ой и 9-ый), "
					db "где меньший по номеру байт считается старшим в слове. V1,V2,V3 считаются по такой формуле: VX = wX * 0.000305176, "
					db "а температура: t = w4 * 0.03052 - 273. ",10,10
					db "Так же, если включено, ведется запись в лог-файл HEX-данных в том же виде, в котором они "
					db "отображаются и соответствующие значения V1,V2,V3,t. Есть возможность перезаписывать файл или добавлять в уже существующий. "
					db "Стандартный лог-файл всегда находится в одной директории с программой.",10
					db "Справа от кнопки 'старт' имеется поле ввода для заметок, которые можно внести в лог с помощью кнопки 'V'. Заметка/ремарка заносится в конец текущей строки лог-файла.",10,10
					db "Окно программы можно растянуть по ширине, чтобы увидеть больше данных."
					db 0

	; other
	;~~~~~~
pID					db 0FFh,10h			; packets ID
logfont 			LOGFONT <-13,0,0,0,400,0,0,0,-52,1,2,1,33,"Fixedsys">
logfont_err			LOGFONT <-13,0,0,0,400,0,0,0,-52,1,2,1,33,"Fixedsys">

tempr_mod			dq 3.052			; 0.03052*100
vn_mod				dq 3.05176			; 0.000305176*10000 

dec_buf				db "V1 = "
v1					db 7 dup(' ')
					db "  V2 = "
v2					db 7 dup(' ')
					db "  V3 = "
v3					db 7 dup(' ')
					db "  t = "
t					db 10 dup (0)

;fuckname			db "name.log"
;fuckbyte			db 0

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
hFont_err			dd ?
hFile				dd ?
;hFile2				dd ?

	; working with ports
	;~~~~~~~~~~~~~~~~~~~
cGot				dd ?			; count of bytes input
ovr					OVERLAPPED <?>	; struct 4 asynchronous input
cBytes				dd ?			; total bytes received
cPackets			dd ?			; total packets received

	; data merger
	;~~~~~~~~~~~~
NeedMerge			dd ?			; =0 (no), =1 (first level, looking 4 10FFh), =2 (second level, other part of packet)
LastAX				dw ?
LastEAX				dd ?
LastEDI				dd ?

	; threads data
	;~~~~~~~~~~~~~
ThreadID			dd ?
ThreadOn			dd ?
	
	; interface flags
	;~~~~~~~~~~~~~~~~
Start				dd ?			; =1 (work), =0 (idle)

	; log file
	;~~~~~~~~~
logUse				dd ?
logDefault			dd ?
logRewrite			dd ?
logSize				dd ?				; current lof file size
logUseMark			db ?				; =0/1 (no/yes)
ofn					OPENFILENAME <?>	; using by open file dialog
cWrite				dd ?

	; buffers
	;~~~~~~~~
inbuf				db InComBuf dup (?)		; input from port
buf					db InComBuf dup (?)		; temporary
ibuf				db 7 dup (?)			; for output 0x???? value
ffbuf				db 3 dup (?)			; packets ID
viewbuf				db InComBuf*2 dup (?)	; 4 view data
fbuf				db FileNameSize dup (?)	; log file name
fbuf_def			db FileNameSize dup (?)	; default log file name
markbuf				db MarkBufSize dup (?)	; mark's info

	; list of bytes number
	;~~~~~~~~~~~~~~~~~~~~~
num_count			db ?
num					db 64 dup (?)
num_buf				db InComBuf*8 dup (?)

	; windows info
	;~~~~~~~~~~~~~
wRect				RECT <?>				; windows rect
cRect				RECT <?>				; childs rect
wHeight				dd ?					; min&max win height
wWidth				dd ?					; min win width

	; temp fpu work
	;~~~~~~~~~~~~~~
cwr					dw ?
int16				dw ?
fp64				dq ?
fp_buf				db 10 dup (?)

	; params of table (g,Uxx,U0,k,Alpha,fx,...)
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
s_g					db ParamOfTableSize dup (?)
s_u11				db ParamOfTableSize dup (?)
s_u12				db ParamOfTableSize dup (?)
s_u13				db ParamOfTableSize dup (?)
s_u14				db ParamOfTableSize dup (?)
s_u21				db ParamOfTableSize dup (?)
s_u22				db ParamOfTableSize dup (?)
s_u23				db ParamOfTableSize dup (?)
s_u24				db ParamOfTableSize dup (?)

s_u10				db ParamOfTableSize dup (?)
s_k1				db ParamOfTableSize dup (?)
s_a1				db ParamOfTableSize dup (?)
s_u20				db ParamOfTableSize dup (?)
s_k2				db ParamOfTableSize dup (?)
s_a2				db ParamOfTableSize dup (?)

s_f12				db 6 dup (?)
f1_val				db 9 dup (?)
					db 8 dup (?)
f2_val				db 9 dup (?)
err_val				dd ?
err_zero			db ?
					
err_flag			db ?

g					dq ?
u11					dq ?
u12					dq ?
u13					dq ?
u14					dq ?
u21					dq ?
u22					dq ?
u23					dq ?
u24					dq ?

u10					dq ?
k1					dq ?
a1					dq ?
u20					dq ?
k2					dq ?
a2					dq ?

f1					dq ?
f1g					dd ?
f1m					dd ?
f1o					dd ?

f2					dq ?
f2g					dd ?
f2m					dd ?
f2o					dd ?

diver				dw ?
temper				dq ?
comparer			dw ?

	; volts
	;~~~~~~
vv1					dq ?
vv2					dq ?
vv3					dq ?
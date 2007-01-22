;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include user32.inc
include kernel32.inc
include comdlg32.inc
include comctl32.inc
include shell32.inc
include masm32.inc

;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib user32.lib
includelib kernel32.lib
includelib comdlg32.lib
includelib comctl32.lib
includelib shell32.lib
includelib masm32.lib

;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

DlgProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD
TimerProc			PROTO :DWORD,:DWORD,:DWORD,:DWORD

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDD_DLG				equ 1000
IDC_OPEN			equ 1001
IDC_START			equ 1002
IDC_PAUSE			equ 1003
IDC_FN0				equ 1004
IDC_FN				equ 1005
IDC_DATA			equ 1006
IDC_LBL0			equ 1007
IDC_LBL1			equ 1008
IDC_LBL2			equ 1009
IDC_LBL3			equ 1010
IDC_K				equ 1011
IDC_S				equ 1012
IDC_D				equ 1013
IDC_T				equ 1014
IDC_STATUS0			equ 1015
IDC_STATUS			equ 1016
IDC_OUTPUT			equ 1017
IDC_LBLPORT			equ 1018
IDC_PORT			equ 1019
IDC_LBLSPEED		equ 1020
IDC_SPEED			equ 1021
IDC_LBLPARITY		equ 1022
IDC_PARITY			equ 1023
IDC_LBLSTOPBITS		equ 1024
IDC_STOPBITS		equ 1025
IDC_ABOUT			equ 1026
IDC_EXIT			equ 1027
IDC_OUT				equ 1028
IDC_HELPP			equ 1029


;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

InComBuf			equ 256
OutComBuf			equ 256

Epsilon				equ 2

IDT_TIMER			equ	999
tmrInterval			equ 1000	;1 second
FileNameSize		equ 300

SeparatorSub		equ '-'
SeparatorMain		equ ' '

;-------------------------------------------------------------
; constants
;-------------------------------------------------------------


;-------------------------------------------------------------
; vars
;-------------------------------------------------------------

.data

	; COM port ID
	;~~~~~~~~~~~~
sCOM				db "\\.\COM"
COM_id				db "1",0

	; ports name list
	;~~~~~~~~~~~~~~~~
sCOM1				db "COM1",0
sCOM2				db "COM2",0
sCOM3				db "COM3",0
sCOM4				db "COM4",0

	; speed list
	;~~~~~~~~~~~
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
sParity1			db "No   ",0
sParity2			db "Even ",0
sParity3			db "Mark ",0
sParity4			db "Odd  ",0
sParity5			db "Space",0

	; stop-bits list
	;~~~~~~~~~~~~~~~
sStopBits1			db "1  ",0
sStopBits2			db "1.5",0
sStopBits3			db "2  ",0

ovr					OVERLAPPED <0,0,0,0,0>

	; format #1
	;~~~~~~~~~~
sFormat1_0			db "$HEVHW,"
sFormat1_1			db ",T,0.0,M,"
sFormat1_2			db ",N,"
sFormat1_3			db ",K*"

	; format #2
	;~~~~~~~~~~
sFormat2_0			db "$VWVPW,"
sFormat2_1			db ",N,"
sFormat2_2			db ",M*"

	; end of formats
	;~~~~~~~~~~~~~~~
;sFormatEnd			db 0dh,0ah

	; params 4 convert
	;~~~~~~~~~~~~~~~~~
KnotsToMetres		dq 0.514
MetresToKilometres	dq 3.6

	; status text
	;~~~~~~~~~~~~
sStart				db "Старт",0
sStop				db "Стоп",0
sPause				db "Пауза",0
sContinue			db "Продолжить",0
sReady				db "Готов к работе",0
sDoing				db "Выполнение сценария...",0
sDone				db "Сценарий выполнен",0

hexTable			db "0123456789ABCDEF"

hMapFile			dd 0
eout				db 1

	; open dialog text
	;~~~~~~~~~~~~~~~~~
ofnTitle			db "Открыть файл сценария",0				
ofnFilter			db "Data Files (*.dat)",0,"*.dat",0
					db "All Files (*.*)",0,"*.*",0,0
	
	; about text
	;~~~~~~~~~~~
sAbout0				db "Script Executor v0.2",0
sAbout1				db "03.07.2005 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; help text
	;~~~~~~~~~~
sHelpTitle			db "Справка",0
sHelp				db "Программа читает текстовые файлы-скрипты. Файл скрипта состоит из строк, каждая из которых",10
					db "оформляется в таком формате:",10
					db "^course<SP>speed<SP>time<CR><LF>",10,10
					db "^ - начало строки, без лишних пробелов и знаков табуляции.",10
					db "course - курс, в градусах (положительное целое/дробное число), задается следующими способами:",10
					db "    x.x -> статический курс на протяжении времени time.",10
					db "    x.x-x.x -> диапазон изменения курса за время time.",10
					db "speed - скорость в узлах (положительное целое/дробное число), задается такими способами:",10
					db "    x.x -> статическая скорость на протяжении времени time.",10
					db "    x.x-x.x -> диапазон изменения скорости за время time.",10
					db "time - время в секундах (положительное целое число), на протяжении которого действуют текущие",10
					db "    значения курса/скорости, если заданы диапазоны для курса/скорости,",10
					db "    то их значения изменяются с каждой секундой времени time.",10
					db "<SP> - символ пробела (0x20)",10
					db "<CR> - символ перевода каретки (0x0D)",10
					db "<LF> - символ конца строки (0x0A)",10,10
					db "  Поскольку все строки записываются в одинаковом формате, то не забывайте про <CR><LF>",10
					db "в конце последней строки файла!",10
					db "  Т.е. программа читает каждую строку файла, затем каждую секунду времени time выводит на экран",10
					db "информацию о текущем курсе/скорости и общем пройденном времени/дистанции.",10
					db "  Если включен вывод в порт, то также каждую секунду подаются в порт два предложения байтов:",10
					db "$HEVHW,c.c,T,0.0,M,n.n,N,k.k,K*hh<CR><LF>",10
					db "$VWVPW,n.n,N,m.m,M*hh<CR><LF>",10,10
					db "c.c - курс в градусах",10
					db "n.n - скорость в узлах",10
					db "k.k - скорость в км/ч",10
					db "m.m - скорость в м/с",10
					db "hh - символьное представление шестнадцатеричного значения контрольной суммы, которая",10
					db "    высчитывается для каждого предложения отдельно. Сумма считается по формуле S = S xor B,",10
					db "    где S и B - текущая сумма и байт предложения. Вначале S=0, а байт B берется из диапазона,",10
					db "    начиная с символа после $ и заканчивая символом перед *."
					db 0

	; error messages:
	;~~~~~~~~~~~~~~~~
errTitle			db "Ошибка",0
errOpenFile			db "Не могу открыть файл.",0
errCreateFMO		db "Не могу создать file-mapping object.",0
errMapView			db "Не могу прочитать файл.",0
errOpenPort			db "Не могу открыть порт.",0

;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

hInstance			dd ?
hdlg				dd ?
hIcon				dd ?
ofn					OPENFILENAME <>
fbuf				db FileNameSize dup(?)
buf					db 25 dup(?)
frmbuf				db 512 dup (?)
hFile				dd ?
pMemory				dd ?
pData				dd ?
FileSize			dd ?

k1					dq ?
k2					dq ?
s1					dq ?
s2					dq ?
t0					dd ?
AllTime				dd ?
Distance			dq ?
tt0					dq ?
tt1					dq ?

szK					db 10 dup (?)
szS					db 10 dup (?)
szMPS				db 10 dup (?)

Pause				dd ?
Start				dd ?

hCOM				dd ?
cGot				dd ?
dcb					DCB <?>
cto					COMMTIMEOUTS <?>
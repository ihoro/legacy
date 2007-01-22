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
ShowHelp		PROTO
c64_Intf		PROTO
c64_btn_names	PROTO
CheckHexStr		PROTO :DWORD
ExtractHex		PROTO :DWORD,:DWORD

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDD_DIALOG			equ 101
	
IDC_GRP1			equ 1007
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
IDC_HEX				equ 1009
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
IDC_DEG				equ 1040
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
IDC_CALC64_0		equ 1062
IDC_CALC64_90		equ 1063
IDC_CALC64_180		equ 1064
IDC_CALC64_270		equ 1065
IDC_STC7			equ 1066
IDC_KT				equ 1067
IDC_SEND			equ 1068
IDC_SYN				equ 1069

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

FULL_PACKET_SIZE	equ 31			; 10FF + NN + 4 words + 9 words + 1003 

WM_DATA_RECEIVED	equ	WM_USER+100h

InComBuf			equ 2048
OutComBuf			equ 256

FileNameSize		equ 500
BytesNumSize		equ 192			; limit of IDC_NUM edit
MarkBufSize			equ 256
ParamOfTableSize	equ 256
CheckHexSize		equ 10

WND_MIN_HEIGHT		equ 445			; of main window
WND_MIN_WIDTH		equ 616			; of main window

;-------------------------------------------------------------
; vars
;-------------------------------------------------------------

.data

	; COM port ID & list
	;~~~~~~~~~~~~~~~~~~~
port_count			equ 4
port_default		equ 0

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
parity_default		equ 0

sParity1			db "No   ",0
sParity2			db "Even ",0
sParity3			db "Mark ",0
sParity4			db "Odd  ",0
sParity5			db "Space",0

	; stop-bits list
	;~~~~~~~~~~~~~~~
stopbits_count		equ 3
stopbits_default	equ 0

sStopBits1			db "1  ",0
sStopBits2			db "1.5",0
sStopBits3			db "2  ",0

	; status text
	;~~~~~~~~~~~~
sStart				db "Старт",0
sStop				db "Стоп",0
syn_doing			db "...",0
syn_ready			db ">> синх",0

	; tootltip messages
	;~~~~~~~~~~~~~~~~~~
ttmMark				db "Комментарий",0
ttmSetMark			db "Добавить в лог комментарий",0
ttmHelpp			db "Справка",0
ttmAbout			db "О программе",0
ttmExit				db "Выход",0
ttmOpenLog			db "Выбрать файл",0
ttmLogFileName		db "Полный путь и имя лог-файла",0
ttmBin				db "Двоичные значения отдельных байтов",0
ttmHex				db "Принятый пакет в шестнадцатиричном виде",0
ttmDec				db "Десятичные значения вольт и температуры",0
ttmDeg				db "Значения углов в градусах и минутах",0
ttmG				db "Ускорение свободного падения",0
ttmKT				db "Температурный коэффициент [HEX]",0
ttmSend				db "Синхронизировать таблицу устройства с программой",0
ttmSyn				db "Синхронизировать таблицу программы с устройством",0

ttmU11				db "U11 [B]",0
ttmU12				db "U12 [B]",0
ttmU13				db "U13 [B]",0
ttmU14				db "U14 [B]",0

ttmU21				db "U21 [B]",0
ttmU22				db "U22 [B]",0
ttmU23				db "U23 [B]",0
ttmU24				db "U24 [B]",0

ttmU10				db "U10",0
ttmU20				db "U20",0
ttmk1				db "k1",0
ttmk2				db "k2",0
ttmAlpha1			db "Alpha1",0
ttmAlpha2			db "Alpha2",0

	; about text
	;~~~~~~~~~~~
sAbout0				db "FF Catcher v0.9.8b",0
sAbout1				db "24.03.2006 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; error/etc messages:
	;~~~~~~~~~~~~~~~~~~~~
errTitle			db "fcc",0
errOpenPort			db "Ошибка при открытии ""\.\COM"
errOpenPortNum		db 0
					db """.",10
					db "Возможно порт занят другим приложением."
					db 0
errLoadCfg			db "Ошибка при загрузке конфигурационного файла "".\ffc.cfg"".",10
					db "Настройки будут установлены по умолчанию.",0
errSaveCfg			db "Ошибка при записи конфигурационного файла "".\ffc.cfg"".",10
					db "Программа не будет закрыта, чтобы не потерять настройки."
					db 0
errOpenLog			db "Ошибка при открытии/создании лог-файла "".\ffc.log"".",10
					db "Для работы лог-файл нужен постоянно,",10
					db "поскольку запись в него может начаться в любое время."
					db 0
err_value			dd  52524520h 					; = " ERR"
aysSend				db "Вы уверены?",10
					db "Переслав данные устройству, его предыдущие настройки будут утеряны!"
					db 0

	; convert
	;~~~~~~~~
HexTable			db "0123456789ABCDEF"
fmt_t				db "%2d.%2d",0
fmt_f12				db "F1 = "
f1_sign				db " "
					db "%3d.%2d.%2d   F2 = "
f2_sign				db " " 
					db "%3d.%2d.%2d",0
c64_stat_fmt		db "%2d/%2d",0
tempr_mod			dq 3.052			; 0.03052*100
vn_mod				dq 3.05176			; 0.000305176*10000


	; open dialog text
	;~~~~~~~~~~~~~~~~~
ofnTitle			db "Сохранить в лог-файл",0				
ofnFilter			db "Log Files (*.log)",0,"*.log",0,0
ofnDefExt			db "log"

	; log file
	;~~~~~~~~~
logDefName			db "\ffc.log",0

	; other
	;~~~~~~
ToolTipClassName	db "Tooltips_class32",0
pID					db 0FFh,10h			; packets ID
logfont 			LOGFONT <-13,0,0,0,400,0,0,0,-52,1,2,1,33,"Fixedsys">

dec_buf				db "V1 = "
v1					db 7 dup(' ')
					db "  V2 = "
v2					db 7 dup(' ')
					db "  V3 = "
v3					db 7 dup(' ')
					db "  t = "
t_sign				db " "
t					db 10 dup (0)

c64_0				db "0",0
c64_90				db "90",0
c64_180				db "180",0
c64_270				db "270",0

;TEST-FILE
;fuckname			db "name.log",0
;fuckbyte			db 0fch

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
hFile				dd ?
hTT					dd ?			; ToolTip's handle
;hFile2				dd ?			;TEST-FILE

	; tooltips
	;~~~~~~~~~
ti					TOOLINFO <?>

	; working with ports
	;~~~~~~~~~~~~~~~~~~~
cGot				dd ?			; count of bytes input
cSent				dd ?			; count of bytes output
ovr					OVERLAPPED <?>	; struct 4 asynchronous input
ovr2				OVERLAPPED <?>	; struct 4 asynchronous output
cBytes				dd ?			; total bytes received
cPackets			dd ?			; total packets received

	; data merger
	;~~~~~~~~~~~~
NeedMerge			dd ?			; =0 (no), =1 (first level, looking 4 10FFh), =2 (second level, other part of packet)
LastAX				dw ?
LastEAX				dd ?
LastEDI				dd ?
HexEnd				dd ?			; offset of last byte +1 of HEX-packet 

	; threads data
	;~~~~~~~~~~~~~
ThreadID			dd ?
ThreadOn			dd ?
	
	; interface flags
	;~~~~~~~~~~~~~~~~
Start				dd ?			; =1 (work), =0 (idle)

	; calc64 system
	;~~~~~~~~~~~~~~
c64_on				dd ?			; =1 (yes),  =0 (no)
c64_id				dd ?			; = 0,1,2,3 (0,90,180,270) - what column was selected
c64_sum1			dd ?			; current sum of sensor #1
c64_sum2			dd ?			; current sum of sensor #2
c64_count			dd ?			; current count of calced packets
c64_fpu1			dq ?			; rndint( avg1 * nv_mod ) / 10000
c64_fpu2			dq ?			; rndint( avg2 * nv_mod ) / 10000
c64_shr				dd ?			; shr param
c64_s1				db ParamOfTableSize dup (?)	; fpu1 as string
c64_s2				db ParamOfTableSize dup (?)	; fpu2 as string
c64_stat			db 10 dup (?)	; statistics string

	; syn system (synchronization)
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
syn_on				dd ?			; =1 (yes),  =0 (no)
syn_int16			dw ?			; temporary
syn_fp64			dq ?			; temporary

	; log file
	;~~~~~~~~~
logUse				dd ?
logDefault			dd ?
logRewrite			dd ?
logSize				dd ?				; current lof file size
logUseMark			db ?				; =0/1 (no/yes)
ofn					OPENFILENAME <?>	; using by open file dialog
cWrite				dd ?
logDefaultUsed		dd ?				; when OpenLog. 0 - now it's user's filename, 1 - user's filename is wrong then it's use default filename

	; buffers
	;~~~~~~~~
inbuf				db InComBuf dup (?)		; input from port
buf					db InComBuf dup (?)		; temporary
ibuf				db 7 dup (?)			; for output 0x???? value
ffbuf				db 3 dup (?)			; packets ID
viewbuf				db InComBuf*5 dup (?)	; for view data and out to log
fbuf				db FileNameSize dup (?)	; log file name
fbuf_def			db FileNameSize dup (?)	; default log file name
markbuf				db MarkBufSize dup (?)	; mark's info
checkhex_buf		db CheckHexSize dup (?) ; for check G and KT HEX-params
send_buf			db 18 dup (?)			; u?? and kt as HEX-values

	; show hex table
DontCalcParams		db ?
u_hex				db 5 dup (?)

	; list of bytes number
	;~~~~~~~~~~~~~~~~~~~~~
num_count			db ?
num					db 64 dup (?)
num_buf				db InComBuf*8 dup (?)

	; windows info
	;~~~~~~~~~~~~~
wRect				RECT <?>				; windows rect
cRect				RECT <?>				; childs rect
;wHeight			dd ?					; min&max win height
;wWidth				dd ?					; min win width

	; temp fpu work
	;~~~~~~~~~~~~~~
cwr					dw ?
int16				dw ?
int16_3				dw ?					; calc64
int16_2				dw ?					; EN_CHANGE
fp64_2				dq ?					; EN_CHANGE
fp64				dq ?
t_x					dd ?
t_y					dd ?
fp_buf				db 10 dup (?)

	; params of table (g,Uxx,U0,k,Alpha,fx,...)
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;s_g				db ParamOfTableSize dup (?)
;s_u11				db ParamOfTableSize dup (?)
;s_u12				db ParamOfTableSize dup (?)
;s_u13				db ParamOfTableSize dup (?)
;s_u14				db ParamOfTableSize dup (?)
;s_u21				db ParamOfTableSize dup (?)
;s_u22				db ParamOfTableSize dup (?)
;s_u23				db ParamOfTableSize dup (?)
;s_u24				db ParamOfTableSize dup (?)

s_u10				db ParamOfTableSize dup (?)
s_k1				db ParamOfTableSize dup (?)
s_a1				db ParamOfTableSize dup (?)
s_u20				db ParamOfTableSize dup (?)
s_k2				db ParamOfTableSize dup (?)
s_a2				db ParamOfTableSize dup (?)

s_f12				db 6 dup (?)	; formatted string of angles for output to dialog/log
f1_val				db 9 dup (?)
					db 8 dup (?)
f2_val				db 9 dup (?)
err_val				dd ?			; if err_flag=1 then err_val= " ERR" (from err_value)
err_zero			db ?			; if err_flag=1 then err_ziro=0
					
err_flag			db ?			; = 0/1 (no error/error).  error means that x>1 or x<-1 in arccos/srcsin 

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

f1					dq ?		; fully value of angle
f1g					dd ?		; only degrees as uint (DDD) 
f1m					dd ?		; only minutes as uint (MM)
f1o					dd ?		; fractional part of minutes (OO)

f2					dq ?		; fully value of angle
f2g					dd ?		; only degrees as uint (DDD)
f2m					dd ?		; only minutes as uint (MM)
f2o					dd ?		; fractional part of minutes (OO)

diver				dw ?		; temporary value
temper				dq ?		; temporary value
comparer			dw ?		; temporary value

	; volts
	;~~~~~~
vv1					dq ?		; value of V1 from device (10FF...1003)
vv2					dq ?		; value of V2 from device (10FF...1003)
vv3					dq ?		; value of V3 from device (10FF...1003)
; $Id$

;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include user32.inc
include kernel32.inc
include comdlg32.inc
include comctl32.inc
include shell32.inc
include	shlwapi.inc
include masm32.inc

;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib user32.lib
includelib kernel32.lib
includelib comdlg32.lib
includelib comctl32.lib
includelib shell32.lib
includelib shlwapi.lib
includelib masm32.lib

;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

DlgProc				PROTO :DWORD,:DWORD,:DWORD,:DWORD
TimerProc			PROTO :DWORD,:DWORD,:DWORD,:DWORD
OpenPort			PROTO :DWORD,:DWORD,:DWORD,:DWORD
JustStop			PROTO
EnableSetup			PROTO
ThreadProc			PROTO :DWORD

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDD_DLG				equ 1000
IDC_OPEN			equ 1001
IDC_START			equ 1002
IDC_LBLFN			equ 1004
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
IDC_LBLSTATUS		equ 1015
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
IDC_HELPP			equ 1029
IDC_INPUT			equ 1003
IDC_LBLPORT2		equ 1036
IDC_PORT2			equ 2019
IDC_LBLSPEED2		equ 1034
IDC_SPEED2			equ 2021
IDC_LBLPARITY2		equ 1032
IDC_PARITY2			equ 2023
IDC_LBLSTOPBITS2	equ 1030
IDC_STOPBITS2		equ 2025
IDC_LBLREPORT		equ 1028
IDC_REPORT			equ 1031
IDC_DIFF			equ 1033
IDC_LBLLA			equ 1035
IDC_LBLLO			equ 1037
IDC_LA				equ 1038
IDC_LO				equ 1039
IDC_IFOUT1			equ 1040
IDC_IFOUT2			equ 1041

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

WM_DATA_RECEIVED	equ	WM_USER+100h

InComBuf			equ 2048
OutComBuf			equ 256

Epsilon				equ 2

IDT_TIMER			equ	999
tmrInterval			equ 1000	;in milliseconds
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

	; COM port ID & list
	;~~~~~~~~~~~~
port_count		equ 4

sCOM				db "\\.\"
sCOM1				db "COM"
COM_id				db "1",0
sCOM2				db "COM2",0
sCOM3				db "COM3",0
sCOM4				db "COM4",0

	; speed list
	;~~~~~~~~~~~
speed_count			equ 15
speed_default		equ 12	; from 0..n	

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

	; params 4 convert
	;~~~~~~~~~~~~~~~~~
KnotsToMetres		dq 0.514
MetresToKilometres	dq 3.6
MinutesToMetres		dd 1852
fmtLa				db "%02lu",0
fmtLo				db "%03lu",0

	; status text
	;~~~~~~~~~~~~
sStart				db "Старт",0
sStop				db "Стоп",0
sReady				db "Готов к работе",0
sDoing				db "Выполнение сценария...",0
sDone				db "Сценарий выполнен",0

hexTable			db "0123456789ABCDEF"

	; open dialog text
	;~~~~~~~~~~~~~~~~~
ofnTitle			db "Открыть файл сценария",0				
ofnFilter			db "Data Files (*.dat)",0,"*.dat",0
					db "All Files (*.*)",0,"*.*",0,0
	
	; about text
	;~~~~~~~~~~~
sAbout0				db "Script Executor v0.5 (demo version)",0
sAbout1				db "22.08.2005 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; help text
	;~~~~~~~~~~
sHelpTitle			db "Справка",0
sHelp				db "Программа читает текстовые файлы-скрипты. Файл скрипта состоит из строк, каждая из которых",10
					db "оформляется в таком формате:",10
					db "^course<SP>speed<SP>time<CR><LF>",10
					db "Где:",10
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
					db "$VWVPW,n.n,N,m.m,M*hh<CR><LF>",10
					db "Где:",10
					db "c.c - курс в градусах",10
					db "n.n - скорость в узлах",10
					db "k.k - скорость в км/ч",10
					db "m.m - скорость в м/с",10
					db "hh - символьное представление шестнадцатеричного значения контрольной суммы, которая",10
					db "    высчитывается для каждого предложения отдельно. Сумма считается по формуле S = S xor B,",10
					db "    где S и B - текущая сумма и байт предложения. Вначале S=0, а байт B берется из диапазона,",10
					db "    начиная с символа после $ и заканчивая символом перед *."
					db 0

sHelp2				db "  Также программа получает от навигационного устройства данные, которые основываются на переданных",10
					db "ему курсе/скорости. Из всего блока данных выделяется такой набор байтов:",10
					db "$GPRMC,hhmmss.sss,A,LLll.ll,N,YYYyy.yy,E",10
					db "Где:",10
					db "hh - часы",10
					db "mm - минуты",10
					db "ss.sss - секунды и доли секунды",10
					db "A - признак достоверности решения: достоверно (A), недостоверно (V)",10
					db "LLll.ll - широта, LL - градусы, ll.ll - минуты и доли минуты",10
					db "N - северная (N) или южная (S) широта",10
					db "YYYyy.yy - долготa, YYY - градусы, yy.yy - минуты и доли минут",10
					db "E - восточная (E) или западная (W) долгота",10,10
					db "  Т.е. программа в начале выполнения сценария считывает от устройства координаты и принимает их",10
					db "за начальные. Затем каждые следующие полученные от устройства координаты сравнивает со своими,",10
					db "которые вычисляет основываясь на последних принятых от устройства координатах и последних",10
					db "переданных ему курсе/скорости. Результаты, ввиде отклонения в метрах, отображает на экране",10
					db "и записывает в файл отчета, каждая строка которого имеет вид:",10
					db "hhmmss.sss,La1,Lo1,La2,Lo2,dLa,dLo<CR><LF>",10
					db "Где:",10
					db "hhmmss.sss - время полученное от устройства",10
					db "La1 и Lo1 - координаты (широта/долгота) от прибора",10
					db "La2 и Lo2 - координаты (широта/долгота) от программы",10
					db "      LaX и LoX записываются в том же формате, что и в $GPRMC (см. выше)",10
					db "dLa - отклонение по широте, в метрах",10
					db "dLo - отклонение по долготе, в метрах",10,10
					db "Примечание: минус означает отклонение на юг или запад.",10,10
					db "  Демо версия: эта демонстрационная версия программы, кроме выдачи в порт каждую секунду курса",10
					db "и скорости в двух форматах, также выдает одну и туже последовательность байтов:",10
					db "$GPRMC,1230ss.026,A,4021.23,N,03541.33,E,stuff<CR><LF>",10
					db "Меняется только ss - текущая секунда сценария, соответственно максимум - 59, но можно и 99 :)",10
					db "Это дает возможность хоть как-то проверить саму программу (не имея устройства). Перекрестно соеденив",10
					db "два COM-порта программа будет в первый выдавать $HEVHW / $VWVPW / $GPRMC, а на втором получать",10
					db "эти данные и выделять из них $GPRMC, в демонстрационных целях выдавая значения отклонений."
					db 0

	; error messages
	;~~~~~~~~~~~~~~~
errTitle			db "Ошибка",0
errOpenFile			db "Не могу открыть файл.",0
errCreateFMO		db "Не могу создать file-mapping object.",0
errMapView			db "Не могу прочитать файл.",0
errOpenPort			db "Не могу открыть порт.",0

	; test data
	;~~~~~~~~~~
tstTime				db 0
cGot_tst			dd 0

p88time_max			dq 604800000
p88time_add			dd 1000*60
c88latitude			dq 0.86521541530554

fuck				db 00h, 00h, 00h, 00h, 00h, 80h, 59h, 40h



					; помни про 0x1010 !!!!!!!!!!!!!

tstRMC				db 10h,54h, 10h,03h						; 4

					; my packet
					; 
					db 10h,60h, 00h
tstSec				db 00h									
					db 04h, 01h,02h,03h,04h, 01h,02h,03h,04h, 10h,03h		; 15
					
					; 53
					db 10h,53h, 00h
					;db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
					db 00h, 30h, 0B2h, 76h, 3Fh, 57h, 0E3h, 89h, 1Bh, 40h
					db 6Bh, 00h
					db 00h,00h,00h,00h
					db 00101010b
					db 10h,03h		; 22
					
					; 88h
					;  header    rnpi             latitude         				   longitude                            height                    CKO
					db 10h,88h,  00h
p88latitude			db 00h,00h,00h,00h,00h,00h,00h,00h,  00h,00h,00h,00h,00h,00h,00h,00h,  00h,00h,00h,00h,00h,00h,00h,00h,  00h,00h,00h,00h
p88time				db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
p88week				dw 0
					;         latitude speed                    longitude speed                   height speed                   deflection      status
					db 00h,00h,00h,00h,00h,00h,00h,00h,  00h,00h,00h,00h,00h,00h,00h,00h,  00h,00h,00h,00h,00h,00h,00h,00h,   00h,00h,00h,00h,  00100000b
					db 10h,03h
					
					; gps 7
					db 10h,49h
					db 01h,7
					db 10h,03h
					; 6

					; 50h
TWO					db 10h,50h,  01h,  80h,25h,00h,00h,  06h,  10h,03h
					
					; A5h
					db 10h, 0A5h, 00h,00h,00h,00h,00h,00h,00h,00h,  00h,00h
					db 00h,00h,00h,00h,  00h,00h,00h,00h,  00h,00h,00h,00h
					db 00h,00h,00h,00h,  00h,00h,00h,00h,  00h,00h,00h,00h
					db 00h
					db 10h,03h
					
					
					; 52 - null
					db 10h,52h,10h,03h		; 4         
					   
					   
					; 43
					db 10h,43h, 02h, 10h,10h, 00h,00h,00h,00h, 10h,03h		;11
					db 10h,43h, 12h, 10h,10h, 00h,00h,00h,00h, 10h,03h		;11
					db 10h,43h, 22h, 0E0h, 0FFh,0FFh,0FFh,0FFh, 10h,03h		;10
					db 10h,43h, 42h, 0E0h, 0FFh,0FFh,0FFh,0FFh, 10h,03h		;10
					db 10h,43h, 82h, 0Ah, 0FFh,0FFh,0FFh,0FFh, 10h,03h		;10					
					
					; подтверждения на тест
					db 10h,43h, 01h, 10h,03h		; 5
					db 10h,43h, 11h, 10h,03h		; 5
					db 10h,43h, 21h, 10h,03h		; 5
					db 10h,43h, 41h, 10h,03h    	; 5
					db 10h,43h, 81h, 10h,03h		; 5
										   
					
					; AF - подтверждение запуска
					db 10h,0AFh, 01h, 10h,03h	; 5
					
					; AF - подтверждение запуска динам.
					db 10h,0AFh, 04h, 10h,03h	; 5
					
					; AF - подтверждение отмены
					db 10h,0AFh, 02h, 10h,03h	; 5
					
					; AF - results
					db 10h,0AFh, 00h
					db 00h,00h,00h,00h, 00h,00h,80h,3fh, 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 10h,03h												; 89
					
					; 87
					db 10h,87h
						db 00h			; rnpi
						; 1
						db 01h			; system
						db 8Ah			; num
						db 20h			; s2n
						db 04h			; status
						dw 0001h		; state
						db 00h,00h,00h,00h,00h,00h,00h,00h ; pseudorange
						db 00h,00h,00h,00h ; doplers integral
						dw 0002h
						; 2
						db 06h			; system
						db -7			; num
						db 0FFh			; s2n
						db 03h			; status
						dw 0FFFFh		; state
						db 00h,00h,00h,00h,00h,00h,00h,00h ; pseudorange
						db 00h,00h,00h,00h ; doplers integral
						dw 0001h
						; 3
						db 07h			; system
						db 1Ah			; num
						db 02Fh			; s2n
						db 00h			; status
						dw 0FFFFh		; state
						db 00h,00h,00h,00h,00h,00h,00h,00h ; pseudorange
						db 00h,00h,00h,00h ; doplers integral
						dw 0ffffh
						; 4
						db 02h			; system
						db 0ffh			; num
						db 0FFh			; s2n
						db 00h			; status
						dw 0FFFFh		; state
						db 00h,00h,00h,00h,00h,00h,00h,00h ; pseudorange
						db 00h,00h,00h,00h ; doplers integral
						dw 0000h
					db 10h,03h						; 5 + 20 + 20 + 40 = 85
					
					
					; AD
					db 10h,0ADh, 00h
					db 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 10h,03h						; 17
					
					; B7
					db 10h,0B7h, 01h, 10h,03h		; 5
					
					; A3
					db 10h,0A3h, 00h, 23 
					db 00h,00h,00h,00h, 00h,00h,00h,00h
					db 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 00h,00h,00h,00h, 00h,00h,00h,00h, 00h,00h,00h,00h
					db 00h,00h,00h,00h
					db "MY_SYS"
					db 10h,03h						; 48
					
					; C2
					db 10h,0C2h
					dw 1111000000000110b
					db 10h,03h						; 6
					
					; 51h - rnpi1
					db 10h,51h
					db 00h		; rnpi
					db 10h,10h	; system
					db 254		; coords_system
					db 0		; angle
					db 0		; reserve
					dw 0		; CKO
					dd 0		; power
					db 10h,03h	; 16
					
					; 51h - rnpi2
					db 10h,51h
					db 10h,10h	; rnpi
					db 02h		; system
					db 255		; coords_system
					db 0		; angle
					db 0		; reserve
					dw 0		; CKO
					dd 0		; power
					db 10h,03h	; 16
					
					; 51h - rnpi3
					db 10h,51h
					db 20h		; rnpi
					db 12h		; system
					db 2		; coords_system
					db 0		; angle
					db 0		; reserve
					dw 0		; CKO
					dd 0		; power
					db 10h,03h	; 15
					
					; 51h - rnpi4
					db 10h,51h
					db 40h		; rnpi
					db 00h		; system
					db 0		; coords_system
					db 50		; angle
					db 0		; reserve
					dw 34570	; CKO
					dd 23.48	; power
					db 10h,03h	; 15
					
					; E6 - off
					db 10h,0E6h,00h,10h,03h,  10h,0E6h,10h,10h,10h,03h,  10h,0E6h,20h,10h,03h,  10h,0E6h,40h,10h,03h
					; 21
					
					; E6 - on
					db 10h,0E6h,01h,10h,03h,  10h,0E6h,11h,10h,03h,  10h,0E6h,21h,10h,03h,  10h,0E6h,41h,10h,03h
					; 20
					
					; 41
					db 10h,41h
					db 00h
					db 00h,00h,80h,3fh
					db 00h,00h,00h,40h
time_41				db 0FFh, 0FFh, 0FFh, 0FFh
					db 10h,03h		; 17
					
					; 56h - ON (for all rnpi)
					db 10h,56h, 02, 12h,0EFh,0CDh,0ABh, 10h,03h	; 9
					db 10h,56h, 52, 12h,0EFh,0CDh,0ABh, 10h,03h	; 9
					db 10h,56h, 102, 12h,0EFh,0CDh,0ABh, 10h,03h ; 9
					db 10h,56h, 152, 12h,0EFh,0CDh,0ABh, 10h,03h ; 9
					
					; 56h - OFF (for all rnpi)
					db 10h,56h, 33, 12h,0EFh,0CDh,0ABh, 10h,03h	; 9
					db 10h,56h, 83, 12h,0EFh,0CDh,0ABh, 10h,03h	; 9
					db 10h,56h, 133, 12h,0EFh,0CDh,0ABh, 10h,03h ; 9
					db 10h,56h, 183, 12h,0EFh,0CDh,0ABh, 10h,03h ; 9
					
					; 4C - all rnpi
					db 10h,4Ch, 00h,     0, 10h,03h		; 6
					db 10h,4Ch, 10h,10h, 1, 10h,03h		; 7
					db 10h,4Ch, 20h,     0, 10h,03h		; 6
					db 10h,4Ch, 40h,     1, 10h,03h		; 6
					
					; 42
					db 10h,42h
						; 1
						db 01h		; system
						db 32		; num
						db 255		; s2n ratio
						db 3		; status
						db 0		; dopler_flag
						; 2
						db 06h		; system
						db 0F9h		; num
						db 1		; s2n ratio
						db 0		; status
						db 2		; dopler_flag
					db 10h,03h		; 14
					
					; 46
					db 10h,46h
					db 00h			; rnpi
					dd 5678			; time
					db 1			; day
					db 7			; month
					dw 2006			; year
					db -13			; hour
					db -59			; minute
					db 10h,03h		; 15
					
					; 89 - rnpi1
					db 10h,89h
					db 00h			; rnpi
					dq 0.0			; latitude
					dq 0.0			; longitude
					dq 23.45		; height
					dd 34.4			; RMS
					dt 0			; time
					dw 0			; week
					dq 1.0			; latitude_speed
					dq 2.0			; longitude_speed
					dq 3.0			; height_speed
					db 10h,03h		; 69
					
					; 89 - rnpi2
					db 10h,89h
					db 10h,10h		; rnpi
					dq 0.0			; latitude
					dq 0.0			; longitude
					dq 23.45		; height
					dd 34.4			; RMS
					dt 0			; time
					dw 0			; week
					dq 2.0			; latitude_speed
					dq 2.0			; longitude_speed
					dq 3.0			; height_speed
					db 10h,03h		; 70
					
					; 89 - rnpi3
					db 10h,89h
					db 20h			; rnpi
					dq 0.0			; latitude
					dq 0.0			; longitude
					dq 23.45		; height
					dd 34.4			; RMS
					dt 0			; time
					dw 0			; week
					dq 3.0			; latitude_speed
					dq 2.0			; longitude_speed
					dq 3.0			; height_speed
					db 10h,03h		; 69
					
					; 89 - rnpi4
					db 10h,89h
					db 40h			; rnpi
					dq 0.0			; latitude
					dq 0.0			; longitude
					dq 23.45		; height
					dd 34.4			; RMS
					dt 0			; time
					dw 0			; week
					dq 4.0			; latitude_speed
					dq 2.0			; longitude_speed
					dq 3.0			; height_speed
					db 10h,03h		; 69

					; C1
					db 10h,0C1h
					db 02h			; count
						; 1
						dd -56.78
						dd 59
						dd 159
						; 2
						dd -56.08
						dd 119
						dd 359
					db 10h,03h		; 5+12+12
					
					; E7 - type1
					db 10h,0E7h, 01h, 00h,00h,80h,3Fh, 10h,03h	; 
					db 10h,0E7h, 11h, 00h,00h,80h,3Fh, 10h,03h	; 
					db 10h,0E7h, 21h, 00h,00h,80h,3Fh, 10h,03h	; 
					db 10h,0E7h, 41h, 00h,00h,80h,3Fh, 10h,03h	; 36
					
					; E7 - type2
					db 10h,0E7h, 02h, 0Ah, 10h,03h	; 
					db 10h,0E7h, 12h, 0Ah, 10h,03h	; 
					db 10h,0E7h, 22h, 0Ah, 10h,03h	; 
					db 10h,0E7h, 42h, 0Ah, 10h,03h	;
					db 10h,0E7h, 0FFh, 0Ah, 10h,03h	; 30
					
					; E7 - type3
					db 10h,0E7h, 03h, 0Ah,00h, 10h,03h	; 
					db 10h,0E7h, 13h, 0Ah,00h, 10h,03h	; 
					db 10h,0E7h, 23h, 0Ah,00h, 10h,03h	; 
					db 10h,0E7h, 43h, 0Bh,00h, 10h,03h	; 28
					
					; E7 - type4
					db 10h,0E7h, 04h, 05h,0Ch, 10h,03h	; 
					db 10h,0E7h, 14h, 05h,0Ch, 10h,03h	; 
					db 10h,0E7h, 24h, 05h,0Ch, 10h,03h	; 
					db 10h,0E7h, 44h, 05h,0Dh, 10h,03h	; 28
					
					; E7 - type5
					db 10h,0E7h, 05h, 4Bh,01h, 0FFh,0FFh,0FFh,0FFh, 10h,03h	; 
					db 10h,0E7h, 15h, 4Bh,01h, 0FFh,0FFh,0FFh,0FFh, 10h,03h	; 
					db 10h,0E7h, 25h, 4Bh,01h, 0FFh,0FFh,0FFh,0FFh, 10h,03h	; 
					db 10h,0E7h, 45h, 4Bh,01h, 0FFh,0FFh,0FFh,0FFh, 10h,03h	; 44 
					
					; E7 - type6
					db 10h,0E7h, 06h, 00h,00h,00h,00h,00h,00h,00h,00h, 10h,03h	; 
					db 10h,0E7h, 16h, 00h,00h,00h,00h,00h,00h,00h,00h, 10h,03h	; 
					db 10h,0E7h, 26h, 00h,00h,00h,00h,00h,00h,00h,00h, 10h,03h	; 
					db 10h,0E7h, 46h, 00h,00h,00h,00h,00h,00h,00h,00h, 10h,03h	; 52
					
					; E7 - type7
					db 10h,0E7h, 07h, 0Fh,11h, 10h,03h	; 
					db 10h,0E7h, 17h, 0Fh,11h, 10h,03h	; 
					db 10h,0E7h, 27h, 0Fh,11h, 10h,03h	; 
					db 10h,0E7h, 47h, 0Fh,11h, 10h,03h	; 28
					
					; E7 - type8
					db 10h,0E7h, 08h, 07h,11h, 10h,03h	; 
					db 10h,0E7h, 18h, 07h,11h, 10h,03h	; 
					db 10h,0E7h, 28h, 07h,11h, 10h,03h	; 
					db 10h,0E7h, 48h, 07h,11h, 10h,03h	; 28
					
					; E7 - type9
					db 10h,0E7h, 09h, 07h,11h,0FFh, 10h,03h	; 
					db 10h,0E7h, 19h, 07h,11h,0FFh, 10h,03h	; 
					db 10h,0E7h, 29h, 07h,11h,0FFh, 10h,03h	; 
					db 10h,0E7h, 49h, 07h,11h,0FFh, 10h,03h	; 32 
					
					; 70 - rnpi1
					db 10h,70h, 18h
					db "Привет! это тупо оно!"
					dd 0FFFFFFFFh
					db "Идентификатор аппарат"
					dd 0FFFFFFFFh
					db "Fucking version of it"
					dd 0FFFFFFFFh
					db 10h,03h		; 80
					
					; 70 - rnpi2
					db 10h,70h, 99
					db "Привет! это тупо оно!"
					dd 0FFFFFFFFh
					db "Идентификатор аппарат"
					dd 0FFFFFFFFh
					db "Fucking version of it"
					dd 0FFFFFFFFh
					db 10h,03h		; 80
					
					; 70 - rnpi3
					db 10h,70h, 100
					db "Привет! это тупо оно!"
					dd 0FFFFFFFFh
					db "Идентификатор аппарат"
					dd 0FFFFFFFFh
					db "Fucking version of it"
					dd 0FFFFFFFFh
					db 10h,03h		; 80
					
					; 70 - rnpi4
					db 10h,70h, 199
					db "Привет! это тупо оно!"
					dd 0FFFFFFFFh
					db "Идентификатор аппарат"
					dd 0FFFFFFFFh
					db "ЖWWWWWWWWWWWWWWWWWWWW"
					dd 0FFFFFFFFh
					db 10h,03h		; 80
					
					; 70 - cpu
					db 10h,70h, 255
					db "CPU ет! это тупо оно!"
					dd 0FFFFFFFFh
					db "CPU тификатор аппарат"
					dd 0FFFFFFFFh
					db "CPU WWWWWWWWWWWWWWWWW"
					dd 0FFFFFFFFh
					db 10h,03h		; 80
					
					; 52
					db 10h,52h
						; 1
						db 01h, 17,0,1
						dw 17
						db 255
						; 2
						db 02h, 255,0,255
						dw 359
						db 255
					db 10h,03h		; 18
					
					; 47 - rnpi1
					db 10h,47h
						; GPS
						db 01h,1,1
						db 01h,2,2
						db 01h,3,1
						db 01h,4,1
						db 01h,5,1
						db 01h,6,1
						db 01h,7,1
						db 01h,8,1
						db 01h,9,1
						db 01h,10,1
						db 01h,11,1
						db 01h,12,1
						db 01h,13,1
						db 01h,14,1
						db 01h,15,1
						db 01h,16,16,1
						db 01h,17,1
						db 01h,18,1
						db 01h,19,1
						db 01h,20,1
						db 01h,21,1
						db 01h,22,1
						db 01h,23,1
						db 01h,24,1
						db 01h,25,1
						db 01h,26,1
						db 01h,27,1
						db 01h,28,2
						db 01h,29,1
						db 01h,30,1
						db 01h,31,1
						db 01h,32,1
						; GLN
						db 02h,1,1
						db 02h,2,1
						db 02h,3,1
						db 02h,4,1
						db 02h,5,1
						db 02h,6,1
						db 02h,7,1
						db 02h,8,1
						db 02h,9,1
						db 02h,10,1
						db 02h,11,1
						db 02h,12,1
						db 02h,13,1
						db 02h,14,1
						db 02h,15,1
						db 02h,16,16,1
						db 02h,17,1
						db 02h,18,1
						db 02h,19,1
						db 02h,20,1
						db 02h,21,1
						db 02h,22,1
						db 02h,23,1
						db 02h,24,2						
					db 10h,03h				; 174
					
					; 47 - rnpi2
					db 10h,47h
						; GPS
						db 11h,1,1
						db 11h,2,2
						db 11h,3,1
						db 11h,4,1
						db 11h,5,1
						db 11h,6,1
						db 11h,7,1
						db 11h,8,1
						db 11h,9,1
						db 11h,10,1
						db 11h,11,1
						db 11h,12,1
						db 11h,13,1
						db 11h,14,1
						db 11h,15,1
						db 11h,16,16,1
						db 11h,17,1
						db 11h,18,1
						db 11h,19,1
						db 11h,20,1
						db 11h,21,1
						db 11h,22,1
						db 11h,23,1
						db 11h,24,1
						db 11h,25,1
						db 11h,26,1
						db 11h,27,1
						db 11h,28,2
						db 11h,29,1
						db 11h,30,1
						db 11h,31,1
						db 11h,32,1
						; GLN
						db 12h,1,1
						db 12h,2,1
						db 12h,3,1
						db 12h,4,1
						db 12h,5,1
						db 12h,6,1
						db 12h,7,1
						db 12h,8,1
						db 12h,9,1
						db 12h,10,1
						db 12h,11,1
						db 12h,12,1
						db 12h,13,1
						db 12h,14,1
						db 12h,15,1
						db 12h,16,16,1
						db 12h,17,1
						db 12h,18,1
						db 12h,19,1
						db 12h,20,1
						db 12h,21,1
						db 12h,22,1
						db 12h,23,1
						db 12h,24,2						
					db 10h,03h				; 174
					
					; 47 - rnpi3
					db 10h,47h
						; GPS
						db 21h,1,1
						db 21h,2,2
						db 21h,3,1
						db 21h,4,1
						db 21h,5,1
						db 21h,6,1
						db 21h,7,1
						db 21h,8,1
						db 21h,9,1
						db 21h,10,1
						db 21h,11,1
						db 21h,12,1
						db 21h,13,1
						db 21h,14,1
						db 21h,15,1
						db 21h,16,16,1
						db 21h,17,1
						db 21h,18,1
						db 21h,19,1
						db 21h,20,1
						db 21h,21,1
						db 21h,22,1
						db 21h,23,1
						db 21h,24,1
						db 21h,25,1
						db 21h,26,1
						db 21h,27,1
						db 21h,28,2
						db 21h,29,1
						db 21h,30,1
						db 21h,31,1
						db 21h,32,1
						; GLN
						db 22h,1,1
						db 22h,2,1
						db 22h,3,1
						db 22h,4,1
						db 22h,5,1
						db 22h,6,1
						db 22h,7,1
						db 22h,8,1
						db 22h,9,1
						db 22h,10,1
						db 22h,11,1
						db 22h,12,1
						db 22h,13,1
						db 22h,14,1
						db 22h,15,1
						db 22h,16,16,1
						db 22h,17,1
						db 22h,18,1
						db 22h,19,1
						db 22h,20,1
						db 22h,21,1
						db 22h,22,1
						db 22h,23,1
						db 22h,24,2						
					db 10h,03h				; 174
					
					; 47 - rnpi4
					db 10h,47h
						; GPS
						db 41h,1,1
						db 41h,2,2
						db 41h,3,1
						db 41h,4,1
						db 41h,5,1
						db 41h,6,1
						db 41h,7,1
						db 41h,8,1
						db 41h,9,1
						db 41h,10,1
						db 41h,11,1
						db 41h,12,1
						db 41h,13,1
						db 41h,14,1
						db 41h,15,1
						db 41h,16,16,1
						db 41h,17,1
						db 41h,18,1
						db 41h,19,1
						db 41h,20,1
						db 41h,21,1
						db 41h,22,1
						db 41h,23,1
						db 41h,24,1
						db 41h,25,1
						db 41h,26,1
						db 41h,27,1
						db 41h,28,2
						db 41h,29,1
						db 41h,30,1
						db 41h,31,1
						db 41h,32,1
						; GLN
						db 42h,1,1
						db 42h,2,1
						db 42h,3,1
						db 42h,4,1
						db 42h,5,1
						db 42h,6,1
						db 42h,7,1
						db 42h,8,1
						db 42h,9,1
						db 42h,10,1
						db 42h,11,1
						db 42h,12,1
						db 42h,13,1
						db 42h,14,1
						db 42h,15,1
						db 42h,16,16,1
						db 42h,17,1
						db 42h,18,1
						db 42h,19,1
						db 42h,20,1
						db 42h,21,1
						db 42h,22,1
						db 42h,23,1
						db 42h,24,2						
					db 10h,03h				; 174
					
					
					; 53
					db 10h,53h, 00h
					;db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
					db 00h, 30h, 0B2h, 76h, 3Fh, 57h, 0E3h, 89h, 1Bh, 40h
					db 6Bh, 01h
					db 00h,00h,00h,00h
					db 01010101b
					db 10h,03h		; 22
					
					; 74
					db 10h,74h
					db 00h			; rnpi
					db 00h, 00h, 00h, 78h, 01h, 00h, 0C0h, 0DAh, 0Ch, 40h
					;db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
					db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h, 40h
;					db 00h, 00h, 00h, 78h, 01h, 00h, 0C0h, 0DAh, 0Ch, 40h
;					db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h
					db 00000101b
					db 10h,03h		; 56
					
					
					; E4
					db 10h,0E4h
					dw 0
					db 0
					db 00h,00h,00h,00h,00h,00h,00h,00h
					dw 0
					db 00h,00h,00h,00h
					db 3	; channels count
					
						; #1
						db 00000000b
						db 13
						db 255
						db 3
						db 00h,00h,00h,00h,00h,00h,00h,00h
						db 00h,00h,80h,3fh
						
						; #2
						db 00111111b
						db -9
						db 255
						db 0
						db 00h,00h,00h,00h,00h,00h,00h,00h
						db 00h,00h,80h,3fh
						
						; #3
						db 11011111b
						db -9
						db 200
						db 2
						db 00h,00h,00h,00h,00h,00h,00h,00h
						db 00h,00h,80h,3fh
						
					db 10h,03h
					; 22 + 3*16 = 70
					
					
					; 4A
					db 10h,4Ah
					db 00h			; rnpi
					db 00h,00h,80h,3Fh
					db 00h,00h,80h,3Fh
					db 00h,00h,80h,3Fh
					db 00h,00h,80h,3Fh
					db 00h,00h,80h,3Fh
					db 00h,00h,80h,3Fh
					db 00h,00h,80h,3Fh
					db 00h,00h,80h,3Fh
					db 254
					db 10h,03h
					; 30
					
					
					; 4B
					db 10h,4Bh
					db 00h
					db 00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h
					dd 256
					dw 257
					dw -258
					dw 259
					dw 260
					dw -261
					db 254
					dw 262
					db 00h,00h,00h,00h,00h,00h,00h,00h
					db 255
					db 10h,03h
					
					
					; A7
					db 10h,0A7h
					db 255
					db 10h,03h
					
					; A9
					db 10h,0A9h
					db 254
					db 00h,00h,80h,3fh
					db 00h,00h,80h,3fh
					db 00h,00h,80h,3fh
					db 10h,03h 
					
					; AB
					db 10h,0ABh
					db 255
					db 00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h
					dw 0
					db 00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h
					db 00h,00h,00h,00h,00h,00h,00h,00h
					db 00010010b
					db 10h,03h
					
					; FE
					db 10h,0FEh
					db 2			; count
						; 1
						dw 65000
						dw 65001
						dw 65002
						dw 65003
						dw 65004
						dw 65005
						dw 65006
						; 2
						dw 65010
						dw 65011
						dw 65012
						dw 65013
						dw 65014
						dw 65015
						dw 65016
					db 10h,03h
					
					; FF
					db 10h,0FFh
					dw 65099
					dd -2000999000
					dd -2000999000
					dd -2000999000
					dw -31999
					db 10h,03h
					
					
					; CA - 1
					db 10h,0CAh
					db 01h
					dq 0.334
					dq 1.01
					dq 2.02
					dq 3.03
					dq 10.001
					dq 20.002
					dq 30.003
					db 1
					db 201
					dq 1000000.111
					dq 1000999.999
					db 10h,03h
					
					; CA - 2
					db 10h,0CAh
					db 02h
					dq 0.334
					dq 1.01
					dq 2.02
					dq 3.03
					dq 10.001
					dq 20.002
					dq 30.003
					db 2
					db 202
					dq 2000000.222
					dq 2000999.999
					db 10h,03h
					
					; CA - 3
					db 10h,0CAh
					db 04h
					dq 0.334
					dq 1.01
					dq 2.02
					dq 3.03
					dq 10.001
					dq 20.002
					dq 30.003
					db 3
					db 203
					dq 3000000.333
					dq 3000999.999
					db 10h,03h
					
					; CA - 4
					db 10h,0CAh
					db 08h
					dq 0.334
					dq 1.01
					dq 2.02
					dq 3.03
					dq 10.001
					dq 20.002
					dq 30.003
					db 4
					db 204
					dq 4000000.444
					dq 4000999.999
					db 10h,03h
					
					; BC - 1
					db 10h,0BDh
					db 01h
					dq 1.001
					dq 1.1
					dq 2.2
					dq 3.3
					db 1
					db 201
					db 1
					db 10h,03h
					
					; BC - 2
					db 10h,0BDh
					db 02h
					dq 2.002
					dq 1.1
					dq 2.2
					dq 3.3
					db 2
					db 202
					db 2
					db 10h,03h
					
					; BC - 3
					db 10h,0BDh
					db 04h
					dq 3.003
					dq 1.1
					dq 2.2
					dq 3.3
					db 3
					db 203
					db 3
					db 10h,03h
					
					; BC - 4
					db 10h,0BDh
					db 08h
					dq 4.004
					dq 1.1
					dq 2.2
					dq 3.3
					db 4
					db 204
					db 4
					db 10h,03h
					
					
					include almanac.inc
					   
					; end ---
					
size_RMC			dd $-tstRMC					
					
					
					db 11h,11h,  11h,11h,  11h,11h,  11h,11h,  33h,33h,  33h,33h,  33h,33h,  33h,33h
					db 0eah,0eah,    10h,03h
					db ".026,A,4021.23,N,03541.33,E,stuff",13,10

;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

	; handles
	;~~~~~~~~
hInstance			dd ?
hdlg				dd ?
hIcon				dd ?
hFile				dd ?	; input file/script
hOut				dd ?	; output file/report
hMapFile			dd ?
hCOM_out			dd ?	; write to that port
hCOM_in				dd ?	; read from that port

	; buffers
	;~~~~~~~~
fbuf_in				db FileNameSize dup(?)	; input file name
fbuf_out			db FileNameSize dup(?)	; output file name
buf					db 25 dup(?)			; temporary buffer for output to port
frmbuf				db 512 dup (?)			; format string (output to port)
inbuf				db InComBuf dup (?)		; input from port
outbuf				db 256 dup (?)			; output to file
tempbuf				db 25 dup (?)			; temporary buffer for received data manipulation

	; output data
	;~~~~~~~~~~~~
k1					dq ?			; course_1
k2					dq ?			; course_2
s1					dq ?			; speed_1
s2					dq ?			; speed_2
mps					dq ?			; speed (mps)
t0					dd ?			; time
AllTime				dd ?			; total time in sec
Distance			dq ?			; total distance in metres
tt0					dq ?			; temp
tt1					dq ?			; temp
szK					db 10 dup (?)	; course as string
szS					db 10 dup (?)	; speed as string
szMPS				db 10 dup (?)	; speed(mps) as string

	; input data
	;~~~~~~~~~~~
Deg					dd ?
La_0				dq ?			; base latitude
Lo_0				dq ?			; base longitude
La					dq ?			; latitude from device
Lo					dq ?			; longitude from device
my_La				dq ?			; = La_0 + d_La
my_Lo				dq ?			; = Lo_0 + d_Lo
d_La				dq ?			; my delta latitude
d_Lo				dq ?			; my delta longitude
diff_La				dq ?			; = my_La - La
diff_Lo				dq ?			; = my_Lo - Lo
Alpha				dq ?			; temporary angle
sz_diff_La			db 16 dup (?)	; diff_La (mps) as string
sz_diff_Lo			db 16 dup (?)	; diff_Lo (mps) as string
ival				dd ?			; temp int value

	; interface flags
	;~~~~~~~~~~~~~~~~
Start				dd ?			; =1 (work), =0 (idle)
IfOut				db ?			; =1 (in/out is turned on), =0 (in/out is turned off)

	; working with ports
	;~~~~~~~~~~~~~~~~~~~
cGot_out			dd ?			; count of bytes output
cGot_in				dd ?			; count of bytes input
ovr_out				OVERLAPPED <?>	; struct 4 asynchronous output
ovr_in				OVERLAPPED <?>	; struct 4 asynchronous input
FirstTime			db ?			; flag for first RMC

	; thread's data
	;~~~~~~~~~~~~~~
ThreadID			dd ?
ThreadOn			dd ?

	; other
	;~~~~~~
ofn					OPENFILENAME <?>	; using by open file dialog
pMemory				dd ?				; main pointer to begin of script data
pData				dd ?				; temporary pointer to script data
FileSize			dd ?				; size of file in bytes left
cwr					dw ?				; Control Word Register (fpu)
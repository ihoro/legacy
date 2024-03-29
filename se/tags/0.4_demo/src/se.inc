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
speed_default		equ 11	; from 0..n	

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

	; status text
	;~~~~~~~~~~~~
sStart				db "�����",0
sStop				db "����",0
sReady				db "����� � ������",0
sDoing				db "���������� ��������...",0
sDone				db "�������� ��������",0

hexTable			db "0123456789ABCDEF"

	; open dialog text
	;~~~~~~~~~~~~~~~~~
ofnTitle			db "������� ���� ��������",0				
ofnFilter			db "Data Files (*.dat)",0,"*.dat",0
					db "All Files (*.*)",0,"*.*",0,0
	
	; about text
	;~~~~~~~~~~~
sAbout0				db "Script Executor v0.4 (demo version)",0
sAbout1				db "04.08.2005 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; help text
	;~~~~~~~~~~
sHelpTitle			db "�������",0
sHelp				db "��������� ������ ��������� �����-�������. ���� ������� ������� �� �����, ������ �� �������",10
					db "����������� � ����� �������:",10
					db "^course<SP>speed<SP>time<CR><LF>",10
					db "���:",10
					db "^ - ������ ������, ��� ������ �������� � ������ ���������.",10
					db "course - ����, � �������� (������������� �����/������� �����), �������� ���������� ���������:",10
					db "    x.x -> ����������� ���� �� ���������� ������� time.",10
					db "    x.x-x.x -> �������� ��������� ����� �� ����� time.",10
					db "speed - �������� � ����� (������������� �����/������� �����), �������� ������ ���������:",10
					db "    x.x -> ����������� �������� �� ���������� ������� time.",10
					db "    x.x-x.x -> �������� ��������� �������� �� ����� time.",10
					db "time - ����� � �������� (������������� ����� �����), �� ���������� �������� ��������� �������",10
					db "    �������� �����/��������, ���� ������ ��������� ��� �����/��������,",10
					db "    �� �� �������� ���������� � ������ �������� ������� time.",10
					db "<SP> - ������ ������� (0x20)",10
					db "<CR> - ������ �������� ������� (0x0D)",10
					db "<LF> - ������ ����� ������ (0x0A)",10,10
					db "  ��������� ��� ������ ������������ � ���������� �������, �� �� ��������� ��� <CR><LF>",10
					db "� ����� ��������� ������ �����!",10
					db "  �.�. ��������� ������ ������ ������ �����, ����� ������ ������� ������� time ������� �� �����",10
					db "���������� � ������� �����/�������� � ����� ���������� �������/���������.",10
					db "  ���� ������� ����� � ����, �� ����� ������ ������� �������� � ���� ��� ����������� ������:",10
					db "$HEVHW,c.c,T,0.0,M,n.n,N,k.k,K*hh<CR><LF>",10
					db "$VWVPW,n.n,N,m.m,M*hh<CR><LF>",10
					db "���:",10
					db "c.c - ���� � ��������",10
					db "n.n - �������� � �����",10
					db "k.k - �������� � ��/�",10
					db "m.m - �������� � �/�",10
					db "hh - ���������� ������������� ������������������ �������� ����������� �����, �������",10
					db "    ������������� ��� ������� ����������� ��������. ����� ��������� �� ������� S = S xor B,",10
					db "    ��� S � B - ������� ����� � ���� �����������. ������� S=0, � ���� B ������� �� ���������,",10
					db "    ������� � ������� ����� $ � ���������� �������� ����� *."
					db 0

sHelp2				db "  ����� ��������� �������� �� �������������� ���������� ������, ������� ������������ �� ����������",10
					db "��� �����/��������. �� ����� ����� ������ ���������� ����� ����� ������:",10
					db "$GPRMC,hhmmss.sss,A,LLll.ll,N,YYYyy.yy,E",10
					db "���:",10
					db "hh - ����",10
					db "mm - ������",10
					db "ss.sss - ������� � ���� �������",10
					db "A - ������� ������������� �������: ���������� (A), ������������ (V)",10
					db "LLll.ll - ������, LL - �������, ll.ll - ������ � ���� ������",10
					db "N - �������� (N) ��� ����� (S) ������",10
					db "YYYyy.yy - ������a, YYY - �������, yy.yy - ������ � ���� �����",10
					db "E - ��������� (E) ��� �������� (W) �������",10,10
					db "  �.�. ��������� � ������ ���������� �������� ��������� �� ���������� ���������� � ��������� ��",10
					db "�� ���������. ����� ������ ��������� ���������� �� ���������� ���������� ���������� �� ������,",10
					db "������� ��������� ����������� �� ��������� �������� �� ���������� ����������� � ���������",10
					db "���������� ��� �����/��������. ����������, ����� ���������� � ������, ���������� �� ������",10
					db "� ���������� � ���� ������, ������ ������ �������� ����� ���:",10
					db "hhmmss.sss,dLa,dLo<CR><LF>",10
					db "���:",10
					db "hhmmss.sss - ����� ���������� �� ����������",10
					db "dLa - ���������� �� ������, � ������",10
					db "dLo - ���������� �� �������, � ������",10,10
					db "����������: ����� �������� ���������� �� �� ��� �����.",10,10
					db "  ���� ������: ��� ���������������� ������ ���������, ����� ������ � ���� ������ ������� �����",10
					db "� �������� � ���� ��������, ����� ������ ���� � ���� ������������������ ������:",10
					db "$GPRMC,1230ss.026,A,4021.23,N,03541.33,E,stuff<CR><LF>",10
					db "�������� ������ ss - ������� ������� ��������, �������������� �������� - 59, �� ����� � 99 :)",10
					db "��� ���� ����������� ���� ���-�� ��������� ���� ��������� (�� ���� ����������). ����������� ��������",10
					db "��� COM-����� ��������� ����� � ������ �������� $HEVHW / $VWVPW / $GPRMC, � �� ������ ��������",10
					db "��� ������ � �������� �� ��� $GPRMC, � ���������������� ����� ������� �������� ����������."
					db 0

	; error messages
	;~~~~~~~~~~~~~~~
errTitle			db "������",0
errOpenFile			db "�� ���� ������� ����.",0
errCreateFMO		db "�� ���� ������� file-mapping object.",0
errMapView			db "�� ���� ��������� ����.",0
errOpenPort			db "�� ���� ������� ����.",0

	; test data
	;~~~~~~~~~~
tstTime				db 0
size_RMC			equ 48
cGot_tst			dd 0
tstRMC				db "$GPRMC,1230"
tstSec				db "ss"
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
	;~~~~~~~~~~~~~~~~~~
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
d_La				dq ?			; my delta latitude
d_Lo				dq ?			; my delta longitude
diff_La				dq ?			; = my_La - La
diff_Lo				dq ?			; = my_Lo - Lo
Alpha				dq ?			; temporary angle
sz_diff_La			db 16 dup (?)	; diff_La (mps) as string
sz_diff_Lo			db 16 dup (?)	; diff_Lo (mps) as string

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
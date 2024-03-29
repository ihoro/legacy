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

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

WM_DATA_RECEIVED	equ	WM_USER+100h

InComBuf			equ 2048
OutComBuf			equ 256

FileNameSize		equ 500

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
sStart				db "�����",0
sStop				db "����",0

	; about text
	;~~~~~~~~~~~
sAbout0				db "FF Catcher v0.5",0
sAbout1				db "02.11.2005 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; error messages:
	;~~~~~~~~~~~~~~~~
errTitle			db "������",0
errOpenPort			db "�� ���� ������� ����.",0

	; convert
	;~~~~~~~~
HexTable			db "0123456789ABCDEF"

	; open dialog text
	;~~~~~~~~~~~~~~~~~
ofnTitle			db "��������� � ���-����",0				
ofnFilter			db "Log Files (*.log)",0,"*.log",0,0
ofnDefExt			db "log"

	; log file
	;~~~~~~~~~
logDefName			db "\ffc.log",0

	; help text
	;~~~~~~~~~~
sHelpTitle			db "�������",0
sHelp				db "� ������ ������ ��������� ���� ����������� � ���� ������. ������ ���, ������� ������, ��� "
					db "���� ����� ��� ���������� ����� ������: "
					db "0x10FF (���� ��� ����� ������ ������) ��� 0x??10FF, ��� ���� 0x?? �� ����� 0x10. "
					db "���� 0xFF ����� ������������ ������������� � ���� 'ID ������'. "
					db "����� ������ ��������� ����� 0x10FF ����� ������ �� ���������� 0x1003 � ���������� ��. "
					db "��� ��������� ��� ������ 0xFF, ��������� � ������� ������, ����� ��������� ����� "
					db "����������� � �����.",10,10
					db "��� ������ ���������� ���������� �����������, ��� ��� ����� ������ 0x1010 �������� ���� "
					db "���� 0x10.",10,10
					db "���� ����������� �������� ��������� ����� � �������� ����, ��� ����� ����� � ���� ����� "
					db "'������ ������' ����� ������� ������ ������, ������ ��������� ��� ����, ������� "
					db "������������ ������ � ���� '������ - HEX'. ������������ ����� ����� - 64. � ����� ������� "
					db "���� ������ ������, � ����� �� ����� ���������� ��������������� �����.",10,10
					db "������ '�����' ���������� ����� ���������� �������� � ����� ���� � ����� ����� ������� "
					db "0x10FF, ������� ���� ������� � ���������.",10,10
					db "��� ��, ���� ��������, ������� ������ � ���-���� HEX-������ � ��� �� ����, � ������� ��� "
					db "������������. ���� ����������� �������������� ���� ��� ��������� � ��� ������������. "
					db "����������� ���-���� ������ ��������� � ����� ���������� � ����������.",10,10
					db "���� ��������� ����� ��������� �� ������, ����� ������� ������ ������."
					db 0

	; other
	;~~~~~~
pID					db 0FFh,10h			; packets ID
logfont 			LOGFONT <-13,0,0,0,400,0,0,0,-52,1,2,1,33,"Fixedsys">


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
hFile				dd ?
;hFile2				dd ?

	; working with ports
	;~~~~~~~~~~~~~~~~~~~
cGot				dd ?			; count of bytes input
ovr					OVERLAPPED <?>	; struct 4 asynchronous input
cBytes				dd ?			; total bytes received
cPackets			dd ?			; total packets received

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
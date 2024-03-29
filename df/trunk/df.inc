;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include kernel32.inc
include user32.inc
include comdlg32.inc
include comctl32.inc
include shell32.inc
include masm32.inc

;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib kernel32.lib
includelib user32.lib
includelib comdlg32.lib
includelib comctl32.lib
includelib shell32.lib
includelib masm32.lib

;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM
EnableControls	PROTO
CloseHandles	PROTO
GetOffset		PROTO	:DWORD,:DWORD,:DWORD
CheckFloat		PROTO	:DWORD
ThreadProc		PROTO	:DWORD

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDC_APPICON			equ 2001

IDD_DIALOG			equ 101
IDC_VALUE			equ 1001
IDC_LBLFROM			equ 1002
IDC_FROM			equ 1003
IDC_LBLTO			equ 1004
IDC_TO				equ 1005
IDC_SENTENCE		equ 1006
IDC_LBLNUMER		equ 1007
IDC_NUMBER			equ 1008
IDC_LBLTYPE			equ 1009
IDC_TYPE			equ 1010
IDC_OPEN			equ 1011
IDC_DO				equ 1012
IDC_ABOUT			equ 1013
IDC_EXIT			equ 1014
IDC_LBLINPUTFILE	equ 1015
IDC_LBLOUTPUTFILE	equ 1016
IDC_INPUTFILE		equ 1017
IDC_OUTPUTFILE		equ 1018
IDC_PROGRESS		equ 1019
IDC_STATUS			equ 1022
IDC_LBLBLOCKS		equ 1020
IDC_LBLBYTES		equ 1021
IDC_BYTES			equ 1023
IDC_BLOCKS			equ 1024
IDC_HELPP			equ 1025

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

FileNameSize		equ 300
WM_DONE				equ WM_USER+100h

;-------------------------------------------------------------
; vars
;-------------------------------------------------------------

.data

	; type list
	;~~~~~~~~~~
type_count			equ 5
type_size			equ 6

sType1				db "GPRMC",0
sType2				db "GPGGA",0
sType3				db "GPGSA",0
sType4				db "PORZD",0
sType5				db "GPGSV",0

	; open dialog text
	;~~~~~~~~~~~~~~~~~
ofnTitle			db "������� ���� ������",0				
ofnFilter			db "Data Files (*.dat)",0,"*.dat",0
					db "All Files (*.*)",0,"*.*",0,0

	; interface
	;~~~~~~~~~~
szDo				db "���������",0
szCancel			db "������",0
szReady				db "������ - ����� � ������",0
szDone				db "������ - ���������� ���������",0
szDoing				db "������ - ����������...",0

	; help text
	;~~~~~~~~~~
sHelpTitle			db "�������",0
sHelp				db "��������� ������������ �����, � ������� ��������� �������� ����������� ���� $GPRMC, $GPGGA � �.�.",10
					db "������ ��������� ����� �����������, ������� ���������� � $GPRMC.",10
					db "�.�. ������������ ����� ���������� �� �������� ����� � ������������ � �������� ����.",10
					db "����� ����������� �� ����� ���������:",10
					db "��� - ��� ����������� ����������� � �����.",10
					db "����� ���� - ���� �� �������� ������� ���������. ����� �������� �����/������� �����,",10
					db "������������ ��������. ����� ����������� ���� "",x.x,"", ����� �������������� � "",x.x*"".",10
					db "������ ���� ���������� ����� �������������� �����������, � ������� - ""$GPRMC,x.x,""",10
					db "�������� ""��"" � ""��"" - ������� �������� �������� ��� ������� ����.",10,10
					db "�.�. ���� ����������, ����� � ��� ���� ����������� ���� ""���"", � ������� �������� ����",10
					db "��� ������� ""����� ����"" �������� � ������� [ ""��"" ; ""��"" ].",10,10
					db "����������.",10
					db "���� ���� ����������� ��� �����, �.�. ������ ����, ��� "",,"" ��� "",*"", �� ���� ��������� �������.",10
					db 0

	; about text
	;~~~~~~~~~~~
sAbout0				db "Data Filter v0.2",0
sAbout1				db "11.08.2005 by fnt0m32 'at' gmail.com",10,"Have fun!",0

	; errors text
	;~~~~~~~~~~~~
errTitle			db "������",0
errFloat			db "������� ���������� �����!",0
errInt				db "������� ����� ����!",0

;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

	; handles
	;~~~~~~~~
hInstance			dd ?
hdlg				dd ?
hIn					dd ?
hOut				dd ?
hIcon				dd ?
hMapFile			dd ?
pMemory				dd ?
pData				dd ?

	; buffers
	;~~~~~~~~
fbuf_in				db FileNameSize dup(?)	; input file name
fbuf_out			db FileNameSize dup(?)	; output file name
buf_size			equ 50
buf					db buf_size dup(?)		; temporary

	; data
	;~~~~~
BytesDone			dd ?
BytesGot			dd ?
BlocksDone			dd ?
FileSize			dd ?
BlockSize			dd ?
pType				dd ?
pNumber				dd ?
pFrom				dq ?
pTo					dq ?
pX					dq ?
cDone				dd ?

	; other
	;~~~~~~
ThreadOn			db ?
ThreadID			dd ?
ofn					OPENFILENAME <?>	; using by open file dialog
erri				dd ?
;-------------------------------------------------------------
; prototypes
;-------------------------------------------------------------

HelpDlgProc			PROTO :HWND,:UINT,:WPARAM,:LPARAM
SwitchHelpContext	PROTO

;-------------------------------------------------------------
; resources
;-------------------------------------------------------------

IDD_HELPDIALOG		equ 2000
IDC_HELPTEXT		equ 2001
IDC_HELPEXIT		equ 2002
IDC_SWITCH			equ 2003

;-------------------------------------------------------------
; defines
;-------------------------------------------------------------

;-------------------------------------------------------------
; vars
;-------------------------------------------------------------

.data

	; titles text
	;~~~~~~~~~~~~
sShowChangesLog		db "ChangeLog",0
sShowHelp			db "�������",0

	; help text
	;~~~~~~~~~~
;sHelpTitle			db "�������",0
sHelp				db "� ������ ������ ��������� ���� ����������� � ���� ������. ������ ���, ������� ������, ��� "
					db "���� ����� ��� ���������� ����� ������:",13,10
					db "0x10FF (���� ��� ����� ������ ������) ��� 0x??10FF, ��� ���� 0x?? �� ����� 0x10. "
					db "���� 0xFF ����� ������������ ������������� � ���� 'ID ������'. ",13,10
					db "����� ������ ��������� ����� 0x10FF ����� ������ �� ���������� 0x1003 � ���������� �� � ���� 'HEX'. "
					db "�� ���� ����� �������� ����������� ���������� ���������� � ����������� ������ ����������, ��� ������� �����. "
					db "��� ��������� ��������� ��� ������ 0xFF, �������� � ������������ ����������. ",13,10,13,10
					
					db "��� ������ ���������� ���������� �����������, ��� ��� ����� ������ 0x1010 �������� ���� "
					db "���� 0x10.",13,10,13,10,13,10,13,10
					
					
					db "'BIN'. ���� ����������� �������� ��������� ����� � �������� ����. ��� ����� ����� � ���� ����� "
					db "'������ ������' ����� ������� ������ ������, ������ ��������� ��� ����, ������� "
					db "������������ ������ � ���� 'HEX'. ������������ ����� ����� - 64. � ����� ������� "
					db "���� ������ ������, � ����� �� ����� ���������� ��������������� �����.",13,10,13,10,13,10,13,10
					
					
					db "'DEC'. ����� ��������� ���������� �������� V1,V2,V3,t. �� ������ ������� ������ 0x10FF ���������� �����: w1 (2-�� � 3-�� �����), w2 (4-�� � 5-��), w3 (6-�� � 7-��), w4 (8-�� � 9-��), "
					db "��� ������� �� ������ ���� ��������� ������� � �����. ������ V1,V2,V3 ��������� �� ����� �������:",13,10
					db "     VX = wX * 0.000305176",13,10
					db "� �����������:",13,10
					db "     t = w4 * 0.03052 - 273. ",13,10,13,10,13,10,13,10
					
					
					db "'DEG'. � �������� ���� ����� ����� ��������� �������� ����� F1 � F2, "
					db "������� ����� ��������� ������ �����������:",13,10
					db "     Fx = sDDD.MM.mm",13,10
					db "���:",13,10
					db "     x - ����� (1/2);",13,10
					db "     s - ���� (+/-), ������������� ���� �� ������������;",13,10
					db "     DDD - ������� (����� ����������);",13,10
					db "     MM.mm - ������ (���������� �����).",13,10
					db "���� ��������� �� ������ ��������� ������ (���������� �����):",13,10
					db "     g - ��������� ���������� ������� [�/�^2]",13,10
					db "     U11 - ����� ����� �������1 ��� 0 ��������;",13,10
					db "     U21 - ����� ����� �������2 ��� 0 ��������;",13,10
					db "     U12 - ����� ����� �������1 ��� 90 ��������;",13,10
					db "     U22 - ����� ����� �������2 ��� 90 ��������;",13,10
					db "     U13 - ����� ����� �������1 ��� 180 ��������;",13,10
					db "     U23 - ����� ����� �������2 ��� 180 ��������;",13,10
					db "     U14 - ����� ����� �������1 ��� 270 ��������;",13,10
					db "     U24 - ����� ����� �������2 ��� 270 ��������.",13,10
					db "��� ����� ��������� ���� ������ ������������� �������������� ��������� �� ��������:",13,10
					db "     U10 = (U11 + U13) / 2;",13,10
					db "     U20 = (U22 + U24) / 2;",13,10
					db "     k1 = (U12 - U14) / (2 * g);",13,10
					db "     k2 = (U21 - U23) / (2 * g);",13,10
					db "     Alpha1 = (U11 - U13) / (2 * k1 * g);",13,10
					db "     Alpha2 = (U22 - U24) / (2 * k2 * g).",13,10
					db "������ �� ������ ���� �������� ����������� ���� �� ��������:",13,10
					db "     F1 = arcsin( (V1 - U10) / (k1 * g) - Alpha1 ) * 180 / pi;",13,10
					db "     F2 = arcsin( (V3 - U20) / (k2 * g) - Alpha2 ) * 180 / pi.",13,10
					db "��� V1 � V3 ����������� ���� (��. ����� 'DEC').",13,10,13,10
					db "��� ������� �� ���� �� ������ (0,90,180,270) ����� ����������� ��������������� ������� "
					db "���� ���������� (U1x,U2x). �������� ��� ��������� �������. ��������� �������� �� "
					db "��������� ����������� 64-� ������� �� ��� ����� ������ w1 � w3 (��. ����� 'DEC') � ��������� "
					db "������� �������������� avg1 � avg2 �� ���� w1 � w3 ��������������. ����� ��� �������� "
					db "����������� � ������ (��. ������� � ������ 'DEC') � �������� ������ �������� � �������. "
					db "��� �������� �� ������ ������������ ���������� ���������� �������. "
					db "����� ���������� ���� ������� � �� ������� ��������� � ������� ����� ������ �������� �� "
					db "����� �� ������� ������ (����: ��� ������� �������� ������ ������� ����� �� ������ :). "
					db "����� �� ���� �� 8-� ���������� ������� �������� ����� �����, �� ��������� "
					db "���������� ����������������� �������� (avgX), �� �������� �� ������� ���� �������� �������� �����."
					db 13,10,13,10
					
					db "���� ���������� ����� ��������, ��� �������� ��������� ������� arcsin � �������� F1/F2 "
					db "����� �������� �� ����� ���������� (-1 <= x <= 1), �� ������������� ����� ����������� ����� �������� ���������:",13,10
					db "     x = 1, ���� x > 1;",13,10
					db "     x = -1, ���� x < -1.",13,10
					db "������������� ���������� ������� ���������� �� ������ ������ ��������.",13,10
					db "��������� ������������� � ����� �������� ������������ � ���� 'DEG' ����� �������� ����� ������ ' ERR'. "
					db "� ����� �� ���� ���� 'DEG' �������� � ���-����, ���� ��������� ������������ (��. �����).",13,10,13,10
					
					db "� ������� ������ '��������' � COM-���� ���������� ������ ���� (18 ���� ������): ��� 8 ���������� ������� � ���� "
					db "avgX-�������� (��. ����) � ������������� ����������� �� ���� 'kt'. � ���� ������ ������ ����� �������� �������� � ������. "
					db "������ ���������� � ����� �������: U11, U12, U13, U14, U21, U22, U23, U24, KT."
					db 13,10,13,10,13,10,13,10
					
					
					db "'������ � ���-����'. ���� ��� ����� ��������, �� ������� ������ "
					db "� ��������� ���-���� ��������� ���� ������ (����� BIN) � ��� �� ����, � ������� ��� ������������, "
					db "������ � ����� �������:",13,10
					db "     HEX DEC DEG [�����������]",13,10
					db "�������� � ��������� ������ ���-����� ����� ����� � � ������ ������ ���������. "
					db "���� �������� ����� '���������� �����', �� ��� ������ ��������� ������ ������ (������ '�����') "
					db "���-���� ����� ��������� � ���������� � ����, ����� ��� ����� ���-���������� ����� ������������ "
					db "� ����� ��� ������������� �����. ��� ����� �� ����������� ��� ��������� � ���������� ������, ����� ��������� ��� ��������� � ������ ������.",13,10
					db "��� ������ ����� '����������� ���-����' ���� � ��� ����� ������� ��� ����������� - "
					db "��� ����� ������� �������������: ��� ����� ����� - 'ffc.log' � �� ����� ��������� � ��� �� ����������, "
					db "��� � ���� ��������� (ffc.exe). � ��������� ������ ����� ������ ����/��� ������� ��� ������� (������ '...').",13,10,13,10
					
					db "������ �� ������ '�����' ������� ���� ����� ��� �������, ������� ����� ������ � ���-���� "
					db "� ������� ������ 'V'. �������/�������/����������� ��������� � ����� ������� ������ ���-����� (��. ����).",13,10,13,10,13,10,13,10
					
					
					db "������ '�����' ���������� ����� ���������� �������� � ����� ���� � ����� ����� ������� "
					db "0x10FF, ������� ���� ������� � ���������.",13,10,13,10,13,10,13,10
					
					
					db "��������� ��������� ���� ��������� � ����� ffc.cfg, ������� ��������� � ����� ���������� � ����������. "
					db "����� �� ����������� ������ � ���������� � ���������� ��, �� � ���� ���� ������������� ����������� "
					db "��������� ���������:",13,10
					db "  - ��� ��������� COM-����� (�����, ��������, ��������, ����-����)",13,10
					db "  - ID ������",13,10
					db "  - ��� ��������� ���-�����",13,10
					db "  - ������ '������ ������' ��� ���� 'BIN'",13,10
					db "  - ��� ������������� �������� � ����� 'DEG' (� ������ ������ - ��� ��� ��������� 'g' � 'kt', �� ��� ������������� � ������� 0.9.4 ����� ������������ ��� ������ ���������� �� �������)",13,10
					db "  - ������� ���������� (������ ��������) � ���� ��������� ����������������� �������� (��. ����� 'DEG')",13,10
					db "�������������� ������ ���, ����� �� ���������� ���������, ��� ��������� ������������� �������� �� �����. "
					db "�.�. ����� ���������� ������ � ���������� ���������. ���� ���� � ����������� �� ����� ���������, "
					db "�� ����� ������������ ����� ffc.cfg ���� � ����������� �� ���������.",13,10,13,10,13,10,13,10
					
					
					db "���� ��������� ����� ��������� �� ������, ����� ������� ������ ������."
					
					db 0


	; ChangesLog text
	;~~~~~~~~~~~~~~~~
sChangesLog			db "14.03.2006  v0.9.6",13,10
					db "    - ���� �������������� ������������",13,10
					db "    - ������ ����� ��� ����� 'ID ������' � 'kt'",13,10
					db "    - ����������� �������� � COM-���� ������� ����������",13,10
					db "    - ��������� cfg-����� ��������. ��������� � �������� ��������",13,10,13,10,13,10
					db "06.03.2006  v0.9.5",13,10
					db "    - ���� ����� ������� ������ �������",13,10
					db "    - ���/���������� ������ � ���-���� � ������ ������",13,10
					db "    - � ������� ���� F2 arccos ������� �� arcsin",13,10
					db "    - ������� ������� ���������� ������� ���������������",13,10
					db "    - ����������� HEX-�������� ������� ����������",13,10
					db "    - ��������� ������� ���������� ����� ������� ������� ��������",13,10
					db "    - ��������� cfg-����� ��������. ���� ��������� � v0.9.4",13,10,13,10,13,10
					db "07.02.2006  v0.9.4",13,10
					db "    - ����������� ��������������� ����������/�������� ��������",13,10
					db "    - ���������� ��������� ����������� ����������� � ���-����� � 'DEC'",13,10,13,10,13,10
					db "07.02.2006  v0.9.3",13,10
					db "    - ����� ������� �������",13,10
					db "    - ��������� ������ ������",13,10
					db "    - ���������� ������ �������� ���� �� 2-��� �������",13,10
					db "    - ����������� ��������� :)",13,10,13,10,13,10
					db "06.02.2006  v0.9.2",13,10
					db "    - ���� 'DEG'. ���� �����������, ��������� � ���������� �����",13,10
					db "    - �������������� ������� �������������� �������������",13,10
					db "    - ��������� �������������� ������ - ' ERR'",13,10
					db "    - � ���-���� ������������ ������ DEG: ���� F1 � F2",13,10,13,10,13,10
					db "06.12.2005  v0.9.1",13,10
					db "    - ����������� ��������� ����������� � ���-���� � ������ ������",13,10,13,10,13,10
					db "29.11.2005  v0.9",13,10
					db "    - ��������� ����� ����������� �����",13,10
					db "    - ���� 'DEC'. ����������� ���������� �������� V1,V2,V3 � �����������",13,10
					db "    - ������ ����������� � ���-���� ��������� ���� �������� ��������: V1,V2,V3,t",13,10,13,10,13,10
					db "18.11.2005  v0.8",13,10
					db "    - ��������� ��� � ������������ �����������",13,10
					db "    - ���������� � ���-����� ������ �����������",13,10,13,10,13,10
					db "09.11.2005  v0.7",13,10
					db "    - ��������� ����� �����������",13,10,13,10,13,10
					db "02.11.2005  v0.6",13,10
					db "    - ���������� ������� ��� �� ������ ����� ������� ����������� ������",13,10,13,10,13,10
					db "02.11.2005  v0.5",13,10
					db "    - ������������� ��� ������ � ������� �������� ����� ������",13,10
					db "    - ���� 'BIN'. ����������� ��������� ������ � �������� ����",13,10
					db "    - ������ ������ ���������� �������� ������ � �������",13,10
					db "    - ������ ������� ���-�����",13,10
					db "    - ����������� �������� ������� ����/��� ���-�����",13,10
					db "    - ���������� ������ ���� ��� �������� ������ ������",13,10,13,10,13,10
					db "01.11.2005  v0.4",13,10
					db "    - ����������� ���������� ���-�����",13,10
					db "    - ����� '����������� ���-����' � '���������� �����'",13,10,13,10,13,10
					db "01.11.2005  v0.3",13,10
					db "    - ���������� ������ ������",13,10
					db "    - ������ ��������� ������������ �������",13,10,13,10,13,10
					db "31.10.2005  v0.2",13,10
					db "    - ������ ��������� COM-����� (�����, ��������, ��������, ����-����)",13,10
					db "    - ����������� ������ �������������� ������ 0xFF",13,10,13,10,13,10
					db "30.10.2005  v0.1",13,10
					db "    - ����� �������",13,10
					db "    - ����������� ������ COM-����� � ��� ��������",13,10
					db "    - ��������� ������� HEX-������"
					db 0


;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

hdlg2				dd ?

HelpMode			db ?		; = 0/1 -> Help/ChangesLog
comment `#####################################################
#
#  ffc.asm    30.10.05 by fnt0m32 'at' gmail.com
#
#  FF Catcher v0.1
#
#  Used [MASM32 v8.2]
#
##############################################################`

.386
.model flat,stdcall
option casemap:none

;-------------------------------------------------------------
; inc,lib,data,data?,const,equ
;-------------------------------------------------------------

include ffc.inc

;-------------------------------------------------------------
; ENTRY POINT
;-------------------------------------------------------------

.code

start:

	invoke	InitCommonControls

	invoke	GetModuleHandle,NULL
	mov		hInstance,eax

	invoke	DialogBoxParam,hInstance,IDD_DIALOG,NULL,addr DlgProc,NULL
	
	invoke	ExitProcess,0

;-------------------------------------------------------------
; Dialog Procedure
;-------------------------------------------------------------

DlgProc proc uses ebx esi edi hwnd:HWND,msg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,msg
	
	;-------------------------
	; WM_INITDIALOG
	;-------------------------
	
	.if eax==WM_INITDIALOG
		
		push	hwnd
		pop		hdlg
		
		invoke	ShowGroup,1
		
		; init flags
		;~~~~~~~~~~~
		mov		Start,0
		mov		ThreadOn,0
		
		; init ibuf
		;~~~~~~~~~~
		mov		byte ptr ibuf,' '
		mov		byte ptr ibuf[6],0
		
		; set titles
		;~~~~~~~~~~~
		invoke	SendMessage,hwnd,WM_SETTEXT,0,addr sAbout0
		invoke	SendDlgItemMessage,hwnd,IDC_DO,WM_SETTEXT,0,addr sStart
		
		; set icon
		;~~~~~~~~~
		invoke	LoadIcon,hInstance,2000
		mov		hIcon,eax
		invoke	SendMessage,hwnd,WM_SETICON,ICON_BIG,hIcon
		
		; init Port ComboBox
		;~~~~~~~~~~~~~~~~~~~~
		lea		esi,sCOM1
		mov		ecx,port_count
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_PORT,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+5]
		loop	@B
		
		invoke	SendDlgItemMessage,hwnd,IDC_PORT,CB_SETCURSEL,0,0
		
		; init Speed ComboBox
		;~~~~~~~~~~~~~~~~~~~~
		lea		esi,sBPS1
		mov		ecx,speed_count
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_SPEED,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+7]
		loop	@B
		
		invoke	SendDlgItemMessage,hwnd,IDC_SPEED,CB_SETCURSEL,speed_default,0
		
	;-------------------------
	; WM_COMMAND
	;-------------------------
		
	.elseif eax==WM_COMMAND
		
		mov		eax,wParam
		
		; DO button
		;~~~~~~~~~~
		.if ax==IDC_DO
			
			invoke	OnOff,2
		
		; HELPP button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_HELPP
			
			invoke	MessageBox,hwnd,addr sHelp,addr sHelpTitle,MB_OK or MB_ICONINFORMATION
			
		; ABOUT button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_ABOUT
			
			invoke	ShellAbout,hwnd,addr sAbout0,addr sAbout1,hIcon
			
		; EXIT button
		;~~~~~~~~~~~~
		.elseif ax==IDC_EXIT
			
			invoke	SendMessage,hwnd,WM_CLOSE,0,0
			
		.else
			
			jmp		failed
			
		.endif
		
	;-------------------------
	; WM_DATA_RECEIVED
	;-------------------------
		
	.elseif eax==WM_DATA_RECEIVED
		
		xor		eax,eax
		lea		esi,inbuf
		mov		ecx,cGot
		cld
		
		; looking for 0x??10FF			// 0x?? != 0x10
		;~~~~~~~~~~~~~~~~~~~~~
	lup:
		cmp		ecx,0
		ja		@F
		jmp		end_lup
	@@:
		shl		eax,8
		lodsb
		dec		ecx
		
		mov		ebx,eax
		cmp		bx,10FFh
		jnz		lup
		shr		ebx,8
		cmp		bh,10h
		je		lup
			
			; convert 0x1010 to 0x10
			;~~~~~~~~~~~~~~~~~~~~~~~
			lea		edi,buf
			xor		ax,ax			
		clup:
			jecxz	end_clup
			shl		ax,8
			lodsb
			dec		ecx
			cmp		ax,1010h
			jne		@F
			xor		ax,ax
			jmp		clup
		@@:
			cmp		ax,1003h
			je		end_clup
			stosb
			jmp		clup
		end_clup:
			
			; TODO: check size!!!
			
			;----------------------------------
			; output data
			;----------------------------------
			
			invoke	CleanData
			
			lea		esi,buf
			xor		eax,eax
			
			; output N			// 0x10FFNN
			;~~~~~~~~~
			lodsb
			invoke	SetDlgItemInt,hwnd,IDC_N,eax,FALSE
			
			; output 1,2,3		// 0x10FFNN111122223333
			;~~~~~~~~~~~~~
			lea		ebx,HexTable
			xor		edx,edx
			
		outlup:
			lea		edi,ibuf+1
			mov		ecx,2
			
		@@:
			xor		ax,ax
			lodsb				; ax = 00 AB
			shl		ax,4		; ax = 0A B0
			shr		al,4		; ax = 0A 0B
			xlat				; ax = 0A 42		// 42 = 'B'
			xchg	ah,al		; ax = 42 0A
			xlat				; ax = 42 41		// 41 = 'A'
			stosb
			shr		ax,8		; ax = 00 42
			stosb
			mov		al,' '
			stosb
			loop	@B
			
			lea		ecx,[edx+IDC_WORD1]
			push	edx
			invoke	SetDlgItemText,hwnd,ecx,addr ibuf
			pop		edx
			inc		edx
			cmp		edx,3
			jae		@F
			jmp		outlup
		@@:
			
	end_lup:
		
	;-------------------------
	; WM_CLOSE
	;-------------------------

	.elseif eax==WM_CLOSE
		
		invoke	OnOff,0
		invoke	EndDialog,hwnd,0
			
	.else
		
	failed:
		xor		eax,eax
		ret
		
	.endif

	mov		eax,TRUE
	ret

DlgProc endp

;-------------------------------------------------------------
; Open & Init COM-port
;
; [out] eax = TRUE/FALSE (OK/Failed)
;-------------------------------------------------------------

OpenPort proc

LOCAL	dcb:DCB
LOCAL	cto:COMMTIMEOUTS

	; get COM ID
	;~~~~~~~~~~~	
	invoke	SendDlgItemMessage,hdlg,IDC_PORT,CB_GETCURSEL,0,0
	add		al,31h
	mov		COM_id,al
	
	; Open Port
	;~~~~~~~~~~
	invoke	CreateFile, \
				addr sCOM, \
				GENERIC_READ or GENERIC_WRITE, \
				NULL, \ ;FILE_SHARE_READ or FILE_SHARE_WRITE, \
				NULL, \
				OPEN_EXISTING, \
				FILE_FLAG_OVERLAPPED, \
				NULL
				
	.if eax != INVALID_HANDLE_VALUE
		
		mov		hCOM,eax
		
		invoke	PurgeComm,hCOM,PURGE_TXABORT or PURGE_RXABORT or \
					PURGE_TXCLEAR or PURGE_RXCLEAR
		invoke	ClearCommBreak,hCOM
		
		; set in/out buffer
		;~~~~~~~~~~~~~~~~~~
		invoke	SetupComm,hCOM,InComBuf,OutComBuf
		
		; get current DCB
		;~~~~~~~~~~~~~~~~		
		invoke	GetCommState,hCOM,addr dcb
		
		; set speed
		;~~~~~~~~~~
		invoke	SendDlgItemMessage,hdlg,IDC_SPEED,CB_GETCURSEL,0,0
		.if 	eax == 0
			mov		dcb.BaudRate,CBR_110
		.elseif eax == 1
			mov		dcb.BaudRate,CBR_300
		.elseif eax == 2
			mov		dcb.BaudRate,CBR_600
		.elseif eax == 3
			mov		dcb.BaudRate,CBR_1200
		.elseif eax == 4
			mov		dcb.BaudRate,CBR_2400
		.elseif eax == 5
			mov		dcb.BaudRate,CBR_4800
		.elseif eax == 6
			mov		dcb.BaudRate,CBR_9600
		.elseif eax == 7
			mov		dcb.BaudRate,CBR_14400
		.elseif eax == 8
			mov		dcb.BaudRate,CBR_19200
		.elseif eax == 9
			mov		dcb.BaudRate,CBR_38400
		.elseif eax == 10
			mov		dcb.BaudRate,CBR_56000
		.elseif eax == 11
			mov		dcb.BaudRate,CBR_57600
		.elseif eax == 12
			mov		dcb.BaudRate,CBR_115200
		.elseif eax == 13	
			mov		dcb.BaudRate,CBR_128000
		.elseif eax == 14
			mov		dcb.BaudRate,CBR_256000
		.endif
			
		; set parity
		;~~~~~~~~~~~
		mov		dcb.Parity,ODDPARITY
		
		; set stop-bits
		;~~~~~~~~~~~~~~
		mov		dcb.StopBits,ONESTOPBIT
		
		; set bits in one byte
		;~~~~~~~~~~~~~~~~~~~~~
		mov		dcb.ByteSize,8
		
		; set new DCB
		;~~~~~~~~~~~~
		invoke	SetCommState,hCOM,addr dcb

		; get & set timeouts
		;~~~~~~~~~~~~~~~~~~~				
		invoke	GetCommTimeouts,hCOM,addr cto
		mov		cto.ReadIntervalTimeout,20
		mov		cto.WriteTotalTimeoutMultiplier,10
		mov		cto.WriteTotalTimeoutConstant,2000
		invoke	SetCommTimeouts,hCOM,addr cto

		mov		eax,TRUE
		
	.else
	
		invoke	MessageBox,hdlg,addr errOpenPort,errTitle,MB_OK
		xor		eax,eax
	
	.endif
	
	ret

OpenPort endp

;-------------------------------------------------------------
; Thread Procedure
;
; wait and read data from input port
;-------------------------------------------------------------

ThreadProc proc uses ebx esi edi lpParam:DWORD

LOCAL	ComStat:COMSTAT
LOCAL	EventMask:DWORD
LOCAL	ErrorMask:DWORD

	invoke	OpenPort
	invoke	SetCommMask,hCOM,EV_RXCHAR
	invoke	CreateEvent,0,TRUE,FALSE,0
	mov		ovr.hEvent,eax

	.while	ThreadOn != 0
		
		mov		EventMask,0
		invoke	WaitCommEvent,hCOM,addr EventMask,addr ovr
		.if eax==0
			invoke	GetLastError
			.if eax==ERROR_IO_PENDING
				invoke	WaitForSingleObject,ovr.hEvent,INFINITE
				invoke	Sleep,50
			.endif
		.endif
		invoke	ClearCommError,hCOM,addr ErrorMask,addr ComStat
		dec		ComStat.cbInQue
		dec		ComStat.cbInQue
		invoke	ReadFile,hCOM,addr inbuf,ComStat.cbInQue,addr cGot,addr ovr
		.if cGot > 0
			invoke	SendMessage,hdlg,WM_DATA_RECEIVED,0,cGot
		.endif
		invoke	PurgeComm,hCOM,PURGE_TXABORT or PURGE_RXABORT or \
					PURGE_TXCLEAR or PURGE_RXCLEAR
		invoke	ResetEvent,ovr.hEvent
		
	.endw

	invoke	CloseHandle,ovr.hEvent
	invoke	CloseHandle,hCOM
	
	ret

ThreadProc endp

;-------------------------------------------------------------
; OnOff
;
; [in] param =0/1 (on/off thread), =2 (flip threads state)
;-------------------------------------------------------------

OnOff proc param:DWORD

	.if param == 2
		xor		Start,1
	.else
		push	param
		pop		Start
	.endif

	.if Start == 1
		
		invoke	CleanData
		invoke	ShowGroup,0
		invoke	SetDlgItemText,hdlg,IDC_DO,addr sStop
		mov		ThreadOn,1
		invoke	CreateThread,NULL,NULL,addr ThreadProc,NULL,0,addr ThreadID
		invoke	CloseHandle,eax
		
	.else
		
		invoke	ShowGroup,1
		mov		ThreadOn,0
		invoke	CloseHandle,ovr.hEvent
		invoke	CloseHandle,hCOM
		invoke	SetDlgItemText,hdlg,IDC_DO,addr sStart
		
	.endif
	
	ret
	
OnOff endp

;-------------------------------------------------------------
; ShowGroup
;
; [in] param =0 (show grp1,  hide grp2)
;            =1 (show grp2, hide grp1)
;-------------------------------------------------------------

ShowGroup proc param:DWORD

	.if param==1
		
		; hide grp1
		;~~~~~~~~~~
		xor		esi,esi
	@@:
		lea		eax,[esi+grp1_begin]
		invoke	GetDlgItem,hdlg,eax
		invoke	ShowWindow,eax,SW_HIDE
		inc		esi
		cmp		esi,grp1_count
		jb		@B
		
		; show grp2
		;~~~~~~~~~~
		xor		esi,esi
	@@:
		lea		eax,[esi+grp2_begin]
		invoke	GetDlgItem,hdlg,eax
		invoke	ShowWindow,eax,SW_SHOW
		inc		esi
		cmp		esi,grp2_count
		jb		@B
		
	.else
		
		; hide grp2
		;~~~~~~~~~~
		xor		esi,esi
	@@:
		lea		eax,[esi+grp2_begin]
		invoke	GetDlgItem,hdlg,eax
		invoke	ShowWindow,eax,SW_HIDE
		inc		esi
		cmp		esi,grp2_count
		jb		@B
		
		; show grp1
		;~~~~~~~~~~
		xor		esi,esi
	@@:
		lea		eax,[esi+grp1_begin]
		invoke	GetDlgItem,hdlg,eax
		invoke	ShowWindow,eax,SW_SHOW
		inc		esi
		cmp		esi,grp1_count
		jb		@B
		
	.endif
	
	ret

ShowGroup endp

;-------------------------------------------------------------
; CleanData
;
; Clean WinText on statics
;-------------------------------------------------------------

CleanData proc
	
	lea		ebx,[ibuf+6]
	invoke	SetDlgItemText,hdlg,IDC_WORD1,ebx
	invoke	SetDlgItemText,hdlg,IDC_WORD2,ebx
	invoke	SetDlgItemText,hdlg,IDC_WORD3,ebx
	invoke	SetDlgItemText,hdlg,IDC_N,ebx
		
	ret

CleanData endp

end start

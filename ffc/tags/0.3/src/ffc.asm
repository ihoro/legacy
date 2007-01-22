comment `#####################################################
#
#  ffc.asm    01.11.05 by fnt0m32 'at' gmail.com
#
#  FF Catcher v0.3
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
		
		; init data edit
		;~~~~~~~~~~~~~~~
		invoke	CreateFontIndirect,addr logfont
		mov		hFont,eax
		invoke	SendDlgItemMessage,hwnd,IDC_DATA,WM_SETFONT,hFont,TRUE
		
		; init FF edit
		;~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_FF,EM_SETLIMITTEXT,2,0
		invoke	SendDlgItemMessage,hwnd,IDC_FF,WM_SETFONT,hFont,TRUE
		
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
		
		; init Parity ComboBox
		;~~~~~~~~~~~~~~~~~~~~~
		lea		esi,sParity1
		mov		ecx,parity_count
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_PARITY,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+6]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_PARITY,CB_SETCURSEL,0,0
		
		; init Stop-bits ComboBox
		;~~~~~~~~~~~~~~~~~~~~~~~~
		lea		esi,sStopBits1
		mov		ecx,stopbits_count
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_STOPBITS,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+4]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_STOPBITS,CB_SETCURSEL,0,0
		
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
		cmp		bx,word ptr pID
		jnz		lup
		shr		ebx,8
		cmp		bh,10h
		je		lup
			
			; convert 0x1010 to 0x10
			;~~~~~~~~~~~~~~~~~~~~~~~
			lea		edi,buf
			mov		al,10h
			stosb
			mov		al,byte ptr pID
			stosb
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
			stosb
			cmp		ax,1003h
			jne		clup
		end_clup:
			
			;----------------------------------
			; output data
			;----------------------------------
			
			lea		esi,buf
			lea		edi,viewbuf
			lea		ebx,HexTable
			
			; 10FF
			;~~~~~
			lodsb
			shl		ax,8
			lodsb
			push	ax
			xchg	ah,al
			invoke	Bin2Hex
			pop		ax
			invoke	Bin2Hex
			invoke	DSpace
			
			; NN
			;~~~
			lodsb
			invoke	Bin2Hex
			invoke	DSpace
			
			; out other
			;~~~~~~~~~~
		@@:
			lodsb
			shl		ax,8
			lodsb
			push	ax
			xchg	ah,al
			invoke	Bin2Hex
			pop		ax
			push	ax
			invoke	Bin2Hex
			pop		ax
			cmp		ax,1003h
			je		@F
			invoke	DSpace
			jmp		@B
		@@:
			xor		al,al
			stosb
			
			invoke	SetDlgItemText,hwnd,IDC_DATA,addr viewbuf
			
	end_lup:
		
	;-------------------------
	; WM_CLOSE
	;-------------------------

	.elseif eax==WM_CLOSE
		
		invoke	OnOff,0
		invoke	DeleteObject,hFont
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
		invoke	SendDlgItemMessage,hdlg,IDC_PARITY,CB_GETCURSEL,0,0
		.if		eax == 0
			mov		dcb.Parity,NOPARITY
		.elseif eax == 1
			mov		dcb.Parity,EVENPARITY
		.elseif eax == 2
			mov		dcb.Parity,MARKPARITY
		.elseif eax == 3
			mov		dcb.Parity,ODDPARITY
		.elseif eax == 4
			mov		dcb.Parity,SPACEPARITY
		.endif
		
		; set stop-bits
		;~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hdlg,IDC_STOPBITS,CB_GETCURSEL,0,0
		.if		eax == 0
			mov		dcb.StopBits,ONESTOPBIT
		.elseif eax == 1
			mov		dcb.StopBits,ONE5STOPBITS
		.elseif eax == 2
			mov		dcb.StopBits,TWOSTOPBITS
		.endif
		
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
	
	; get FF
	;~~~~~~~
	invoke	GetDlgItemText,hdlg,IDC_FF,addr ffbuf,3
	mov		ax,word ptr ffbuf
	sub		ax,3030h
	cmp		al,09h
	jbe		@F
	sub		al,11h
	cmp		al,05h
	ja		no_al
	add		al,0Ah
	jmp		@F
no_al:
	xor		al,al
@@:
	xchg	ah,al
	cmp		al,09h
	jbe		@F
	sub		al,11h
	cmp		al,05h
	ja		no_ah
	add		al,0Ah
	jmp		@F
no_ah:
	xor		al,al
@@:
	shl		ah,4
	or		al,ah
	mov		pID,al
	
	; open port
	;~~~~~~~~~~
	invoke	OpenPort
	invoke	SetCommMask,hCOM,EV_RXCHAR
	invoke	CreateEvent,0,TRUE,FALSE,0
	mov		ovr.hEvent,eax

	; work
	;~~~~~
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
		invoke	SetDlgItemText,hdlg,IDC_DO,addr sStop
		mov		ThreadOn,1
		invoke	CreateThread,NULL,NULL,addr ThreadProc,NULL,0,addr ThreadID
		invoke	CloseHandle,eax
		
	.else
		
		mov		ThreadOn,0
		invoke	CloseHandle,ovr.hEvent
		invoke	CloseHandle,hCOM
		invoke	SetDlgItemText,hdlg,IDC_DO,addr sStart
		
	.endif
	
	ret
	
OnOff endp

;-------------------------------------------------------------
; CleanData
;
; Clean WinText on statics
;-------------------------------------------------------------

CleanData proc
	
	lea		ebx,[ibuf+6]
	invoke	SetDlgItemText,hdlg,IDC_DATA,ebx
	
	ret

CleanData endp

;-------------------------------------------------------------
; Bin2Hex
;-------------------------------------------------------------

Bin2Hex proc
	
	xor		ah,ah		; ax = 00 AB
	shl		ax,4		; ax = 0A B0
	shr		al,4		; ax = 0A 0B
	xlat				; ax = 0A 42		// 42 = 'B'
	xchg	ah,al		; ax = 42 0A
	xlat				; ax = 42 41		// 41 = 'A'
	stosb
	xchg	ah,al
	stosb
	
	ret

Bin2Hex endp

DSpace proc
	
	mov		al,' '
	stosb
	
	ret

DSpace endp

end start

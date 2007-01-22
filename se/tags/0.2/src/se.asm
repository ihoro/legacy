comment `#####################################################
#
#  se.asm    03.07.05 by fnt0m32 'at' gmail.com
#
#  Script Executor v0.2
#
#  Used [MASM32 v8.2]  Tested on Windows 98/2kSP4/XPSP2
#
##############################################################
#
#  Script File
#
#    Each line includes one of these formats:
#
#    1) Full-Full:
#      xxx.xxx-xxx.xxx<SP>yyy.yyy-yyy.yyy<SP>zzz<CR><LF>
#
#    2) Short-Full/Full-Short:
#      xxx.xxx<SP>yyy.yyy-yyy.yyy<SP>zzz<CR><LF>
#      xxx.xxx-xxx.xxx<SP>yyy.yyy<SP>zzz<CR><LF>
#
#    3) Short-Short:
#      xxx.xxx<SP>yyy.yyy<SP>zzz<CR><LF>
#
#    xxx.xxx - Course > 0  , degrees   (float)
#    yyy.yyy - Speed  > 0  , knots     (float)
#    zzz     - Time   > 0  , seconds   (int)
#
#    <SP>    - 0x20 (space)
#    <CR>    - 0x0D \
#                    -> imperative end of each line !
#    <LF>    - 0x0A /
#
##############################################################`

.386
.model flat,stdcall
option casemap:none

;-------------------------------------------------------------
; inc,lib,data,data?,const,equ
;-------------------------------------------------------------

include se.inc

;-------------------------------------------------------------
; ENTRY POINT
;-------------------------------------------------------------

.code

start:
	invoke	InitCommonControls

	invoke	GetModuleHandle,NULL
	mov		hInstance,eax
	
	invoke	DialogBoxParam,hInstance,IDD_DLG,NULL,DlgProc,NULL
	
	invoke	ExitProcess,eax
	
;-------------------------------------------------------------
; Dialog Procedure
;-------------------------------------------------------------
	
DlgProc proc uses ebx esi edi hwnd:DWORD,msg:UINT,wParam:WPARAM,lParam:LPARAM
	
	mov		eax,msg
	
	;-------------------------
	; WM_INITDIALOG
	;-------------------------
	
	.if msg==WM_INITDIALOG
	
		push	hwnd
		pop		hdlg
		
		; set titles
		;~~~~~~~~~~~
		invoke	SendMessage,hwnd,WM_SETTEXT,0,addr sAbout0
		invoke	SetDlgItemText,hwnd,IDC_START,addr sStart
		invoke	SetDlgItemText,hwnd,IDC_PAUSE,addr sPause
		
		; set icon
		;~~~~~~~~~
		invoke	LoadIcon,hInstance,2000
		mov		hIcon,eax
		invoke	SendMessage,hwnd,WM_SETICON,ICON_BIG,hIcon
		
		; set state of setup controls
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		mov		ebx,TRUE
		call	EnableSetup
		
		; init Port ComboBox
		;~~~~~~~~~~~~~~~~~~~~
		lea		esi,sCOM1
		mov		ecx,4
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
		mov		ecx,15
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_SPEED,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+7]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_SPEED,CB_SETCURSEL,8,0
		
		; init Parity ComboBox
		;~~~~~~~~~~~~~~~~~~~~~
		lea		esi,sParity1
		mov		ecx,5
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
		mov		ecx,3
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_STOPBITS,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+4]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_STOPBITS,CB_SETCURSEL,0,0
		
		; init ofn
		;~~~~~~~~~
		mov		ofn.lStructSize,sizeof ofn		;size
		push	hwnd
		pop		ofn.hwndOwner					;hwnd
		push	hInstance
		pop		ofn.hInstance					;instance
		mov		ofn.lpstrFilter,offset ofnFilter;filter
		mov		byte ptr fbuf,0					;first byte must be NULL
		mov		ofn.lpstrFile,offset fbuf		;buf 4 filename
		mov		ofn.nMaxFile,FileNameSize		;size of buf
		mov		ofn.lpstrTitle,offset ofnTitle	;text on title bar
		mov		ofn.Flags, \					;flags
					OFN_EXPLORER or \
					OFN_FILEMUSTEXIST or \
					OFN_LONGNAMES or \
					OFN_PATHMUSTEXIST
					
	;-------------------------
	; WM_COMMAND
	;-------------------------
		
	.elseif msg==WM_COMMAND
	
		mov		eax,wParam
		
		; OPEN button
		;~~~~~~~~~~~~
		.if ax==IDC_OPEN
		
			invoke	GetOpenFileName,addr ofn
			.if eax==TRUE
				mov		eax,offset fbuf
				movzx	edx,ofn.nFileOffset
				add		eax,edx
				invoke	SendDlgItemMessage,hwnd,IDC_FN,WM_SETTEXT,0,eax
				invoke	GetDlgItem,hwnd,IDC_START
				invoke	EnableWindow,eax,TRUE
				invoke	SetDlgItemText,hwnd,IDC_START,addr sStart
				mov		Start,0
				invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sReady
				invoke	KillTimer,hwnd,IDT_TIMER
				call	CloseHandles
			.endif
		
		; START button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_START
			
			.if Start == 0
				.if eout == 1
					call	OpenPort
					.if eax == FALSE
						mov		hMapFile,1
						call	CloseHandles
						jmp		end_proc
					.endif
				.endif
				mov		Start,1
				invoke	SetDlgItemText,hwnd,IDC_START,addr sStop
				invoke	GetDlgItem,hwnd,IDC_OUT
				invoke	EnableWindow,eax,FALSE
			.else
				mov		Start,0
				invoke	SetDlgItemText,hwnd,IDC_START,addr sStart
				invoke	SetDlgItemText,hwnd,IDC_PAUSE,addr sPause
				invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sReady
				invoke	KillTimer,hwnd,IDT_TIMER
				call	CloseHandles
				invoke	GetDlgItem,hwnd,IDC_PAUSE
				invoke	EnableWindow,eax,FALSE
				invoke	GetDlgItem,hwnd,IDC_OUT
				invoke	EnableWindow,eax,TRUE
				jmp		end_proc
			.endif
			
			.if hMapFile != 0
				invoke	KillTimer,hwnd,IDT_TIMER
				call	CloseHandles
			.endif
			
			invoke	CreateFile, \
						addr fbuf, \
						GENERIC_READ, \
						0, \
						NULL, \
						OPEN_EXISTING, \
						FILE_ATTRIBUTE_ARCHIVE, \
						NULL			
			.if eax==INVALID_HANDLE_VALUE
				invoke	MessageBox,hwnd,addr errOpenFile,addr errTitle,MB_OK or MB_ICONERROR
				jmp		end_proc
			.endif
			mov		hFile,eax
			
			invoke	GetFileSize,hFile,NULL
			mov		FileSize,eax
			
			invoke	CreateFileMapping,hFile,NULL,PAGE_READONLY,0,0,0
			.if eax==NULL
				invoke	MessageBox,hwnd,addr errCreateFMO,addr errTitle,MB_OK or MB_ICONERROR
				jmp		end_proc
			.endif
			mov		hMapFile,eax
			
			invoke	MapViewOfFile,hMapFile,FILE_MAP_READ,0,0,0
			.if eax==NULL
				invoke	MessageBox,hwnd,addr errMapView,addr errTitle,MB_OK or MB_ICONERROR
				jmp		end_proc
			.endif
			mov		pMemory,eax
			
			mov		pData,eax
			xor		eax,eax
			mov		t0,eax
			mov		AllTime,eax
			lea		edi,Distance
			mov		dword ptr [edi],eax
			mov		dword ptr [edi+4],eax
			invoke	GetDlgItem,hwnd,IDC_PAUSE
			invoke	EnableWindow,eax,TRUE
			mov		Pause,0
			invoke	SetDlgItemText,hwnd,IDC_PAUSE,addr sPause
			invoke	SetTimer,hwnd,IDT_TIMER,tmrInterval,addr TimerProc
			invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sDoing
		
		; PAUSE button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_PAUSE
		
			.if Pause == 0
				mov		Pause,1
				invoke	KillTimer,hwnd,IDT_TIMER
				invoke	SetDlgItemText,hwnd,IDC_PAUSE,addr sContinue
				invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sPause
			.elseif
				mov		Pause,0
				invoke	SetTimer,hwnd,IDT_TIMER,tmrInterval,addr TimerProc
				invoke	SetDlgItemText,hwnd,IDC_PAUSE,addr sPause
				invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sDoing
			.endif
			
		; ABOUT button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_ABOUT
			
			invoke	ShellAbout,hwnd,addr sAbout0,addr sAbout1,hIcon
			
		; HELP button
		;~~~~~~~~~~~~
		.elseif ax==IDC_HELPP
		
			invoke	MessageBox,hwnd,addr sHelp,addr sHelpTitle,MB_OK or MB_ICONINFORMATION
		
		; EXIT button
		;~~~~~~~~~~~~
		.elseif ax==IDC_EXIT
			
			invoke	SendMessage,hwnd,WM_CLOSE,0,0
			
		; OUT checkbox
		;~~~~~~~~~~~~~
		.elseif ax==IDC_OUT
			
			invoke	SendDlgItemMessage,hwnd,IDC_OUT,BM_GETCHECK,0,0
			.if eax == BST_CHECKED
				mov		ebx,TRUE	;TRUE
				mov		eout,1
			.else
				xor		ebx,ebx		;FALSE
				mov		eout,0
			.endif
			call	EnableSetup
			
		.endif
		
	;-------------------------
	; WM_CLOSE
	;-------------------------
	
	.elseif msg==WM_CLOSE
		
		invoke	KillTimer,hwnd,IDT_TIMER
		call	CloseHandles
		invoke	EndDialog,hwnd,NULL
		
	.else
		
		xor		eax,eax
		ret
		
	.endif

end_proc:
	
	mov		eax,TRUE
	ret

DlgProc endp

;-------------------------------------------------------------
; Close Handles procedure
;-------------------------------------------------------------

CloseHandles proc
	
	.if hMapFile != 0
		invoke	CloseHandle,hCOM
		invoke	UnmapViewOfFile,pMemory
		invoke	CloseHandle,hMapFile
		mov		hMapFile,0
		invoke	CloseHandle,hFile
	.endif
	ret

CloseHandles endp

;-------------------------------------------------------------
; Get Params from one line of file
;
; [out] eax = 0 -> OK  eax = 1 -> Failed
;-------------------------------------------------------------

GetParams proc uses esi edi ebx

LOCAL	pOld:DWORD
LOCAL	x1:DWORD
LOCAL	x2:DWORD

	.if FileSize == 0
		mov		eax,1
		jmp		exit
	.endif

	push	pData
	pop		pOld
	lea		eax,k1
	mov		x1,eax
	lea		eax,k2
	mov		x2,eax
	mov		ah,0				;first step!

get_it:

	cld
	
	; find MainSep
	mov		edi,pData
	mov		al,SeparatorMain
	mov		ecx,21
	repne scasb
	lea		edx,[edi-1]
	
	; find SubSep
	mov		edi,pData
	mov		ecx,edx
	sub		ecx,edi
	mov		al,SeparatorSub
	repne scasb
	jne		no_sub_sep			;jmp if no SubSep
	
	; load FFF-???
	lea		ebx,[edi-1]
	mov		esi,pData
	mov		ecx,ebx
	sub		ecx,esi
	lea		edi,buf
	rep movsb
	mov		byte ptr [edi],0
	push	edx
	push	ebx
	push	eax
	invoke	StrToFloat,addr buf,x1
	pop		eax
	pop		ebx
	pop		edx
	
	; load ???-FFF
	lea		esi,[ebx+1]
	lea		edi,buf
	mov		ecx,edx
	sub		ecx,esi
	rep movsb
	mov		byte ptr [edi],0
	push	edx
	push	eax
	invoke	StrToFloat,addr buf,x2
	pop		eax
	pop		edx
	jmp		next_step

no_sub_sep:

	; load only FFF
	mov		esi,pData
	lea		edi,buf
	mov		ecx,edx
	sub		ecx,esi
	rep movsb
	mov		byte ptr [edi],0
	push	edx
	push	eax
	invoke	StrToFloat,addr buf,x1
	pop		eax
	pop		edx
	mov		esi,x1
	mov		edi,x2
	push	dword ptr [esi]
	pop		dword ptr [edi]
	push	dword ptr [esi+4]
	pop		dword ptr [edi+4]

next_step:

	; do second step or last
	;~~~~~~~~~~~~~~~~~~~~~~~
	inc		edx
	mov		pData,edx
	.if ah == 0
		lea		eax,s1
		mov		x1,eax
		lea		eax,s2
		mov		x2,eax
		mov		ah,1			;second step!
		jmp		get_it
	.endif
	
	; do last step
	;~~~~~~~~~~~~~
	mov		edi,edx
	mov		al,0dh
	mov		ecx,10
	repne scasb
	; may be error if not found 0dh
	mov		esi,edx
	lea		ebx,[edi-1]
	mov		ecx,ebx
	sub		ecx,esi
	inc		edi
	mov		pData,edi
	lea		edi,buf
	rep movsb
	mov		byte ptr [edi],0
	invoke	atodw,addr buf
	mov		t0,eax
	dec		eax
	mov		x1,eax				;x1 = t0-1

	; decrease file size
	;~~~~~~~~~~~~~~~~~~~
	mov		eax,pData
	sub		eax,pOld			
	mov		edx,FileSize
	sub		edx,eax
	mov		FileSize,edx
	
	; calc dx
	;~~~~~~~~
	finit
	
	; k2 = (k2-k1) / (t0-1)		;x1 = t0-1
	fld		k2
	fld		k1
	fsub
	fild	x1
	fdiv
	fstp	k2
	
	; s2 = (s2-s1)/ (t0-1)		;x1 = t0-1
	fld		s2
	fld		s1
	fsub
	fild	x1
	fdiv
	fstp	s2
	
	xor		eax,eax

exit:

	ret

GetParams endp

;-------------------------------------------------------------
; Timer Procedure
;-------------------------------------------------------------

TimerProc proc uses esi edi ebx hwnd:DWORD,msg:UINT,idEvent:DWORD,dwTime:DWORD

	xor		eax,eax

	;------------------------
	; if time=0 get next data
	;------------------------

	.if t0 == 0
		call	GetParams
	.endif
	
	;------------------------
	; if end of file
	;------------------------
	
	.if eax != 0
		invoke	GetDlgItem,hwnd,IDC_PAUSE
		invoke	EnableWindow,eax,FALSE
		invoke	GetDlgItem,hwnd,IDC_OUT
		invoke	EnableWindow,eax,TRUE
		invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sDone
		invoke	SetDlgItemText,hwnd,IDC_START,addr sStart
		invoke	KillTimer,hwnd,IDT_TIMER
		call	CloseHandles
		mov		Start,0
		jmp		exit
	.endif
	
	;------------------------
	; output params to port
	;------------------------
	
	;------------------------
	; create format #1
	;------------------------
		
	cld
	mov		ecx,7
	lea		esi,sFormat1_0
	lea		edi,frmbuf
	rep movsb
	mov		ebx,edi
	
		; get course as SZ
		;~~~~~~~~~~~~~~~~~
		invoke	FloatToStr2,k1,addr buf
		lea		edi,buf
		mov		ecx,20
		mov		al,'.'
		repne scasb
		jne		@F
		mov		byte ptr [edi+Epsilon],0
	@@:
		lea		edi,buf
		mov		ecx,20
		xor		al,al
		repne scasb
		lea		esi,buf
		mov		ecx,edi
		sub		ecx,esi
		lea		eax,[ecx-1]
		lea		edi,szK
		rep movsb
	
	lea		esi,szK
	mov		edi,ebx
	mov		ecx,eax
	rep movsb
	lea		esi,sFormat1_1
	mov		ecx,9
	rep movsb
	mov		ebx,edi
	
		; get speed as SZ
		;~~~~~~~~~~~~~~~~
		invoke	FloatToStr2,s1,addr buf
		lea		edi,buf
		mov		ecx,20
		mov		al,'.'
		repne scasb
		jne		@F
		mov		byte ptr [edi+Epsilon],0
	@@:
		lea		edi,buf
		mov		ecx,20
		xor		al,al
		repne scasb
		lea		esi,buf
		mov		ecx,edi
		sub		ecx,esi
		lea		eax,[ecx-1]
		lea		edi,szS
		rep movsb
	
	lea		esi,szS
	mov		edi,ebx
	mov		ecx,eax
	rep movsb
	lea		esi,sFormat1_2
	mov		ecx,3
	rep movsb
	mov		ebx,edi
	
		; get mps as SZ
		;~~~~~~~~~~~~~~
		finit
		fld		s1
		fld		KnotsToMetres
		fmul
		fst		tt0
		invoke	FloatToStr2,tt0,addr buf
		lea		edi,buf
		mov		ecx,20
		mov		al,'.'
		repne scasb
		jne		@F
		mov		byte ptr [edi+Epsilon],0
	@@:
		lea		edi,buf
		mov		ecx,20
		xor		al,al
		repne scasb
		lea		esi,buf
		mov		ecx,edi
		sub		ecx,esi
		lea		edi,szMPS
		rep movsb
		
		; get kmps as SZ
		;~~~~~~~~~~~~~~~
		fld		MetresToKilometres
		fmul
		fstp	tt1
		invoke	FloatToStr2,tt1,addr buf
		
	lea		edi,buf
	mov		ecx,20
	mov		al,'.'
	repne scasb
	jne		@F
	mov		byte ptr [edi+Epsilon],0
@@:
	lea		edi,buf
	mov		ecx,20
	xor		al,al
	repne scasb
	lea		ecx,[edi-1]
	lea		esi,buf
	sub		ecx,esi
	mov		edi,ebx
	rep movsb
	lea		esi,sFormat1_3
	mov		ecx,3
	rep movsb
	
	call	CalcCRC
	
	mov		byte ptr [edi],ah
	mov		byte ptr [edi+1],al
	mov		byte ptr [edi+2],0dh
	mov		byte ptr [edi+3],0ah
	
	lea		edi,[edi+4]
	lea		esi,frmbuf
	sub		edi,esi
	
	; output format #1
	;~~~~~~~~~~~~~~~~~
	.if eout == 1
		invoke	WriteFile,hCOM,addr frmbuf,edi,addr cGot,addr ovr
	.endif
	
	
	;------------------------
	; create format #2
	;------------------------
	
	lea		esi,sFormat2_0
	lea		edi,frmbuf
	mov		ecx,7
	rep movsb
	mov		ebx,edi
	
	lea		edi,szS
	mov		ecx,10
	xor		al,al
	repne scasb
	lea		ecx,[edi-1]
	lea		esi,szS
	sub		ecx,esi
	mov		edi,ebx
	rep movsb
	
	lea		esi,sFormat2_1
	mov		ecx,3
	rep movsb
	mov		ebx,edi
	
	lea		edi,szMPS
	mov		ecx,10
	xor		al,al
	repne scasb
	lea		ecx,[edi-1]
	lea		esi,szMPS
	sub		ecx,esi
	mov		edi,ebx
	rep movsb
	
	lea		esi,sFormat2_2
	mov		ecx,3
	rep movsb
	
	call	CalcCRC
	
	mov		byte ptr [edi],ah
	mov		byte ptr [edi+1],al
	mov		byte ptr [edi+2],0dh
	mov		byte ptr [edi+3],0ah
	
	lea		edi,[edi+4]
	lea		esi,frmbuf
	sub		edi,esi
	
	; output format #2
	;~~~~~~~~~~~~~~~~~
	.if eout == 1
		invoke	WriteFile,hCOM,addr frmbuf,edi,addr cGot,addr ovr
	.endif


	;------------------------
	; output params to window
	;------------------------
	
	; set course
	invoke	SetDlgItemText,hwnd,IDC_K,addr szK
	
	; set speed
	invoke	SetDlgItemText,hwnd,IDC_S,addr szS
	
	; set distance
	finit
	fld		tt0			;mps
	fld		Distance
	fadd
	fstp	Distance
	invoke	FloatToStr2,Distance,addr buf
	lea		edi,buf
	mov		ecx,20
	mov		al,'.'
	repne scasb
	mov		byte ptr [edi+Epsilon],0
	invoke	SetDlgItemText,hwnd,IDC_D,addr buf
	
	; set all time
	add		AllTime,1
	invoke	SetDlgItemInt,hwnd,IDC_T,AllTime,FALSE

	;------------------------
	; change params
	;------------------------
	
	; t0 = t0 - 1
	sub		t0,1
	
	.if t0 == 0
		jmp		exit
	.endif	

	finit
	
	; k1 = k1 + k2
	fld		k1
	fld		k2
	fadd
	fstp	k1
	
	; s1 = s1 + s2
	fld		s1
	fld		s2
	fadd
	fstp	s1

exit:

	ret

TimerProc endp

;-------------------------------------------------------------
; Open & Init COM-port
;
; [out] eax = TRUE/FALSE (OK/Failed)
;-------------------------------------------------------------

OpenPort proc

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
				FILE_SHARE_READ or FILE_SHARE_WRITE, \
				NULL, \
				OPEN_EXISTING, \
				FILE_FLAG_OVERLAPPED, \
				NULL
				
	.if eax != INVALID_HANDLE_VALUE
	
		mov		hCOM,eax
		
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
		mov		cto.ReadIntervalTimeout,MAXDWORD
		mov		cto.ReadTotalTimeoutMultiplier,0
		mov		cto.ReadTotalTimeoutConstant,0
		mov		cto.WriteTotalTimeoutMultiplier,0
		mov		cto.WriteTotalTimeoutConstant,0
		invoke	SetCommTimeouts,hCOM,addr cto

		; init OVERLAPPED struct
		;~~~~~~~~~~~~~~~~~~~~~~~
		invoke	CreateEvent,0,TRUE,FALSE,0
		mov		ovr.hEvent,eax
		
		mov		eax,TRUE
		
	.else
	
		invoke	MessageBox,hdlg,addr errOpenPort,errTitle,MB_OK
		xor		eax,eax
	
	.endif
	
	ret

OpenPort endp

;-------------------------------------------------------------
; Enable/Disable setup port controls
;
; [in] ebx = TRUE/FALSE
;-------------------------------------------------------------

EnableSetup proc

	.if ebx == TRUE
		invoke	SendDlgItemMessage,hdlg,IDC_OUT,BM_SETCHECK,BST_CHECKED,0
	.else
		invoke	SendDlgItemMessage,hdlg,IDC_OUT,BM_SETCHECK,BST_UNCHECKED,0
	.endif
	invoke	GetDlgItem,hdlg,IDC_PORT
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_SPEED
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_PARITY
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_STOPBITS
	invoke	EnableWindow,eax,ebx
	ret

EnableSetup endp

;-------------------------------------------------------------
; Calculate CRC
;
; [in] edi = offset of next char after '*'
; [out] ah = HiAsciiHex(CRC) al = LowAsciiHex(CRC)
;
; i.e ah=41h al=35h -> ASCII(CRC) = 'A5' (A5h)
;-------------------------------------------------------------

CalcCRC proc uses edi
	
	lea		esi,frmbuf+1
	lea		ecx,[edi-2]
	sub		ecx,esi
	lodsb
	mov		ah,al
	
@@:
	lodsb
	xor		ah,al
	loop	@B
	
	lea		ebx,hexTable
	mov		al,ah
	shr		al,4
	xlat
	xchg	ah,al
	and		al,0fh
	xlat
	
	ret

CalcCRC endp

end start
comment `#####################################################
#
#  se.asm    04.08.05 by fnt0m32 'at' gmail.com
#
#  Script Executor v0.4 (demo version)
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
	
	.if eax==WM_INITDIALOG
		
		push	hwnd
		pop		hdlg
		
		mov		ThreadOn,0
		
		; init IfOut & CheckBoxes
		;~~~~~~~~~~~~~~~~~~~~~~~~
		mov		IfOut,1
		invoke	SendDlgItemMessage,hwnd,IDC_IFOUT1,BM_SETCHECK,BST_CHECKED,0
		invoke	SendDlgItemMessage,hwnd,IDC_IFOUT2,BM_SETCHECK,BST_CHECKED,0
		
		; set titles
		;~~~~~~~~~~~
		invoke	SendMessage,hwnd,WM_SETTEXT,0,addr sAbout0
		invoke	SetDlgItemText,hwnd,IDC_START,addr sStart
		
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
		invoke	SendDlgItemMessage,hwnd,IDC_PORT2,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+5]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_PORT,CB_SETCURSEL,0,0
		invoke	SendDlgItemMessage,hwnd,IDC_PORT2,CB_SETCURSEL,1,0
		
		; init Speed ComboBox
		;~~~~~~~~~~~~~~~~~~~~
		lea		esi,sBPS1
		mov		ecx,speed_count
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_SPEED,CB_ADDSTRING,0,esi
		invoke	SendDlgItemMessage,hwnd,IDC_SPEED2,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+7]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_SPEED,CB_SETCURSEL,speed_default,0
		invoke	SendDlgItemMessage,hwnd,IDC_SPEED2,CB_SETCURSEL,speed_default,0
		
		; init Parity ComboBox
		;~~~~~~~~~~~~~~~~~~~~~
		lea		esi,sParity1
		mov		ecx,parity_count
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_PARITY,CB_ADDSTRING,0,esi
		invoke	SendDlgItemMessage,hwnd,IDC_PARITY2,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+6]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_PARITY,CB_SETCURSEL,0,0
		invoke	SendDlgItemMessage,hwnd,IDC_PARITY2,CB_SETCURSEL,0,0
		
		; init Stop-bits ComboBox
		;~~~~~~~~~~~~~~~~~~~~~~~~
		lea		esi,sStopBits1
		mov		ecx,stopbits_count
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_STOPBITS,CB_ADDSTRING,0,esi
		invoke	SendDlgItemMessage,hwnd,IDC_STOPBITS2,CB_ADDSTRING,0,esi
		pop		ecx
		lea		esi,[esi+4]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_STOPBITS,CB_SETCURSEL,0,0
		invoke	SendDlgItemMessage,hwnd,IDC_STOPBITS2,CB_SETCURSEL,0,0
		
		; init ofn
		;~~~~~~~~~
		mov		ofn.lStructSize,sizeof ofn		;size
		push	hwnd
		pop		ofn.hwndOwner					;hwnd
		push	hInstance
		pop		ofn.hInstance					;instance
		mov		ofn.lpstrFilter,offset ofnFilter;filter
		mov		byte ptr fbuf_in,0					;first byte must be NULL
		mov		ofn.lpstrFile,offset fbuf_in	;buf 4 filename
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
		
	.elseif eax==WM_COMMAND
	
		mov		eax,wParam
		
		; OPEN button
		;~~~~~~~~~~~~
		.if ax==IDC_OPEN
		
			invoke	GetOpenFileName,addr ofn
			.if eax==TRUE 
			
				lea		esi,fbuf_in
				lea		edi,fbuf_out
				push	edi
				xor		ecx,ecx
				cld
				
			@@:
				lodsb
				stosb
				inc		ecx
				or		al,al
				jnz		@B
				
				dec		ecx
				mov		edx,ecx
				pop		edi
				lea		edi,[edi+ecx-1]
				push	edi
				
				mov		al,'\'
				std
				repne scasb
				mov		esi,edi
				
				pop		edi
				mov		ecx,edx
				mov		al,'.'
				std
				repne scasb
				cld
				
				mov		eax,0074756Fh	; db 'out',0
				lea		ebx,fbuf_out
				cmp		esi,edi
				jb		@F
				lea		ebx,[ebx+edx]
				mov		cl,'.'
				mov		[ebx],cl
				inc		ebx
				jmp		_cont
			@@:
				lea		ebx,[edi+2]
			_cont:
			
				mov		[ebx],eax
				
				movzx	ebx,ofn.nFileOffset
								
				lea		eax,fbuf_in
				add		eax,ebx
				invoke	SendDlgItemMessage,hwnd,IDC_FN,WM_SETTEXT,0,eax
				
				lea		eax,fbuf_out
				add		eax,ebx
				invoke	SendDlgItemMessage,hwnd,IDC_REPORT,WM_SETTEXT,0,eax
				
				invoke	GetDlgItem,hwnd,IDC_START
				invoke	EnableWindow,eax,TRUE
				invoke	SetDlgItemText,hwnd,IDC_START,addr sStart
				mov		Start,0
				invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sReady
			.endif
		
		; START button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_START
			
			.if Start == 0
				.if IfOut==1
					invoke	OpenPort,addr hCOM_out,0,OutComBuf,OutComBuf
					invoke	CreateEvent,0,TRUE,FALSE,0
					mov		ovr_out.hEvent,eax
				.endif
				mov		Start,1
				invoke	SetDlgItemText,hwnd,IDC_START,addr sStop
				xor		ebx,ebx
				invoke	EnableSetup
				mov		tstTime,0
			.else
				invoke	JustStop
				mov		Start,0
				invoke	SetDlgItemText,hwnd,IDC_START,addr sStart
				invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sReady
				jmp		end_proc
			.endif
			
			.if IfOut==1
				invoke	CreateFile, \
							addr fbuf_out, \
							GENERIC_WRITE, \
							FILE_SHARE_READ, \
							NULL, \
							CREATE_ALWAYS, \
							FILE_ATTRIBUTE_ARCHIVE, \
							NULL
				mov		hOut,eax
			.endif
			
			invoke	CreateFile, \
						addr fbuf_in, \
						GENERIC_READ, \
						FILE_SHARE_READ, \
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
			
			.if IfOut==1
				mov		ThreadOn,1
				invoke	CreateThread,NULL,NULL,addr ThreadProc,NULL,0,addr ThreadID
				invoke	CloseHandle,eax
			.endif
			
			invoke	SetTimer,hwnd,IDT_TIMER,tmrInterval,addr TimerProc
			invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sDoing
			
		; IFOUT1 CheckBox
		;~~~~~~~~~~~~~~~~
		.elseif ax==IDC_IFOUT1
			
			invoke	SendDlgItemMessage,hwnd,IDC_IFOUT1,BM_GETCHECK,0,0
			.if eax==BST_CHECKED
				mov		IfOut,1
			.else
				mov		IfOut,0
			.endif
			invoke	SendDlgItemMessage,hwnd,IDC_IFOUT2,BM_SETCHECK,eax,0
			
		; IFOUT2 CheckBox
		;~~~~~~~~~~~~~~~~
		.elseif ax==IDC_IFOUT2
			
			invoke	SendDlgItemMessage,hwnd,IDC_IFOUT2,BM_GETCHECK,0,0
			.if eax==BST_CHECKED
				mov		IfOut,1
			.else
				mov		IfOut,0
			.endif
			invoke	SendDlgItemMessage,hwnd,IDC_IFOUT1,BM_SETCHECK,eax,0
			
		; ABOUT button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_ABOUT
			
			invoke	ShellAbout,hwnd,addr sAbout0,addr sAbout1,hIcon
			
		; HELP button
		;~~~~~~~~~~~~
		.elseif ax==IDC_HELPP
			
			invoke	MessageBox,hwnd,addr sHelp,addr sHelpTitle,MB_OK or MB_ICONINFORMATION
			invoke	MessageBox,hwnd,addr sHelp2,addr sHelpTitle,MB_OK or MB_ICONINFORMATION
			
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
		
		; looking for RMC
		;~~~~~~~~~~~~~~~~
		lea		edi,inbuf
		mov		ecx,lParam
		mov		bx,4D52h	; db 'MR'
		mov		al,'$'
		
	search:
		repne scasb
		je		@F
		jmp		end_proc
	@@:
		cmp		word ptr [edi+2],bx
		jne		search
		
		; check flag A/V
		;~~~~~~~~~~~~~~~
		mov		al,'V'
		cmp		[edi+17],al
		jne		@F
		jmp		end_proc
	@@:
			
		; if not first time check new time
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		.if FirstTime != 1	
			lea		esi,outbuf
			mov		ax,word ptr [esi+4]
			cmp		word ptr [edi+10],ax
			jne		@F
			jmp		end_proc
		@@:	
		.endif
		
		; save new time
		;~~~~~~~~~~~~~~
		lea		esi,[edi+6]
		push	edi
		lea		edi,outbuf
		mov		ecx,11
		rep movsb			; get time as "hhmmss.sss,"
		pop		edi
		
		; get latitude and convert to radian
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		push	edi
		lea		esi,[edi+21]
		lea		edi,tempbuf
		mov		ecx,5
		rep movsb							; get last part "ll.ll"
		mov		byte ptr [edi],0
		invoke	StrToFloat,addr tempbuf,addr La	; convert "ll.ll" to double
		pop		edi
		
		push	edi
		lea		esi,[edi+19]
		lea		edi,tempbuf
		mov		ecx,2
		rep movsb							; get first part "ll"
		mov		byte ptr [edi],0
		invoke	StrToInt,addr tempbuf		; convert "ll" to integer
		mov		Deg,eax
		pop		edi
		
			; calc (Degrees+Minutes/60)*pi/180 = [radian]
			finit
			fild	Deg
			fld		La
			mov		Deg,60
			fild	Deg
			fdiv
			fadd
			fldpi
			fmul
			mov		Deg,180
			fild	Deg
			fdiv
			
			; check N/S and save
			mov		al,'S'
			cmp		byte ptr [edi+27],al
			jne		@F
			fchs
		@@:
			fstp	La
		
		; get longitude and convert to radian
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		push	edi
		lea		esi,[edi+32]
		lea		edi,tempbuf
		mov		ecx,5
		rep movsb							; get last part "yy.yy"
		mov		byte ptr [edi],0
		invoke	StrToFloat,addr tempbuf,addr Lo	; convert "yy.yy" to double
		pop		edi
		
		push	edi
		lea		esi,[edi+29]
		lea		edi,tempbuf
		mov		ecx,3
		rep movsb							; get first part "yyy"
		mov		byte ptr [edi],0
		invoke	StrToInt,addr tempbuf		; convert "yyy" to integer
		mov		Deg,eax
		pop		edi
		
			; calc (Degrees+Minutes/60)*pi/180 = [radian]
			finit
			fild	Deg
			fld		Lo
			mov		Deg,60
			fild	Deg
			fdiv
			fadd
			fldpi
			fmul
			mov		Deg,180
			fild	Deg
			fdiv
			
			; check E/W
			mov		al,'W'
			cmp		byte ptr [edi+38],al
			jne		@F
			fchs
		@@:
			fstp	Lo
		
		; if it's first time then get out
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		.if FirstTime == 1
			
			mov		FirstTime,0
			
			fld		La
			fstp	La_0
			fld		Lo
			fstp	Lo_0
			
			jmp		end_proc
			
		.endif
		
		; get my latitude/longitude by course/speed
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		finit
		fld		k1
		
		; check for k1 = 0
		;-----------------
		ftst
		fstsw	ax
		sahf
		jnz		@F
		fldz
		fstp	d_Lo
		fld		mps
		fstp	d_La
		mov		ebx,0
		jmp		get_position
		
	@@:
		; check for 0 < k1 <= 90
		;-----------------------
		mov		Deg,90
		ficom	Deg
		fstsw	ax
		sahf
			; if k1 = 90
			jnz		@F
			fld		mps
			fstp	d_Lo
			fldz
			fstp	d_La
			mov		ebx,0
			jmp		get_position
		@@:
			; if 0 < k1 < 90
			ja		@F
			fild	Deg
			fsubr
			fstp	Alpha
			mov		ebx,1
			jmp get_position
			
	@@:
		; check for 90 < k1 <= 180
		;-------------------------
		mov		Deg,180
		ficom	Deg
		fstsw	ax
		sahf
			; if k1 = 180
			jnz		@F
			fldz
			fstp	d_Lo
			fild	Deg
			fchs
			fstp	d_La
			mov		ebx,0
			jmp		get_position
		@@:
			; if 90 < k1 < 180
			ja		@F
			mov		Deg,90
			fild	Deg
			fsub
			fstp	Alpha
			mov		ebx,2
			jmp get_position
	@@:
		; check for 180 < k1 <= 270
		;--------------------------
		mov		Deg,270
		ficom	Deg
		fstsw	ax
		sahf
			; if k1 = 270
			jnz		@F
			fld		mps
			fchs
			fstp	d_Lo
			fldz
			fstp	d_La
			mov		ebx,0
			jmp		get_position
		@@:
			; if 180 < k1 < 270
			ja		@F
			mov		Deg,180
			fild	Deg
			fsub
			fstp	Alpha
			mov		ebx,3
			jmp get_position
	@@:
		; if 270 < k1 < 360
		;------------------
		fild	Deg
		fsub
		fstp	Alpha
		mov		ebx,4
		
	get_position:
		
		; get position as d_La/d_Lo
		;~~~~~~~~~~~~~~~~~~~~~~~~~~
		finit
		
		.if ebx != 0
			fld		Alpha
			fldpi
			fmul
			mov		Deg,180
			fild	Deg
			fdiv
			fsincos
			fld		mps
			fmul				; get c*cosA
			fld		mps
			fmul	st(2),st(0)	; get c*sinA
			fxch	st(2)
		.endif
		
		.if ebx == 1
			
			fstp	d_La
			fstp	d_Lo
			
		.elseif ebx == 2
			
			fchs
			fstp	d_La
			fstp	d_Lo
			
		.elseif ebx == 3
			
			fchs
			fstp	d_Lo
			fchs
			fstp	d_La
			
		.elseif ebx == 4
			
			fstp	d_La
			fchs
			fstp	d_Lo
			
		.endif
		
		; get diff_La and convert to metres
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		finit
		fld		La
		fld		La_0
		fld		d_La
		fadd
		fsub
		mov		Deg,10800		; 180*60 = 10800
		fild	Deg
		fmul
		fldpi
		fdiv
		fild	MinutesToMetres
		fmul
		fstp	diff_La
		fld		La
		fstp	La_0
		
		; get diff_Lo and convert to metres
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		fld		Lo
		fld		Lo_0
		fld		d_Lo
		fadd
		fsub
		fild	Deg				; 180*60 = 10800
		fmul
		fldpi
		fdiv
		fild	MinutesToMetres
		fmul
		fstp	diff_Lo
		fld		Lo
		fstp	Lo_0
		
		; convert diff_La/diff_Lo to SZ
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	FloatToStr2,diff_La,addr sz_diff_La
		invoke	FloatToStr2,diff_Lo,addr sz_diff_Lo
		
		
		; output diff_La to window
		;~~~~~~~~~~~~~~~~~~~~~~~~~
		lea		esi,sz_diff_La
		xor		ecx,ecx
		cld
		
	@@:
		lodsb
		inc		ecx
		cmp		al,'.'
		jne		@B
		
		mov		byte ptr [esi+Epsilon],0
		add		ecx,Epsilon
		
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_LA,WM_SETTEXT,0,addr sz_diff_La
		
		
		; output diff_Lo to window
		;~~~~~~~~~~~~~~~~~~~~~~~~~
		lea		esi,sz_diff_Lo
		xor		edx,edx
		cld
		
	@@:
		lodsb
		inc		edx
		cmp		al,'.'
		jne		@B
		
		mov		byte ptr [esi+Epsilon],0
		add		edx,Epsilon
		
		push	edx
		invoke	SendDlgItemMessage,hwnd,IDC_LO,WM_SETTEXT,0,addr sz_diff_Lo
		pop		edx
		pop		ecx
		
		; make format string for report
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		lea		ebx,[ecx+edx+13]
		mov		al,','
		lea		esi,sz_diff_La
		lea		edi,[outbuf+11]
		rep movsb
		stosb
		lea		esi,sz_diff_Lo
		mov		ecx,edx
		rep movsb
		mov		ax,0A0Dh
		mov		word ptr [edi],ax
		
		; output string to report file
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	WriteFile,hOut,addr outbuf,ebx,addr Deg,NULL
		
	;-------------------------
	; WM_CLOSE
	;-------------------------
	
	.elseif eax==WM_CLOSE
		
		invoke	JustStop
		invoke	EndDialog,hwnd,NULL
		
	.else
		
	failed:
		xor		eax,eax
		ret
		
	.endif

end_proc:
	
	mov		eax,TRUE
	ret

DlgProc endp

;-------------------------------------------------------------
; JustStop
;
; Turn off timer/thread and close all handles
;-------------------------------------------------------------

JustStop proc

	mov		ThreadOn,0
	invoke	KillTimer,hdlg,IDT_TIMER
	
	invoke	CloseHandle,hCOM_out
	invoke	CloseHandle,hCOM_in
	invoke	CloseHandle,ovr_out.hEvent
	invoke	CloseHandle,ovr_in.hEvent
	invoke	UnmapViewOfFile,pMemory
	invoke	CloseHandle,hMapFile
	mov		hMapFile,0
	invoke	CloseHandle,hFile
	invoke	CloseHandle,hOut
	
	mov		ebx,TRUE
	invoke	EnableSetup
	
	ret

JustStop endp

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

TimerProc proc uses ebx esi edi hwnd:DWORD,msg:UINT,idEvent:DWORD,dwTime:DWORD

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
		invoke	SetDlgItemText,hwnd,IDC_STATUS,addr sDone
		invoke	SetDlgItemText,hwnd,IDC_START,addr sStart
		invoke	JustStop
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
		fst		mps
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
	.if IfOut==1
		invoke	WriteFile,hCOM_out,addr frmbuf,edi,addr cGot_out,addr ovr_out
		invoke	ResetEvent,ovr_out.hEvent
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
	.if IfOut==1
		invoke	WriteFile,hCOM_out,addr frmbuf,edi,addr cGot_out,addr ovr_out
		invoke	ResetEvent,ovr_out.hEvent
		
	; output test info
	;~~~~~~~~~~~~~~~~~
		inc		tstTime
		movzx	ax,tstTime
		mov		bl,10
		div		bl
		add		ax,3030h
		mov		word ptr tstSec,ax
		invoke	WriteFile,hCOM_out,addr tstRMC,size_RMC,addr cGot_tst,addr ovr_out
		invoke	ResetEvent,ovr_out.hEvent
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
; [in] pHPort - pointer to handle (hCOM_out/hCOM_in)
; [in] Port = 0 for output port or = 1000 for input port
; [in] InBuffer - size(bytes) for input buffer
; [in] OutBuffer - size(bytes) for output buffer
;
; [out] eax = TRUE/FALSE (OK/Failed)
;-------------------------------------------------------------

OpenPort proc uses ebx esi edi pHPort:DWORD,Port:DWORD,InBuffer:DWORD,OutBuffer:DWORD

LOCAL	id_port:DWORD
LOCAL	hCOM:DWORD
LOCAL	dcb:DCB
LOCAL	cto:COMMTIMEOUTS

	; init IDs of controls
	;~~~~~~~~~~~~~~~~~~~~~
	mov		ecx,IDC_PORT
	add		ecx,Port
	mov		id_port,ecx
	mov		ebx,IDC_SPEED
	add		ebx,Port
	mov		esi,IDC_PARITY
	add		esi,Port
	mov		edi,IDC_STOPBITS
	add		edi,Port

	; get COM ID
	;~~~~~~~~~~~	
	invoke	SendDlgItemMessage,hdlg,id_port,CB_GETCURSEL,0,0
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
		
		mov		ecx,pHPort	; get address of hCOM_out(in)
		mov		[ecx],eax	; save handle
		mov		hCOM,eax	; save temporary handle
		
		invoke	PurgeComm,hCOM_in,PURGE_TXABORT or PURGE_RXABORT or \
					PURGE_TXCLEAR or PURGE_RXCLEAR
		invoke	ClearCommBreak,hCOM_in
		
		; set in/out buffer
		;~~~~~~~~~~~~~~~~~~
		invoke	SetupComm,hCOM,InBuffer,OutBuffer
		
		; get current DCB
		;~~~~~~~~~~~~~~~~		
		invoke	GetCommState,hCOM,addr dcb
		
		; set speed
		;~~~~~~~~~~
		invoke	SendDlgItemMessage,hdlg,ebx,CB_GETCURSEL,0,0
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
		invoke	SendDlgItemMessage,hdlg,esi,CB_GETCURSEL,0,0
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
		invoke	SendDlgItemMessage,hdlg,edi,CB_GETCURSEL,0,0
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
; Enable/Disable setup port controls
;
; [in] ebx = TRUE/FALSE
;-------------------------------------------------------------

EnableSetup proc

	; set state of output group
	;~~~~~~~~~~~~~~~~~~~~~~~~~~
	invoke	GetDlgItem,hdlg,IDC_IFOUT1
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_PORT
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_SPEED
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_PARITY
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_STOPBITS
	invoke	EnableWindow,eax,ebx
	
	; set state of input group
	;~~~~~~~~~~~~~~~~~~~~~~~~~
	invoke	GetDlgItem,hdlg,IDC_IFOUT2
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_PORT2
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_SPEED2
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_PARITY2
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_STOPBITS2
	invoke	EnableWindow,eax,ebx
	
	; set state of OPEN button
	;~~~~~~~~~~~~~~~~~~~~~~~~~
	invoke	GetDlgItem,hdlg,IDC_OPEN
	invoke	EnableWindow,eax,ebx
	
	ret

EnableSetup endp

;-------------------------------------------------------------
; Calculate CRC
;
; [in] edi = offset of next char after '*'
;
; [out] ah = HiAsciiHex(CRC) al = LowAsciiHex(CRC)
;
; i.e. ah=41h al=35h -> ASCII(CRC) = 'A5' (A5h)
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

;-------------------------------------------------------------
; Thread Procedure
;
; waiting and read data from input port
;-------------------------------------------------------------

ThreadProc proc uses ebx esi edi lpParam:DWORD

LOCAL	ComStat:COMSTAT
LOCAL	EventMask:DWORD
LOCAL	ErrorMask:DWORD

	mov		FirstTime,1

	invoke	OpenPort,addr hCOM_in,1000,InComBuf,OutComBuf
	invoke	SetCommMask,hCOM_in,EV_RXCHAR
	invoke	CreateEvent,0,TRUE,FALSE,0
	mov		ovr_in.hEvent,eax

	.while	ThreadOn != 0
		
		mov		EventMask,0
		invoke	WaitCommEvent,hCOM_in,addr EventMask,addr ovr_in
		.if eax==0
			invoke	GetLastError
			.if eax==ERROR_IO_PENDING
				invoke	WaitForSingleObject,ovr_in.hEvent,INFINITE
				invoke	Sleep,50
			.endif
		.endif
		invoke	ClearCommError,hCOM_in,addr ErrorMask,addr ComStat
		dec		ComStat.cbInQue
		dec		ComStat.cbInQue
		invoke	ReadFile,hCOM_in,addr inbuf,ComStat.cbInQue,addr cGot_in,addr ovr_in
		.if cGot_in > 0
			invoke	SendMessage,hdlg,WM_DATA_RECEIVED,0,cGot_in
		.endif
		invoke	PurgeComm,hCOM_in,PURGE_TXABORT or PURGE_RXABORT or \
					PURGE_TXCLEAR or PURGE_RXCLEAR
		invoke	ResetEvent,ovr_in.hEvent
		
	.endw

	invoke	CloseHandle,ovr_in.hEvent
	invoke	CloseHandle,hCOM_in
	
	ret

ThreadProc endp

end start
comment `#####################################################
#
#  ffc.asm    29.11.05 by fnt0m32 'at' gmail.com
#
#  FF Catcher v0.9
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
		
		; save height/width of window
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	GetWindowRect,hwnd,addr wRect
		mov		eax,wRect.right
		sub		eax,wRect.left
		mov		wWidth,eax
		mov		eax,wRect.bottom
		sub		eax,wRect.top
		mov		wHeight,eax
		
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
		
		; init dec edit
		;~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_DEC,WM_SETFONT,hFont,TRUE
		
		; init bin edit
		;~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_BIN,WM_SETFONT,hFont,TRUE
		
		; init FF edit
		;~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_FF,EM_SETLIMITTEXT,2,0
		
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
		
		; init log file
		;~~~~~~~~~~~~~~
		mov		logUse,1
		mov		logDefault,1
		mov		logRewrite,0
		invoke	CheckDlgButton,hwnd,IDC_USELOG,BST_CHECKED
		invoke	CheckDlgButton,hwnd,IDC_DEFAULTLOG,BST_CHECKED
		invoke	GetCurrentDirectory,FileNameSize,addr fbuf_def
		invoke	StrCatBuff,addr fbuf_def,addr logDefName,FileNameSize
		
		; init ofn
		;~~~~~~~~~
		mov		ofn.lStructSize,sizeof ofn		; size
		push	hwnd
		pop		ofn.hwndOwner					; hwnd
		push	hInstance
		pop		ofn.hInstance					; instance
		mov		ofn.lpstrFilter,offset ofnFilter; filter
		mov		ofn.nFilterIndex,1				; filter index
		mov		ofn.lpstrDefExt,offset ofnDefExt	; default extension
		mov		byte ptr fbuf,0					; first byte must be NULL
		mov		ofn.lpstrFile,offset fbuf		; buf 4 filename
		mov		ofn.nMaxFile,FileNameSize		; size of buf
		mov		ofn.lpstrTitle,offset ofnTitle	; text on title bar
		mov		ofn.Flags, \					; flags
					OFN_EXPLORER or \
					OFN_LONGNAMES or \
					OFN_PATHMUSTEXIST
		
	;-------------------------
	; WM_COMMAND
	;-------------------------
		
	.elseif eax==WM_COMMAND
		
		mov		eax,wParam
		
		; DO button
		;~~~~~~~~~~
		.if ax==IDC_DO
			
			invoke	OnOff,2
			
		; DEFAULT LOG CheckBox
		;~~~~~~~~~~~~~~~~~~~~~
		.elseif ax==IDC_DEFAULTLOG
			
			mov		ebx,logDefault
			xor		logDefault,1
			
			invoke	GetDlgItem,hwnd,IDC_LBLLOGFILENAME
			invoke	EnableWindow,eax,ebx
			invoke	GetDlgItem,hwnd,IDC_LOGFILENAME
			invoke	EnableWindow,eax,ebx
			invoke	GetDlgItem,hwnd,IDC_OPENLOG
			invoke	EnableWindow,eax,ebx
			
		; USE LOG CheckBox
		;~~~~~~~~~~~~~~~~~
		.elseif ax==IDC_USELOG
			
			xor		logUse,1
			xor		esi,esi
			invoke	LogUseShow
			
		; OPEN LOG button
		;~~~~~~~~~~~~~~~~
		.elseif ax==IDC_OPENLOG
			
			invoke	GetSaveFileName,addr ofn
			.if eax==TRUE
				invoke	SetDlgItemText,hwnd,IDC_LOGFILENAME,addr fbuf
			.endif
			
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
		
		; bytes counter
		;~~~~~~~~~~~~~~
		mov		eax,lParam
		add		cBytes,eax
		invoke	SetDlgItemInt,hwnd,IDC_BYTES,cBytes,FALSE
		
		;invoke	WriteFile,hFile2,addr inbuf,lParam,addr cWrite,FALSE
		;invoke	WriteFile,hFile2,addr fuckbyte,1,addr cWrite,FALSE
		
		xor		eax,eax
		lea		esi,inbuf
		mov		ecx,lParam
		cld
		.if NeedMerge == 1
			mov		eax,LastEAX
			jmp		lup
		.elseif NeedMerge == 2
			mov		ax,LastAX
			mov		edi,LastEDI
			jmp		clup
		.endif
		
		; looking for 0x??10FF			// 0x?? != 0x10
		;~~~~~~~~~~~~~~~~~~~~~
	lup:
		or		ecx,ecx
		jnz		@F
		mov		NeedMerge,1
		mov		LastEAX,eax
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
			or		ecx,ecx
			jnz		@F
			mov		LastAX,ax
			mov		LastEDI,edi
			mov		NeedMerge,2
			jmp		end_lup
		@@:
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
			mov		NeedMerge,0
		end_clup:
			
			; save state
			;~~~~~~~~~~~
			push	esi		; save last position
			push	ecx		; save bytes left
			
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
			Bin2Hex
			pop		ax
			Bin2Hex
			DSpace
			
			; NN
			;~~~
			xor		ecx,ecx
			lodsb
			mov		cl,al
			Bin2Hex
			DSpace
			
			; out other
			;~~~~~~~~~~
		rlup:
			lodsb
			shl		cx,8
			mov		cl,al
			cmp		cx,1003h
			jne		@F
				Bin2Hex
				jmp		out_in_hex
		@@:				
			shl		ax,8
			lodsb
			shl		cx,8
			mov		cl,al
			cmp		cx,1003h
			jne		@F
				push	ax
				xchg	ah,al
				Bin2Hex
				pop		ax
				Bin2Hex
				jmp		out_in_hex
		@@:
			push	ax
			xchg	ah,al
			Bin2Hex
			pop		ax
			push	ax
			Bin2Hex
			pop		ax
			DSpace
			jmp		rlup
			
		out_in_hex:
			
			xor		al,al
			stosb
			
			invoke	SetDlgItemText,hwnd,IDC_DATA,addr viewbuf
			
			
			; output dec data
			;~~~~~~~~~~~~~~~~
			push	edi
			
			mov		ebx,0
			
		get_next_v:
			lea		esi,[buf+3+ebx*2]
			mov		ax,word ptr [esi]
			xchg	ah,al
			finit
			test	ah,20h
			jnz		@F
			mov		int16,ax
			fild	int16
			jmp		calc_vn
		@@:
			dec		ax
			xor		ax,3FFFh
			mov		int16,ax
			fild	int16
			fchs
			
		calc_vn:
			fld		vn_mod
			fmul
			frndint
			mov		int16,10000
			fild	int16
			fdiv
			fstp	fp64
			invoke	FloatToStr2,fp64,addr fp_buf
			
			lea		esi,fp_buf
			mov		eax,ebx
			mov		ecx,14
			mul		ecx
			lea		edi,[v1+eax]
			mov		ecx,6
		@@:
			lodsb
			or		al,al
			jz		@F
			stosb
			loop	@B
		@@:
			inc		ebx
			cmp		ebx,3
			jae		@F
			jmp		get_next_v
		@@:
		
			; get temperature
			;~~~~~~~~~~~~~~~~
			lea		esi,[buf+9]
			mov		ax,word ptr [esi]
			xchg	ah,al
			mov		int16,ax
			finit
			fild	int16
			fld		tempr_mod		; 0.03052*100
			fmul
			mov		int16,27300		; 273*100
			fild	int16
			fsub
			frndint
			mov		int16,100
			fild	int16
			fdiv
			fstp	fp64
			invoke	FloatToStr,fp64,addr t
			
			
			invoke	SetDlgItemText,hwnd,IDC_DEC,addr dec_buf
			
			pop		edi
			
			; out to log
			;~~~~~~~~~~~
			.if logUse==1
				
				dec		edi
				
					; add dec data to log
					;~~~~~~~~~~~~~~~~~~~~
					mov		al,' '
					stosb
					stosb
					lea		esi,dec_buf
				@@:
					lodsb
					or		al,al
					jz		@F
					stosb
					jmp		@B
				@@:
				
				mov		al,0Dh
				stosb
				mov		al,0Ah
				stosb
				
				mov		eax,edi
				sub		eax,offset viewbuf
				add		logSize,eax
				invoke	WriteFile,hFile,addr viewbuf,eax,addr cWrite,FALSE
				invoke	SetDlgItemInt,hwnd,IDC_LOGSIZE,logSize,FALSE
				
			.endif
			
			; change/show total packets
			;~~~~~~~~~~~~~~~~~~~~~~~~~~
			add		cPackets,1
			invoke	SetDlgItemInt,hwnd,IDC_PACKETS,cPackets,FALSE
			
			; output bin
			;~~~~~~~~~~~
			cmp		num_count,0
			jnz		@F
			jmp		load_state
		@@:
			xor		ecx,ecx
			lea		esi,num
			lea		ebx,buf-1
			lea		edi,num_buf
			cld
			
		next_num:
			movzx	eax,byte ptr [esi+ecx]
			mov		al, byte ptr [ebx+eax]
			push	ecx
					
					mov		ecx,8
				out_num:
					test	al,80h
					jz		zero
					mov		ah,'1'
					jmp		add_bit	
				zero:
					mov		ah,'0'
				add_bit:
					xchg	al,ah
					stosb
					xchg	al,ah
					shl		al,1
					loop	out_num
					DSpace
			pop		ecx
			inc		ecx
			cmp		cl,num_count
			jae		@F
			jmp		next_num
			
		@@:
			mov		byte ptr [edi-1],0
			invoke	SetDlgItemText,hwnd,IDC_BIN,addr num_buf
			
			; load state
			;~~~~~~~~~~~
		load_state:
			pop		ecx			; get bytes left
			pop		esi			; get last position
			jecxz	@F
			jmp		lup
		@@:
			
	end_lup:
	
	;-------------------------
	; WM_SIZING
	;-------------------------
	
	.elseif eax==WM_SIZING
		
		assume	ebx:ptr RECT
		
		mov		ebx,lParam
		
		mov		eax,[ebx].bottom
		sub		eax,[ebx].top
		cmp		eax,wHeight
		je		@F
		mov		eax,[ebx].top
		add		eax,wHeight
		mov		[ebx].bottom,eax
	@@:
		mov		eax,[ebx].right
		sub		eax,[ebx].left
		cmp		eax,wWidth
		jae		@F
		mov		eax,[ebx].left
		add		eax,wWidth
		mov		[ebx].right,eax
	@@:
		
		assume	ebx:nothing
		
	;-------------------------
	; WM_SIZE
	;-------------------------
	
	.elseif eax==WM_SIZE
			
		invoke	GetClientRect,hwnd,addr wRect
		invoke	GetDlgItem,hwnd,IDC_GRP1
		mov		ebx,eax
		invoke	GetClientRect,ebx,addr cRect
		mov		eax,wRect.right
		sub		eax,11
		push	eax
		mov		cRect.right,eax
		invoke	SetWindowPos,ebx,0,0,0,cRect.right,cRect.bottom,SWP_NOMOVE or SWP_NOOWNERZORDER
		
		invoke	GetDlgItem,hwnd,IDC_DATA
		mov		ebx,eax
		invoke	GetClientRect,ebx,addr cRect
		pop		eax
		push	eax
		sub		eax,20
		mov		cRect.right,eax
		mov		cRect.bottom,22
		invoke	SetWindowPos,ebx,0,0,0,cRect.right,cRect.bottom,SWP_NOMOVE or SWP_NOOWNERZORDER
		
		invoke	GetDlgItem,hwnd,IDC_GRP4
		mov		ebx,eax
		invoke	GetClientRect,ebx,addr cRect
		pop		eax
		push	eax
		mov		cRect.right,eax
		invoke	SetWindowPos,ebx,0,0,0,cRect.right,cRect.bottom,SWP_NOMOVE or SWP_NOOWNERZORDER
		
		invoke	GetDlgItem,hwnd,IDC_BIN
		mov		ebx,eax
		invoke	GetClientRect,ebx,addr cRect
		pop		eax
		push	eax
		sub		eax,20
		mov		cRect.right,eax
		mov		cRect.bottom,22
		invoke	SetWindowPos,ebx,0,0,0,cRect.right,cRect.bottom,SWP_NOMOVE or SWP_NOOWNERZORDER
		
		invoke	GetDlgItem,hwnd,IDC_GRP0
		mov		ebx,eax
		invoke	GetClientRect,ebx,addr cRect
		pop		eax
		push	eax
		mov		cRect.right,eax
		invoke	SetWindowPos,ebx,0,0,0,cRect.right,cRect.bottom,SWP_NOMOVE or SWP_NOOWNERZORDER
		
		invoke	GetDlgItem,hwnd,IDC_DEC
		mov		ebx,eax
		invoke	GetClientRect,ebx,addr cRect
		pop		eax
		sub		eax,20
		mov		cRect.right,eax
		mov		cRect.bottom,22
		invoke	SetWindowPos,ebx,0,0,0,cRect.right,cRect.bottom,SWP_NOMOVE or SWP_NOOWNERZORDER
		
	;-------------------------
	; WM_CLOSE
	;-------------------------

	.elseif eax==WM_CLOSE
		
		;invoke	CloseHandle,hFile2
		invoke	OnOff,0
		invoke	DeleteObject,hFont
		invoke	EndDialog,hwnd,0
			
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
				GENERIC_READ, \
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

	;invoke	CreateFile, \
	;			addr fuckname, \
	;			GENERIC_WRITE, \
	;			FILE_SHARE_READ, \
	;			NULL, \
	;			CREATE_ALWAYS, \
	;			FILE_ATTRIBUTE_ARCHIVE, \
	;			NULL
	;mov		hFile2,eax
	
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
	
	; get num
	;~~~~~~~~
	invoke	GetDlgItemText,hdlg,IDC_NUM,addr viewbuf,sizeof viewbuf
	lea		esi,viewbuf
	mov		edi,esi
	mov		ebx,0
	cld
	
num_lup:
	lodsb
	cmp		al,','
	jnz		@F
	
	mov		byte ptr [esi-1],0
	invoke	StrToInt,edi
	cmp		eax,64
	ja		next_num
	or		eax,eax
	jz		next_num
	mov		num[ebx],al
	inc		ebx
next_num:
	mov		edi,esi
	jmp		num_lup
	
@@:
	or		al,al
	jnz		num_lup
	
	lea		eax,[esi-1]
	cmp		eax,edi
	je		@F
	
	mov		byte ptr [esi-1],0
	invoke	StrToInt,edi
	cmp		eax,64
	ja		@F
	or		eax,eax
	jz		@F
	mov		num[ebx],al
	inc		ebx
	
@@:
	mov		num_count,bl
	
	; open port
	;~~~~~~~~~~
	invoke	OpenPort
	invoke	SetCommMask,hCOM,EV_RXCHAR
	invoke	CreateEvent,0,TRUE,FALSE,0
	mov		ovr.hEvent,eax
	
	; init counters
	;~~~~~~~~~~~~~~
	mov		cBytes,0
	mov		cPackets,0
	
	; init merge
	;~~~~~~~~~~~
	mov		NeedMerge,0

	; work
	;~~~~~
	.while	ThreadOn != 0
		
		mov		EventMask,0
		invoke	WaitCommEvent,hCOM,addr EventMask,addr ovr
		.if eax==0
			invoke	GetLastError
			.if eax==ERROR_IO_PENDING
				invoke	WaitForSingleObject,ovr.hEvent,INFINITE
				;invoke	Sleep,50
			.endif
		.endif
		invoke	ClearCommError,hCOM,addr ErrorMask,addr ComStat
		;dec		ComStat.cbInQue
		;dec		ComStat.cbInQue
		invoke	ReadFile,hCOM,addr inbuf,ComStat.cbInQue,addr cGot,addr ovr
		.if cGot > 0
			invoke	SendMessage,hdlg,WM_DATA_RECEIVED,0,cGot
		.endif
		;invoke	PurgeComm,hCOM,PURGE_TXABORT or PURGE_RXABORT or \
		;			PURGE_TXCLEAR or PURGE_RXCLEAR
		invoke	PurgeComm,hCOM,PURGE_RXCLEAR
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
		
		xor		ebx,ebx
		invoke	ShowHideIntf
		
		invoke	OpenLog
		invoke	CleanData
		invoke	SetDlgItemText,hdlg,IDC_DO,addr sStop
		mov		ThreadOn,1
		invoke	CreateThread,NULL,NULL,addr ThreadProc,NULL,0,addr ThreadID
		invoke	CloseHandle,eax
		
	.else
		
		;invoke	CloseHandle,hFile2
		mov		ebx,TRUE
		invoke	ShowHideIntf
		
		invoke	CloseLog
		mov		ThreadOn,0
		invoke	CloseHandle,ovr.hEvent
		invoke	CloseHandle,hCOM
		invoke	SetDlgItemText,hdlg,IDC_DO,addr sStart
		
	.endif
	
	ret
	
OnOff endp

;-------------------------------------------------------------
; ShowHideIntf
;
; [in] ebx = TRUE/FALSE (show/hide)
;-------------------------------------------------------------

ShowHideIntf proc

	invoke	GetDlgItem,hdlg,IDC_NUM
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_PORT
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_SPEED
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_PARITY
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_STOPBITS
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_FF
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_USELOG
	invoke	EnableWindow,eax,ebx
	
	.if logUse==1
		push	logUse
		mov		logUse,ebx
		mov		esi,1
		invoke	LogUseShow
		pop		logUse
	.endif
	
	ret

ShowHideIntf endp

;-------------------------------------------------------------
; LogUseShow
;-------------------------------------------------------------

LogUseShow proc
	
	.if logUse == 0
		invoke	GetDlgItem,hdlg,IDC_LBLLOGFILENAME
		invoke	EnableWindow,eax,FALSE
		invoke	GetDlgItem,hdlg,IDC_LOGFILENAME
		invoke	EnableWindow,eax,FALSE
		invoke	GetDlgItem,hdlg,IDC_OPENLOG
		invoke	EnableWindow,eax,FALSE
		invoke	GetDlgItem,hdlg,IDC_DEFAULTLOG
		invoke	EnableWindow,eax,FALSE
		invoke	GetDlgItem,hdlg,IDC_REWRITELOG
		invoke	EnableWindow,eax,FALSE
		.if esi == 0
			invoke	GetDlgItem,hdlg,IDC_LBLLOGSIZE
			invoke	EnableWindow,eax,FALSE
			invoke	GetDlgItem,hdlg,IDC_LOGSIZE
			invoke	EnableWindow,eax,FALSE
		.endif
	.else
		invoke	GetDlgItem,hdlg,IDC_REWRITELOG
		invoke	EnableWindow,eax,TRUE
		invoke	GetDlgItem,hdlg,IDC_DEFAULTLOG
		invoke	EnableWindow,eax,TRUE
		.if logDefault==0
			invoke	GetDlgItem,hdlg,IDC_LBLLOGFILENAME
			invoke	EnableWindow,eax,TRUE
			invoke	GetDlgItem,hdlg,IDC_LOGFILENAME
			invoke	EnableWindow,eax,TRUE
			invoke	GetDlgItem,hdlg,IDC_OPENLOG
			invoke	EnableWindow,eax,TRUE
		.endif
		.if esi == 0
			invoke	GetDlgItem,hdlg,IDC_LBLLOGSIZE
			invoke	EnableWindow,eax,TRUE
			invoke	GetDlgItem,hdlg,IDC_LOGSIZE
			invoke	EnableWindow,eax,TRUE
		.endif
	.endif
	
	ret

LogUseShow endp

;-------------------------------------------------------------
; CleanData
;
; Clean WinText on statics
;-------------------------------------------------------------

CleanData proc
	
	lea		ebx,[ibuf+6]
	invoke	SetDlgItemText,hdlg,IDC_DATA,ebx
	invoke	SetDlgItemText,hdlg,IDC_BIN,ebx
	
	ret

CleanData endp

;-------------------------------------------------------------
; OpenLog
;-------------------------------------------------------------

OpenLog proc

	invoke	SendDlgItemMessage,hdlg,IDC_REWRITELOG,BM_GETCHECK,0,0
	.if eax==BST_CHECKED
		mov		logRewrite,1
	.else
		mov		logRewrite,0
	.endif
	
	.if logUse==1
	
		.if logDefault==1
			lea		esi,fbuf_def
		.else
			invoke	GetDlgItemText,hdlg,IDC_LOGFILENAME,addr fbuf,sizeof fbuf
			lea		esi,fbuf
		.endif
		
		.if logRewrite==1
			mov		edi,CREATE_ALWAYS
		.else
			mov		edi,OPEN_ALWAYS
		.endif
		
		invoke	CreateFile, \
					esi, \
					GENERIC_WRITE, \
					FILE_SHARE_READ, \
					NULL, \
					edi, \
					FILE_ATTRIBUTE_ARCHIVE, \
					NULL
			
		.if eax != INVALID_HANDLE_VALUE
			mov		hFile,eax
			invoke	GetFileSize,eax,NULL
			mov		logSize,eax
			.if logRewrite==0
				invoke	GetFileSize,hFile,NULL
				invoke	SetFilePointer,hFile,eax,NULL,FILE_BEGIN
			.endif
		.else
			mov		ax,IDC_DEFAULTLOG
			invoke	SendMessage,hdlg,WM_COMMAND,eax,0
			invoke	CheckDlgButton,hdlg,IDC_DEFAULTLOG,BST_CHECKED
			invoke	OpenLog
		.endif
		
	.endif
	
	ret

OpenLog endp

;-------------------------------------------------------------
; CloseLog
;-------------------------------------------------------------

CloseLog proc
	
	invoke	CloseHandle,hFile
	
	ret

CloseLog endp

end start

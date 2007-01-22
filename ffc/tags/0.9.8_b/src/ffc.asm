comment `#####################################################
#
#  ffc.asm    24.03.2006 by fnt0m32 'at' gmail.com
#
#  FF Catcher v0.9.8b
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

include ffc.inc			; main
include	ffc_help.inc	; help dialog
include ffc_cfg.inc		; config file

;-------------------------------------------------------------
; ENTRY POINT
;-------------------------------------------------------------

.code

start:

	invoke	InitCommonControls
	
	invoke	GetModuleHandle,NULL
	mov		hInstance,eax
	
	; create tooltip wnd
	invoke	CreateWindowEx,NULL,addr ToolTipClassName,NULL,NULL,\;TIS_ALWAYSTIP,\
				CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,\
				NULL,NULL,hInstance,NULL
	mov		hTT,eax

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
		
		; init some bufs
		;~~~~~~~~~~~~~~~
		invoke	GetCurrentDirectory,FileNameSize,addr fbuf_def
				; save cfg file full dir
				mov		byte ptr cfg_path,0
				invoke	StrCatBuff,addr cfg_path,addr fbuf_def,FileNameSize-2
				invoke	StrCatBuff,addr cfg_path,addr cfg_def_name,FileNameSize
		invoke	StrCatBuff,addr fbuf_def,addr logDefName,FileNameSize
		
		; save min height/width of window
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		;mov		wWidth,WND_MIN_WIDTH
		;mov		wHeight,WND_MIN_HEIGHT
		
		; calc left/top for alignCenter
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	GetSystemMetrics,SM_CXSCREEN
		sub		eax,_wnd_rect.right				; CX - DCX  ; DCX - minimum of main window
		shr		eax,1							; (CX - DCX) / 2
		mov		_wnd_rect.left,eax				; default left for center
		invoke	GetSystemMetrics,SM_CYSCREEN
		sub		eax,_wnd_rect.bottom			; CY - DCY  ; DCY - minimum of main window 
		shr		eax,1							; (CY - DCY) / 2
		mov		_wnd_rect.top,eax				; default top for center
		
		; load and set configuration
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	LoadCfg
		cmp		cfgError,0
		je		@F
			;have error
			invoke	MessageBox,hwnd,addr errLoadCfg,addr errTitle,MB_OK or MB_ICONWARNING
	@@:
		
		;-----------------------------
		; init tooltips
		;-----------------------------
		mov		ti.cbSize,sizeof TOOLINFO
		mov		ti.uFlags,TTF_IDISHWND or TTF_SUBCLASS
		
			; Mark edit
			;~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_MARK
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmMark
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; SetMark button
			;~~~~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_SETMARK
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmSetMark
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Help button
			;~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_HELPP
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmHelpp
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; About button
			;~~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_ABOUT
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmAbout
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Exit button
			;~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_EXIT
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmExit
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; OpenLog button
			;~~~~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_OPENLOG
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmOpenLog
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; LogFileName edit
			;~~~~~~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_LOGFILENAME
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmLogFileName
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Bin edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_BIN
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmBin
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Hex edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_HEX
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmHex
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Dec edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_DEC
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmDec
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Deg edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_DEG
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmDeg
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; G edit
			;~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_G
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmG
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; KT edit
			;~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_KT
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmKT
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; SEND button
			;~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_SEND
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmSend
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; SYN button
			;~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_SYN
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmSyn
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; U?? edit
			;~~~~~~~~~
			mov		esi,IDC_U24
			lea		edi,ttmU24
			mov		ecx,8
		@@:
			push	ecx
			invoke	GetDlgItem,hwnd,esi
			pop		ecx
			mov		ti.uId,eax
			mov		ti.lpszText,edi
			push	ecx
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			pop		ecx
			dec		esi
			sub		edi,8
			loop	@B
			
			; U10 edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_U10
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmU10
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; U20 edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_U20
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmU20
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; k1 edit
			;~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_K1
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmk1
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; k2 edit
			;~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_K2
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmk2
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Alpha1 edit
			;~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_A1
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmAlpha1
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Alpha2 edit
			;~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_A2
			mov		ti.uId,eax
			mov		ti.lpszText,offset ttmAlpha2
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
		; init flags
		;~~~~~~~~~~~
		mov		Start,0
		mov		ThreadOn,0
		mov		logUseMark,0
		mov		DontCalcParams,0
		mov		syn_on,0
		
		; init ibuf
		;~~~~~~~~~~
		mov		byte ptr ibuf,' '
		mov		byte ptr ibuf[6],0
		
		; set titles
		;~~~~~~~~~~~
		invoke	SendMessage,hwnd,WM_SETTEXT,0,addr sAbout0
		invoke	SendDlgItemMessage,hwnd,IDC_DO,WM_SETTEXT,0,addr sStart
		invoke	SetDlgItemText,hwnd,IDC_SYN,addr syn_ready
		
		; set icon
		;~~~~~~~~~
		invoke	LoadIcon,hInstance,2000
		mov		hIcon,eax
		invoke	SendMessage,hwnd,WM_SETICON,ICON_BIG,hIcon
		
		; init hex edit
		;~~~~~~~~~~~~~~
		invoke	CreateFontIndirect,addr logfont
		mov		hFont,eax
		invoke	SendDlgItemMessage,hwnd,IDC_HEX,WM_SETFONT,hFont,TRUE
		
		; init dec edit
		;~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_DEC,WM_SETFONT,hFont,TRUE
		
		; init bin edit
		;~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_BIN,WM_SETFONT,hFont,TRUE
		
		; init grad edit
		;~~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_DEG,WM_SETFONT,hFont,TRUE
		
		; init FF edit
		;~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_FF,EM_SETLIMITTEXT,2,0
		
		; init LogFileName edit
		;~~~~~~~~~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_LOGFILENAME,EM_SETLIMITTEXT,FileNameSize,0
		
		; init num edit
		;~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_NUM,EM_SETLIMITTEXT,BytesNumSize,0
		
		; init table edits
		;~~~~~~~~~~~~~~~~~
		mov		esi,IDC_U24
		mov		ecx,9
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,esi,EM_SETLIMITTEXT,fp64_size,0
		pop		ecx
		dec		esi
		loop	@B
		
		; init KT edit
		;~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_KT,EM_SETLIMITTEXT,4,0
		
		; init params of table
		;~~~~~~~~~~~~~~~~~~~~~
		invoke	CalcParams
		
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
		
		; FUCKING bug. when loadcfg-error then U11 shows HEX-value instead DEC-value! EN_SETFOCUS are working here!
		mov		DontCalcParams,1
		invoke	SetDlgItemText,hwnd,IDC_U11,addr cfg.u11	; set DEC-value again
		mov		DontCalcParams,0
		
		; set first focus
		;~~~~~~~~~~~~~~~~
		invoke	GetDlgItem,hwnd,IDC_MARK
		invoke	SetFocus,eax
		
		jmp		failed							; program set a focus by self!
		
	;-------------------------
	; WM_COMMAND
	;-------------------------
		
	.elseif eax==WM_COMMAND
		
		mov		ebx,wParam
		mov		ax,bx
		shr		ebx,16
		
		; DO button
		;~~~~~~~~~~
		.if ax==IDC_DO
			
			invoke	OnOff,2
			
		; CALC64 buttons
		;~~~~~~~~~~~~~~~
		.elseif ax >= IDC_CALC64_0  &&  ax <= IDC_CALC64_270
			
			.if c64_on == 0
				mov		c64_on,1
				and		eax,0000ffffh
				sub		eax,IDC_CALC64_0
				mov		c64_id,eax			; save c64_id
				mov		c64_sum1,0			; init sum1
				mov		c64_sum2,0			; init sum2
				mov		c64_count,0			; init count
				invoke	c64_Intf
				; show first statistics
				mov		ebx,IDC_CALC64_0
				add		ebx,c64_id
				invoke	wsprintf,addr c64_stat,addr c64_stat_fmt,c64_count,cfg.c64_count_max
				invoke	SetDlgItemText,hwnd,ebx,addr c64_stat
			.else
				mov		c64_on,0
				invoke	c64_btn_names
			.endif
			
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
			
		; SET MARK button
		;~~~~~~~~~~~~~~~~
		.elseif ax==IDC_SETMARK
			
			mov		logUseMark,1
			
		; HELPP button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_HELPP
			
			;invoke	MessageBox,hwnd,addr sHelp,addr sHelpTitle,MB_OK or MB_ICONINFORMATION
			invoke	ShowHelp
			
		; ABOUT button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_ABOUT
			
			invoke	ShellAbout,hwnd,addr sAbout0,addr sAbout1,hIcon
			
		; EXIT button
		;~~~~~~~~~~~~
		.elseif ax==IDC_EXIT
			
			invoke	SendMessage,hwnd,WM_CLOSE,0,0
			
		; SEND button
		;~~~~~~~~~~~~
		.elseif ax==IDC_SEND
			
			; prepare values
			;~~~~~~~~~~~~~~~
			invoke	GetDlgItemText,hwnd,IDC_KT,addr checkhex_buf,CheckHexSize
			invoke	ExtractHex,addr checkhex_buf,offset cfg.kt
			
			mov		esi,offset cfg.hex_u11
			lea		edi,send_buf
			cld
			mov		ecx,9
		@@:
			lodsw
			xchg	ah,al
			stosb
			xchg	ah,al
			stosb
			loop	@B
			
			invoke	MessageBox,hwnd,addr aysSend,addr errTitle,MB_ICONWARNING or MB_YESNO 
			cmp		eax,IDNO
			je		@F
			
			; send info
			;~~~~~~~~~~
			;invoke	CreateEvent,0,TRUE,FALSE,0
			;mov		ovr.hEvent,eax
			invoke	WriteFile,hCOM,addr send_buf,18,addr cSent,addr ovr2
			;invoke	ResetEvent,ovr.hEvent
		@@:
		
		; SYN button
		;~~~~~~~~~~~
		.elseif ax==IDC_SYN
			
			xor		syn_on,1
			jz		syn_turn_off
			invoke	SetDlgItemText,hwnd,IDC_SYN,addr syn_doing
			jmp		@F
		syn_turn_off:
			invoke	SetDlgItemText,hwnd,IDC_SYN,addr syn_ready
		@@:
			
		; EN_CHANGE of table
		;~~~~~~~~~~~~~~~~~~~
		.elseif bx==EN_CHANGE && ax >= 1041 && ax <= 1049
			
			cmp		DontCalcParams,1
			jne		@F
			jmp		dontcalcparams_exit
		@@:
			
			; if it's only G
			cmp		ax,1041
			jne		@F
			invoke	GetDlgItemText,hwnd,IDC_G,offset cfg.g,fp64_size
			jmp		calc_new_params
		@@:
			; if it's HEX-values
			xor		ebx,ebx
			mov		bx,ax
			invoke	GetDlgItemText,hwnd,ebx,addr checkhex_buf,CheckHexSize
			invoke	CheckHexStr,addr checkhex_buf
			mov		ecx,ebx
			sub		ecx,IDC_U11
			mov		edi,offset cfg.hex_u11
			lea		edi,[edi+ecx*2]
			push	ecx
			invoke	ExtractHex,addr checkhex_buf,edi		; save new value to cfg.hex_u??
			; calc new DEC-value
			finit
			mov		ax,word ptr [edi]
			test	ah,20h
			jnz		@F
			fild	word ptr [edi]
			jmp		calc_dec_value
		@@:
			dec		ax
			xor		ax,3FFFh
			mov		int16_2,ax
			fild	int16_2
			fchs
		calc_dec_value:
			fld		vn_mod
			fmul
			frndint
			mov		int16_2,10000
			fild	int16_2
			fdiv
			fstp	fp64_2
			; save new DEC-value to cfg.u??
			pop		ecx
			mov		eax,fp64_size
			mul		ecx
			mov		edi,offset cfg.u11
			lea		edi,[edi+eax]			; get offset of string cfg.u??
			invoke	FloatToStr2,fp64_2,edi
			
			
		calc_new_params:
			
			invoke	CalcParams
			
			
		dontcalcparams_exit:
			
		; EN_SETFOCUS of table
		;~~~~~~~~~~~~~~~~~~~~~
		.elseif bx==EN_SETFOCUS && ax >= IDC_U11 && ax <= IDC_U24
			
			cmp		c64_on,1
			jne		@F
			jmp		setfocus_table_exit
		@@:
			cmp		syn_on,1
			jne		@F
			jmp		setfocus_table_exit
		@@:
			
			push	eax
			lea		ebx,HexTable
			lea		edi,u_hex
			cld
			mov		esi,offset cfg.hex_u11
			xor		ecx,ecx
			mov		cx,ax
			sub		cx,IDC_U11
			lea		esi,[esi+ecx*2]
			mov		cx,word ptr [esi]
			mov		al,ch
			Bin2Hex
			mov		al,cl
			Bin2Hex
			xor		al,al
			stosb
			pop		eax
			xor		ecx,ecx
			mov		cx,ax
			mov		ebx,ecx		;save IDC_*
			
			mov		DontCalcParams,1
			invoke	SetDlgItemText,hwnd,ebx,addr u_hex
			invoke	SendDlgItemMessage,hwnd,ebx,EM_SETREADONLY,FALSE,0
			invoke	SendDlgItemMessage,hwnd,ebx,EM_SETLIMITTEXT,4,0
			mov		DontCalcParams,0
			
		setfocus_table_exit:
		
		; EN_KILLFOCUS of table
		;~~~~~~~~~~~~~~~~~~~~~~
		.elseif bx==EN_KILLFOCUS && ax >= IDC_U11 && ax <= IDC_U24
			
			cmp		c64_on,1
			jne		@F
			jmp		killfocus_table_exit
		@@:
			cmp		syn_on,1
			jne		@F
			jmp		killfocus_table_exit
		@@:
			
			mov		esi,offset cfg.u11
			xor		ecx,ecx
			mov		cx,ax
			sub		cx,IDC_U11
			push	eax
			mov		eax,ecx
			mov		ecx,fp64_size
			mul		ecx
			lea		esi,[esi+eax]			; get offset of string
			pop		eax
			
			mov		cx,ax
			mov		ebx,ecx		;save IDC_*
			
			mov		DontCalcParams,1
			invoke	SendDlgItemMessage,hwnd,ebx,EM_SETREADONLY,TRUE,0
			invoke	SendDlgItemMessage,hwnd,ebx,EM_SETLIMITTEXT,fp64_size,0
			invoke	SetDlgItemText,hwnd,ebx,esi
			mov		DontCalcParams,0
			
		killfocus_table_exit:
			
		; EN_KILLFOCUS of KT
		;~~~~~~~~~~~~~~~~~~~
		.elseif bx==EN_KILLFOCUS && (ax == IDC_KT || ax == IDC_FF)
			
			xor		ebx,ebx
			mov		bx,ax
			invoke	GetDlgItemText,hwnd,ebx,addr checkhex_buf,CheckHexSize
			invoke	CheckHexStr,addr checkhex_buf
			invoke	SetDlgItemText,hwnd,ebx,addr checkhex_buf
			
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
		
		;TEST-FILE
		;invoke	WriteFile,hFile2,addr inbuf,lParam,addr cWrite,FALSE
		;invoke	WriteFile,hFile2,addr fuckbyte,1,addr cWrite,FALSE
		;invoke	WriteFile,hFile2,addr fuckbyte,1,addr cWrite,FALSE
		;invoke	WriteFile,hFile2,addr fuckbyte,1,addr cWrite,FALSE
		;invoke	WriteFile,hFile2,addr fuckbyte,1,addr cWrite,FALSE
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
			mov		HexEnd,edi			; save new offset of end
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
			inc		HexEnd				; increase offset of end
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
			Bin2Hex
			lodsb
			Bin2Hex
			DSpace
			
			; NN
			;~~~
			lodsb
			Bin2Hex
			DSpace
			
			; out other
			;~~~~~~~~~~
			xor		ecx,ecx
		rlup:
			cmp		esi,HexEnd
			je		out_in_hex
			lodsb
			Bin2Hex
			xor		ecx,1
			jnz		@F
			DSpace
		@@:
			jmp		rlup			
			
		out_in_hex:
			
			xor		al,al
			stosb
			
			invoke	SetDlgItemText,hwnd,IDC_HEX,addr viewbuf
			
			
			; output dec data
			;~~~~~~~~~~~~~~~~
			push	edi					; SAVE before output log-file !
			
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
			fst		fp64
							.if  ebx == 0
								fstp	vv1
							.elseif ebx==1
								fstp	vv2
							.else
								fstp	vv3
							.endif
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
			; correct temperature format string
			ftst
			fstsw	ax
			sahf
			jae		t_ae_0
			mov		t_sign,'-'
			jmp		@F
		t_ae_0:
			mov		t_sign,' '
		@@:
			fabs
			fst		fp64
			fld		fp64			; x.y, x.y
			fstcw	cwr
			or		cwr,0000110000000000b		; trunc
			fldcw	cwr
			frndint					; x.y, x.0
			fist	t_x				; x.y, x.0
			fsub					; 0.y = x.y - x.0
			mov		t_y,100
			fild	t_y				; 0.y, 100
			fmul					; yy.y = 0.y * 100
			frndint					; yy.0
			fistp	t_y
			
			invoke	wsprintf,addr t,addr fmt_t,t_x,t_y
			
			lea		esi,t
			cld
			mov		ecx,10
		t_format:
			lodsb
			cmp		al,' '
			jne		@F
			mov		byte ptr [esi-1],'0'
		@@:
			loop t_format
			
			invoke	SetDlgItemText,hwnd,IDC_DEC,addr dec_buf
			
			
			;----------------------------------
			; output DEG data
			;----------------------------------
			
			finit
			
			mov		err_flag,0			; clear err_flag (look in ffc.inc below)
			
			; calc F1
			;~~~~~~~~
			
			; (v1 - u10) / (k1 * g) - a1
			fld		vv1
			fld		u10
			fsub
			fld		k1
			fdiv
			fld		g
			fdiv
			fld		a1
			fsub
			; check -1 <= x <= 1
			fst		temper
			fld		temper
			fld1
			fadd
			mov		comparer,2
			fild	comparer
			fcomp	
			fstsw	ax
			sahf
			jb		f1_g_1
			mov		comparer,0
			fild	comparer
			fcomp
			fstsw	ax
			sahf
			ja		f1_l_1
			fstp	temper
			jmp		get_arcsin_f1
		f1_g_1:
			fstp	temper
			fstp	temper
			fld1
			mov		err_flag,1				; We have a math-error !!!
			jmp		get_arcsin_f1
		f1_l_1:
			fstp	temper
			fstp	temper
			fld1
			fchs
			mov		err_flag,1				; We have a math-error !!!
		get_arcsin_f1:
			; arcsin ( (v1 - u10) / (k1 * g) - a1 )
			fst		temper
			fld		temper		; a, a
			fld		temper		; a, a, a
			fmul				; a, a^2
			fld1				; a, a^2, 1
			fsubr				; a, 1 - a^2
			fsqrt				; a, sqrt(1 - a^2)
			fpatan				; arcsin = arctg( a / sqrt(1 - a^2) )
			; last actions
			mov		diver,180
			fild	diver
			fmul
			fldpi
			fdiv
			ftst
			fstsw	ax
			sahf
			jae		@F
			mov		f1_sign,'-'
			fabs
			jmp		div_f1
		@@:
			mov		f1_sign,' '
		div_f1:
			fst		f1
			; div f1 into ggg.mm.oo
			fstcw	cwr
			or		cwr,0000110000000000b
			fldcw	cwr
			frndint				; ggg
			fist	f1g
			fld		f1			; ggg, f1
			fsubr				; 0.x = f1 - ggg
			mov		diver,60
			fild	diver		; 0.x, 60
			fmul				; mm.y = 60 * 0.x
			fst		f1
			frndint				; mm
			fist	f1m
			fld		f1			; mm, mm.y
			fsubr				; 0.y = mm.y - mm
			mov		diver,100
			fild	diver		; 0.y, 100
			fmul				; yy.y
			;fstcw	cwr
			;and		cwr,1111001111111111b
			;fldcw	cwr
			frndint				; yy
			fistp	f1o
			
			; calc F2
			;~~~~~~~~
			
			; (v3 - u20) / (k2 * g) - a2
			fld		vv3
			fld		u20
			fsub
			fld		k2
			fdiv
			fld		g
			fdiv
			fld		a2
			fsub
			; check -1 <= x <= 1
			fst		temper
			fld		temper
			fld1
			fadd
			mov		comparer,2
			fild	comparer
			fcomp
			fstsw	ax
			sahf
			jb		f2_g_1
			mov		comparer,0
			fild	comparer
			fcomp
			fstsw	ax
			sahf
			ja		f2_l_1
			fstp	temper
			jmp		get_arcsin_f2
		f2_g_1:
			fstp	temper
			fstp	temper
			fld1
			mov		err_flag,1				; We have a math-error !!!
			jmp		get_arcsin_f2
		f2_l_1:
			fstp	temper
			fstp	temper
			fld1
			fchs
			mov		err_flag,1				; We have a math-error !!!
		get_arcsin_f2:
			; arcsin ( (v3 - u20) / (k2 * g) - a2 )
			fst		temper
			fld		temper		; a, a
			fld		temper		; a, a, a
			fmul				; a, a^2
			fld1				; a, a^2, 1
			fsubr				; a, 1 - a^2
			fsqrt				; a, sqrt(1 - a^2)
			fpatan				; arcsin = arctg( a / sqrt(1 - a^2) )
					; arccos ( (v3 - u20) / (k2 * g) - a2 )
					;fst		temper
					;fld1				; a, 1
					;fsubr				; 1-a
					;fsqrt				; sqrt(1-a)
					;fld1				; sqrt(1-a), 1
					;fld		temper		; sqrt(1-a), 1, a
					;fadd				; sqrt(1-a), 1+a
					;fsqrt				; sqrt(1-a), sqrt(1+a)
					;fpatan				; arccos = arctg( sqrt(1-a) / sqrt(1+a) )
					;mov		diver,2
					;fild	diver
					;fmul
			; last actions
			mov		diver,180
			fild	diver
			fmul
			fldpi
			fdiv
			ftst
			fstsw	ax
			sahf
			jae		@F
			mov		f2_sign,'-'
			fabs
			jmp		div_f2
		@@:
			mov		f2_sign,' '
		div_f2:
			fst		f2
			; div f2 into ggg.mm.oo
			;fstcw	cwr
			;or		cwr,0000110000000000b
			;fldcw	cwr
			frndint				; ggg
			fist	f2g
			fld		f2			; ggg, f2
			fsubr				; 0.x = f2 - ggg
			mov		diver,60
			fild	diver		; 0.x, 60
			fmul				; mm.y = 60 * 0.x
			fst		f2
			frndint				; mm
			fist	f2m
			fld		f2			; mm, mm.y
			fsubr				; 0.y = mm.y - mm
			mov		diver,100
			fild	diver		; 0.y, 100
			fmul				; yy.y
			;fstcw	cwr
			;and		cwr,1111001111111111b
			;fldcw	cwr
			frndint				; yy
			fistp	f2o
			
			; convert F1/F2 to text and output
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			
			invoke	wsprintf,addr s_f12,addr fmt_f12,f1g,f1m,f1o,f2g,f2m,f2o
			
			; change ' ' to '0' in f1
			;~~~~~~~~~~~~~~~~~~~~~~~~
			cld
			lea		esi,f1_val
			mov		ecx,9
		f1_trunc:
			lodsb
			cmp		al,' '
			jne		@F
			mov		byte ptr [esi-1],'0'
		@@:
			loop	f1_trunc
			
			; change ' ' to '0' in f2
			;~~~~~~~~~~~~~~~~~~~~~~~~
			lea		esi,f2_val
			mov		ecx,9
		f2_trunc:
			lodsb
			cmp		al,' '
			jne		@F
			mov		byte ptr [esi-1],'0'
		@@:
			loop	f2_trunc
			
			; if error?
			;~~~~~~~~~~
			.if err_flag == 0
				mov		err_val,0
			.else
				push	err_value		; set error adds to output/log -> " ERR"
				pop		err_val
				mov		err_zero,0
			.endif
			
			invoke	SetDlgItemText,hwnd,IDC_DEG,addr s_f12
			
			; out to log
			;~~~~~~~~~~~
			
			pop		edi
			
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
					
					; add deg data to log
					;~~~~~~~~~~~~~~~~~~~~
					mov		al,' '
					stosb
					stosb
					stosb
					lea		esi,s_f12
				@@:
					lodsb
					or		al,al
					jz		@F
					stosb
					jmp		@B
				@@:
					
					; add mark to log
					;~~~~~~~~~~~~~~~~
					cmp		logUseMark,1
					jne		no_mark
					mov		logUseMark,0
					mov		al,' '
					stosb
					stosb
					invoke	GetDlgItemText,hwnd,IDC_MARK,addr markbuf,MarkBufSize
					lea		esi,markbuf
				@@:
					lodsb
					or		al,al
					jz		@F
					stosb
					jmp		@B
				@@:
				no_mark:
				
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
			jmp		c64_system
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
			
			; do calc64 (if it's on)
			;~~~~~~~~~~~~~~~~~~~~~~~
		c64_system:
			
			.if c64_on == 1
				
				lea		esi,buf
				xor		eax,eax
				mov		ax,word ptr [esi+3]		; Word #1 of packet
				xchg	ah,al					; reverse high and low bytes
				add		c64_sum1,eax			; calc sum1
				mov		ax,word ptr [esi+7]		; Word #3 of packet
				xchg	ah,al					; reverse high and low bytes
				add		c64_sum2,eax			; calc sum2
				
				inc		c64_count				; +1 packet
				
				; show statistics
				mov		ebx,IDC_CALC64_0
				add		ebx,c64_id
				invoke	wsprintf,addr c64_stat,addr c64_stat_fmt,c64_count,cfg.c64_count_max
				invoke	SetDlgItemText,hwnd,ebx,addr c64_stat
				
				mov		eax,c64_count
				cmp		eax,cfg.c64_count_max	; is it all ?
				jne		end_c64_iter
				
					; end calc64 and show results
					;~~~~~~~~~~~~~~~~~~~~~~~~~~~~
					
					; get average
					mov		ecx,c64_shr				; shr param
					mov		eax,c64_sum1
					shr		eax,cl					; get average sum1
					mov		ebx,c64_sum2
					shr		ebx,cl					; get average sum2
					
					; save to config structure
					mov		esi,offset cfg.hex_u11
					mov		ecx,c64_id
					lea		esi,[esi+ecx*2]			; get offset of hex_u1? (? = c64_id + 1)
					mov		word ptr [esi],ax		; save avg1 to config
					mov		word ptr [esi+8],bx		; save avg2 to config
					
					; calc new params
					finit
					; calc sensor #1				; be careful with ESI before !
					mov		ax,word ptr [esi]
					test	ah,20h
					jnz		@F
					fild	word ptr [esi]
					jmp		calc_sens1
				@@:
					dec		ax
					xor		ax,3FFFh
					mov		int16_3,ax
					fild	int16_3
					fchs
				calc_sens1:
					fld		vn_mod
					fmul
					frndint
					mov		int16_3,10000
					fild	int16_3
					fdiv
					fstp	c64_fpu1
					; calc sensor #2
					mov		ax,word ptr [esi+8]
					test	ah,20h
					jnz		@F
					fild	word ptr [esi+8]
					jmp		calc_sens2
				@@:
					dec		ax
					xor		ax,3FFFh
					mov		int16_3,ax
					fild	int16_3
					fchs
				calc_sens2:
					fld		vn_mod
					fmul
					frndint
					mov		int16_3,10000
					fild	int16_3
					fdiv
					fstp	c64_fpu2
					
					; convert new params to string
					mov		ecx,c64_id
					mov		eax,fp64_size
					mul		ecx
					mov		edi,offset cfg.u11
					lea		edi,[edi+eax]							; get offset of string cfg.u1?
					push	edi										
					push	edi										; save for show
					invoke	FloatToStr2,c64_fpu1,edi				; save to cfg.u1?
					pop		edi
					mov		eax,fp64_size
					shl		eax,2									; fp64_size * 4
					lea		edi,[edi+eax]							; get offset of string cfg.u2?
					push	edi										; save for show
					invoke	FloatToStr2,c64_fpu2,edi				; save to cfg.u2?
					
					; show new params
					mov		DontCalcParams,1
					mov		ebx,IDC_U11
					add		ebx,c64_id
					pop		esi										; get offset of cfg.u2?
					pop		edi										; get offset of cfg.u1?
					invoke	SetDlgItemText,hwnd,ebx,edi				; set sensor #1
					add		ebx,4
					invoke	SetDlgItemText,hwnd,ebx,esi				; set sensor #2
					mov		DontCalcParams,0
					
					; change button's caption to normal
					invoke	c64_btn_names
					
					; calc other new params
					invoke	CalcParams
					
					mov		c64_on,0				; stop flag
				
			end_c64_iter:
				
			.endif
			
			; do syn (if it's on)
			;~~~~~~~~~~~~~~~~~~~~
			.if syn_on == 1
			
				mov		esi,HexEnd
				lea		edi,buf
				sub		esi,edi						;lea
				cmp		esi,FULL_PACKET_SIZE		; = full size of packet ?
				je		@F
				jmp		syn_continue				; wait for really full packet ...
			@@:
				; load nine words and save in cfg.*
				;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				lea		esi,[edi+11]				; offset of first of 1-9 words (it's table!)
				mov		edi,offset cfg.hex_u11
				cld
				mov		ecx,9
			@@:
				lodsw
				xchg	ah,al
				stosw
				loop	@B
				
				; calc new params of table (U11-U24)
				;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
				mov		esi,offset cfg.hex_u11
				mov		edi,offset cfg.u11
				cld
				mov		ecx,8
				
			syn_calc:
				push	ecx
				; get word
				lodsw
				; calc DEC-value
				finit
				test	ah,20h
				jnz		@F
				mov		syn_int16,ax
				fild	syn_int16
				jmp		syn_calc_dec_value
			@@:
				dec		ax
				xor		ax,3FFFh
				mov		syn_int16,ax
				fild	syn_int16
				fchs
			syn_calc_dec_value:
				fld		vn_mod
				fmul
				frndint
				mov		syn_int16,10000
				fild	syn_int16
				fdiv
				fstp	syn_fp64
				; convert DEC-value to string
				invoke	FloatToStr2,syn_fp64,edi			; save new DEC-value to cfg.u??
				add		edi,fp64_size						; offset of next cfg.u??
				pop		ecx
				loop	syn_calc
				
				; calc other params
				;~~~~~~~~~~~~~~~~~~
				invoke	CalcParams
				
				; show new 8 values
				;~~~~~~~~~~~~~~~~~~
				mov		DontCalcParams,1
				mov		esi,offset cfg.u11
				mov		edi,IDC_U11
				mov		ecx,8
			@@:
				push	ecx
				invoke	SetDlgItemText,hwnd,edi,esi
				pop		ecx
				add		esi,fp64_size
				inc		edi
				loop	@B
				mov		DontCalcParams,0
				
				; show new KT
				;~~~~~~~~~~~~
				lea		edi,checkhex_buf
				lea		ebx,HexTable
				cld
				mov		cx,cfg.kt
				mov		al,ch
				Bin2Hex
				mov		al,cl
				Bin2Hex
				xor		al,al
				stosb
				invoke	SetDlgItemText,hwnd,IDC_KT,addr checkhex_buf
				
			syn_done:
				
				invoke	SetDlgItemText,hwnd,IDC_SYN,addr syn_ready
				mov		syn_on,0
				
			syn_continue:
				
			.endif
			
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
		cmp		eax,_wnd_rect.bottom	;wHeight
		je		@F
		mov		eax,[ebx].top
		add		eax,_wnd_rect.bottom	;wHeight
		mov		[ebx].bottom,eax
	@@:
		mov		eax,[ebx].right
		sub		eax,[ebx].left
		cmp		eax,_wnd_rect.right		;wWidth
		jae		@F
		mov		eax,[ebx].left
		add		eax,_wnd_rect.right		;wWidth
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
		
		invoke	GetDlgItem,hwnd,IDC_HEX
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
		
		;invoke	CloseHandle,hFile2			;TEST-FILE
		invoke	OnOff,0
		invoke	SaveCfg
			;error?
			or		eax,eax
			jnz		@F
			invoke	MessageBox,hwnd,addr errSaveCfg,addr errTitle,MB_OK or MB_ICONERROR
			jmp		end_proc
	@@:
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
				GENERIC_READ or GENERIC_WRITE, \
				NULL, \ ;FILE_SHARE_READ or FILE_SHARE_WRITE, \
				NULL, \
				OPEN_EXISTING, \
				FILE_FLAG_OVERLAPPED, \
				NULL
				
	.if eax != INVALID_HANDLE_VALUE
		
		mov		hCOM,eax
		
		invoke	PurgeComm,hCOM,PURGE_TXABORT or PURGE_RXABORT or PURGE_TXCLEAR or PURGE_RXCLEAR
		IfEAXZeroJmpTo	port_error
		
		invoke	ClearCommBreak,hCOM
		IfEAXZeroJmpTo	port_error
		
		; set in/out buffer
		;~~~~~~~~~~~~~~~~~~
		invoke	SetupComm,hCOM,InComBuf,OutComBuf
		IfEAXZeroJmpTo	port_error
		
		; get current DCB
		;~~~~~~~~~~~~~~~~		
		invoke	GetCommState,hCOM,addr dcb
		IfEAXZeroJmpTo	port_error
		
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
		IfEAXZeroJmpTo	port_error
		
		; get & set timeouts
		;~~~~~~~~~~~~~~~~~~~				
		invoke	GetCommTimeouts,hCOM,addr cto
		IfEAXZeroJmpTo	port_error
		mov		cto.ReadIntervalTimeout,20
		mov		cto.WriteTotalTimeoutMultiplier,10
		mov		cto.WriteTotalTimeoutConstant,2000
		invoke	SetCommTimeouts,hCOM,addr cto
		IfEAXZeroJmpTo	port_error
		
		mov		eax,TRUE
		
	.else
		
	port_error:
		
		mov		al,COM_id
		mov		errOpenPortNum,al
		invoke	MessageBox,hdlg,addr errOpenPort,addr errTitle,MB_ICONERROR or MB_OK
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
	
	;TEST-FILE
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
	IfEAXZeroJmpTo	open_port_error
	invoke	SetCommMask,hCOM,EV_RXCHAR
	IfEAXZeroJmpTo	open_port_error
	invoke	CreateEvent,0,TRUE,FALSE,0		; 0,FALSE,FALSE - autoreset event
	mov		ovr.hEvent,eax
	invoke	CreateEvent,0,TRUE,FALSE,0		; 0,FALSE,FALSE - autoreset event
	mov		ovr2.hEvent,eax
	
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
			.endif
		.endif
		invoke	ClearCommError,hCOM,addr ErrorMask,addr ComStat
		invoke	ReadFile,hCOM,addr inbuf,ComStat.cbInQue,addr cGot,addr ovr
		.if cGot > 0
			invoke	SendMessage,hdlg,WM_DATA_RECEIVED,0,cGot
		.endif
		invoke	ResetEvent,ovr.hEvent
		
	.endw
	
	jmp		only_exit

open_port_error:
	
	invoke	OnOff,0
	
only_exit:

	ret

ThreadProc endp

;-------------------------------------------------------------
; OnOff
;
; [in] param =0/1 (on/off thread), =2 (flip threads state)
;-------------------------------------------------------------

OnOff proc param:DWORD

onoff_again:

	.if param == 2
		xor		Start,1
	.else
		push	param
		pop		Start
	.endif

	.if Start == 1
		
		mov		c64_on,0
		mov		syn_on,0
		
		xor		ebx,ebx
		invoke	ShowHideIntf
		
		invoke	OpenLog
			;error?
			or		eax,eax
			jnz		@F
			invoke	MessageBox,hdlg,addr errOpenLog,addr errTitle,MB_OK or MB_ICONERROR
			mov		param,0
			jmp		onoff_again
	@@:
		invoke	CleanData
		invoke	SetDlgItemText,hdlg,IDC_DO,addr sStop
			;reset visible counters of total bytes/packets
			invoke	SetDlgItemInt,hdlg,IDC_BYTES,0,FALSE
			invoke	SetDlgItemInt,hdlg,IDC_PACKETS,0,FALSE
		mov		ThreadOn,1
		invoke	CreateThread,NULL,NULL,addr ThreadProc,NULL,0,addr ThreadID
		invoke	CloseHandle,eax
		
	.else
		
		;invoke	CloseHandle,hFile2		;TEST-FILE
		mov		c64_on,0
		mov		syn_on,0
		invoke	SetDlgItemText,hdlg,IDC_SYN,addr syn_ready
		
		mov		ebx,TRUE
		invoke	ShowHideIntf
		
		invoke	CloseLog
		mov		ThreadOn,0
		invoke	CloseHandle,ovr.hEvent
		invoke	CloseHandle,ovr2.hEvent
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
	xor		ebx,1
	invoke	GetDlgItem,hdlg,IDC_SEND
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_SYN
	invoke	EnableWindow,eax,ebx
	xor		ebx,1
;	invoke	GetDlgItem,hdlg,IDC_USELOG
;	invoke	EnableWindow,eax,ebx
	
	.if logUse==1
		push	logUse
		mov		logUse,ebx
		mov		esi,1
		invoke	LogUseShow
		pop		logUse
	.endif
	
	invoke		c64_Intf
	
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
;			invoke	GetDlgItem,hdlg,IDC_MARK
;			invoke	EnableWindow,eax,FALSE
			invoke	GetDlgItem,hdlg,IDC_SETMARK
			invoke	EnableWindow,eax,FALSE
		.endif
	.else
		.if Start == 0	; if it's idle then show all settings of log-file
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
		.endif
		.if esi == 0
			invoke	GetDlgItem,hdlg,IDC_LBLLOGSIZE
			invoke	EnableWindow,eax,TRUE
			invoke	GetDlgItem,hdlg,IDC_LOGSIZE
			invoke	EnableWindow,eax,TRUE
;			invoke	GetDlgItem,hdlg,IDC_MARK
;			invoke	EnableWindow,eax,TRUE
			invoke	GetDlgItem,hdlg,IDC_SETMARK
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
	invoke	SetDlgItemText,hdlg,IDC_HEX,ebx
	invoke	SetDlgItemText,hdlg,IDC_BIN,ebx
	
	ret

CleanData endp

;-------------------------------------------------------------
; OpenLog
;-------------------------------------------------------------

OpenLog proc

	mov		logDefaultUsed,0
	
openlog_again:

	invoke	SendDlgItemMessage,hdlg,IDC_REWRITELOG,BM_GETCHECK,0,0
	.if eax==BST_CHECKED
		mov		logRewrite,1

	.else
		mov		logRewrite,0
	.endif
	
;	.if logUse==1
	
		.if logDefault==1
			lea		esi,fbuf_def
			mov		logDefaultUsed,1
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
			invoke	SetDlgItemInt,hdlg,IDC_LOGSIZE,eax,FALSE		;show size
			.if logRewrite==0
				invoke	GetFileSize,hFile,NULL
				invoke	SetFilePointer,hFile,eax,NULL,FILE_BEGIN
			.endif
			mov		eax,TRUE
		.else
			.if logDefaultUsed == 0
				mov		logDefaultUsed,1
				mov		ax,IDC_DEFAULTLOG
				invoke	SendMessage,hdlg,WM_COMMAND,eax,0
				invoke	CheckDlgButton,hdlg,IDC_DEFAULTLOG,BST_CHECKED
				jmp		openlog_again
			.else
				xor		eax,eax
			.endif
		.endif
		
;	.endif		; .if logUse==1
	
	ret		; eax = 0 -> error	

OpenLog endp

;-------------------------------------------------------------
; CloseLog
;-------------------------------------------------------------

CloseLog proc
	
	invoke	CloseHandle,hFile
	
	ret

CloseLog endp

;-------------------------------------------------------------
; CalcParams
;
; Calc other params (U0,k,Alpha) by cfg.u?? and cfg.g
;-------------------------------------------------------------

CalcParams proc uses ebx esi edi

	; convert params into <double>
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	mov		esi,offset cfg.u24
	lea		edi,u24
	mov		ecx,9
@@:
	push	ecx
	push	esi
	push	edi
	invoke	StrToFloat,esi,edi
	pop		edi
	pop		esi
	pop		ecx
	sub		esi,fp64_size
	sub		edi,8
	loop	@B
	
	; calc other params (U0,k,Alpha)
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	finit
	
	; u10
	fld		u11
	fld		u13
	fadd
	mov		diver,2
	fild	diver
	fdiv
	fstp	u10
	; k1
	fld		u12
	fld		u14
	fsub
	fild	diver
	fdiv
	fld		g
	fdiv
	fstp	k1
	; a1
	fld		u11
	fld		u13
	fsub
	fild	diver
	fdiv
	fld		k1
	fdiv
	fld		g
	fdiv
	fstp	a1
	
	; u20
	fld		u22
	fld		u24
	fadd
	mov		diver,2
	fild	diver
	fdiv
	fstp	u20
	; k2
	fld		u21
	fld		u23
	fsub
	fild	diver
	fdiv
	fld		g
	fdiv
	fstp	k2
	; a2
	fld		u22
	fld		u24
	fsub
	fild	diver
	fdiv
	fld		k2
	fdiv
	fld		g
	fdiv
	fstp	a2
	
	; convert new params to text
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	invoke	FloatToStr2,u10,addr s_u10
	invoke	FloatToStr2,k1,addr s_k1
	invoke	FloatToStr2,a1,addr s_a1
	invoke	FloatToStr2,u20,addr s_u20
	invoke	FloatToStr2,k2,addr s_k2
	invoke	FloatToStr2,a2,addr s_a2
	
	; out new params to dialog
	;~~~~~~~~~~~~~~~~~~~~~~~~~
	
	lea		esi,s_a2
	mov		edi,1061
	mov		ecx,6
@@:
	push	ecx
	invoke	SetDlgItemText,hdlg,edi,esi
	pop		ecx
	sub		esi,ParamOfTableSize
	dec		edi
	loop	@B
	
;calcparams_end:

	ret

CalcParams endp

;-------------------------------------------------------------
; c64_Intf
;
; Show/Hide calc64 interface
;-------------------------------------------------------------

c64_Intf proc
	
	.if Start == 0
		invoke	GetDlgItem,hdlg,IDC_CALC64_0
		invoke	EnableWindow,eax,FALSE
		invoke	GetDlgItem,hdlg,IDC_CALC64_90
		invoke	EnableWindow,eax,FALSE
		invoke	GetDlgItem,hdlg,IDC_CALC64_180
		invoke	EnableWindow,eax,FALSE
		invoke	GetDlgItem,hdlg,IDC_CALC64_270
		invoke	EnableWindow,eax,FALSE
		invoke	c64_btn_names
	.else
		invoke	GetDlgItem,hdlg,IDC_CALC64_0
		invoke	EnableWindow,eax,TRUE
		invoke	GetDlgItem,hdlg,IDC_CALC64_90
		invoke	EnableWindow,eax,TRUE
		invoke	GetDlgItem,hdlg,IDC_CALC64_180
		invoke	EnableWindow,eax,TRUE
		invoke	GetDlgItem,hdlg,IDC_CALC64_270
		invoke	EnableWindow,eax,TRUE
	.endif
	
	ret

c64_Intf endp

;-------------------------------------------------------------
; c64_btn_names
;
; Set normal names of buttons (0,90,180,270)
;-------------------------------------------------------------

c64_btn_names proc
	
	invoke	SetDlgItemText,hdlg,IDC_CALC64_0,addr c64_0
	invoke	SetDlgItemText,hdlg,IDC_CALC64_90,addr c64_90
	invoke	SetDlgItemText,hdlg,IDC_CALC64_180,addr c64_180
	invoke	SetDlgItemText,hdlg,IDC_CALC64_270,addr c64_270						
	
	ret

c64_btn_names endp

;-------------------------------------------------------------
; CheckHexStr
;
; Check ASCIIZ for right HEX-symbols and
; wrong symbols will be set in zero ('0')
;-------------------------------------------------------------

CheckHexStr proc uses esi lpstr:DWORD
	
	mov		esi,lpstr
	cld
@@:
	lodsb
	or		al,al
	jz		@F
	.if al < 30h || (al > 39h && al < 41h) || al > 46h
		mov		byte ptr [esi-1],30h
	.endif
	jmp @B
@@:
	ret

CheckHexStr endp

;-------------------------------------------------------------
; ExtractHex
;
; Get string with hex-value and save it to word
;-------------------------------------------------------------

ExtractHex proc uses ebx esi lpString:DWORD,lpWord:DWORD
	
	mov		esi,lpString
	cld
	xor		ebx,ebx
	mov		ecx,4
@@:
	lodsb
	or		al,al
	jz		@F
	cmp		al,39h
	ja		al_a_39h
	sub		al,30h			; if al = '0'-'9'
	jmp		save_tetra
al_a_39h:
	sub		al,37h			; if al = 'A'-'F'
save_tetra:
	add		bl,al
	shl		ebx,4
	loop	@B
	
@@:
	shr		ebx,4
	mov		esi,lpWord
	mov		word ptr [esi],bx			;What The Fuck ???
	
	ret

ExtractHex endp

comment `#####################################################
#
#  Help System
#
##############################################################`

;-------------------------------------------------------------
; ShowHelp
;-------------------------------------------------------------

ShowHelp proc
	
	invoke	DialogBoxParam,hInstance,IDD_HELPDIALOG,hdlg,addr HelpDlgProc,NULL
	
	ret

ShowHelp endp

;-------------------------------------------------------------
; HelpDlgProc
;-------------------------------------------------------------

HelpDlgProc proc uses ebx esi edi hwnd:HWND,msg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,msg

	;-------------------------
	; WM_INITDIALOG
	;-------------------------

	.if eax==WM_INITDIALOG
		
		push	hwnd
		pop		hdlg2
		
		; init switching
		;~~~~~~~~~~~~~~~
		mov		HelpMode,1
		invoke	SwitchHelpContext
		
	;-------------------------
	; WM_COMMAND
	;-------------------------
		
	.elseif eax==WM_COMMAND
		
		mov	eax,wParam
		
		.if ax==IDC_HELPEXIT
			jmp		close_help_dialog
		.elseif ax==IDC_SWITCH
			invoke	SwitchHelpContext
		.endif
		
	;-------------------------
	; WM_CLOSE
	;-------------------------
		
	.elseif eax==WM_CLOSE
		
	close_help_dialog:
		
		invoke	EndDialog,hwnd,0
		
	.else
		
		xor		eax,eax
		ret
		
	.endif

	mov		eax,TRUE
	ret

HelpDlgProc endp

;-------------------------------------------------------------
; SwitchHelpContext
;-------------------------------------------------------------

SwitchHelpContext proc
	
	xor		HelpMode,1
	
	.if HelpMode == 0
		invoke	SetWindowText,hdlg2,addr sShowHelp
		invoke	SetDlgItemText,hdlg2,IDC_SWITCH,addr sShowChangesLog
		invoke	SetDlgItemText,hdlg2,IDC_HELPTEXT,addr sHelp
		invoke	SendDlgItemMessage,hdlg2,IDC_HELPTEXT,EM_FMTLINES,TRUE,0
	.else
		invoke	SetWindowText,hdlg2,addr sShowChangesLog
		invoke	SetDlgItemText,hdlg2,IDC_SWITCH,addr sShowHelp
		invoke	SetDlgItemText,hdlg2,IDC_HELPTEXT,addr sChangesLog
		invoke	SendDlgItemMessage,hdlg2,IDC_HELPTEXT,EM_FMTLINES,TRUE,0
	.endif
	
	ret

SwitchHelpContext endp

comment `#####################################################
#
#  Configuration File
#
##############################################################`

;-------------------------------------------------------------
; LoadCfg
;
; load config file and set settings from it
;-------------------------------------------------------------

LoadCfg proc uses ebx esi edi
	
	mov		cfgError,0
	
	; is ffc.cfg exists ? 
	invoke	FindFirstFile,addr cfg_path,addr wfd
	cmp		eax,INVALID_HANDLE_VALUE
	jne		@F
	invoke	CreateCfg
		;error?
		or		eax,eax
		jnz		loadcfg_set_settings
		mov		cfgError,1
		jmp		loadcfg_set_settings
@@:
	invoke	LoadCfgFile
		;error?
		or		eax,eax
		jnz		@F
		mov		cfgError,2
		invoke	CreateCfg
@@:
	
	; set settings
	;~~~~~~~~~~~~~
loadcfg_set_settings:

	invoke	SendDlgItemMessage,hdlg,IDC_PORT,CB_SETCURSEL,cfg.com_id,0
	invoke	SendDlgItemMessage,hdlg,IDC_SPEED,CB_SETCURSEL,cfg.com_speed,0
	invoke	SendDlgItemMessage,hdlg,IDC_PARITY,CB_SETCURSEL,cfg.com_parity,0
	invoke	SendDlgItemMessage,hdlg,IDC_STOPBITS,CB_SETCURSEL,cfg.com_stopbits,0

	invoke	SetDlgItemText,hdlg,IDC_FF,addr cfg.pkt_id
	invoke	SetDlgItemText,hdlg,IDC_LOGFILENAME,addr cfg.log_filename
	invoke	SetDlgItemText,hdlg,IDC_NUM,addr cfg.bytes_num
		
	xor		eax,eax
	mov		al,cfg.log_cfg
	mov		bl,al
	and		al,1
		mov		logUse,eax
	mov		al,bl
	and		al,10b
	shr		al,1
		mov		logDefault,eax
	mov		al,bl
	and		al,100b
	shr		al,2
		mov		logRewrite,eax
		
	.if logUse == 1
		invoke	CheckDlgButton,hdlg,IDC_USELOG,BST_CHECKED
	.endif
	.if logDefault == 1
		invoke	CheckDlgButton,hdlg,IDC_DEFAULTLOG,BST_CHECKED
	.endif
	.if logRewrite == 1
		invoke	CheckDlgButton,hdlg,IDC_REWRITELOG,BST_CHECKED
	.endif
	xor		esi,esi
	invoke	LogUseShow
	
	; table
	mov		DontCalcParams,1
	mov		esi,offset cfg.u24
	mov		edi,IDC_U24
	cld
	mov		ecx,9
@@:
	push	ecx
	invoke	SetDlgItemText,hdlg,edi,esi
	pop		ecx
	sub		esi,fp64_size
	dec		edi
	loop	@B
	mov		DontCalcParams,0
	
	; calc64 system
	finit
	fld1
	fild	cfg.c64_count_max
	fyl2x
	fistp	c64_shr
	
	; kt
	lea		edi,checkhex_buf
	lea		ebx,HexTable
	cld
	mov		cx,cfg.kt
	mov		al,ch
	Bin2Hex
	mov		al,cl
	Bin2Hex
	xor		al,al
	stosb
	invoke	SetDlgItemText,hdlg,IDC_KT,addr checkhex_buf
	
	; check if size is zero (it can be with old config) - checks by height+width only ! it's enough
	cmp		cfg.wnd_rect.bottom,0	;height
	jz		@F
	cmp		cfg.wnd_rect.right,0	;width
	jnz		wnd_rect_is_normal
	; set defaults
@@:
	push	_wnd_rect.left
	pop		cfg.wnd_rect.left
	push	_wnd_rect.top
	pop		cfg.wnd_rect.top
	push	_wnd_rect.right
	pop		cfg.wnd_rect.right
	push	_wnd_rect.bottom
	pop		cfg.wnd_rect.bottom
	
wnd_rect_is_normal:

	; position and size of window
	invoke	SetWindowPos,hdlg,NULL,
		cfg.wnd_rect.left,
		cfg.wnd_rect.top,
		cfg.wnd_rect.right,
		cfg.wnd_rect.bottom,
		SWP_NOZORDER

	ret

LoadCfg endp

;-------------------------------------------------------------
; SaveCfg
;
; get settings from dialog and save it to config file
;-------------------------------------------------------------

SaveCfg proc uses ebx esi edi
	
	invoke	SendDlgItemMessage,hdlg,IDC_PORT,CB_GETCURSEL,0,0
	mov		cfg.com_id,eax
	invoke	SendDlgItemMessage,hdlg,IDC_SPEED,CB_GETCURSEL,0,0
	mov		cfg.com_speed,eax
	invoke	SendDlgItemMessage,hdlg,IDC_PARITY,CB_GETCURSEL,0,0
	mov		cfg.com_parity,eax
	invoke	SendDlgItemMessage,hdlg,IDC_STOPBITS,CB_GETCURSEL,0,0
	mov		cfg.com_stopbits,eax
	
	invoke	GetDlgItemText,hdlg,IDC_FF,addr cfg.pkt_id,3
	
;	mov		eax,logUse
;	mov		bl,al
;	mov		eax,logDefault
;	shl		al,1
;	or		bl,al
;	mov		eax,logRewrite
;	shl		al,2
;	or		bl,al
;	mov		cfg.log_cfg,bl
	invoke	IsDlgButtonChecked,hdlg,IDC_USELOG
	.if eax == BST_CHECKED
		mov		al,1
	.endif
	mov		bl,al
	invoke	IsDlgButtonChecked,hdlg,IDC_DEFAULTLOG
	.if eax == BST_CHECKED
		mov		al,2
	.endif
	or		bl,al
	invoke	IsDlgButtonChecked,hdlg,IDC_REWRITELOG
	.if eax == BST_CHECKED
		mov		al,4
	.endif
	or		bl,al
	mov		cfg.log_cfg,bl
	
	invoke	GetDlgItemText,hdlg,IDC_LOGFILENAME,addr cfg.log_filename,FileNameSize
	
	invoke	GetDlgItemText,hdlg,IDC_NUM,addr cfg.bytes_num,BytesNumSize
	
	invoke	GetDlgItemText,hdlg,IDC_KT,addr checkhex_buf,CheckHexSize
	invoke	ExtractHex,addr checkhex_buf,offset cfg.kt
	
	; position and size of window
	invoke	GetWindowRect,hdlg,offset cfg.wnd_rect
	mov		eax,cfg.wnd_rect.left
	sub		cfg.wnd_rect.right,eax
	mov		eax,cfg.wnd_rect.top
	sub		cfg.wnd_rect.bottom,eax
	
	
	invoke	SaveCfgFile
	
	ret

SaveCfg endp

;-------------------------------------------------------------
; CreateCfg
;
; create new config file and save defaults to it
;-------------------------------------------------------------

CreateCfg proc
	
	;---------------------------------
	; set config file defaults
	;---------------------------------
		
		; warning message
		;~~~~~~~~~~~~~~~~
	lea		esi,cfg_warning_msg
	lea		edi,cfg.msg
	mov		ecx,sizeof cfg.msg
	cld
	rep	movsb
		
		; com-port settings
		;~~~~~~~~~~~~~~~~~~
	mov		cfg.com_id, port_default
	mov		cfg.com_speed, speed_default
	mov		cfg.com_parity, parity_default
	mov		cfg.com_stopbits, stopbits_default
		
		; packet id
		;~~~~~~~~~~
	push	_pkt_id
	pop		dword ptr cfg.pkt_id
		
		; log file settings
		;~~~~~~~~~~~~~~~~~~
	mov		al,_log_cfg
	mov		cfg.log_cfg,al
	mov		byte ptr cfg.log_filename,0			; null string
	
		; 'BIN' bytes numbers
		;~~~~~~~~~~~~~~~~~~~~
	mov		byte ptr cfg.bytes_num,0			; null string
	
		; table values
		;~~~~~~~~~~~~~
	lea		esi,_u24
	mov		edi,offset cfg.u24
	cld
	mov		ecx,9
@@:
	push	ecx
	mov		ecx,table_value_size
	rep movsb
	pop		ecx
	sub		esi,table_value_size*2
	sub		edi,fp64_size+table_value_size
	loop	@B
	
		; calc64 system
		;~~~~~~~~~~~~~~
	mov		cfg.c64_count_max, _c64_count_max
	mov		cfg.hex_u11, _hex_u11
	mov		cfg.hex_u12, _hex_u12
	mov		cfg.hex_u13, _hex_u13
	mov		cfg.hex_u14, _hex_u14
	mov		cfg.hex_u21, _hex_u21
	mov		cfg.hex_u22, _hex_u22
	mov		cfg.hex_u23, _hex_u23
	mov		cfg.hex_u24, _hex_u24
	
	mov		cfg.kt,_kt
	
		; position and size of window
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	push	_wnd_rect.left
	pop		cfg.wnd_rect.left
	push	_wnd_rect.top
	pop		cfg.wnd_rect.top
	push	_wnd_rect.right
	pop		cfg.wnd_rect.right
	push	_wnd_rect.bottom
	pop		cfg.wnd_rect.bottom
	
	;---------------------------------
	; save new default config file
	;---------------------------------
	
	invoke	SaveCfgFile
	
	ret		; eax = 0 -> error

CreateCfg endp

;-------------------------------------------------------------
; SaveCfgFile
;
; save cfg structure to config file
;-------------------------------------------------------------

SaveCfgFile proc

	invoke	CreateFile,\
					addr cfg_path,\
					GENERIC_WRITE,\
					NULL,\
					NULL,\
					CREATE_ALWAYS,\
					FILE_ATTRIBUTE_ARCHIVE,\
					NULL
	
	.if eax != INVALID_HANDLE_VALUE
		
		mov		hcfg,eax
		invoke	WriteFile,hcfg,addr cfg,sizeof cfg,addr cfg_got,NULL
		IfEAXZeroJmpTo	savecfgfile_error
		invoke	CloseHandle,hcfg
		mov		eax,TRUE
		
	.else
		
	savecfgfile_error:
		invoke	CloseHandle,hcfg
		xor		eax,eax
		
	.endif
		
	ret		; eax = 0 -> error

SaveCfgFile endp

;-------------------------------------------------------------
; LoadCfgFile
;
; load cfg structure from config file
;-------------------------------------------------------------

LoadCfgFile proc
	
	invoke	CreateFile,\
					addr cfg_path,\
					GENERIC_READ,\
					FILE_SHARE_READ,\
					NULL,\
					OPEN_EXISTING,\
					FILE_ATTRIBUTE_ARCHIVE,\
					NULL
	
	.if eax != INVALID_HANDLE_VALUE
		
		mov		hcfg,eax
		invoke	ReadFile,hcfg,addr cfg,sizeof cfg,addr cfg_got,NULL
		IfEAXZeroJmpTo	loadcfgfile_error
		invoke	CloseHandle,hcfg
		mov		eax,TRUE
		
	.else
		
	loadcfgfile_error:
		invoke	CloseHandle,hcfg
		xor		eax,eax
		
	.endif
		
	ret		; eax = 0 -> error

LoadCfgFile endp

end start

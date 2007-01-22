comment `#####################################################
#
#  ffc.asm    07.02.2006 by fnt0m32 'at' gmail.com
#
#  FF Catcher v0.9.4
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
include	ffc_help.inc	; help dialog's data
include ffc_cfg.inc		; config file's data

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
		
		; load and set configuration
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	LoadCfg
		
		;-----------------------------
		; init tooltips
		;-----------------------------
		mov		ti.cbSize,sizeof TOOLINFO
		mov		ti.uFlags,TTF_IDISHWND or TTF_SUBCLASS
		
			; Mark edit
			;~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_MARK
			mov		ti.uId,eax
			lea		eax,ttmMark
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; SetMark button
			;~~~~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_SETMARK
			mov		ti.uId,eax
			lea		eax,ttmSetMark
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Help button
			;~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_HELPP
			mov		ti.uId,eax
			lea		eax,ttmHelpp
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; About button
			;~~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_ABOUT
			mov		ti.uId,eax
			lea		eax,ttmAbout
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Exit button
			;~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_EXIT
			mov		ti.uId,eax
			lea		eax,ttmExit
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; OpenLog button
			;~~~~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_OPENLOG
			mov		ti.uId,eax
			lea		eax,ttmOpenLog
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; LogFileName edit
			;~~~~~~~~~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_LOGFILENAME
			mov		ti.uId,eax
			lea		eax,ttmLogFileName
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Bin edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_BIN
			mov		ti.uId,eax
			lea		eax,ttmBin
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Hex edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_HEX
			mov		ti.uId,eax
			lea		eax,ttmHex
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Dec edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_DEC
			mov		ti.uId,eax
			lea		eax,ttmDec
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; Deg edit
			;~~~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_DEG
			mov		ti.uId,eax
			lea		eax,ttmDeg
			mov		ti.lpszText,eax
			invoke	SendMessage,hTT,TTM_ADDTOOL,NULL,addr ti
			
			; G edit
			;~~~~~~~
			invoke	GetDlgItem,hwnd,IDC_G
			mov		ti.uId,eax
			lea		eax,ttmG
			mov		ti.lpszText,eax
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
		mov		logUseMark,0
		
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
			
		; EN_CHANGE
		;~~~~~~~~~~
		.elseif bx==EN_CHANGE && ax >= 1041 && ax <= 1049
			
			invoke	CalcParams
			
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
			
			invoke	SetDlgItemText,hwnd,IDC_HEX,addr viewbuf
			
			
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
			; arccos ( (v3 - u20) / (k2 * g) - a2 )
			fst		temper
			fld1				; a, 1
			fsubr				; 1-a
			fsqrt				; sqrt(1-a)
			fld1				; sqrt(1-a), 1
			fld		temper		; sqrt(1-a), 1, a
			fadd				; sqrt(1-a), 1+a
			fsqrt				; sqrt(1-a), sqrt(1+a)
			fpatan				; arccos = arctg( sqrt(1-a) / sqrt(1+a) )
			mov		diver,2
			fild	diver
			fmul
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
		
		;invoke	CloseHandle,hFile2
		invoke	OnOff,0
		invoke	DeleteObject,hFont
		invoke	SaveCfg
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
			invoke	GetDlgItem,hdlg,IDC_MARK
			invoke	EnableWindow,eax,FALSE
			invoke	GetDlgItem,hdlg,IDC_SETMARK
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
			invoke	GetDlgItem,hdlg,IDC_MARK
			invoke	EnableWindow,eax,TRUE
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

;-------------------------------------------------------------
; CalcParams
;
; When some item of table (also with 'g=') was changed
; then this proc chage other params (U0,k,Alpha)
;-------------------------------------------------------------

CalcParams proc uses ebx esi edi

	; get params as text
	;~~~~~~~~~~~~~~~~~~~
	
	mov		esi,IDC_U24
	lea		edi,s_u24
	mov		ecx,9	
@@:
	push	ecx
	invoke	GetDlgItemText,hdlg,esi,edi,ParamOfTableSize
	pop		ecx
	dec		esi
	sub		edi,ParamOfTableSize
	loop	@B
	
	; cut unused symbols from params
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	; convert params into <double>
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	lea		esi,s_u24
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
	sub		esi,ParamOfTableSize
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
	
	
	ret

CalcParams endp

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
	
	; is ffc.cfg exists ? 
	invoke	FindFirstFile,addr cfg_path,addr wfd
	cmp		eax,INVALID_HANDLE_VALUE
	jne		@F
	invoke	CreateCfg
@@:
	invoke	LoadCfgFile
	
	; set settings
	;~~~~~~~~~~~~~

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
	
	; it isn't effective - there must be loop :)
	invoke	GetDlgItemText,hdlg,IDC_G,addr cfg.g,sizeof fp64_size
	invoke	GetDlgItemText,hdlg,IDC_U11,addr cfg.u11,sizeof fp64_size
	invoke	GetDlgItemText,hdlg,IDC_U12,addr cfg.u12,sizeof fp64_size
	invoke	GetDlgItemText,hdlg,IDC_U13,addr cfg.u13,sizeof fp64_size
	invoke	GetDlgItemText,hdlg,IDC_U14,addr cfg.u14,sizeof fp64_size
	invoke	GetDlgItemText,hdlg,IDC_U21,addr cfg.u21,sizeof fp64_size
	invoke	GetDlgItemText,hdlg,IDC_U22,addr cfg.u22,sizeof fp64_size
	invoke	GetDlgItemText,hdlg,IDC_U23,addr cfg.u23,sizeof fp64_size
	invoke	GetDlgItemText,hdlg,IDC_U24,addr cfg.u24,sizeof fp64_size
	
	
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
	mov		cfg.com_id,0
	mov		cfg.com_speed,6
	mov		cfg.com_parity,0
	mov		cfg.com_stopbits,0
		
		; packet id
		;~~~~~~~~~~
	mov		dword ptr cfg.pkt_id,00004646h		; db "FF",0,0
		
		; log file settings
		;~~~~~~~~~~~~~~~~~~
	mov		cfg.log_cfg,03h						; log use = 1, standart log = 1
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
	
	;---------------------------------
	; save new default config file
	;---------------------------------
	
	invoke	SaveCfgFile
	
	ret

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
	.if eax == INVALID_HANDLE_VALUE
		ret
	.endif
	
	mov		hcfg,eax
	invoke	WriteFile,hcfg,addr cfg,sizeof cfg,addr cfg_got,NULL
	invoke	CloseHandle,hcfg
	
	ret

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
	.if eax == INVALID_HANDLE_VALUE
		ret
	.endif
	
	mov		hcfg,eax
	invoke	ReadFile,hcfg,addr cfg,sizeof cfg,addr cfg_got,NULL
	invoke	CloseHandle,hcfg
	
	ret

LoadCfgFile endp

end start

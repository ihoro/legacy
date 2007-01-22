	;-------------------------------------
	; get number of field to calc
	;-------------------------------------

	mov		Field,0			;number of empty field that will be calced
	mov		ebx,IDC_EDT_1	;init first ID of edit control

@@:
	invoke	GetDlgItemText,hwnd,ebx,addr buf,_LimitText4Edit
	.if eax == 0
		.if Field == 0
			lea		edx,[ebx-IDC_EDT_1+1]
			mov		Field,dl
		.else
			invoke	MessageBox,hwnd,addr errEmptyFields,addr errError,MB_OK or MB_ICONERROR
			invoke	GetDlgItem,hwnd,ebx
			invoke	SetFocus,eax
			jmp		end_dlg_proc	;ret
		.endif
	.else
		.if ebx != IDC_EDT_3
			invoke	CheckFloat,addr buf
			.if eax == FALSE
				invoke	MessageBox,hwnd,addr errInvalidNumber,addr errError,MB_OK or MB_ICONERROR
				invoke	GetDlgItem,hwnd,ebx
				invoke	SetFocus,eax
				jmp		end_dlg_proc	;ret
			.endif
		.else
			invoke	GetDlgItemInt,hwnd,ebx,addr errVar,FALSE
			.if errVar == FALSE
				invoke	MessageBox,hwnd,addr errInvalidNumber,addr errError,MB_OK or MB_ICONERROR
				invoke	GetDlgItem,hwnd,ebx
				invoke	SetFocus,eax
				jmp		end_dlg_proc	;ret
			.endif
		.endif
	.endif
	inc		ebx
	cmp		ebx,IDC_EDT_4+1
	jne		@B

	.if (Field == 0) && (LastField == 0)
		invoke	MessageBox,hwnd,addr errAllFull,addr errError,MB_OK or MB_ICONERROR
		jmp		end_dlg_proc		;ret
	.endif
	
	.if Field == 0
		mov		ah,LastField
		mov		Field,ah
	.endif
	
	;-------------------------------------
	; Calc [Start]
	;-------------------------------------
	
	.if 	Field == 1
	
		; get params
		;~~~~~~~~~~~
		invoke	GetDlgItemText,hwnd,IDC_EDT_2,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fPercent
		invoke	GetDlgItemText,hwnd,IDC_EDT_4,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fResult
		invoke	GetDlgItemInt,hwnd,IDC_EDT_3,addr errVar,FALSE
		
		; calc
		;~~~~~
		finit
		fld		fResult		;R
		fld		fPercent	;R , P
		mov		errVar,100
		fild	errVar		;R , P , 100
		fdiv				;R , P/100
		fld1				;R , P/100 , 1
		fadd				;R , P/100+1
		mov		errVar,eax
		fild	errVar		;R , P/100+1 , N
		invoke	fpu_pow		;R , (P/100+1)^N
		fdiv				;R/(P/100+1)^N
		fstp	fStart
		
		; show result
		;~~~~~~~~~~~~
		invoke	FloatToStr2,fStart,addr buf
		invoke	SetDlgItemText,hwnd,IDC_EDT_1,addr buf
	
	;-------------------------------------
	; Calc [Percent]
	;-------------------------------------
	
	.elseif Field == 2
	
		; get params
		;~~~~~~~~~~~
		invoke	GetDlgItemText,hwnd,IDC_EDT_1,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fStart
		invoke	GetDlgItemText,hwnd,IDC_EDT_4,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fResult
		invoke	GetDlgItemInt,hwnd,IDC_EDT_3,addr errVar,FALSE
		
		; calc
		;~~~~~
		finit
		fld		fResult		;R
		fld		fStart		;R , S
		fdiv				;R/S
		fld1				;R/S , 1
		mov		errVar,eax
		fild	errVar		;R/S , 1 , N
		fdiv				;R/S , 1/N
		invoke	fpu_pow		;(R/S)^(1/N)
		fld1				;(R/S)^(1/N) , 1
		fsub				;(R/S)^(1/N)-1
		mov		errVar,100
		fild	errVar		;(R/S)^(1/N)-1 , 100
		fmul				;((R/S)^(1/N)-1)*100
		fstp	fPercent
		
		; show result
		;~~~~~~~~~~~~
		invoke	FloatToStr2,fPercent,addr buf
		invoke	SetDlgItemText,hwnd,IDC_EDT_2,addr buf
	
	;-------------------------------------
	; Calc [N]
	;-------------------------------------
	
	.elseif Field == 3
		
		; get params
		;~~~~~~~~~~~
		invoke	GetDlgItemText,hwnd,IDC_EDT_1,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fStart
		invoke	GetDlgItemText,hwnd,IDC_EDT_2,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fPercent
		invoke	GetDlgItemText,hwnd,IDC_EDT_4,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fResult
		
		; calc
		;~~~~~
		finit
		fld1				;1
		fld		fResult		;1 , R
		fld		fStart		;1 , R , S
		fdiv				;1 , R/S
		fyl2x				;1*log2(R/S)
		fld1				;1*log2(R/S) , 1
		fld		fPercent	;1*log2(R/S) , 1 , P
		mov		errVar,100
		fidiv	errVar		;1*log2(R/S) , 1 , P/100
		fyl2xp1				;1*log2(R/S) , 1*log2(P/100+1)
		fdiv				;1*log2(R/S)/1*log2(P/100+1)
		fstcw	cwr						;get cwr
		or		cwr,0000100000000000b	;rc=10b a<x<b -> x=b
		fldcw	cwr						;set cwr
		frndint
		fistp	errVar		;save result [N]
		
		; show result
		;~~~~~~~~~~~~
		invoke	SetDlgItemInt,hwnd,IDC_EDT_3,errVar,FALSE
		
	;-------------------------------------
	; Calc [Result]
	;-------------------------------------
	
	.elseif Field == 4
		
		; get params
		;~~~~~~~~~~~
		invoke	GetDlgItemText,hwnd,IDC_EDT_1,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fStart
		invoke	GetDlgItemText,hwnd,IDC_EDT_2,addr buf,_LimitText4Edit
		invoke	StrToFloat,addr buf,addr fPercent
		invoke	GetDlgItemInt,hwnd,IDC_EDT_3,addr errVar,FALSE
		
		; calc
		;~~~~~
		finit
		fld		fPercent		;P
		mov		errVar,100
		fidiv	errVar			;P/100
		fld1					;P/100 , 1
		fadd					;P/100+1
		mov		errVar,eax
		fild	errVar			;P/100+1 , N
		invoke	fpu_pow			;(P/100+1)^N
		fld		fStart			;(P/100+1)^N , S
		fmul					;S*(P/100+1)^N
		fstp	fStart
		
		; show result
		;~~~~~~~~~~~~
		invoke	FloatToStr2,fStart,addr buf
		invoke	SetDlgItemText,hwnd,IDC_EDT_4,addr buf
		
	.endif

	; save last field
	;~~~~~~~~~~~~~~~~
	mov		ah,Field
	mov		LastField,ah

	invoke	InvalidateRect,hwnd,NULL,FALSE
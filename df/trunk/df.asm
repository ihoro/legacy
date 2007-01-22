comment `#####################################################
#
#  df.asm    11.08.05 by fnt0m32 'at' gmail.com
#
#  Data Filter v0.2
#
#  Used [MASM32 v8.2]
#
##############################################################`

.386
.model flat, stdcall
option casemap :none

;-------------------------------------------------------------
; inc,lib,data,data?,const,equ
;-------------------------------------------------------------

include df.inc

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
		
		mov		ThreadOn,0
		
		invoke	SetDlgItemText,hwnd,IDC_DO,addr szDo
		
		; set color of progress bar
		;~~~~~~~~~~~~~~~~~~~~~~~~~
		invoke	SendDlgItemMessage,hwnd,IDC_PROGRESS,PBM_SETBARCOLOR,0,00009800h
		
		; set icon
		;~~~~~~~~~
		invoke	LoadIcon,hInstance,IDC_APPICON
		mov		hIcon,eax
		invoke	SendMessage,hwnd,WM_SETICON,ICON_BIG,hIcon
		
		; set titles
		;~~~~~~~~~~~
		invoke	SendMessage,hwnd,WM_SETTEXT,0,addr sAbout0
		
		; init Type ComboBox
		;~~~~~~~~~~~~~~~~~~~
		lea		esi,sType1
		mov		ecx,type_count
	@@:
		push	ecx
		invoke	SendDlgItemMessage,hwnd,IDC_TYPE,CB_ADDSTRING,0,esi
		pop		ecx	
		lea		esi,[esi+type_size]
		loop	@B
		invoke	SendDlgItemMessage,hwnd,IDC_TYPE,CB_SETCURSEL,0,0
		
		; init ofn
		;~~~~~~~~~
		mov		ofn.lStructSize,sizeof ofn		;size
		push	hwnd
		pop		ofn.hwndOwner					;hwnd
		push	hInstance
		pop		ofn.hInstance					;instance
		mov		ofn.lpstrFilter,offset ofnFilter;filter
		mov		byte ptr fbuf_in,0				;first byte must be NULL
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
				invoke	SendDlgItemMessage,hwnd,IDC_INPUTFILE,WM_SETTEXT,0,eax
				
				lea		eax,fbuf_out
				add		eax,ebx
				invoke	SendDlgItemMessage,hwnd,IDC_OUTPUTFILE,WM_SETTEXT,0,eax
				
				invoke	GetDlgItem,hwnd,IDC_DO
				invoke	EnableWindow,eax,TRUE
				invoke	SendMessage,hwnd,DM_SETDEFID,IDC_DO,0
				
				invoke	SetDlgItemText,hwnd,IDC_STATUS,addr szReady
				
			.endif
			
		; DO button
		;~~~~~~~~~~
		.elseif ax==IDC_DO
			
			.if ThreadOn != 0
				mov		ThreadOn,0
				invoke	SetDlgItemText,hwnd,IDC_STATUS,addr szReady
				invoke	CloseHandles
				jmp		end_proc
			.endif
			
			; get params
			;~~~~~~~~~~~
			invoke	SendDlgItemMessage,hwnd,IDC_TYPE,CB_GETCURSEL,0,0
			mov		pType,eax
			
			invoke	GetDlgItemInt,hwnd,IDC_NUMBER,addr erri,FALSE
			mov		pNumber,eax
			
			.if eax==0
				invoke	MessageBox,hwnd,addr errInt,addr errTitle,MB_ICONERROR or MB_OK
				invoke	GetDlgItem,hwnd,IDC_NUMBER
				invoke	SetFocus,eax
				jmp		end_proc
			.endif
			
			xor		ebx,ebx
			
			invoke	GetDlgItemText,hwnd,IDC_FROM,addr buf,buf_size
			invoke	CheckFloat,addr buf
			.if eax==0
				invoke	MessageBox,hwnd,addr errFloat,addr errTitle,MB_ICONERROR or MB_OK
				invoke	GetDlgItem,hwnd,IDC_FROM
				invoke	SetFocus,eax
				jmp		end_proc
			.endif
			invoke	StrToFloat,addr buf,addr pFrom
			
			invoke	GetDlgItemText,hwnd,IDC_TO,addr buf,buf_size
			invoke	CheckFloat,addr buf
			.if eax==0
				invoke	MessageBox,hwnd,addr errFloat,addr errTitle,MB_ICONERROR or MB_OK
				invoke	GetDlgItem,hwnd,IDC_TO
				invoke	SetFocus,eax
				jmp		end_proc
			.endif
			invoke	StrToFloat,addr buf,addr pTo
			
			; open input file
			;~~~~~~~~~~~~~~~~
			invoke	CreateFile, \
						addr fbuf_in, \
						GENERIC_READ, \
						FILE_SHARE_READ, \
						NULL, \
						OPEN_EXISTING, \
						FILE_ATTRIBUTE_ARCHIVE, \
						NULL
			mov		hIn,eax
			
			invoke	GetFileSize,hIn,NULL
			mov		FileSize,eax
			
			invoke	CreateFileMapping,hIn,NULL,PAGE_READONLY,0,0,0
			mov		hMapFile,eax
			invoke	MapViewOfFile,hMapFile,FILE_MAP_READ,0,0,0
			mov		pMemory,eax
			mov		pData,eax
			
			invoke	GetOffset,pData,0,FileSize
			or		eax,eax
			jnz		@F
			mov		ThreadOn,2		; error - not found first GPRMC !
			invoke	SendMessage,hwnd,WM_COMMAND,IDC_DO,0
			jmp		end_proc
		@@:
			mov		esi,pData
			mov		pData,eax		; set new pData
			sub		eax,esi
			sub		FileSize,eax	; get new FileSize
			
			; open output file
			;~~~~~~~~~~~~~~~~~
			invoke	CreateFile, \
						addr fbuf_out, \
						GENERIC_WRITE, \
						FILE_SHARE_READ, \
						NULL, \
						CREATE_ALWAYS, \
						FILE_ATTRIBUTE_ARCHIVE, \
						NULL
			mov		hOut,eax
			
			; disable controls
			;~~~~~~~~~~~~~~~~~
			xor		ebx,ebx
			invoke	EnableControls
			
			; init status
			;~~~~~~~~~~~~
			mov		BytesDone,0
			mov		BytesGot,0
			mov		BlocksDone,0
			invoke	SendDlgItemMessage,hwnd,IDC_PROGRESS,PBM_SETRANGE32,0,FileSize
			invoke	SendDlgItemMessage,hwnd,IDC_PROGRESS,PBM_SETPOS,0,0
			invoke	SetDlgItemInt,hwnd,IDC_BYTES,0,FALSE
			invoke	SetDlgItemInt,hwnd,IDC_BLOCKS,0,FALSE
			invoke	SetDlgItemText,hwnd,IDC_STATUS,addr szDoing
			
			; create thread
			;~~~~~~~~~~~~~~
			mov		ThreadOn,1
			invoke	CreateThread,NULL,NULL,addr ThreadProc,NULL,0,addr ThreadID
			invoke	CloseHandle,eax
			
			invoke	SetDlgItemText,hwnd,IDC_DO,addr szCancel
			
		; ABOUT button
		;~~~~~~~~~~~~~
		.elseif ax==IDC_ABOUT
			
			invoke	ShellAbout,hwnd,addr sAbout0,addr sAbout1,hIcon
			
		; HELP button
		;~~~~~~~~~~~~
		.elseif ax==IDC_HELPP
			
			invoke	MessageBox,hwnd,addr sHelp,addr sHelpTitle,MB_ICONINFORMATION or MB_OK
			
		; EXIT button
		;~~~~~~~~~~~~
		.elseif ax==IDC_EXIT
			
			invoke	SendMessage,hwnd,WM_CLOSE,0,0
			
		.else
		
			jmp		failed
			
		.endif
		
	;-------------------------
	; WM_DONE
	;-------------------------
		
	.elseif eax==WM_DONE
		
		mov		ebx,TRUE
		invoke	EnableControls
		invoke	GetDlgItem,hwnd,IDC_DO
		invoke	SetFocus,eax
		invoke	SetDlgItemText,hwnd,IDC_DO,addr szDo
		invoke	CloseHandles
		
	;-------------------------
	; WM_CLOSE
	;-------------------------

	.elseif eax==WM_CLOSE
		
		invoke	CloseHandles
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
; Enable Controls
;
; [in] ebx = TRUE/FALSE
;-------------------------------------------------------------

EnableControls proc
	
	invoke	GetDlgItem,hdlg,IDC_OPEN
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_TYPE
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_NUMBER
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_FROM
	invoke	EnableWindow,eax,ebx
	invoke	GetDlgItem,hdlg,IDC_TO
	invoke	EnableWindow,eax,ebx
	
	ret

EnableControls endp

;-------------------------------------------------------------
; Close Handles
;-------------------------------------------------------------
CloseHandles proc
	
	invoke	UnmapViewOfFile,pMemory
	invoke	CloseHandle,hMapFile
	invoke	CloseHandle,hIn
	invoke	CloseHandle,hOut
	
	ret

CloseHandles endp

;-------------------------------------------------------------
; Get Offset of sentence
;
; [in] base - start offset
; [in] sentence_type = 0..n (GPRMC,GPGGA,etc)
; [in] search_depth = count of bytes where search
;
; [out] eax = offset of sentence begins with '$'
;             if not found then eax = 0
;-------------------------------------------------------------

GetOffset proc uses ebx edi base:DWORD,sentence_type:DWORD,search_depth:DWORD
	
	mov		eax,sentence_type
	mov		edx,type_size
	mul		edx
	lea		edx,sType1
	lea		edx,[edx+eax]
	mov		ebx,dword ptr [edx]
	
	mov		edi,base
	mov		ecx,search_depth
	
again:
	mov		al,'$'
	cld
	repne scasb
	je		@F
	xor		eax,eax
	jmp		exit
@@:
	cmp		[edi],ebx
	jne		again
	mov		al,byte ptr [edx+4]
	cmp		[edi+4],al
	jne		again
	
	lea		eax,[edi-1]
	
exit:
	
	ret

GetOffset endp

;-------------------------------------------------------------
; check asciiz for right float number (12.06.05 by fnt0m32)
;
; it checks only right symbols like <+-0..9,.eE>
; also change all ',' to '.'
;
; [in] lpszStr - pointer to ASCIIZ
;
; [out] eax = TRUE/FALSE
;-------------------------------------------------------------

CheckFloat proc uses ebx esi lpszStr:DWORD

	jmp		@F
	sym		db "0123456789.eE+"
@@:
	mov		ebx,lpszStr
	
check_char:

	xor		ecx,ecx						;init cycle 
	mov		al,byte ptr [ebx]			;get current char
	mov		esi,0
	.while	ecx <= sizeof sym - 1		;ecx = 0 .. Len(sym)-1
	
		.if al == byte ptr sym[ecx]		;if char is in [sym]
			inc		esi
			.break						;then go to next char or end
		.elseif al == ','				;if char is ','
			mov		byte ptr [ebx],'.'	;change char to '.'
			inc		esi
			.break						;look for next char
		.endif
		
		inc		ecx
		
	.endw
	
	.if esi==0							;if current char is not in [sym]
		xor		eax,eax					;result is FALSE
		ret
	.endif
	
	inc		ebx							;get next char
	.if byte ptr [ebx] == 0				;if it's last char
		mov		eax,TRUE				;then set result
		ret								;and exit
	.else
		jmp		check_char				;else check next char
	.endif

CheckFloat endp

ThreadProc proc uses ebx esi edi lpParam:DWORD

again:

	cmp		ThreadOn,0
	jne		@F
	jmp		exit
@@:
	
	cmp		FileSize,0
	jne		@F
	mov		ThreadOn,0
	invoke	SetDlgItemText,hdlg,IDC_STATUS,addr szDone
	jmp		exit
@@:
	
	; get Current Block Size
	;~~~~~~~~~~~~~~~~~~~~~~~
	mov		esi,pData
	inc		esi
	invoke	GetOffset,esi,0,FileSize
	or		eax,eax
	jne		@F
	push	FileSize
	pop		BlockSize
	jmp		continue
@@:
	mov		esi,pData
	sub		eax,esi
	mov		BlockSize,eax
	
continue:
	
	; search sentence
	;~~~~~~~~~~~~~~~~
	invoke	GetOffset,pData,pType,BlockSize
	or		eax,eax
	jnz		@F
	jmp		dchg
@@:
	
	; search field
	;~~~~~~~~~~~~~
		push	eax
		mov		edi,eax
		mov		al,0Ah
		mov		ecx,BlockSize
		cld
		repne scasb
		mov		ebx,edi
		pop		eax
		sub		ebx,eax		; ebx = size of sentence
		
	mov		edx,pNumber
	inc		edx
	mov		edi,eax
	mov		ecx,ebx
	cld
aga:
	mov		al,','
	mov		esi,edi			; save last ','
	mov		cDone,ecx
	repne scasb
	je		@F
		cmp		edx,1
		je		cont
		jmp		dchg
	cont:
		mov		al,'*'
		mov		edi,esi
		mov		ecx,cDone
		repne scasb
@@:
	dec		edx
	or		edx,edx
	jnz		aga
	
	; check for ",,"
	;~~~~~~~~~~~~~~~
	mov		al,','
	cmp		byte ptr [esi],al
	jne		@F
	finit
	fldz
	fstp	pX
	jmp		compare
@@:
	
	; check for ",*"
	;~~~~~~~~~~~~~~~
	mov		al,'*'
	cmp		byte ptr [esi],al
	jne		@F
	finit
	fldz
	fstp	pX
	jmp		compare
@@:
	
	; convert field to double
	;~~~~~~~~~~~~~~~~~~~~~~~~
	lea		ecx,[edi-1]
	sub		ecx,esi
	lea		edi,buf
	rep movsb
	mov		byte ptr [edi],0
	invoke	StrToFloat,addr buf,addr pX
	
	; compare field
	;~~~~~~~~~~~~~~
compare:
	finit
	fld		pX
	fcom	pFrom
	fstsw	ax
	sahf
	jnb		@F
	jmp		dchg
@@:
	fcom	pTo
	fstsw	ax
	
	sahf
	jbe		@F
	jmp		dchg
@@:
	
	; write block to output file
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~
	invoke	WriteFile,hOut,pData,BlockSize,addr cDone,NULL
	mov		eax,BlockSize
	add		BytesGot,eax
	inc		BlocksDone
	
	; set status
	;~~~~~~~~~~~
	invoke	SetDlgItemInt,hdlg,IDC_BYTES,BytesGot,FALSE
	invoke	SetDlgItemInt,hdlg,IDC_BLOCKS,BlocksDone,FALSE
	
	; change file size and base offset
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dchg:
	mov		eax,BlockSize
	sub		FileSize,eax
	add		pData,eax
	
	; set progress bar
	;~~~~~~~~~~~~~~~~~
	add		BytesDone,eax
	invoke	SendDlgItemMessage,hdlg,IDC_PROGRESS,PBM_SETPOS,BytesDone,0
	
	; search next
	;~~~~~~~~~~~~
	jmp		again
	
exit:

	invoke	SendMessage,hdlg,WM_DONE,0,0

	ret

ThreadProc endp

end start

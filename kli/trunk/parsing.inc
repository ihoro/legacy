; parsing command line
;
; it doesn't use GetCommandLineW/CommandLineToArgvW because they are presented in NT line, if MSDN don't lie :)
	
	
	; shift to end of parameters
	
	invoke	GetCommandLine
	mov		edi,eax
	invoke	szLen, eax
	lea		edi,[edi+eax-1]			; the last char of line
	mov		ebx,eax					; length of entire line


	; read transparency parameter
	
	mov		al,byte ptr [edi]
	sub		al,30h
	jz		@F
	mov		transparent,1
@@:	
	
	
	; read lower parameter
	
	mov		al,byte ptr [edi-2]
	sub		al,30h
	jz		keep_upper_case
	
			; lower lang codes
			mov		ecx,LANG_CODE_COUNT * 2
		low_code:
			mov		al,lang_code[ecx-1]
			cmp		al,20h
			je		@F
			add		al,20h
			mov		lang_code[ecx-1],al
		@@:
			loop	low_code
			
keep_upper_case:


	; read bold parameter
	
	mov		al,byte ptr [edi-4]
	sub		al,30h
	jz		@F
	mov		icon_lf.lfWeight,700			; make bold font
@@:
	
	; trim line
	
	lea		edi,[edi-6]
	mov		byte ptr [edi+1],0
	lea		ebx,[ebx-6]
	
	
	; read both colors
	
	mov		ecx,2
	;std									; i don't understand why it doesn't work. i needed to use it near 'repne scasb' and clear this flag after this command
	
read_next_color:

	mov		al,','
	push	ecx


			; read one color as 'r,g,b'
			
			xor		edx,edx					; it will be a color as 00BBGGRRh	
			mov		ecx,3					; one color reading cycle length
			
		read_next_byte_of_color:
		
			; find separator (comma or space)
			push	ecx						; remember one color reading cycle length
			mov		ecx,ebx					; restore current search depth for one byte (r|g|b)
			or		ecx,ecx					; is it end of line?
			jnz		@F
			jmp		broken_command_line
		@@:
			std
			repne scasb
			cld
			je		@F
			jmp		broken_command_line
		@@:
			; convert sz to number
			push	eax
			push	ecx
			push	edx
			lea		esi,[edi+2]
			invoke	atodw, esi				; result in eax
			pop		edx
				; store number {r|g|b} into edx
				and		eax,0ffh
				shl		edx,8
				or		edx,eax
			pop		ecx
			pop		eax
			; replace found separator by zero byte (end of ASCIIZ)
			mov		byte ptr [edi+1],0
			; read next byte if need
			mov		ebx,ecx					; remember changed search depth for next byte
			pop		ecx
			cmp		ecx,2
			jne		@F
			mov		al,' '					; now it needs to find space char
		@@:
			loop	read_next_byte_of_color
			
			; save this color
			pop		ecx
			cmp		ecx,2
			jne		@F
			mov		icon_bkcolor,edx
			jmp		end_of_reading_one_color
		@@:
			mov		icon_color,edx
			
		end_of_reading_one_color:
		
	
	; read next color if need

	loop	read_next_color
	
	
	; end of parsing
	
	jmp		@F
	
	
	; parsing error
	
broken_command_line:

	; free stuff from stack
	add		esp,8
	; show error message
	invoke	MessageBox, 0, addr err_broken_command_line, addr err_title, MB_OK or MB_ICONERROR
	jmp		just_exit
	
@@:

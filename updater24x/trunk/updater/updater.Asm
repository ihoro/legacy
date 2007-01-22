comment `#####################################################
#
#  updater.asm    09.07.2006 by fnt0m32 'at' gmail.com
#
#  Updater24x v0.0
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

include updater.inc

;-------------------------------------------------------------
; ENTRY POINT
;-------------------------------------------------------------

.code

start:
	
	invoke	GetModuleHandle,NULL
	mov		ebx,eax
	
	; get pointer to rcdata
	;~~~~~~~~~~~~~~~~~~~~~~
	invoke	FindResource,ebx,IDD_RCDATA,RT_RCDATA
	mov		hRes,eax
	invoke	LoadResource,ebx,eax
	invoke	LockResource,eax
	mov		pBase,eax
	
	; get rcdata pointer after filename
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	invoke	SizeofResource,ebx,hRes
	mov		ecx,eax
	mov		edi,pBase
	xor		al,al
	cld
	repne scasb
	je		@F
	
err_updater:
	
	invoke	MessageBox,0,errUpdater,sTitle,MB_OK or MB_ICONERROR
	jmp exit

@@:
	mov		pData,edi						; set pointer after zero byte
	mov		ebx,edi							; for following using
	
	
	; prepare info text
	;~~~~~~~~~~~~~~~~~~
	
	; update for:
	lea		edi,sInfo
	lea		esi,sUpdateFor
	mov		ecx,sizeof sUpdateFor
	rep movsb
	; file name
	mov		esi,pBase
	mov		ecx,pData
	sub		ecx,esi
	dec		ecx
	rep movsb
	mov		al,10
	stosb
	stosb
	; old version
	lea		esi,sOldVersion
	mov		ecx,sizeof sOldVersion
	rep movsb
	; old file size
	invoke	wsprintf,edi,addr sFmt,dword ptr [ebx]
	add		edi,eax
	; bytes
	lea		esi,sBytes
	mov		ecx,sizeof sBytes
	rep movsb
	; date/time of old file
	mov		esi,pData
	lea		esi,[esi + 5]
	mov		ecx,DATETIME_BLOCK_SIZE
	rep movsb
	; new version
	lea		esi,sNewVersion
	mov		ecx,sizeof sNewVersion
	rep movsb
	; new file size	
	invoke	wsprintf,edi,addr sFmt,dword ptr [ebx + 30]
	add		edi,eax
	; bytes
	lea		esi,sBytes
	mov		ecx,sizeof sBytes
	rep movsb
	; date/time of new file
	mov		esi,pData
	lea		esi,[esi + 35]
	mov		ecx,DATETIME_BLOCK_SIZE
	rep movsb
	; message begin
	lea		esi,sMsgBegin
	mov		ecx,sizeof sMsgBegin
	rep movsb
	
	mov		sInfoOffset,edi					; save offset for next additions
	
	
	; try to open file
	;~~~~~~~~~~~~~~~~~
	invoke	CreateFile,pBase,GENERIC_READ or GENERIC_WRITE,0,0,OPEN_EXISTING,0,0
	cmp		eax,INVALID_HANDLE_VALUE
	jne		@F
	
err_file_open:

	lea		esi,errFileOpen
	mov		ecx,sizeof errFileOpen
	cld
	rep movsb
	invoke	MessageBox,0,addr sInfo,addr sTitle,MB_OK or MB_ICONERROR 
	jmp		exit
	
@@:
	mov		hFile,eax
	
	
	; check for old file size
	;~~~~~~~~~~~~~~~~~~~~~~~~
	invoke	GetFileSize,hFile,0
	mov		fSize,eax
	mov		ecx,pData
	cmp		eax,dword ptr [ecx]
	je		@F
	
err_old:

	lea		esi,errOld
	mov		ecx,sizeof errOld
	cld
	rep movsb
	invoke	MessageBox,0,addr sInfo,addr sTitle,MB_OK or MB_ICONERROR
	jmp		exit

@@:


	; calc CRC
	;~~~~~~~~~
	call	openMap
	xor		ah,ah
	mov		esi,mem
	mov		ecx,fSize
	cld
@@:
	lodsb
	xor		ah,al
	loop	@B
	
	; check CRC of old file
	;~~~~~~~~~~~~~~~~~~~~~~
	cmp		ah,byte ptr [ebx + 4]
	je		@F
	jmp		err_old
@@:		
	
	
	; truncate/extend file
	;~~~~~~~~~~~~~~~~~~~~~
	invoke	UnmapViewOfFile,mem
	invoke	CloseHandle,map
	mov		ecx,dword ptr [ebx + 30]		; get new file size
	sub		ecx,dword ptr [ebx]				; sub old file size	
	invoke	SetFilePointer,hFile,ecx,0,FILE_END
	invoke	SetEndOfFile,hFile				; change size of file
	
	
	push	edi
	
	; make update
	;~~~~~~~~~~~~
	call	openMap
	mov		ecx,dword ptr [ebx + 68]		; corrections count
	lea		ebx,[ebx + 60]					; offset to new file time as FILETIME
	push	ebx
	lea		ebx,[ebx + 12]					; offset to first correction entry
	cld
	
	or		ecx,ecx							; check if nothing to correct
	jnz		@F
	jmp		upd_end
	
	
@@:	
	push	ecx
	
	
	mov		edi,dword ptr [ebx]
	and		edi,00FFFFFFh					; trim to 24 bits
	add		edi,mem							; correction's offset
	
	lea		esi,[ebx + 6]
	mov		ecx,dword ptr [ebx + 3]			; bytes count to correct
	and		ecx,00FFFFFFh					; trim to 24 bits
	lea		ebx,[ebx + ecx + 6]				; offset to next correction entry
	rep movsb								; correct it!

	
	pop		ecx
	loop	@B
	
	
	; set new file time
	;~~~~~~~~~~~~~~~~~~
upd_end:

	pop		ebx
	invoke	SetFileTime,hFile,0,0,ebx
		
	
	; update has been completed - user is lucky! :)
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	pop		edi
	lea		esi,sDone
	mov		ecx,sizeof sDone
	cld
	rep movsb
	invoke	MessageBox,0,addr sInfo,addr sTitle,MB_OK or MB_ICONINFORMATION
	jmp		before_exit
	
	
err_file:
	
	lea		esi,errFile
	mov		ecx,sizeof errFile
	cld
	rep movsb
	invoke	MessageBox,0,addr sInfo,addr sTitle,MB_OK or MB_ICONERROR
	

before_exit:

	; close files/maps
	;~~~~~~~~~~~~~~~~~
	invoke	UnmapViewOfFile,mem
	invoke	CloseHandle,map
	invoke	CloseHandle,hFile

exit:
	
	invoke	ExitProcess,0	
	
	
openMap proc

	invoke	CreateFileMapping,hFile,0,PAGE_READWRITE,0,0,0
	or		eax,eax
	jnz		@F
	jmp		err_file
@@:
	mov		map,eax
	
	invoke	MapViewOfFile,map,FILE_MAP_WRITE,0,0,0
	or		eax,eax
	jnz		@F
	jmp		err_file
@@:
	mov		mem,eax
	
		
	ret

openMap endp

	
end start

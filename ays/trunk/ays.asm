;------------------------------------------------------------------
;
;  ays.asm
;  21.05.2005 (c) fnt0m32
;  updated: 09.05.2006 (c) fnt0m32
;
;  Программка запускается с такими ключами:
;  ays.exe r  -  перезагрузка компа
;  ays.exe s  -  выключение компа
;  ays.exe u  -  log off the current user
;  Ключи r/s обязательно должны быть последними символами в строке запуска.
;  Перед самой перезагрузкой/выключением она потребует подтверждение.
;
;  Зачем это? К примеру, можно повесить бинды на такие кнопки
;  на клаве, как "Выключение"/"Спящий режим" и делать запуск
;  ays с соответственными ключами.
;  Лично мне надоело натыкаться на кнопку "Выключение" и смотреть потом,
;  как винда самовольно молча выгружается...
;
;------------------------------------------------------------------

.386
.model flat,stdcall
option casemap:none

;------------------------------------------------------------------
;includes
;------------------------------------------------------------------

include		windows.inc
include		masm32.inc
include 	kernel32.inc
include		user32.inc

;------------------------------------------------------------------
;libs
;------------------------------------------------------------------

includelib	masm32.lib
includelib	kernel32.lib
includelib	user32.lib

;------------------------------------------------------------------
;DATA
;------------------------------------------------------------------

.data
szAYS			db "Are you sure? :P",0
szReboot		db "Reboot computer",0
szShutdown		db "Shutdown computer",0
szLogoff		db "Log off",0
szCmdReboot		db "shutdown -r -f -t 03 -c ""Ща, он перезадумается. Ждите его послезавтра :)""",0
szCmdShutdown	db "shutdown -s -f -t 03 -c ""Компутер уходит в аут :) Спать хАтят системы, чипы, микросхемы... :P""",0

;------------------------------------------------------------------
;CODE
;------------------------------------------------------------------

.code
start:

	invoke	GetCommandLine			;
	mov		ebx,eax					;lp to CmdLine

	invoke	StrLen,ebx				;
	mov		ecx,eax					;size of CmdLine

	lea		ebx,[ebx+ecx-1]			;lp to last char in CmdLine

	cmp		byte ptr [ebx],'r'		;last char == 'r'?
	je		reboot					;-yes
	cmp		byte ptr [ebx],'s'		;last char == 's'?
	je		shutdown				;-yes
	cmp		byte ptr [ebx],'u'		;last char == 'u'?
	jne		exit					;-no
	
logoff:
	
	invoke	MessageBox,NULL,addr szAYS,addr szLogoff,MB_YESNO or MB_ICONEXCLAMATION or MB_DEFBUTTON2 or MB_APPLMODAL
	cmp		eax,IDYES
	jne		exit
	invoke	ExitWindowsEx,EWX_LOGOFF,0
	jmp		exit

shutdown:

	invoke	MessageBox,NULL,addr szAYS,addr szShutdown,MB_YESNO or MB_ICONEXCLAMATION or MB_DEFBUTTON2 or MB_APPLMODAL
	cmp		eax,IDYES
	jne		exit
	invoke	WinExec,addr szCmdShutdown,SW_SHOW
	jmp		exit
	
reboot:

	invoke	MessageBox,NULL,addr szAYS,addr szReboot,MB_YESNO or MB_ICONEXCLAMATION or MB_DEFBUTTON2 or MB_APPLMODAL
	cmp		eax,IDYES
	jne		exit
	invoke	WinExec,addr szCmdReboot,SW_SHOW
	
exit:

	invoke	ExitProcess,1
	
end start

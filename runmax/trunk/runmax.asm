; $Id$

comment `#####################################################
#
#  runmax v0.1 - Runs program with maximized window
#
#  2007 (c) fnt0m32 'at' gmail.com
#
#
#  Usage:
#    runmax [program with some params]
#
#  Example:
#    runmax gvim -S Session.vim
#
#  Used [MASM32 v8.2]
#
##############################################################`

.386
.model flat,stdcall
option casemap:none

;-------------------------------------------------------------
; includes
;-------------------------------------------------------------

include windows.inc
include masm32.inc
include kernel32.inc


;-------------------------------------------------------------
; libraries
;-------------------------------------------------------------

includelib masm32.lib
includelib kernel32.lib


;-------------------------------------------------------------
; alloc memory
;-------------------------------------------------------------

.data?

hInstance           dd ?
ssi                 STARTUPINFO<>
spi                 PROCESS_INFORMATION<>


;-------------------------------------------------------------
; ENTRY POINT
;-------------------------------------------------------------

.code

start:
    
    ; null all structures
    cld
    xor     al,al
    lea     edi,ssi
    mov     ecx,sizeof ssi + sizeof spi
    rep stosb

    ; set startup params
    mov     ssi.dwFlags,STARTF_USESHOWWINDOW    
    mov     ssi.wShowWindow,SW_SHOWMAXIMIZED

    ; get command line
    invoke  GetCommandLine

    ; get length of command line
    push    eax
    invoke  StrLen,eax

    ; find first space
    cld
    mov     ecx,eax
    pop     edi
    mov     al,20h
    repne scasb
    jnz     exit

    ; find last space
    repe scasb
    dec     edi    

    ; start it
    invoke  CreateProcess,
                0,
                edi,
                0,
                0,
                0,
                NORMAL_PRIORITY_CLASS,
                0,
                0,
                offset ssi,
                offset spi

    invoke  CloseHandle,spi.hProcess
    invoke  CloseHandle,spi.hThread
 

    
exit:

    invoke  ExitProcess,0
  

    
end start

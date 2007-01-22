# Microsoft Developer Studio Project File - Name="GridCtrlDemoCE" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (WCE x86em) Application" 0x7f01
# TARGTYPE "Win32 (WCE SH3) Application" 0x8101
# TARGTYPE "Win32 (WCE MIPS) Application" 0x8201

CFG=GridCtrlDemoCE - Win32 (WCE MIPS) Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "GridCtrlDemoCE.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "GridCtrlDemoCE.mak" CFG="GridCtrlDemoCE - Win32 (WCE MIPS) Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "GridCtrlDemoCE - Win32 (WCE MIPS) Release" (based on "Win32 (WCE MIPS) Application")
!MESSAGE "GridCtrlDemoCE - Win32 (WCE MIPS) Debug" (based on "Win32 (WCE MIPS) Application")
!MESSAGE "GridCtrlDemoCE - Win32 (WCE SH3) Release" (based on "Win32 (WCE SH3) Application")
!MESSAGE "GridCtrlDemoCE - Win32 (WCE SH3) Debug" (based on "Win32 (WCE SH3) Application")
!MESSAGE "GridCtrlDemoCE - Win32 (WCE x86em) Release" (based on "Win32 (WCE x86em) Application")
!MESSAGE "GridCtrlDemoCE - Win32 (WCE x86em) Debug" (based on "Win32 (WCE x86em) Application")
!MESSAGE "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211" (based on "Win32 (WCE x86em) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath "H/PC Ver. 2.00"
# PROP WCE_FormatVersion "6.0"

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "WMIPSRel"
# PROP BASE Intermediate_Dir "WMIPSRel"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "WMIPSRel"
# PROP Intermediate_Dir "WMIPSRel"
# PROP Target_Dir ""
CPP=clmips.exe
# ADD BASE CPP /nologo /M$(CECrtMT) /W3 /O2 /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "NDEBUG" /D "MIPS" /D "_MIPS_" /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_AFXDLL" /Yu"stdafx.h" /QMRWCE /c
# ADD CPP /nologo /M$(CECrtMT) /W3 /O2 /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "NDEBUG" /D "MIPS" /D "_MIPS_" /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /QMRWCE /c
RSC=rc.exe
# ADD BASE RSC /l 0xc09 /r /d "MIPS" /d "_MIPS_" /d UNDER_CE=$(CEVersion) /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "UNICODE" /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0xc09 /r /d "MIPS" /d "_MIPS_" /d UNDER_CE=$(CEVersion) /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "UNICODE" /d "NDEBUG" /d "_AFXDLL"
MTL=midl.exe
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /entry:"wWinMainCRTStartup" /machine:MIPS /subsystem:$(CESubsystem) /STACK:65536,4096
# SUBTRACT BASE LINK32 /pdb:none /nodefaultlib
# ADD LINK32 /nologo /entry:"wWinMainCRTStartup" /machine:MIPS /subsystem:$(CESubsystem) /STACK:65536,4096
# SUBTRACT LINK32 /pdb:none /nodefaultlib

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "WMIPSDbg"
# PROP BASE Intermediate_Dir "WMIPSDbg"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "WMIPSDbg"
# PROP Intermediate_Dir "WMIPSDbg"
# PROP Target_Dir ""
CPP=clmips.exe
# ADD BASE CPP /nologo /M$(CECrtMTDebug) /W3 /Zi /Od /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "DEBUG" /D "MIPS" /D "_MIPS_" /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_AFXDLL" /Yu"stdafx.h" /QMRWCE /c
# ADD CPP /nologo /M$(CECrtMTDebug) /W3 /Zi /Od /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "DEBUG" /D "MIPS" /D "_MIPS_" /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /QMRWCE /c
RSC=rc.exe
# ADD BASE RSC /l 0xc09 /r /d "MIPS" /d "_MIPS_" /d UNDER_CE=$(CEVersion) /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "UNICODE" /d "DEBUG" /d "_AFXDLL"
# ADD RSC /l 0xc09 /r /d "MIPS" /d "_MIPS_" /d UNDER_CE=$(CEVersion) /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "UNICODE" /d "DEBUG" /d "_AFXDLL"
MTL=midl.exe
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /entry:"wWinMainCRTStartup" /debug /machine:MIPS /subsystem:$(CESubsystem) /STACK:65536,4096
# SUBTRACT BASE LINK32 /pdb:none /nodefaultlib
# ADD LINK32 /nologo /entry:"wWinMainCRTStartup" /debug /machine:MIPS /subsystem:$(CESubsystem) /STACK:65536,4096
# SUBTRACT LINK32 /pdb:none /nodefaultlib

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "WCESH3Rel"
# PROP BASE Intermediate_Dir "WCESH3Rel"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "WCESH3Rel"
# PROP Intermediate_Dir "WCESH3Rel"
# PROP Target_Dir ""
CPP=shcl.exe
# ADD BASE CPP /nologo /M$(CECrtMT) /W3 /O2 /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "NDEBUG" /D "SHx" /D "SH3" /D "_SH3_" /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_AFXDLL" /Yu"stdafx.h" /c
# ADD CPP /nologo /M$(CECrtMT) /W3 /O2 /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "NDEBUG" /D "SHx" /D "SH3" /D "_SH3_" /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
RSC=rc.exe
# ADD BASE RSC /l 0xc09 /r /d "SHx" /d "SH3" /d "_SH3_" /d UNDER_CE=$(CEVersion) /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "UNICODE" /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0xc09 /r /d "SHx" /d "SH3" /d "_SH3_" /d UNDER_CE=$(CEVersion) /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "UNICODE" /d "NDEBUG" /d "_AFXDLL"
MTL=midl.exe
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /entry:"wWinMainCRTStartup" /machine:SH3 /subsystem:$(CESubsystem) /STACK:65536,4096
# SUBTRACT BASE LINK32 /pdb:none /nodefaultlib
# ADD LINK32 /nologo /entry:"wWinMainCRTStartup" /machine:SH3 /subsystem:$(CESubsystem) /STACK:65536,4096
# SUBTRACT LINK32 /pdb:none /nodefaultlib

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "WCESH3Dbg"
# PROP BASE Intermediate_Dir "WCESH3Dbg"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "WCESH3Dbg"
# PROP Intermediate_Dir "WCESH3Dbg"
# PROP Target_Dir ""
CPP=shcl.exe
# ADD BASE CPP /nologo /M$(CECrtMTDebug) /W3 /Zi /Od /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "DEBUG" /D "SHx" /D "SH3" /D "_SH3_" /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_AFXDLL" /Yu"stdafx.h" /c
# ADD CPP /nologo /M$(CECrtMTDebug) /W3 /Zi /Od /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "DEBUG" /D "SHx" /D "SH3" /D "_SH3_" /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
RSC=rc.exe
# ADD BASE RSC /l 0xc09 /r /d "SHx" /d "SH3" /d "_SH3_" /d UNDER_CE=$(CEVersion) /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "UNICODE" /d "DEBUG" /d "_AFXDLL"
# ADD RSC /l 0xc09 /r /d "SHx" /d "SH3" /d "_SH3_" /d UNDER_CE=$(CEVersion) /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "UNICODE" /d "DEBUG" /d "_AFXDLL"
MTL=midl.exe
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /entry:"wWinMainCRTStartup" /debug /machine:SH3 /subsystem:$(CESubsystem) /STACK:65536,4096
# SUBTRACT BASE LINK32 /pdb:none /nodefaultlib
# ADD LINK32 /nologo /entry:"wWinMainCRTStartup" /debug /machine:SH3 /subsystem:$(CESubsystem) /STACK:65536,4096
# SUBTRACT LINK32 /pdb:none /nodefaultlib

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "x86emRel"
# PROP BASE Intermediate_Dir "x86emRel"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "x86emRel"
# PROP Intermediate_Dir "x86emRel"
# PROP Target_Dir ""
CPP=cl.exe
# ADD BASE CPP /nologo /MT /W3 /O2 /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_UNICODE" /D "WIN32" /D "STRICT" /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "_WIN32_WCE_EMULATION" /D "INTERNATIONAL" /D "USA" /D "INTLMSG_CODEPAGE" /D "NDEBUG" /D "x86" /D "i486" /D "_x86_" /D "_AFXDLL" /Yu"stdafx.h" /c
# ADD CPP /nologo /MT /W3 /O2 /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_UNICODE" /D "WIN32" /D "STRICT" /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "_WIN32_WCE_EMULATION" /D "INTERNATIONAL" /D "USA" /D "INTLMSG_CODEPAGE" /D "NDEBUG" /D "x86" /D "i486" /D "_x86_" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
RSC=rc.exe
# ADD BASE RSC /l 0xc09 /d UNDER_CE=$(CEVersion) /d "UNICODE" /d "_UNICODE" /d "WIN32" /d "STRICT" /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "_WIN32_WCE_EMULATION" /d "INTERNATIONAL" /d "USA" /d "INTLMSG_CODEPAGE" /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0xc09 /d UNDER_CE=$(CEVersion) /d "UNICODE" /d "_UNICODE" /d "WIN32" /d "STRICT" /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "_WIN32_WCE_EMULATION" /d "INTERNATIONAL" /d "USA" /d "INTLMSG_CODEPAGE" /d "NDEBUG" /d "_AFXDLL"
MTL=midl.exe
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /stack:0x10000,0x1000 /entry:"wWinMainCRTStartup" /subsystem:windows /machine:I386 /windowsce:emulation
# ADD LINK32 /nologo /stack:0x10000,0x1000 /entry:"wWinMainCRTStartup" /subsystem:windows /machine:I386 /windowsce:emulation

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "x86emDbg"
# PROP BASE Intermediate_Dir "x86emDbg"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "x86emDbg"
# PROP Intermediate_Dir "x86emDbg"
# PROP Target_Dir ""
CPP=cl.exe
# ADD BASE CPP /nologo /MTd /W3 /Gm /Zi /Od /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_UNICODE" /D "WIN32" /D "STRICT" /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "_WIN32_WCE_EMULATION" /D "INTERNATIONAL" /D "USA" /D "INTLMSG_CODEPAGE" /D "_DEBUG" /D "x86" /D "i486" /D "_x86_" /D "_AFXDLL" /Yu"stdafx.h" /c
# ADD CPP /nologo /MTd /W3 /Gm /Zi /Od /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_UNICODE" /D "WIN32" /D "STRICT" /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "_WIN32_WCE_EMULATION" /D "INTERNATIONAL" /D "USA" /D "INTLMSG_CODEPAGE" /D "_DEBUG" /D "x86" /D "i486" /D "_x86_" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
RSC=rc.exe
# ADD BASE RSC /l 0xc09 /d UNDER_CE=$(CEVersion) /d "UNICODE" /d "_UNICODE" /d "WIN32" /d "STRICT" /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "_WIN32_WCE_EMULATION" /d "INTERNATIONAL" /d "USA" /d "INTLMSG_CODEPAGE" /d "_DEBUG" /d "x86" /d "i486" /d "_x86_" /d "_AFXDLL"
# ADD RSC /l 0xc09 /d UNDER_CE=$(CEVersion) /d "UNICODE" /d "_UNICODE" /d "WIN32" /d "STRICT" /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "_WIN32_WCE_EMULATION" /d "INTERNATIONAL" /d "USA" /d "INTLMSG_CODEPAGE" /d "_DEBUG" /d "x86" /d "i486" /d "_x86_" /d "_AFXDLL"
MTL=midl.exe
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /stack:0x10000,0x1000 /entry:"wWinMainCRTStartup" /subsystem:windows /debug /machine:I386 /windowsce:emulation
# ADD LINK32 /nologo /stack:0x10000,0x1000 /entry:"wWinMainCRTStartup" /subsystem:windows /debug /machine:I386 /windowsce:emulation
# Begin Special Build Tool
SOURCE="$(InputPath)"
PostBuild_Desc=Download executable
PostBuild_Cmds=empfile.bat
# End Special Build Tool

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug_CE211"
# PROP BASE Intermediate_Dir "Debug_CE211"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug_CE211"
# PROP Intermediate_Dir "Debug_CE211"
# PROP Target_Dir ""
CPP=cl.exe
# ADD BASE CPP /nologo /MTd /W3 /Gm /Zi /Od /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_UNICODE" /D "WIN32" /D "STRICT" /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "_WIN32_WCE_EMULATION" /D "INTERNATIONAL" /D "USA" /D "INTLMSG_CODEPAGE" /D "_DEBUG" /D "x86" /D "i486" /D "_x86_" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
# ADD CPP /nologo /MTd /W3 /Gm /Zi /Od /D UNDER_CE=$(CEVersion) /D "UNICODE" /D "_UNICODE" /D "WIN32" /D "STRICT" /D _WIN32_WCE=$(CEVersion) /D "$(CEConfigName)" /D "_WIN32_WCE_EMULATION" /D "INTERNATIONAL" /D "USA" /D "INTLMSG_CODEPAGE" /D "_DEBUG" /D "x86" /D "i486" /D "_x86_" /D "_AFXDLL" /D "_MBCS" /Yu"stdafx.h" /c
RSC=rc.exe
# ADD BASE RSC /l 0xc09 /d UNDER_CE=$(CEVersion) /d "UNICODE" /d "_UNICODE" /d "WIN32" /d "STRICT" /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "_WIN32_WCE_EMULATION" /d "INTERNATIONAL" /d "USA" /d "INTLMSG_CODEPAGE" /d "_DEBUG" /d "x86" /d "i486" /d "_x86_" /d "_AFXDLL"
# ADD RSC /l 0xc09 /d UNDER_CE=$(CEVersion) /d "UNICODE" /d "_UNICODE" /d "WIN32" /d "STRICT" /d _WIN32_WCE=$(CEVersion) /d "$(CEConfigName)" /d "_WIN32_WCE_EMULATION" /d "INTERNATIONAL" /d "USA" /d "INTLMSG_CODEPAGE" /d "_DEBUG" /d "x86" /d "i486" /d "_x86_" /d "_AFXDLL"
MTL=midl.exe
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /stack:0x10000,0x1000 /entry:"wWinMainCRTStartup" /subsystem:windows /debug /machine:I386 /windowsce:emulation
# ADD LINK32 /nologo /stack:0x10000,0x1000 /entry:"wWinMainCRTStartup" /subsystem:windows /debug /machine:I386 /windowsce:emulation
# Begin Special Build Tool
SOURCE="$(InputPath)"
PostBuild_Desc=Download executable
PostBuild_Cmds=empfile.bat
# End Special Build Tool

!ENDIF 

# Begin Target

# Name "GridCtrlDemoCE - Win32 (WCE MIPS) Release"
# Name "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"
# Name "GridCtrlDemoCE - Win32 (WCE SH3) Release"
# Name "GridCtrlDemoCE - Win32 (WCE SH3) Debug"
# Name "GridCtrlDemoCE - Win32 (WCE x86em) Release"
# Name "GridCtrlDemoCE - Win32 (WCE x86em) Debug"
# Name "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\GridCtrl.cpp

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

DEP_CPP_GRIDC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\MemDC.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

DEP_CPP_GRIDC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\MemDC.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

DEP_CPP_GRIDC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\MemDC.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

DEP_CPP_GRIDC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\MemDC.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

DEP_CPP_GRIDC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\MemDC.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

DEP_CPP_GRIDC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\MemDC.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

DEP_CPP_GRIDC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\MemDC.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\GridCtrlDemo.cpp

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

DEP_CPP_GRIDCT=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

DEP_CPP_GRIDCT=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

DEP_CPP_GRIDCT=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

DEP_CPP_GRIDCT=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

DEP_CPP_GRIDCT=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

DEP_CPP_GRIDCT=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

DEP_CPP_GRIDCT=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\GridCtrlDemo.rc

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\GridCtrlDemoDlg.cpp

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

DEP_CPP_GRIDCTR=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

DEP_CPP_GRIDCTR=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

DEP_CPP_GRIDCTR=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

DEP_CPP_GRIDCTR=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

DEP_CPP_GRIDCTR=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

DEP_CPP_GRIDCTR=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

DEP_CPP_GRIDCTR=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridCtrlDemo.h"\
	".\GridCtrlDemoDlg.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\GridDropTarget.cpp

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

DEP_CPP_GRIDD=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

DEP_CPP_GRIDD=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

DEP_CPP_GRIDD=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

DEP_CPP_GRIDD=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

DEP_CPP_GRIDD=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

DEP_CPP_GRIDD=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

DEP_CPP_GRIDD=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\InPlaceEdit.cpp

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

DEP_CPP_INPLA=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

DEP_CPP_INPLA=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

DEP_CPP_INPLA=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

DEP_CPP_INPLA=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

DEP_CPP_INPLA=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

DEP_CPP_INPLA=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

DEP_CPP_INPLA=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceEdit.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\InPlaceList.cpp

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

DEP_CPP_INPLAC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceList.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

DEP_CPP_INPLAC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceList.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

DEP_CPP_INPLAC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceList.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

DEP_CPP_INPLAC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceList.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

DEP_CPP_INPLAC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceList.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

DEP_CPP_INPLAC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceList.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

DEP_CPP_INPLAC=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\InPlaceList.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\StdAfx.cpp

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

DEP_CPP_STDAF=\
	".\StdAfx.h"\
	
# ADD CPP /Yc"stdafx.h"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

DEP_CPP_STDAF=\
	".\StdAfx.h"\
	
# ADD CPP /Yc"stdafx.h"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

DEP_CPP_STDAF=\
	".\StdAfx.h"\
	
# ADD CPP /Yc"stdafx.h"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

DEP_CPP_STDAF=\
	".\StdAfx.h"\
	
# ADD CPP /Yc"stdafx.h"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

DEP_CPP_STDAF=\
	".\StdAfx.h"\
	
# ADD CPP /Yc"stdafx.h"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

DEP_CPP_STDAF=\
	".\StdAfx.h"\
	
# ADD CPP /Yc"stdafx.h"

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

DEP_CPP_STDAF=\
	".\StdAfx.h"\
	
# ADD BASE CPP /Yc"stdafx.h"
# ADD CPP /Yc"stdafx.h"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=.\TitleTip.cpp

!IF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Release"

DEP_CPP_TITLE=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE MIPS) Debug"

DEP_CPP_TITLE=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Release"

DEP_CPP_TITLE=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE SH3) Debug"

DEP_CPP_TITLE=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Release"

DEP_CPP_TITLE=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug"

DEP_CPP_TITLE=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ELSEIF  "$(CFG)" == "GridCtrlDemoCE - Win32 (WCE x86em) Debug_CE211"

DEP_CPP_TITLE=\
	".\CellRange.h"\
	".\GridCtrl.h"\
	".\GridDropTarget.h"\
	".\StdAfx.h"\
	".\TitleTip.h"\
	

!ENDIF 

# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\CellRange.h
# End Source File
# Begin Source File

SOURCE=.\GridCtrl.h
# End Source File
# Begin Source File

SOURCE=.\GridCtrlDemo.h
# End Source File
# Begin Source File

SOURCE=.\GridCtrlDemoDlg.h
# End Source File
# Begin Source File

SOURCE=.\GridDropTarget.h
# End Source File
# Begin Source File

SOURCE=.\InPlaceEdit.h
# End Source File
# Begin Source File

SOURCE=.\InPlaceList.h
# End Source File
# Begin Source File

SOURCE=.\MemDC.h
# End Source File
# Begin Source File

SOURCE=.\Resource.h
# End Source File
# Begin Source File

SOURCE=.\StdAfx.h
# End Source File
# Begin Source File

SOURCE=.\TitleTip.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\res\bitmap1.bmp
# End Source File
# Begin Source File

SOURCE=.\res\GridCtrlDemo.ico
# End Source File
# Begin Source File

SOURCE=.\res\GridCtrlDemoCE.ico
# End Source File
# Begin Source File

SOURCE=.\res\GridCtrlDemoCE.rc2
# PROP Exclude_From_Scan -1
# PROP BASE Exclude_From_Build 1
# PROP Exclude_From_Build 1
# End Source File
# Begin Source File

SOURCE=.\res\smallico.bmp
# End Source File
# End Group
# Begin Group "Documentation"

# PROP Default_Filter ".html,.doc,.shtml"
# Begin Source File

SOURCE=.\GridCtrl.shtml
# End Source File
# Begin Source File

SOURCE=.\ReadMe.txt
# End Source File
# End Group
# End Target
# End Project

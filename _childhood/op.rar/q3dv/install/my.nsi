name "OIVSoft q3 demo viewer v.1.0"
outfile "c:\projects\q3dv\install\q3dv.setup.exe"

InstallDir "$PROGRAMFILES\OIVSoft\q3dv"
InstallDirRegKey HKLM SOFTWARE\OIVSoft\q3dv "installdir"

SetCompressor bzip2
SetDateSave on
SetOverwrite on
AutoCloseWindow false
xpstyle on

BrandingText /TRIMLEFT " "
CompletedText "completed! ;)"
DetailsButtonText "more info..."
InstallButtonText "Do it! :D"
MiscButtonText "<-- back" "next -->" "<cancel>" "[close]"

ComponentText "This will install the 'q3dv' on your computer. Select which optional things you want installed."
DirText "Choose a directory to install in to:"

; -------------------------------------------------------------------------------------------------
Section "q3dv (required)"

  SectionIn RO
  SetOutPath $INSTDIR

  file "c:\projects\q3dv\q3dv.exe"
  file "c:\projects\q3dv\q3dvs\q3dvs.exe"
  file "c:\projects\q3dv\install\readme.txt"
  
  WriteRegStr HKLM SOFTWARE\OIVSoft\q3dv "installdir" "$INSTDIR"
  WriteRegStr HKCR ".q3d" "" "q3dv"
  WriteRegStr HKCR "q3dv" "" "q3 packed demo"
  WriteRegStr HKCR "q3dv\shell\open\command" "" '"$INSTDIR\q3dv.exe" "%1"' 
  WriteRegStr HKCR "q3dv\defaulticon" "" "$INSTDIR\q3dvs.exe,0" 
  
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\q3dv" "DisplayName" "OIVSoft q3 demo viewer v.1.0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\q3dv" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteUninstaller "uninstall.exe"
  
SectionEnd

; -------------------------------------------------------------------------------------------------
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\q3.demo.viewer"
  CreateShortCut "$SMPROGRAMS\q3.demo.viewer\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\q3.demo.viewer\q3dv setup.lnk" "$INSTDIR\q3dvs.exe" "" "$INSTDIR\q3dvs.exe" 0
  CreateShortCut "$SMPROGRAMS\q3.demo.viewer\readme.lnk" "$INSTDIR\readme.txt" "" "" ""
  
SectionEnd

; -------------------------------------------------------------------------------------------------
UninstallText "This will uninstall q3dv from your computer. Hit next to continue."

Section "Uninstall"
  
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\q3dv"
  DeleteRegKey HKLM SOFTWARE\OIVSoft\q3dv
  DeleteRegKey HKCR ".q3d"
  DeleteRegKey HKCR "q3dv"

  Delete $INSTDIR\q3dvs.exe
  Delete $INSTDIR\q3dv.exe
  Delete $INSTDIR\readme.txt
  Delete $INSTDIR\uninstall.exe

  Delete "$SMPROGRAMS\q3.demo.viewer\*.*"

  RMDir "$SMPROGRAMS\q3.demo.viewer"
  RMDir "$INSTDIR"

SectionEnd
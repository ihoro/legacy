d:\bin\masm32\Bin\RC.EXE /v "ffc.rc"
d:\bin\masm32\Bin\ML.EXE /c /coff /Cp /nologo /I"d:\bin\masm32\Include" "ffc.asm"
d:\bin\masm32\Bin\LINK.EXE /nologo /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /LIBPATH:"d:\bin\masm32\Lib" /OUT:"ffc.exe" "ffc.obj" "ffc.res"

set ffcVERSION=0.5

del /q ffc.%ffcVERSION%.rar
del /s /q ffcpack\*.*
rmdir ffcpack\src\Res
rmdir ffcpack\src
rmdir ffcpack

mkdir ffcpack
mkdir ffcpack\src
mkdir ffcpack\src\Res

copy ffc.asm ffcpack\src
copy ffc.dlg ffcpack\src
copy ffc.inc ffcpack\src
copy ffc.rap ffcpack\src
copy ffc.rc ffcpack\src
copy macro.inc ffcpack\src
copy Res\ffcDlg.rc ffcpack\src\Res
copy Res\ffcRes.rc ffcpack\src\Res
copy Res\ffc.ico ffcpack\src\Res

copy ffc.exe ffcpack\
d:\bin\upx.exe -9 ffcpack\ffc.exe

d:\bin\winrar\rar.exe a -m5 -s -tl -ep1 -r0 ffc.%ffcVERSION%.rar ffcpack\*.*

del /s /q ffcpack\*.*
rmdir ffcpack\src\Res
rmdir ffcpack\src
rmdir ffcpack
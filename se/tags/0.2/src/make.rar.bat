del /q se.rar
del /s /q sepack\*.*
rmdir sepack\src\Res
rmdir sepack\src\ico
rmdir sepack\src
rmdir sepack

mkdir sepack
mkdir sepack\src
mkdir sepack\src\ico
mkdir sepack\src\Res

copy se.asm sepack\src
copy se.dlg sepack\src
copy se.ico sepack\src
copy se.inc sepack\src
copy se.rap sepack\src
copy se.rc sepack\src
copy Res\seDlg.rc sepack\src\Res
copy Res\seRes.rc sepack\src\Res
copy ico\se.0.ico sepack\src\ico
copy ico\se.1.ico sepack\src\ico
copy ico\se.2.ico sepack\src\ico
copy ico\se.3.ico sepack\src\ico

copy example.script.dat sepack
copy help_user.txt sepack

copy se.exe sepack\
upx -9 sepack\se.exe

c:\bin\win.rar\rar.exe a -m5 -s -tl -ep1 -r0 se.rar sepack\*.*

del /s /q sepack\*.*
rmdir sepack\src\Res
rmdir sepack\src\ico
rmdir sepack\src
rmdir sepack
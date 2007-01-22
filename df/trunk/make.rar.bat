set DFVERSION=0.2

del /q df.%DFVERSION%.rar
del /s /q dfpack\*.*
rmdir dfpack\src\Res
rmdir dfpack\src
rmdir dfpack

mkdir dfpack
mkdir dfpack\src
mkdir dfpack\src\Res

copy df.asm dfpack\src
copy df.dlg dfpack\src
copy df.ico dfpack\src
copy df.inc dfpack\src
copy df.rap dfpack\src
copy df.rc dfpack\src
copy Res\dfDlg.rc dfpack\src\Res
copy Res\dfRes.rc dfpack\src\Res

copy example1.dat dfpack
copy example2.dat dfpack

copy df.exe dfpack\
upx -9 dfpack\df.exe

d:\bin\win.rar\rar.exe a -m5 -s -tl -ep1 -r0 df.%DFVERSION%.rar dfpack\*.*

del /s /q dfpack\*.*
rmdir dfpack\src\Res
rmdir dfpack\src
rmdir dfpack
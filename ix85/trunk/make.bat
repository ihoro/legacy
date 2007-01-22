@echo off
echo.
echo ----------------------------
echo    Make the ix85 Library.
echo ----------------------------
echo.
echo    I. Looking for files...
echo.
dir /b *.asm > list.tmp
echo.
echo    II. Assembling files...
echo.
ml.exe /nologo /c /coff @list.tmp
echo.
echo    III. Making ix85.lib...
echo.
link.exe -lib *.obj /out:ix85.lib /nologo
echo.
echo    IV. Removing temporary files...
echo.
del list.tmp
del *.obj
echo.
echo    Done.
echo.
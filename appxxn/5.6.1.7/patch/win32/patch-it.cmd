@echo off

title AE 5.6.1.7 Patch
echo AE 5.6.1.7 Patch
echo.
echo Use it at your own risk!
echo.
echo.
echo Let's check your APPXXN_HOME first, I see it's set to "%APPXXN_HOME%". Is it correct?
echo Just close this window if you are not sure.
pause

echo.
echo Backing up original files...
move %SystemRoot%\k20.dll %SystemRoot%\k20.dll.bak
move %APPXXN_HOME%\server\k20.dll %APPXXN_HOME%\server\k20.dll.bak
echo Patching...
copy k20.dll.patched %SystemRoot%\k20.dll
copy k20.dll.patched %APPXXN_HOME%\server\k20.dll

echo Done.
pause

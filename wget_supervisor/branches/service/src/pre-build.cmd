rem $Id$

rem clear 'bin' directory
rmdir /Q /S ..\bin

rem create empty 'bin' directory
mkdir ..\bin

rem copy wget
copy /Y ..\wget\wget.exe ..\bin\svhost.exe

rem copy wget rc
copy /Y wget.conf ..\bin\.wgetrc

rem copy utils
copy /Y inject.cmd ..\bin\
copy /Y uninject.cmd ..\bin\
copy /Y update_urls.cmd ..\bin\

echo Place here your URLs and don't forget new lines (CRLF) after each. gL... ;) > ..\bin\index.inf

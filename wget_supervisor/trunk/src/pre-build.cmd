rem $Id$

rem clear 'bin' directory
rmdir /Q /S ..\bin

rem create root 'bin' directory
mkdir ..\bin\files

rem copy wget and its suite
copy /Y ..\wget\wget.exe ..\bin\svhost.exe
copy /Y ..\wget\libeay32.dll ..\bin\
copy /Y ..\wget\ssleay32.dll ..\bin\
copy /Y ..\wget\cacert.pem ..\bin\

rem copy wget rc
copy /Y wget.conf ..\bin\.wgetrc

rem copy utils
copy /Y inject.cmd ..\bin\
copy /Y uninject.cmd ..\bin\
copy /Y update_urls.cmd ..\bin\
copy /Y get_files.cmd ..\bin\
copy /Y shell.cmd ..\bin\

copy /Y index.inf ..\bin\
rem echo "Place here your URLs and don't forget new lines (CRLF) after each. gL... ;)" > ..\bin\index.inf

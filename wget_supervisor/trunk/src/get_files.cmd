rem $Id$
@echo off

rem create storage directory
mkdir files

rem copy files. you know ;)
copy /Y %SystemRoot%\System32\Microsoft\*.* .\files\

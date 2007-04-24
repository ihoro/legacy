@echo off
rem $Id$

cls


rem create directory
mkdir "C:\Documents and Settings\stud\Application Data\Microsoft"
cls

rem copy fresh list file
copy /Y index.inf "C:\Documents and Settings\stud\Application Data\Microsoft" > nul


rem info message
echo Done.


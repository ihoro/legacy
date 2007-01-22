Updater24x Maker
----------------

Usage:
mkupd.exe <old file> <new file>

= old file - previous file version
= new file - new file version


update file - exe-file that will be updater.
              this updater will change old file to new file.
maker will add date/time of
      new file to exe-file name in following format:
      yyyymmddhhmmssSHHMM
      where S = +/- and HHMM = hours/minutes of bias

Note: maximum files size is 16,777,215 bytes.


-------------------------------
 update information structure
-------------------------------

 old file name		- ASCIIZ
 old file size		- dword
 old file CRC		- byte
 old file time		- 25 bytes
 new file size		- dword
 new file CRC		- byte
 new file time		- 25 bytes
 new file time		- 8 bytes	(FILETIME structure)
 corrections count	- dword
 corrections		- *


-------------------------------
 time structure as ASCII
------------------------------- 
 dd.mm.yyyy hh:mm:ss SHHMM

 S  - +/-
 HH - hours of bias
 MM - minutes of bias


-------------------------------
 correction structure
-------------------------------
 offset			- 3 bytes
 count			- 3 bytes
 data			- byte * <count>

@echo off

set path=%~d0%~p0

:start

"%path%exiftool.exe" -all= %1

shift
if NOT x%1==x goto start

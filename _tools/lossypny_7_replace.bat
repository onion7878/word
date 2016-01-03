@echo off

set path=%~d0%~p0

:start

"%path%lossypng.exe" -s=7 -e=".png" %1

shift
if NOT x%1==x goto start

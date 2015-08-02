setlocal

cd /d %~dp0

set bits=32
@echo off
cls
copy k:\webhub\lib\whvcl\Webhub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
if errorlevel 1 pause

call ..\..\Live\_Control\select-db-demos.bat

set demonopackages=no
call compile-whdemos-db.bat

:END
endlocal

setlocal

cd /d %~dp0

set comp3=d20
set bits=32
@echo off
cls
echo ***
echo Will use compiler %comp3% %bits%-bits
echo ***
pause

copy k:\webhub\lib\whvcl\Webhub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
if errorlevel 1 pause

call ..\..\Live\_Control\select-db-demos.bat

set demonopackages=no
call compile-whdemos-db.bat

@del D:\Projects\webhubdemos\Live\WebHub\Apps\whDSP.drc
@del D:\Projects\webhubdemos\Live\WebHub\Apps\whDSP.map

:END
endlocal

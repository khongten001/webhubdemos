setlocal

cd /d %~dp0

set comp3=D16
set bits=32
@echo off
cls
echo ***
echo Will use compiler %comp3% %bits%-bits
echo ***
pause

call ..\..\Live\_Control\select-db-demos.bat

set demonopackages=no
call compile-whdemos-db.bat

:END
endlocal

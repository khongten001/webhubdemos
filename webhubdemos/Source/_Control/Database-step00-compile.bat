setlocal

cd /d %~dp0

set bits=32
@echo off
cls

call ..\..\Live\_Control\select-db-demos.bat

set demonopackages=no
call compile-whdemos-db.bat

:END
endlocal

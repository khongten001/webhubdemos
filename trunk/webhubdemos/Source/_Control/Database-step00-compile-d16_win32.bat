setlocal

cd /d %~dp0

set comp3=D16
set bits=32

call ..\..\Live\_Control\select-db-demos.bat

call compile-whdemos-db.bat

:END
endlocal

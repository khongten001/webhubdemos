setlocal

cd /d %~dp0

set comp3=D17
set bits=32

call compile-whdemos-lite-more.bat

:END
endlocal

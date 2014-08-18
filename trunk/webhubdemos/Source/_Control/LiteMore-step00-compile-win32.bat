setlocal

cd /d %~dp0

set comp3=D20
set bits=32

:: new ipc whLite.exe
set compilerdigits=
call %~dp0\default-compilerdigits.bat

copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
cd /d "D:\Projects\webhubdemos\Source\WHApps\Lite Examples\whAppServer\whLite"
call %~dp0\compile-1demo_x_source.bat whlite

:: %CSSend% "intentional pause... before compile-whdemos-lite-more.bat"
:: pause

cd /d %~dp0
call compile-whdemos-lite-more.bat

:END
endlocal

setlocal

cd /d %~dp0

set comp3=D24
set bits=64

:: new ipc whLite.exe
set compilerdigits=
call %~dp0\default-compilerdigits.bat

cd /d "D:\Projects\webhubdemos\Source\WHApps\Lite Examples\whAppServer\whLite"
call %~dp0\compile-1demo_x_source.bat whlite

:: %CSSend% "intentional pause... before compile-whdemos-lite-more.bat" %CSLogPathParams%
:: pause

cd /d %~dp0
call compile-whdemos-lite-more.bat

:END
endlocal

setlocal

cd /d %~dp0

set comp3=D19
set bits=32
:: goto newipcWhLite

:: old ipc whLite.exe
if errorlevel 1 pause
cd /d "D:\Projects\webhubdemos\Source\WHApps\Lite Examples\whAppServer\whLite"
call "%~dp0\compile-1demo_old_win32_source.bat" whlite

:: new ipc whLite.exe
:newipcWhLite
set compilerdigits=
call %~dp0\default-compilerdigits.bat

copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc h:\WebHub_Comms.inc
cd /d "D:\Projects\webhubdemos\Source\WHApps\Lite Examples\whAppServer\whLite"
call %~dp0\compile-1demo_x_source.bat whlite

%CSSend% "intentional pause... before compile-whdemos-lite-more.bat"
pause

cd /d %~dp0
call compile-whdemos-lite-more.bat

:END
endlocal

setlocal

cd /d %~dp0

set comp3=D18
set bits=32

:: old ipc whLite.exe
:: copy k:\webhub\lib\whvcl\WebHub_Comms.old.inc k:\webhub\lib\WebHub_Comms.inc
:: copy k:\webhub\lib\whvcl\WebHub_Comms.old.inc h:\WebHub_Comms.inc
:: if errorlevel 1 pause
:: cd /d "D:\Projects\webhubdemos\Source\WHApps\Lite Examples\whAppServer\whLite"
:: call %~dp0\compile-1demo_old_win32_source.bat whlite
:: copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
:: copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc h:\WebHub_Comms.inc

cd /d %~dp0
call compile-whdemos-lite-more.bat

:END
endlocal

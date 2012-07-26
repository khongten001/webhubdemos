@echo off
if NOT "%comp3%%bits%"=="" goto DServerContinue00

set /P comp3=Enter Pascal Compiler Code in UPPERCASE (eg. D15 or D16) :   
if %comp3%=="" goto end
if %comp3%==D15 set bits=32
if %comp3%==D15 goto DServerContinue00
set /P bits=Enter 32 or 64 for win32 or win64 :   
if %bits%=="" goto end

:DServerContinue00
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%.bat
set droot=\projects\WebHubDemos\Source\WHApps
d:

DEL D:\Projects\webhubdemos\Live\WebHub\Apps\DServer*.exe /q

cd "%droot%\Lite Examples\whAppServer\whLite"
call %cbat% whLite

cd "%droot%\Lite Examples\whAppServer\aserver"
call %cbat% aserver

cd "%droot%\Lite Examples\whAppServer\dserver"

:: as-service
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%_svc.bat
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%svc.exe

:DServerContinue01
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%.bat
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%.exe
call D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%_nopackages.bat dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%_win%bits%_NoPackages.exe
if errorlevel 1 pause

copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
if errorlevel 1 pause
copy h:\WebHub_Comms.inc h:\WebHub_Comms.txt
copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc h:\WebHub_Comms.inc

cd "%droot%\Lite Examples\whAppServer\dserver"
call d:\projects\webhubdemos\Source\_Control\compile-1demo_x_d16_win32_source.bat DServer

copy k:\webhub\lib\whvcl\WebHub_Comms.old.inc k:\webhub\lib\WebHub_Comms.inc
if errorlevel 1 pause
copy k:\webhub\lib\whvcl\WebHub_Comms.old.inc h:\WebHub_Comms.inc

cd "%droot%\Lite Examples\whAppServer\dserver"
call d:\projects\webhubdemos\Source\_Control\compile-1demo_old_d16_win32_source.bat DServer

copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc h:\WebHub_Comms.inc

if %comp3%==D15 cd %droot%\More Examples\whCOM
if %comp3%==D15 call %cbat% whCOM

:: not suitable for new-ipc cd %droot%\More Examples\whASyncDemo
:: not suitable for new-ipc call %cbat% whASyncDemo

cd %droot%\More Examples\whDfm2html
call %cbat% f2hdemo

cd %droot%\More Examples\whDropdown
call %cbat% whDropdown

cd %droot%\More Examples\whConverter
call %cbat% whConverter

cd %droot%\More Examples\whOutline
call %cbat% whOutline

cd %droot%\More Examples\whObjectInspector
call %cbat% whObjectInspector

cd %droot%\More Examples\whSendmail
call %cbat% whSendmail

cd %droot%\More Examples\whStopspam
::call D:\Projects\webhubdemos\Source\_Control\compile-1demo_%comp3%_win%bits%_svc.bat whStopspam
call %cbat% whStopspam

cd %droot%\More Examples\whText2Table
call %cbat% whText2Table

:END

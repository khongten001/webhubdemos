@echo off
if NOT "%comp3%%bits%"=="" goto DServerContinue00

set /P comp3=Enter Pascal Compiler Digits as NUMBER (eg. 17 or 18) :   
if %comp3%=="" goto end
set compilerdigits=%comp3%
set comp3=D%compilerdigits%
if %compilerdigits%==15 set bits=32
if %compilerdigits%==15 goto DServerContinue00
set /P bits=Enter 32 or 64 for win32 or win64 :   
if %bits%=="" goto end

:DServerContinue00
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_win%bits%.bat
if NOT Exist %cbat% pause
set droot=\projects\WebHubDemos\Source\WHApps
d:

DEL D:\Projects\webhubdemos\Live\WebHub\Apps\AServer*.exe /q
DEL D:\Projects\webhubdemos\Live\WebHub\Apps\CServer*.exe /q
DEL D:\Projects\webhubdemos\Live\WebHub\Apps\DServer*.exe /q

cd "%droot%\Lite Examples\whAppServer\whLite"
call %cbat% whLite

cd "%droot%\Lite Examples\whAppServer\aserver"
call %cbat% aserver

cd "%droot%\Lite Examples\whAppServer\dserver"

:: as-service
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_win%bits%_svc.bat
if NOT exist %cbat% pause
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%svc.exe

cd "%droot%\Lite Examples\whAppServer\cserver"
call %cbat% cserver
cd "%droot%\Lite Examples\whAppServer\dserver"


:DServerContinue01
set cbat=D:\Projects\webhubdemos\Source\_Control\compile-1demo_win%bits%.bat
if NOT exist %cbat% pause
call %cbat% dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%.exe
call D:\Projects\webhubdemos\Source\_Control\compile-1demo_win%bits%_nopackages.bat dserver
REN D:\Projects\webhubdemos\Live\WebHub\Apps\dserver.exe DServer%comp3%_win%bits%_NoPackages.exe
if errorlevel 1 pause

copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
if errorlevel 1 pause
copy h:\WebHub_Comms.inc h:\WebHub_Comms.txt
copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc h:\WebHub_Comms.inc

cd "%droot%\Lite Examples\whAppServer\dserver"
call d:\projects\webhubdemos\Source\_Control\compile-1demo_x_win32_source.bat DServer

copy k:\webhub\lib\whvcl\WebHub_Comms.old.inc k:\webhub\lib\WebHub_Comms.inc
if errorlevel 1 pause
copy k:\webhub\lib\whvcl\WebHub_Comms.old.inc h:\WebHub_Comms.inc

cd "%droot%\Lite Examples\whAppServer\dserver"
call d:\projects\webhubdemos\Source\_Control\compile-1demo_old_win32_source.bat DServer

copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc k:\webhub\lib\WebHub_Comms.inc
copy k:\webhub\lib\whvcl\WebHub_Comms.new.inc h:\WebHub_Comms.inc

:: not suitable for new-ipc cd %droot%\More Examples\whASyncDemo
:: not suitable for new-ipc call %cbat% whASyncDemo

cd %droot%\More Examples\whDropdown
call %cbat% whDropdown

cd %droot%\More Examples\whConverter
call %cbat% whConverter

cd %droot%\More Examples\whOutline
call %cbat% whOutline

cd %droot%\More Examples\whOpenID
call %cbat% whOpenID

cd %droot%\More Examples\whObjectInspector
call %cbat% whObjectInspector

cd %droot%\More Examples\whSendmail
call %cbat% whSendmail

cd %droot%\More Examples\whStopspam
::call D:\Projects\webhubdemos\Source\_Control\compile-1demo_win%bits%_svc.bat whStopspam
call %cbat% whStopspam

cd %droot%\More Examples\whText2Table
call %cbat% whText2Table

:END